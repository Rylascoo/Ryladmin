# C9A R3 Project Opening Specification — 2026-09-12

Status: **ADMINISTRATOR DRAFT ONLY — NO PROJECT/DIRECTOR OPENING; NO LIVE R3 AUTHORITY**

This file is Ryladmin continuity/research only. It prepares the exact shape of a future `Rylascoo/Ensemble-Project` corrected-attempt decision and implementation candidate. It creates no Project authority, no C9A commissioning, no repository mutation authority outside Ryladmin, and no permission to invoke Claude under C9A.

## Proposed Project authority artifacts

If the Director elects to open R3, Project should create a decision record named approximately:

`docs/evidence/CODEX_ADMINISTRATOR_C9A_R3_PLAN_MODE_OUTPUT_ROUTING_CORRECTED_ATTEMPT_DECISION_2026_09_12.md`

and a separate isolated implementation branch named approximately:

`q-admin-02-c9a-r3-plan-mode-output-routing-2026-09-12`

The decision must merge first through normal Project PR/Validation. The implementation candidate must then be built separately from the exact then-current Project `main`; do not treat this Ryladmin draft or an old archived candidate as authority.

## Frozen causal hypothesis

R1/R2 packet-size and native-StructuredOutput hypotheses are already falsified. Fresh supervised evidence identifies a narrower mechanism: in the current headless/tool-less task shape, Claude Code Plan Mode can redirect or suppress the direct inline advisory-result path C9A requires.

R3 changes one primary runtime variable only: `--permission-mode plan` becomes `--permission-mode dontAsk`.

The commissioned Claude realization remains frozen at Claude Code `2.1.267`, executable SHA-256 `0DC306259E3036AF4255F66B77451D3F7297BCD376BFAE20F7B42E2FA1473607`. Local CLI help explicitly lists `dontAsk` and `plan` as supported permission modes and states that `--permission-prompts none` automatically denies anything that would otherwise prompt.
## Candidate construction contract

Use archived R2 candidate `58fedc8e54679804813d6780b31f4c034d0e9a2f` only as a source oracle. Do not resurrect or merge it. Reconcile its bounded implementation into the then-current Project tree.

The R2 functional/validation surface was exactly five paths:

- `.agents/skills/claude-readonly-review/SKILL.md`
- `.github/workflows/gate.yml`
- `tools/codex-admin-claude-review-selftest.py`
- `tools/codex-admin-claude-review.py`
- `tools/codex-admin-skills-selftest.py`

R3 should preserve that bounded surface unless current Project law requires a mechanical documentation/index adjustment. Any additional functional path requires an explicit reason in the candidate audit.

The dispatcher invocation must retain: `-p`, `--safe-mode`, `--restricted`, empty `--tools`, `--strict-mcp-config`, `--setting-sources user`, `--permission-prompts none`, `--no-session-persistence`, `--output-format json`, `--effort high`, `--max-turns 1`, `--no-chrome`, and `--disable-slash-commands`.

The dispatcher must continue to omit Claude native `--json-schema`; ordinary output is parsed locally and validated against the frozen review payload contract. No explicit model/fallback route should be added merely for R3; actual provider/model telemetry must be captured.

The only intended invocation-policy change is `--permission-mode dontAsk`. The candidate must contain an adversarial assertion that `plan` is absent and `dontAsk` is present at the exact command position.

All R2 fail-closed controls remain: 180-second hard subprocess bound, one dispatcher invocation, zero automatic retry, scrubbed API/cloud credential routes, first-party claude.ai Pro authentication, scratch outside every Project worktree, timeout/failure stdout-stderr-telemetry sealing, and before/after Git/ref/status/worktree snapshots.

## Required offline evidence before any live call

The exact candidate must pass the existing R2 adversarial suite plus explicit R3 checks for: non-Plan permission mode, `--permission-prompts none`, empty tool surface, strict MCP isolation, one-turn command bound, absence of native StructuredOutput, deterministic packet generation, local schema validation, auth fail-closed behavior, scratch-boundary enforcement, repository mutation detection, timeout telemetry sealing, and post-timeout mutation detection.
The full Administrator Skill fixture suite, repository law, document census, oracle coverage, diff hygiene, ARM64 cross-compile, and any still-required Project x64 regression must also pass on the exact candidate before live authorization.

## Proposed one-attempt live gate

A live R3 pilot remains a separate Director/Project decision after the decision record and implementation candidate are both durably validated. Exactly one invocation may be authorized.

Immediately before dispatch, reverify the exact candidate HEAD/cleanliness, Claude version/hash, first-party Pro authentication, absence of `ANTHROPIC_API_KEY` and alternate cloud-provider routes, scratch boundary, command line, and repository snapshot.

Build a fresh exact-ref packet from the authorized R3 candidate. It must not be byte-identical to any preserved R1/R2 packet. Record exact source refs, path list, byte count, and SHA-256 before invocation.

R3 passes only if the single invocation returns within the frozen 180-second bound with a locally schema-valid structured advisory payload, one turn, no unauthorized tools/MCP/subagents/browser/session persistence, admitted first-party subscription routing, sealed result/runtime telemetry, zero dispatcher retry, and identical repository/Git state before and after.

Timeout, plan-file diversion, malformed or locally invalid payload, unexpected permission denial/capability use, alternate billing/provider route, repository-state change, or missing telemetry falsifies R3. No same-realization retry follows.

A pass commissions only the Director-approved on-demand read-only C9A advisory path. It does not pass C10, unlock C11, authorize mutation, schedule/background work, enable provider traffic, or alter Engineering/Design/product/ODR/validation authority.

## Director opening sequence

1. Fresh-resolve Project authority and reconcile any current Engineering gate before opening Administrator work.
2. Convert this draft into a Project-owned corrected-attempt decision with exact then-current base SHA and explicit one-attempt semantics.
3. Merge/validate that decision through normal Project process.
4. Create the separate R3 candidate from the exact validated Project base and reconstruct the bounded R2 surfaces with the single `dontAsk` policy delta.
5. Run recursive audit plus all offline/CI/native-required validation. Do not invoke Claude live from the implementation branch merely because tests pass.
6. Only after exact candidate validation and a distinct live-pilot authorization, consume one R3 invocation.
7. Record PASS or falsification durably; never infer C10/C11 progression from C9A.

Until step 6 is explicitly authorized, C9 manual Claude review remains the available advisory plane and supervised parallel production may continue independently.
