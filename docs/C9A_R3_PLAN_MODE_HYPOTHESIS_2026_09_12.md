# C9A R3 Plan-Mode Output-Routing Hypothesis — 2026-09-12

Status: **PLAUSIBLE OPERATIONAL HYPOTHESIS — NOT CAUSALLY ISOLATED; LIVE R3 REMAINS BLOCKED PENDING CORRECTED PROJECT/DIRECTOR OPENING**

This is Administrator continuity/research only. It does not authorize a C9A live call, config mutation, retry, C10/C11 progression, repository mutation, provider traffic, or automation.

## Evidence boundary

R1 and R2 both used Claude Code `2.1.267`, high effort, a 180-second hard bound, empty tools, strict MCP isolation, no persistence/browser, first-party Pro auth, and `--permission-mode plan` / no-prompt posture. R1 timed out twice. R2 removed native StructuredOutput, added `--max-turns 1`, local result validation and stronger timeout evidence, then its one authorized live call also timed out. Packet size alone and native StructuredOutput alone are therefore falsified as sufficient explanations.

Fresh supervised evidence adds a different mechanism. PP-ENG-CLAUDE-01A completed normally under the same Plan/no-prompt/tool-less posture but stopped after preliminary analysis and said it would write its full findings to a plan file despite having no file tools. A separate C9-style advisory also completed under Plan Mode and explicitly reported a conflict between Plan Mode's plan-file path and the requested inline result contract. Historical C9 nevertheless completed successfully under Plan Mode.

The surviving narrow hypothesis is:

> In the current headless/tool-less C9A-style task shape, Plan Mode can redirect or suppress the direct inline advisory-result path C9A requires and may materially contribute to timeout or nonconforming-result behavior.

This is a plausible operational hypothesis, not proof that Plan Mode caused R1/R2 and not a universal claim about Plan Mode.

## RO-02 correction

`PP-CODEX-DESKTOP-RO-02` independently audited the proposed R3 opening and returned `R3_HYPOTHESIS_NOT_ISOLATED`. Administrator verified the packet integrity and the consequential findings against live Project/Ryladmin authority. Durable disposition: `docs/PP_CODEX_DESKTOP_RO_02_RESULT_2026_09_12.md`.

The previous wording that R3 would change `one primary runtime variable only` is no longer sufficient as an experiment description. Current Project `main` no longer contains the archived R2 Skill, dispatcher or dispatcher self-test, and a safe successor needs hardening not present in R2. A future R3 candidate therefore has two distinct layers:

1. **reconstructed/hardened baseline** — reconcile the archived R2 capability onto exact then-current Project `main`, while repairing independently justified containment/telemetry/validation gaps; and
2. **mode-only R3 delta** — from that baseline, change `--permission-mode plan` to `--permission-mode dontAsk` plus only the assertions/documentation that necessarily describe that policy delta.

These layers must have separate byte-level manifests/diffs. Any live R3 result evaluates the complete exact realization. It cannot retroactively turn historical R2 into a contemporaneous A/B control.

## `dontAsk` threat model

Claude Code `2.1.267` help confirms that `dontAsk` is a supported permission mode. The same help also states that `--permission-prompts none` automatically denies only actions that would prompt and that the selected permission mode decides everything else. Therefore syntax support is not safe-semantics proof.

R3 may investigate `dontAsk` only after offline/adversarial evidence demonstrates the effective capability posture required by C9A. No-prompt mode must never be represented as a global deny by itself. Empty built-in tools, strict MCP isolation, safe/restricted mode and managed-policy effects must be tested/contained as a combined realization.

## Reconstruction/hardening requirements

Before any Project opening can lead to a live attempt, a separately reconstructed candidate must prove offline at minimum:

- exact commissioned Claude executable path/version/SHA-256 enforcement before review;
- independent golden argv with `plan` absent and exactly one `dontAsk` in the intended position;
- `--permission-prompts none`, empty built-in tools, strict MCP isolation, no persistence/browser/slash-command/fallback/cloud/resume/plugin/worktree switches;
- minimal allowlisted child environment rather than inherited ambient environment plus a finite secret blacklist;
- canonical scratch/config boundaries with reparse/junction escape rejection;
- strict locally validated advisory payload and mandatory runtime-envelope fields;
- terminal evidence on every preflight/spawn/timeout/parse/schema/snapshot/evidence failure path;
- complete process-tree containment/termination proof for timeout/failure, including delayed-child-write tests;
- bounded packet/question/path/stdout/stderr sizes;
- prevention-oriented repository/Git/config/session write containment where practical plus broad before/after mutation checks;
- explicit separation of dispatcher retry, fallback, turn count and any observable provider-request retry signal;
- exact Administrator Skill allowlist with `claude-readonly-review` added, not the archived R2 required-subset weakening;
- CI execution of the dispatcher self-test;
- native Windows ARM64 offline fake-process coverage before live authorization.

## Falsifiable live interpretation

A separately authorized live R3 pass requires one invocation to return a locally valid advisory result inside the frozen bound through the admitted first-party subscription route, with no unauthorized capability use, no survivor process, sealed evidence, zero dispatcher retry and unchanged protected state.

A pass would establish only that the exact R3 realization is operationally adequate for the Director-approved on-demand C9A advisory path and is consistent with the Plan-Mode hypothesis. It would not prove Plan Mode was R2's sole cause.

A timeout, plan-file diversion, malformed/invalid result, missing mandatory telemetry, unexpected capability/permission/provider event, survivor process, unauthorized write or second dispatch falsifies that exact realization. No same-realization retry follows.

C9 remains the commissioned manual advisory plane. C9A remains uncommissioned. C10 remains independently falsified. C11+ remain blocked.