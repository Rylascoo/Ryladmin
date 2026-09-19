"""Offline FOUNDATION-01 policy. No model, shell, network or admission promotion."""
from __future__ import annotations

import hashlib
import json
import math
import os
from pathlib import Path, PurePosixPath
import re
import stat
import tempfile

STATES = {"NORMAL", "LIGHT", "CHECKPOINT_ONLY", "WAITING_FOR_RESET", "USAGE_UNKNOWN"}
CAPABILITIES = {"ADMITTED", "SUSPENDED", "EXPERIMENTAL", "NOT_ADMITTED"}


class Rejected(ValueError):
    pass


def require(condition, reason):
    if not condition:
        raise Rejected(reason)


def digest(data):
    return hashlib.sha256(data).hexdigest()


def load_json(path):
    def unique(pairs):
        result = {}
        for key, value in pairs:
            require(key not in result, "duplicate JSON field")
            result[key] = value
        return result
    return json.loads(Path(path).read_text(encoding="utf-8"), object_pairs_hook=unique,
                      parse_constant=lambda _: (_ for _ in ()).throw(Rejected("nonfinite JSON")))


def validate(value, schema):
    """Closed subset used by the bundled schemas; unknown schema keywords fail closed.

    Not a general JSON Schema implementation. No remote references or resolution.
    """
    supported = {"$schema", "$id", "title", "type", "properties", "required",
                 "additionalProperties", "items", "minItems", "maxItems", "uniqueItems",
                 "minLength", "maxLength", "pattern", "enum", "const", "minimum", "maximum"}
    require(not set(schema) - supported, "unsupported schema keyword")
    kind = schema.get("type")
    checks = {"object": lambda: type(value) is dict, "array": lambda: type(value) is list,
              "string": lambda: type(value) is str, "boolean": lambda: type(value) is bool,
              "integer": lambda: type(value) is int,
              "number": lambda: type(value) in (int, float) and math.isfinite(value),
              "null": lambda: value is None}
    require(kind in checks and checks[kind](), "schema type")
    if "const" in schema:
        require(value == schema["const"] and type(value) is type(schema["const"]), "schema const")
    if "enum" in schema:
        require(value in schema["enum"], "schema enum")
    if kind == "object":
        props = schema.get("properties", {})
        require(schema.get("additionalProperties") is False, "object must be closed")
        require(not set(value) - set(props), "unknown field")
        require(set(schema.get("required", [])) <= set(value), "missing field")
        for key, item in value.items():
            validate(item, props[key])
    elif kind == "array":
        require(schema.get("minItems", 0) <= len(value) <= schema.get("maxItems", 10000), "array size")
        if schema.get("uniqueItems"):
            require(len({json.dumps(x, sort_keys=True) for x in value}) == len(value), "duplicate item")
        for item in value:
            validate(item, schema["items"])
    elif kind == "string":
        require(schema.get("minLength", 0) <= len(value) <= schema.get("maxLength", 1000000), "string size")
        if "pattern" in schema:
            require(re.fullmatch(schema["pattern"], value) is not None, "string pattern")
    elif kind in ("integer", "number"):
        require(schema.get("minimum", -math.inf) <= value <= schema.get("maximum", math.inf), "number range")


def contract(name, value):
    validate(value, load_json(Path(__file__).with_name("schemas") / (name + ".json")))


def quota(observation, previous, *, now, required_windows, reservations,
          task_cost, closeout_cost=5, small=False, active_jobs=0, paused=False,
          resume_checks=False):
    """Pure state selector. Costs are allowance percentage points, never token counts."""
    result = {"state": "USAGE_UNKNOWN", "dispatch": False, "checkpoint": True,
              "reason": "invalid or missing usage", "limiting_remaining": None}
    if paused:
        return {**result, "state": "CHECKPOINT_ONLY", "reason": "user pause/cancel"}
    try:
        contract("usage", observation)
        require(previous in STATES, "unknown prior state")
        require(type(now) in (int, float) and math.isfinite(now), "invalid clock")
        require(0 <= now - observation["observed_at"] <= 300, "stale/future usage")
        require(required_windows and len(set(required_windows)) == len(required_windows), "required windows")
        windows = {w["id"]: w for w in observation["windows"]}
        require(len(windows) == len(observation["windows"]), "duplicate windows")
        require(set(windows) == set(required_windows), "missing/unexpected required windows")
        require(set(reservations) == set(windows), "reservation coverage")
        for cost in [closeout_cost, *reservations.values()]:
            require(type(cost) in (int, float) and math.isfinite(cost) and 0 <= cost <= 100, "bad cost")
        require(type(active_jobs) is int and 0 <= active_jobs <= 2, "bad active jobs")
        if task_cost is not None:
            require(type(task_cost) in (int, float) and math.isfinite(task_cost) and 0 <= task_cost <= 100, "bad estimate")
        remaining = min(w["remaining"] for w in windows.values())
        available = min(w["remaining"] - reservations[key] for key, w in windows.items())
        reserve = max(5, closeout_cost)
        result["limiting_remaining"] = remaining
        if remaining <= 0 or available <= 0:
            return {**result, "state": "WAITING_FOR_RESET", "reason": "exhausted/reserved allowance"}
        if remaining <= 5 or available <= reserve:
            return {**result, "state": "CHECKPOINT_ONLY", "reason": "closeout reserve"}
        # Elapsed reset time never clears hysteresis. Require a fresh observation and
        # all applicable windows above 15 plus current authority/ownership checks.
        held = previous != "NORMAL" and (remaining <= 15 or not resume_checks)
        light = held or remaining <= 10 or task_cost is None or available - task_cost <= reserve
        state = "LIGHT" if light else "NORMAL"
        enough = task_cost is not None and available - task_cost > reserve
        permitted = enough and active_jobs < (1 if light else 2) and (not light or small)
        return {**result, "state": state, "dispatch": permitted, "checkpoint": light,
                "reason": "eligible" if permitted else "reserve, unknown estimate or concurrency"}
    except (Rejected, TypeError, KeyError, ValueError):
        return result


