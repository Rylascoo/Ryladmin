# PP-CODEX-DESKTOP-RO-02 Result — 2026-09-12

Status: **READ-ONLY PILOT PASS — R3 OPENING SPECIFICATION REQUIRES CORRECTION; NO C9A AUTHORITY CREATED**

This record preserves the independently returned Windows Codex Desktop adversarial audit of the proposed C9A R3 Plan-Mode hypothesis. It is Administrator continuity only. It creates no Project, Engineering, Design, provider, validation, product, ODR, C9A commissioning, C10, C11, scheduling, background-execution, or live-invocation authority.

## Frozen input and returned result

Packet root: `C:\Users\Wiryl\.codex-ensemble\scratch\parallel-production\pp-codex-desktop-ro-02`.

Packet SHA-256: `CEE19119D190290238A37E1753D3AE542738B50DA6A4E86C9A1AB1A97EDE2A76`.

Manifest SHA-256: `7FF6392385B16718F32B74302AC79D0658086B39B3CB36E784DA7768DA6FF2A9`.

Returned report as supplied to the Administrator: 27,635 bytes; SHA-256 `31B35EB0E0EC0C0FE636B2EC1256C86D5B2CD5584F4BAFC9F6D22782CF648012`.

Worker verdict: `R3_HYPOTHESIS_NOT_ISOLATED`.

Administrator independently recomputed the packet/manifest hashes and then verified every manifest-listed source/derived/runtime artifact plus `packet.md`: 24 of 24 byte counts and SHA-256 values matched; zero mismatches were found. The result therefore applies to the exact sealed packet it claims to review.

## Fresh live reconciliation

Before adopting any finding, Administrator fresh-resolved owning authority:

- Ryladmin `main@9c447f8e732b44e9c0326598606a03ba2dff4b57`;
- Project `main@38f67609c611a1e16e512ad2c22245835a4eb709`;
- Website `main@1f0b696e7341a58642904b14969d2eb9f60596ee`.

The RO-02 packet was frozen at Ryladmin `c8cb7f42624978e25778f649327101f71de9ef96` and Project `52bd7a934d9d9d48ebf82741b4c495030a746cbc`. Ryladmin has advanced only through supervised-production/RO-02 continuity. Project has advanced two commits, but the changed paths are E0-B state/index/queue/activation evidence only; none changes the C9A runtime specification or the five archived R2 functional/validation surfaces. The R2 archive tag still resolves through tag object `a79f13c11effc47ac4ad5d9696e051c690d38307` to exact candidate `58fedc8e54679804813d6780b31f4c034d0e9a2f`.

Project push-triggered Validation run #728 on `38f67609...` is green. Project `CURRENT_STATE.md` still says activation integration/post-merge Validation is pending and marks provider traffic BLOCKED. Administrator records the CI fact but does not convert it into provider execution authority or rewrite Project state; owning Engineering/Director must reconcile that volatile boundary.

Website has no active Design serial at the reconciliation point. No Design file or authority was changed by this audit.

## Consequential findings independently verified

### 1. Plan Mode remains a plausible hypothesis, not isolated causal proof

R1 and R2 shared Plan Mode and failed; supervised Plan-Mode advisories also demonstrated plan-file/output-routing behavior. Historical C9 nevertheless completed under Plan Mode. Therefore the narrow hypothesis remains plausible: Plan Mode can interfere with the direct headless result path in this task shape. It is not established as a universal or sole timeout cause.

A future R3 success can demonstrate operational adequacy of that exact realization and be consistent with the hypothesis. It cannot prove Plan Mode was the sole cause of R2 because time/service state, packet bytes, Project base, reconstructed code and required hardening differ. A future failure falsifies that R3 realization, not every possible Plan-Mode mechanism.

### 2. R3 is reconstruction, not a one-token edit of current Project main

Current Project `main` does not contain the archived R2 Claude-review Skill, dispatcher, or dispatcher self-test. The workflow and Administrator Skill self-test remain but must be reconciled. Any R3 candidate must therefore reconstruct the bounded R2 capability onto then-current Project authority rather than merge/resurrect R2.

The candidate must expose two separately auditable deltas:

1. current Project `main` -> reconstructed/hardened C9A baseline; and
2. reconstructed/hardened baseline -> R3 policy delta.

Only the second delta may contain the intended `--permission-mode plan` -> `dontAsk` change plus assertions/documentation that necessarily describe it. Any safety hardening belongs in the first delta and must be classified separately.

### 3. `dontAsk` safety semantics are not proven by CLI syntax

The sealed Claude Code `2.1.267` help lists both `dontAsk` and `plan`, but `--permission-prompts none` says only operations that would prompt are automatically denied and that permission mode decides everything else. `--tools ""` disables built-in tools; restricted/safe mode reduce surfaces but managed policy may still apply.

