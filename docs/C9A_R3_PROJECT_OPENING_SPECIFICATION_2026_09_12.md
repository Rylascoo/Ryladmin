# C9A R3 Project Opening Specification — 2026-09-12

Status: **ADMINISTRATOR DRAFT ONLY — CORRECTED AFTER RO-02; NO PROJECT/DIRECTOR OPENING; NO LIVE R3 AUTHORITY**

This file is Ryladmin continuity/research only. It prepares the shape of a possible future `Rylascoo/Ensemble-Project` decision and candidate. It creates no Project authority, no C9A commissioning, no repository-mutation authority outside already-authorized Ryladmin continuity, and no permission to invoke Claude under C9A.

RO-02 disposition: `docs/PP_CODEX_DESKTOP_RO_02_RESULT_2026_09_12.md`.

## Proposed Project authority artifacts

If the Director elects to open R3 after owning-Project reconciliation, Project should create a corrected-attempt decision approximately named:

`docs/evidence/CODEX_ADMINISTRATOR_C9A_R3_PLAN_MODE_OUTPUT_ROUTING_CORRECTED_ATTEMPT_DECISION_2026_09_12.md`

and later a separate isolated implementation branch approximately named:

`q-admin-02-c9a-r3-plan-mode-output-routing-2026-09-12`

The Project decision must merge/validate first. A separate candidate is then reconstructed from the exact validated Project `main`; neither this Ryladmin draft nor archived R2 is authority.

## Corrected hypothesis and evidence claim

R1/R2 packet-size and native-StructuredOutput hypotheses are already falsified as sufficient explanations. Supervised evidence identifies a narrower mechanism: in the current headless/tool-less task shape, Claude Code Plan Mode can redirect or suppress the direct inline advisory-result path C9A requires.

The intended mode-policy delta remains:

`--permission-mode plan` -> `--permission-mode dontAsk`

But RO-02 established that a future R3 is **not** a strict one-variable comparison with historical R2. Current Project `main` lacks three archived R2 surfaces and a safe successor requires independently justified hardening. Service time, packet bytes and Project base also differ.

Therefore a future success may establish operational adequacy of the exact R3 realization and be consistent with the Plan-Mode hypothesis. It may not be represented as proof that Plan Mode was the sole cause of historical R2 failure.

## Required two-layer candidate construction

Archived R2 candidate `58fedc8e54679804813d6780b31f4c034d0e9a2f` is a source oracle only. Do not resurrect or merge it.

The archived R2 functional/validation surface was exactly five paths:

- `.agents/skills/claude-readonly-review/SKILL.md`
- `.github/workflows/gate.yml`
- `tools/codex-admin-claude-review-selftest.py`
- `tools/codex-admin-claude-review.py`
- `tools/codex-admin-skills-selftest.py`

Construct and audit two explicit layers.

### Layer A — reconstructed/hardened baseline

Start from exact then-current Project `main`. Reconstruct only the bounded C9A capability required by current Project law and the Director-approved C9A runtime contract. Produce a byte-level manifest/diff from Project base to this baseline and classify every changed line as one of:

- archived-R2 capability restoration;
- compatibility reconciliation required by current Project law/tree;
- independently justified fail-closed hardening;
- deterministic test/CI evidence;
- documentation describing the same capability.

Any additional functional path beyond the five archived surfaces requires an explicit reason. Mechanical document/index changes must be named separately and may not hide functional changes.

Layer A must repair the independently verified R2 proof gaps below before a live attempt can be considered.

### Layer B — mode-only R3 delta

From Layer A, the only intended runtime-policy change is exactly:

`--permission-mode plan` -> `--permission-mode dontAsk`

plus assertions/documentation that necessarily describe that change. Produce a second byte-level manifest/diff proving no unrelated runtime change occurs in Layer B.

This isolates the proposed mechanism inside the newly reconstructed candidate. It does not create a contemporaneous historical R2 control.

## Frozen invocation shape

Except for the Layer-B permission-mode token, retain the R2 command shape unless stronger current Project/Claude evidence requires a separately classified correction:

- `-p`
- `--safe-mode`
- `--restricted`
- `--tools ""`
- `--strict-mcp-config`
- `--setting-sources user`
- `--permission-prompts none`
- `--no-session-persistence`
- `--output-format json`
- `--effort high`
- `--max-turns 1`
- `--no-chrome`
- `--disable-slash-commands`

Continue to omit native `--json-schema`; ordinary output is parsed locally and validated against the frozen advisory contract. Do not add an explicit model/fallback route merely for R3; capture actual provider/model telemetry.

The Layer-B golden argv must be independent of the function that constructs the command. It must fail if `plan` appears, if `dontAsk` appears other than exactly once immediately after `--permission-mode`, if `none` does not immediately follow `--permission-prompts`, if empty tools are lost, or if dangerous/fallback/cloud/resume/plugin/worktree switches appear.