def normalize_usage(raw, *, observed_at, source, required_buckets):
    """Normalize supported account/rateLimits/read fields; drop all account/private data.

    Applicability must be supplied from verified model/bucket discovery. This adapter
    cannot infer which buckets/windows a model uses. Never falls back from a malformed map.
    """
    require(type(raw) is dict and required_buckets, "missing mapping")
    if raw.get("rateLimitsByLimitId") is not None:
        buckets = raw["rateLimitsByLimitId"]
        require(type(buckets) is dict and buckets, "invalid bucket map")
    else:
        legacy = raw.get("rateLimits")
        require(type(legacy) is dict and legacy.get("limitId"), "missing legacy identity")
        buckets = {legacy["limitId"]: legacy}
    windows = []
    for bucket_id in required_buckets:
        require(bucket_id in buckets, "missing required bucket")
        bucket = buckets[bucket_id]
        for slot in ("primary", "secondary"):
            window = bucket.get(slot)
            if window is None:
                continue  # Caller compares normalized IDs to persisted required IDs.
            used = window.get("usedPercent")
            require(type(used) in (int, float) and math.isfinite(used) and 0 <= used <= 100, "invalid usage")
            windows.append({"id": bucket_id + ":" + slot, "duration_minutes": window.get("windowDurationMins"),
                            "remaining": 100 - used, "reset_at": window.get("resetsAt", 0) or 0})
    result = {"schema": "ryladmin.usage.v1", "observed_at": observed_at,
              "source": source, "windows": windows}
    contract("usage", result)
    return result


def account_usage(events):
    """Latest cumulative count per unique job; aggregate/child totals cannot mix."""
    latest, seen, sequences = {}, {}, {}
    for event in events:
        contract("usage-event", event)
        require(event["scope"] == "job", "aggregate totals excluded")
        identity = (event["job_id"], event["event_id"])
        if identity in seen:
            require(seen[identity] == event, "conflicting repeated event")
            continue
        seen[identity] = event
        sequence_key = (event["job_id"], event["sequence"])
        require(sequence_key not in sequences, "ambiguous repeated sequence")
        sequences[sequence_key] = event["tokens"]
        old = latest.get(event["job_id"])
        if old:
            require(event["sequence"] != old["sequence"], "ambiguous cumulative sequence")
            newer, older = (event, old) if event["sequence"] > old["sequence"] else (old, event)
            require(newer["tokens"] >= older["tokens"], "decreasing cumulative usage")
        if old is None or event["sequence"] > old["sequence"]:
            latest[event["job_id"]] = event
    return sum(event["tokens"] for event in latest.values())


def safe_path(root, relative):
    require(type(relative) is str and relative and "\\" not in relative and ":" not in relative, "nonportable path")
    parts = relative.split("/")
    require(all(p and p not in (".", "..") and p == p.rstrip(" .") for p in parts), "path traversal/alias")
    require(not PurePosixPath(relative).is_absolute(), "absolute path")
    for part in parts:
        require(not re.fullmatch(r"(?i)(con|prn|aux|nul|com[1-9]|lpt[1-9])(?:\..*)?", part), "device path")
    root = Path(root).absolute()
    require(root.is_dir(), "missing worktree root")
    # Reject links/junctions in every ancestor, including the selected root.
    for path in [root, *root.parents]:
        if path.exists() or path.is_symlink():
            info = path.lstat()
            require(not stat.S_ISLNK(info.st_mode) and not getattr(info, "st_file_attributes", 0) & 0x400, "reparse root")
    target = root.joinpath(*parts)
    for path in [target, *target.parents]:
        if path == root:
            break
        if path.exists() or path.is_symlink():
            info = path.lstat()
            require(not stat.S_ISLNK(info.st_mode) and not getattr(info, "st_file_attributes", 0) & 0x400, "reparse path")
            require(not stat.S_ISREG(info.st_mode) or info.st_nlink == 1, "hardlink path")
    require(target.resolve().is_relative_to(root.resolve()), "foreign path")
    return target