Therefore `dontAsk` must be treated as an unproven permission-semantic boundary until offline/adversarial evidence demonstrates the effective capability posture required by C9A. The corrected specification must not equate no prompts with global denial.

### 4. Archived R2 tests do not independently pin the command

The R2 `FakeRunner` computes its expected argv by calling the same `review_command()` function under test. That is circular for exact command construction and does not test real Claude permission semantics. R3 requires an independent golden argv plus negative assertions: no `plan`, exactly one `dontAsk` immediately after `--permission-mode`, `none` immediately after `--permission-prompts`, empty tools, and no dangerous/fallback/cloud/resume/plugin/worktree switches.

### 5. The archived R2 Skill fixture weakening must not return

Current Project law requires an exact Skill set. Archived R2 changed the fixture from exact equality to a required-subset test while leaving `claude-readonly-review` outside `REQUIRED_SKILLS`. That would admit unexplained Skills.

R3 must instead add `claude-readonly-review` to the exact `REQUIRED_SKILLS` tuple and preserve the exact-set assertion.

### 6. Several R2 fail-closed gaps are real and must be separated from the mode hypothesis

Direct source audit confirms that archived R2:

- inherits the ambient environment and removes only a finite credential blacklist rather than constructing a minimal allowlisted child environment;
- records Claude executable version/hash but does not compare them with the commissioned identity before review;
- bounds the direct subprocess with `subprocess.run(timeout=180)` but does not prove complete Windows descendant/process-tree termination;
- takes its post repository snapshot before sealing stdout/stderr files;
- can fail before terminal telemetry is written on auth/version/spawn/snapshot/evidence paths;
- validates only a weak `verdict`/string `summary`/array-of-arbitrary-object `findings` payload;
- accepts absent `permission_denials` as empty and absent `is_error` as false;
- snapshots the selected worktree status plus refs/worktree topology but does not prove complete sibling-worktree/Git/config/session immutability or mutate-then-restore absence.

These are not evidence that R2 mutated anything; R2's recorded before/after state was unchanged. They are limits on what R2 proved and required hardening inputs for any new realization.

## Corrected R3 opening boundary

The current R3 Project-opening draft is not ready to be converted into Project authority as written. Before any Project opening, the Administrator draft must require:

- byte-level reconstruction/hardening manifest distinct from the mode-only delta;
- explicit statement that historical R2 vs future R3 cannot provide strict causal proof;
- `dontAsk` threat model and effective-permission falsification tests;
- exact executable path/version/hash enforcement before review;
- minimal allowlisted child environment;
- canonical scratch/config boundary with reparse/junction escape tests;
- independent golden argv and negative command assertions;
- exact Skill allowlist preservation and CI execution of the dispatcher self-test;
- strict advisory-result schema and fail-closed mandatory runtime fields;
- terminal evidence on every preflight/spawn/timeout/parse/schema/snapshot/evidence failure path;
- bounded stdout/stderr/question/path/packet sizes;
- Windows process-tree containment/termination proof and delayed-write tests;
- prevention-oriented repository/Git/config/session write containment where practical, plus broader before/after mutation checks;
- explicit separation of dispatcher retry, fallback, model-turn count, and any observable provider-request retry signal;
- native Windows ARM64 offline fake-process coverage before any live authorization.

A future live gate remains exactly one separately Director/Project-authorized invocation after the corrected decision and separately reconstructed/audited candidate pass their required validation. No same-realization retry follows a terminal outcome.

## Desktop worker disposition

`PP-CODEX-DESKTOP-RO-02`: **PASS** for supervised read-only analysis.

Pass basis:

- the worker returned a complete bounded adversarial deliverable;
- its central verdict survived independent exact-source verification;
- packet limitations were stated rather than filled with invented facts;
- actionable claims were separable into verified, packet-limited and proposed-hardening categories;
- the sealed packet remained internally valid when independently rehashed;
- no worker output was treated as owning authority.

This PASS extends only the already-admitted read-only desktop-worker use class. It does not admit desktop Codex as a mutating worker and does not create C9A authority.

## Administrator disposition

R3 remains **LIVE-BLOCKED**. R1/R2 remain immutable falsifications and non-retryable. The Plan-Mode output-routing hypothesis remains worth offline investigation, but the prior `single primary runtime variable` framing is corrected: the future candidate must first establish a reconstructed/hardened baseline and then isolate the mode-only delta within that candidate.

C9 manual Claude review remains commissioned. C10 remains falsified/blocked pending its independent upstream trigger. C11 and Administrator Automations remain blocked.