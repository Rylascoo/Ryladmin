# PP-CODEX-DESKTOP-RO-02 Packet — 2026-09-12

Status: **SEALED INPUT RECORD — RUN COMPLETE; SEE VERIFIED RESULT — NO C9A AUTHORITY CREATED**

This record preserves the second supervised Windows Codex desktop packet and the recommended fresh-chat boundary. It creates no Project, C9A, C10, C11, provider, Engineering, Design, validation, product, ODR, scheduling, or automation authority.

Run completion/result: docs/PP_CODEX_DESKTOP_RO_02_RESULT_2026_09_12.md. The sealed packet hashes and frozen refs below remain historical input identity; the result record owns post-run verification/disposition.

## Purpose

`PP-CODEX-DESKTOP-RO-02` is an adversarial commissioning audit of the proposed C9A R3 Plan-Mode output-routing hypothesis. Its job is to challenge whether the proposed R2 `--permission-mode plan` -> R3 `dontAsk` change is sufficiently isolated, fail-closed, and testable to justify a future Project opening. It must not implement, invoke, retry, authorize, or commission C9A.

## Frozen packet

Packet root: `C:\Users\Wiryl\.codex-ensemble\scratch\parallel-production\pp-codex-desktop-ro-02`.

Packet SHA-256: `CEE19119D190290238A37E1753D3AE542738B50DA6A4E86C9A1AB1A97EDE2A76`.

Manifest SHA-256: `7FF6392385B16718F32B74302AC79D0658086B39B3CB36E784DA7768DA6FF2A9`.

Frozen authority refs:

- Ryladmin `main`: `c8cb7f42624978e25778f649327101f71de9ef96`;
- Project `main`: `52bd7a934d9d9d48ebf82741b4c495030a746cbc`;
- archived R2 candidate: `58fedc8e54679804813d6780b31f4c034d0e9a2f`;
- R2 parent: `339d0f58e9647dc4efb67ffe362e4ab21c7997a3`;
- R2 archive tag: `archive/q-admin-02-c9a-r2-falsified-timeout-2026-09-11`, tag object `a79f13c11effc47ac4ad5d9696e051c690d38307`.

The packet contains 18 exact repository-source files (158,657 source bytes), the exact R2 candidate delta, a current-main presence census for the five R2 surfaces, and local no-network Claude CLI evidence. It contains no `.git` directory. Final hash verification found zero manifest mismatches and zero likely API/private-key pattern hits.

The archived R2 functional/validation delta is exactly five paths:

- `.agents/skills/claude-readonly-review/SKILL.md`;
- `.github/workflows/gate.yml`;
- `tools/codex-admin-claude-review-selftest.py`;
- `tools/codex-admin-claude-review.py`;
- `tools/codex-admin-skills-selftest.py`.

At frozen Project `main`, the R2 Skill and the two dedicated Claude-review Python files are absent; the workflow and Administrator Skill self-test remain present. The packet requires Codex to treat reconstruction drift as a possible hidden experimental variable rather than assuming the archived candidate can be resurrected unchanged.

The local Claude evidence records commissioned Claude Code `2.1.267` and current CLI help showing `dontAsk` as a supported `--permission-mode`. Syntax support is evidence only; the audit must not infer safe semantics from help text.

## Launch boundary

Use Windows Codex desktop with GPT-5.6 Sol / High reasoning and `Ask for approval`. Open only the packet root above. The fixed task in `packet.md` prohibits edits, Git, network/web, credentials, provider traffic, plugins, browser/Computer Use, and external side effects. Deny any request to cross those boundaries.

The returned result must be supplied back to the Administrator in full. Before adoption, the Administrator rechecks packet integrity, verifies consequential findings against exact authority, and records a PASS/failure result separately. A successful read-only audit does not authorize the live R3 attempt.

## Recommended fresh-chat boundary

The preferred handoff moment is immediately after the Director launches RO-02 in desktop Codex. At that point the old Administrator chat has no unfinished setup mutation: PR #19 is closed, RO-01 is durably recorded, RO-02 is sealed, and the worker run is independent of the ChatGPT conversation.

A fresh Administrator chat should not treat a handoff prompt as authority. It should fresh-resolve live Ryladmin first, read `AGENTS.md` and `CURRENT_STATE.md` through EOF, then recover live Project authority and Website authority only as required by those files. It should read this packet record plus `docs/C9A_R3_PLAN_MODE_HYPOTHESIS_2026_09_12.md`, `docs/C9A_R3_PROJECT_OPENING_SPECIFICATION_2026_09_12.md`, `docs/CODEX_DESKTOP_SUPERVISED_WORKER_ADMISSION_2026_09_12.md`, and the supervised production board.

When the Director supplies the RO-02 final report, the fresh chat should verify the frozen packet hashes/path first, reconcile live refs, audit every consequential finding, and only then decide whether the R3 Project-opening specification needs amendment. Do not launch a live C9A R3 invocation from the handoff alone.