def writable(relative):
    lower = relative.lower()
    require(not any(p.startswith(".") for p in relative.split("/")), "hidden/protected path")
    require(lower.startswith(("runtime/foundation/", "tests/")), "outside writer surface")
    require(not lower.endswith(("capabilities.json", "source-manifest.json")), "self-grant/integrity record")
    require(not any(p in lower.split("/") for p in ("admission", "grants", "state")), "protected state")


def admit(task, grant, observed, quota_decision):
    """Pure admission over coordinator-owned observations, never caller self-claims."""
    contract("task", task)
    contract("grant", grant)
    require(task["capability"] == "ryladmin-repository-writer", "unknown capability")
    require(task["capability"] == grant["capability"] and grant["status"] == "ADMITTED", "capability unavailable")
    require(task["repository"] == grant["repository"] == "Rylascoo/Ryladmin", "foreign repository")
    for field in ("head", "authority_ref", "authority_sha256", "input_sha256", "tool_sha256", "worktree", "owner", "lease"):
        require(task[field] == grant[field] == observed.get(field), "changed " + field)
    require(observed.get("grant_sha256") == digest(json.dumps(grant, sort_keys=True, separators=(",", ":")).encode()), "grant identity")
    require(observed.get("exclusive_writer") is True and observed.get("paused") is False, "ownership/pause")
    require(observed.get("now", math.inf) < task["expires_at"] <= grant["expires_at"], "expired lease")
    require(task["depth"] <= grant["max_depth"] <= 1, "depth")
    require(type(observed.get("active_jobs")) is int and 0 <= observed["active_jobs"] < grant["max_jobs"] <= 2, "concurrency")
    require(task["deadline_seconds"] <= grant["max_seconds"], "deadline")
    require(task["token_budget"] <= grant["max_tokens"], "usage bound")
    require(task["args"] == [] and not task["network"] and task["mcp"] == [] and task["plugins"] == [], "unexpected startup/arguments")
    require(set(task["tools"]) <= set(grant["tools"]), "foreign tool")
    require(task["write_paths"] and set(task["write_paths"]) <= set(grant["write_paths"]), "write scope")
    require(task["role"] == "repository-writer", "read-only role")
    require(task["cancellation_owner"] == task["owner"], "cancellation owner")
    require(quota_decision.get("dispatch") is True and quota_decision.get("state") in ("NORMAL", "LIGHT"), "quota hold")
    for relative in task["write_paths"]:
        writable(relative)
        safe_path(task["worktree"], relative)
    return {"job_id": task["job_id"], "status": "POLICY_ELIGIBLE", "token_enforcement": "UNAVAILABLE"}


def validate_result(result, task, evidence):
    contract("result", result)
    for field in ("job_id", "repository", "head", "authority_ref", "input_sha256", "owner"):
        require(result[field] == task[field], "result identity")
    require(result["root_exit_code"] == 0 and result["owned_survivors"] == 0, "incomplete termination")
    require(set(result["changed_paths"]) <= set(task["write_paths"]), "foreign result changes")
    require(set(evidence) == {e["path"] for e in result["evidence"]}, "evidence set")
    for entry in result["evidence"]:
        require(digest(evidence[entry["path"]]) == entry["sha256"], "evidence hash")
    return "VALIDATED_RETURN_NOT_ADMISSION"


def save_checkpoint(path, checkpoint):
    contract("checkpoint", checkpoint)
    path = Path(path)
    require(not path.exists() or not path.is_symlink(), "checkpoint link")
    encoded = json.dumps(checkpoint, sort_keys=True, indent=2).encode() + b"\n"
    fd, temporary = tempfile.mkstemp(prefix=".checkpoint-", dir=path.parent)
    try:
        with os.fdopen(fd, "wb") as stream:
            stream.write(encoded)
            stream.flush()
            os.fsync(stream.fileno())
        os.replace(temporary, path)
    finally:
        if os.path.exists(temporary):
            os.unlink(temporary)


def restore_checkpoint(path):
    value = load_json(path)
    contract("checkpoint", value)
    require(value["state"] in STATES, "unknown saved state")
    return value  # No reset to NORMAL, no automatic dispatch or replay.