## `dontAsk` permission threat model

Claude Code `2.1.267` help proves only that `dontAsk` is accepted syntax. It also states that `--permission-prompts none` denies only operations that would have prompted and that permission mode decides everything else. Therefore no-prompt mode is not a global deny mode and `dontAsk` cannot be assumed safe merely from its name.

Before Project can authorize a live R3, offline/adversarial evidence must demonstrate or structurally contain the effective capability posture of the exact combined realization:

- no built-in tool use;
- no MCP server use;
- no subagent/browser/session-persistence path;
- no write-capable path through managed policy or another effective setting;
- no permission event that escapes the admitted read-only contract.

If exact `dontAsk` semantics cannot be established strongly enough for C9A, the proposed realization is not eligible for live authorization.

## Required fail-closed hardening in Layer A

### Runtime identity

Before any review spawn, compare the exact Claude executable path, version and SHA-256 with the commissioned realization. A mismatch fails closed before a model-bearing call.

### Environment / billing route

Construct a minimal allowlisted child environment sufficient for the commissioned first-party Claude subscription path. Do not copy the ambient process environment and merely subtract a finite blacklist. Prove alternate API/cloud-provider credential routes absent without exposing secret values.

Pre- and post-auth evidence must remain inside the admitted `claude.ai` / first-party / Pro boundary.

### Scratch/config path containment

Constrain scratch and Claude config paths to the exact Administrator-authorized roots after canonical resolution. Reject repository/worktree overlap and reparse/junction/symlink-style escape where applicable on Windows. A merely `outside this worktree` path is insufficient.

### Process containment and timeout

The 180-second review bound must cover the live review process and its descendants. The implementation must prove complete process-tree termination on timeout/failure and prove no delayed descendant can mutate protected state after the parent is gone. Git/evidence helper operations that can block the terminal path require their own bounded behavior.

### Evidence sealing

Terminal evidence must be emitted atomically for every significant failure class, including auth, version/hash, spawn, timeout, nonzero exit, parse, schema, snapshot and evidence-write failure where technically possible.

Preserve bounded stdout/stderr before a post-run operation can prevent capture. The terminal record must make clear whether a review process was spawned and whether it survived/was terminated.

### Strict result/runtime contract

Replace the weak three-field payload contract with the complete frozen advisory result contract. At minimum require verdict, ordered severity-ranked findings, exact evidence references, uncertainty/unsupported claims, owning-lane verification recommendation and explicit no-authority statement.

Runtime-envelope fields used as safety evidence must be mandatory and fail closed when absent. Do not default a missing permission-denial field to empty or a missing error field to false. Record actual model/provider/turn/terminal status and available tool/MCP/web/subagent/browser activity indicators.

### Repository/Git/config/session containment

Prefer prevention over after-the-fact inference. The child must not have write capability to Project worktrees/shared Git metadata/config/session surfaces except the exact allowed evidence run directory required by the implementation. Where OS-level write denial is practical, use it and test it.

Before/after evidence must cover every Project worktree and the defined shared Git/config/session surfaces, not only the selected worktree status plus ref/worktree-list hashes. Snapshot equality cannot prove mutate-then-restore; document that limit and rely on prevention for the strongest guarantee.

### Retry/accounting semantics

Distinguish and record separately:

- dispatcher review spawn count;
- dispatcher retry count;
- model turn count;
- explicit fallback route use;
- any authoritative/observable provider-request or internal retry signal available from the exact CLI.

`--max-turns 1` does not by itself prove one provider request.

### Bounds

Freeze maximum question/path count, packet bytes and stdout/stderr capture sizes. Excess must fail deterministically without broadening execution authority.

## Administrator Skill / CI reconstruction law

Current Project `tools/codex-admin-skills-selftest.py` enforces an exact Skill set. Preserve that property.

When reconstructing C9A:

- add `claude-readonly-review` to the exact `REQUIRED_SKILLS` tuple;
- keep `actual == sorted(REQUIRED_SKILLS)` or an equivalent exact-set assertion;
- do **not** carry forward archived R2's required-subset weakening;
- restore the offline C9A dispatcher self-test to the repository-law CI job or a current equivalent so the exact candidate cannot pass CI without its falsification suite.

Do not copy unrelated archived R2 fixture rewrites unless exact current authority independently requires them.

## Required offline adversarial evidence before live authorization

All tests use fake/local processes and frozen local help; no model/provider request is permitted.

The exact candidate must cover at least:

1. **Independent golden argv** — positive exact command and negative moved/duplicated `dontAsk`, any `plan`, missing empty-tools/prompt-none, dangerous/fallback/cloud/resume/plugin/worktree flags.
2. **Frozen help** — required options/wording present; changed/ambiguous contract blocks rather than being guessed.
3. **Executable pin** — exact path/version/hash pass; retarget/hash/version mismatch fail before review.
4. **Environment** — only allowlisted names reach child; alternate credential/provider route classes fail.
5. **Auth** — exact subscription boundary passes; logged-out/malformed/timeout/API-key/alternate provider fail with terminal evidence and zero review spawns.
6. **Scratch/config** — canonical authorized paths pass; repository overlap, arbitrary outside-root paths and reparse/junction escape fail.
7. **Packet generation** — exact commit/paths/question deterministic; traversal/missing/duplicate/oversized input fails.
8. **Strict advisory result** — complete result passes; empty/prose/plan-file promise/malformed/missing/invalid fields fail.
9. **Runtime envelope** — mandatory provider/model/turn/terminal/no-error/activity fields pass only when present and admissible.
10. **Write containment** — fake child attempts current and sibling-worktree, shared-Git, config/session writes and delayed writes; forbidden writes do not succeed.
11. **Mutation detection** — persistent changes to every monitored surface fail; test/doc explicitly states snapshot limits for mutate-restore.
12. **Timeout/process tree** — fake parent spawns child then hangs; bound terminates complete tree, seals partial streams and proves no delayed write.
13. **Failure sealing** — injected auth/version/spawn/timeout/nonzero/parse/schema/snapshot/evidence failures each leave a bounded terminal record where the failure point permits it.
14. **Output bounds** — excessive stdout/stderr fails deterministically without unbounded memory/disk behavior.
15. **Zero dispatcher retry** — every failure mode launches at most one review process.
16. **Native Windows ARM64 suite** — execute the full fake-process/process-tree/write-containment suite on the commissioned Windows ARM64 Python/runtime.

The exact candidate must also pass all current Project repository law, document census, oracle coverage, diff hygiene, compiler/regression and other then-required gates. Offline Linux CI does not replace the native Windows process-behavior evidence above.

## Proposed one-attempt live gate

A live R3 pilot remains a separate Director/Project decision after:

1. the corrected Project-owned decision is merged/validated;
2. Layer A reconstruction/hardening is exact-manifested and audited;
3. Layer B mode-only delta is exact-manifested and audited;
4. the complete offline/adversarial suite passes, including native Windows ARM64 cases;
5. a distinct live-pilot authorization opens exactly one model-bearing invocation.

Immediately before dispatch, reverify exact candidate HEAD/cleanliness, commissioned Claude binary identity, first-party subscription auth, allowlisted child environment, effective capability posture, scratch/config identity, exact argv, packet manifest and protected pre-snapshots.

Build a fresh exact-ref packet. Record exact refs, path list, question hash, byte count and SHA-256. The packet will necessarily differ from historical R1/R2 and must not be used as if it were a contemporaneous control.

### Pass criteria

The single invocation must:

- finish within the frozen bound;
- return the complete strict locally valid advisory result;
- report the mandatory admissible runtime envelope;
- use the first-party subscription route with actual model recorded;
- use one turn, no admitted tool/MCP/web/subagent/browser/session-persistence capability;
- produce no unexpected permission event or alternate provider/fallback route;
- leave no survivor process;
- seal raw streams/result/packet/manifest/command/runtime/terminal evidence with hashes;
- keep protected repository/Git/config/session state within the frozen equality/allowed-difference rules;
- perform exactly one dispatcher review spawn and zero dispatcher retry;
- result in manager reconciliation with no automatic implementation.

### Fail criteria

Any timeout, plan-file diversion, empty/malformed/schema-invalid result, missing mandatory runtime field, unexpected capability/permission/provider/fallback event, auth drift, output bound violation, survivor process, unauthorized write/protected-state difference, evidence-sealing failure or second review dispatch falsifies the exact R3 realization. No same-realization retry follows.

A pass commissions only the Director-approved on-demand read-only C9A advisory path. It does not pass C10, unlock C11, authorize mutation, schedule/background work, enable product-provider traffic, alter validation, or change Engineering/Design/product/ODR authority.

## Director opening sequence

1. Fresh-resolve Project/Ryladmin authority and reconcile any newer owning-lane state.
2. Convert this corrected Administrator draft into a Project-owned corrected-attempt decision with exact then-current base SHA and one-attempt semantics.
3. Merge/validate that decision through normal Project process.
4. Create a separate candidate from the exact validated Project base.
5. Build Layer A reconstructed/hardened baseline and audit its manifest/diff.
6. Build Layer B mode-only R3 delta and audit its manifest/diff.
7. Run recursive audit plus complete offline/CI/native-required validation. No live Claude review occurs merely because tests pass.
8. Only after a distinct live-pilot authorization, consume exactly one R3 invocation.
9. Record operational PASS or falsification durably without making a sole-cause claim.

Until step 8 is explicitly authorized, C9 manual Claude review remains the commissioned advisory plane and supervised parallel production may continue independently.