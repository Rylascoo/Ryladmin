# Ryladmin Current Administrator State

Updated: 2026-09-11

## Scope

This file carries Administrator continuity only. It never overrides Ensemble Project/Website authority. Every fresh session must read root `AGENTS.md`, re-resolve live owning refs, and reconcile this snapshot before acting.

If the commissioned machine/runtime is lost, read `docs/ADMINISTRATOR_DISASTER_RECOVERY.md` and use the `recovery/` kit. Durable gate history and local capability realization are separate: repository/CI evidence survives hardware loss, but a replacement machine must re-prove its local tools, auth, paths, connectors, and fail-closed defaults.

## Last reconciled owning authority snapshots

`Rylascoo/Ensemble-Project` was last reconciled at `main@2ec8905f2998f94e2650e89510989753c589ce43`, commit `Integrate Q-E0A-03 Run 06 activation`. Post-merge Validation #656 (`34570969833`) passed on that exact SHA.

Project `CURRENT_STATE.md` at that SHA still says Run 06 is preregistered/preexecution-green and becomes executable only after activation integration plus post-merge Validation, and its `Next` text still instructs activation integration. The integration merge and Validation #656 are objective facts, but Ryladmin does not convert them into provider-execution authority. Re-read live Project state/queue/Director authority before any provider-dependent action.

At this snapshot, Project native validation authority remains `bb869fb1c505603612bc718f739b3f1b358e5539` under tag `validation/e0a-gemini-technical-failure-diagnostic-classification-native-arm64`; provider traffic recorded by Project state remains zero after Run 05 and Run 06 consumption is recorded as zero calls.

`Rylascoo/Ensemble-Website` was last reconciled at `main@017458bd8b5453d3a048ef8a0a60dc68fb5cbc31`, `Complete TYP-02 branch promotion`. TYP-02 is closed with one provisional survivor, F1 Ratio Ladder; Design remains separately authoritative and requires a fresh Phase-B shared-brand sequencing/reentry audit before another integration/convergence program. This is a snapshot only.

## Administrator gate status

**C0-C9 DONE. C10 - Hook pilot is IN PROGRESS and not yet passed. C11+ remain blocked.**

C9 creates no Engineering, provider, experiment, product, Design, ODR, spend, or validation authority. Claude remains advisory. C10 remains bounded by the live Runtime Specification/queue and the incomplete pilot state below.

## C10 Hook pilot - incomplete fresh-chat handoff

C10 is the sole active Administrator commissioning gate. It is not closed. Normal Administrator `config.toml` still has `features.hooks = false`; Hooks are enabled only for bounded C10 pilot invocations. Automations remain blocked until C11.

Disposable fixture: `C:\\Users\\Wiryl\\Sol Dev\\Ensemble-Admin-C10-Hook-Fixture`, baseline HEAD `70a0f6f90eff4a1a0772beb109d14b8e3393f387`. Its dirty/untracked pilot evidence is intentional; do not clean or repurpose it before C10 evidence is reconciled. The authoritative Project root remains separately clean/detached at its historical validation checkout.

Pilot implementation: user hook config `C:\\Users\\Wiryl\\.codex-ensemble\\hooks.json`; guard `C:\\Users\\Wiryl\\.codex-ensemble\\hooks\\c10-protective-guard.py`; Windows wrapper `C:\\Users\\Wiryl\\.codex-ensemble\\hooks\\c10-guard.cmd`. The one `PreToolUse` matcher covers `Bash|shell_command|exec_command`, timeout 5 seconds. The guard deterministically allows ordinary commands, denies commands containing `C10_FORBIDDEN`, and deliberately exits nonzero for commands containing `C10_HOOK_FAILURE`.

Direct preflight proved the Python guard's allow JSON, deny JSON with explicit blocking reason, and deliberate nonzero failure branches. The first Codex-trusted definition used embedded quoted executable paths, hash `sha256:9665c3a5fb20d77d7e5f8f38de33a083c1b0544fe1ff54c91cdcfa7ce7b021ec`. A live allowed-action attempt produced `PreToolUse Failed`; the guard log showed the script was never reached and the harmless command executed. Treat that attempt as rejected pre-proof and evidence of a Windows hook-launch/possible fail-open path, not as a C10 pass.

The definition was corrected to the no-space `.cmd` wrapper. Codex changed the hash to `sha256:96ca6c600481fd14fa68f44f76e7de5e86d6a17c305c514e75bf780363fc3d72` and reported `trustStatus=modified`, directly proving content-hash trust invalidation. Trust was then renewed through Codex's supported config API, never through `--dangerously-bypass-hook-trust`. After the latest RDC restart, a fresh app-server `hooks/list` readback reports the corrected exact hash with `trustStatus=trusted`, no warnings/errors.

Exact remaining C10 execution: (1) one harmless allowed shell command must fire the hook and execute; (2) one harmless command containing `C10_FORBIDDEN` must be denied before execution with the explicit guard reason; (3) one harmless command containing `C10_HOOK_FAILURE` must prove fail-closed behavior. If case 3 executes after the hook process fails, classify C10 as blocked by Codex fail-open semantics and do not weaken the Runtime Specification. Preserve hook logs/output and prove no Project authority rewrite. Do not start C11.

RDC was restarted by the Director immediately before this handoff and SurfSeven is reachable again. Do not rely on any old app-server PID/session; start a fresh census as needed and re-list the hook rather than recreating or retrusting it.

## C9 Claude read-only review closeout

Dedicated Claude Code 2.1.267 ARM64 was commissioned under isolated `C:\Users\Wiryl\.claude-ensemble` state. Authentication proved first-party `claude.ai` Pro subscription use; no `ANTHROPIC_API_KEY` or alternate cloud-provider credential route was admitted. Credentials/OAuth state are not stored in Ryladmin and must be reauthenticated interactively on any replacement machine.

One bounded independent review was executed against a fixed packet from exact Project C8 merge `e9511cacb2a58e59aa18595248bdf9ea16d7c435`. Built-in tools were disabled, MCP was isolated, permission mode was plan, session persistence was disabled, and the reviewer used zero web requests and zero subagents. The review returned `PASS_WITH_FINDINGS`; it was not retried or rewritten into a clean result.

Two material C8 findings were accepted and repaired before C9 closeout: direct cross-origin storage isolation and direct browser-permission denial. A fresh Guest context proved origin B could not see origin A `localStorage`, live cookies stayed zero, actual geolocation and notification requests were denied, active Guest account entries were zero, Login Data was absent, safe teardown succeeded, and the ordinary Edge session remained untouched. The earlier non-Guest auto-signed attempt is explicitly rejected evidence.

Durable C9 Project evidence: `docs/evidence/CODEX_ADMINISTRATOR_C9_CLAUDE_READ_ONLY_REVIEW_2026_09_11.md`. Corrected C8 evidence remains `docs/evidence/CODEX_ADMINISTRATOR_C8_BROWSER_CDP_PILOT_2026_09_10.md`.

## C9 Project promotion / archive / disposal

- final candidate: `9db16f96dbd2e612b200e2f7ae45ba5a0afe8484`;
- parent/live base at commit: `51fadfa610548c11bb010effaae6fc644820c080`;
- exact-commit repository law, document authority, oracle guard, diff hygiene, protected-diff, and commissioning-closeout: PASS;
- protected-diff: only `CURRENT_STATE.md` and `docs/PROJECT_EXECUTION_QUEUE.md` were adopted protected surfaces; `authority_created=false`;
- commissioning closeout: exact clean head, `validation_rung_promoted=false`;
- push Validation #649 (`34570182641`): PASS;
- PR #74: one commit, six changed files, exact expected head/base;
- PR Validation #650 and E0-E preparation #30: PASS;
- merge: `78026f3fae040dabcdd55fe0adc331c06ffa2b21`;
- post-merge Validation #653 (`34570417785`): PASS;
- archive tag: `archive/q-admin-02-c9-claude-review-closeout-2026-09-11`;
- annotated tag object: `97c6424e4af07bf91788dc4ce52532d0fbe45ac5`;
- local/remote tag peel: exact candidate `9db16f96dbd2e612b200e2f7ae45ba5a0afe8484`.

The C9 candidate is contained in Project main. Its worktree, local branch, and remote branch are retired. Final Project root remains clean/detached at historical validation checkout `689655eed677b789ab3ee395f1c65b4f2cb72cc8`; shared-Git lock residue is zero. Unrelated Engineering and validation/evidence worktrees were preserved.

## Commissioned runtime continuity

Historical SurfSeven realization remains useful as a reproducibility checkpoint, not as replacement-machine authority:

- dedicated Codex home: `C:\Users\Wiryl\.codex-ensemble`;
- Codex: `codex-cli 0.153.4`, ARM64 binary SHA-256 `77F792476FE0DEF726503F02A7C55F485E562DD7AD8801FE61DC8F4BF9991D20`;
- pinned Python: 3.12.10 ARM64, executable SHA-256 `7F1EBBBB04164CAF8F8073AAFA7F82321FB44695E10FE6A9EBAF2138B63892C4`;
- shared-Git helper SHA-256 `A8550C6234D0C5F8721AB2224DAE36043C7E649077BD73A2A16F765547C55830`;
- runtime manifest SHA-256 `D19CD1333E0642960FED60D75BFDCF1BFCAAE1DD3AD2B7BC0C7FB6D6E2D743F9`;
- Claude Code historical admitted version: 2.1.267;
- Remote Desktop Commander historical admitted version: 0.2.50.

Base runtime remains fail-closed: read-only / on-request, no ambient network, browser/CDP off by default, computer use off, Hooks off until C10, Automations off until C11, memories/goals/multi-agent/remote plugins off, and no provider authorization created by runtime recovery.

The C7 connector-selection incident correction remains binding: edit Ryladmin only from an isolated local branch, audit the net diff, and explicitly load/use pull-request operations for PR creation/merge. Do not mutate Ryladmin `main` through generic connector file actions.

## Machine-loss recovery kit

Ryladmin now carries the portable non-secret recovery surface:

- `docs/ADMINISTRATOR_DISASTER_RECOVERY.md` - governing recovery contract;
- `recovery/RECOVERY_BASELINE.json` - historical tool/ref/safety snapshot;
- `recovery/bootstrap-ensemble-admin.ps1` - ARM64/tool validation, repository clone/verification, and idempotent fail-closed runtime rendering;
- `recovery/verify-recovery.ps1` - non-mutating core safety/live-ref verification plus interactive-action reporting;
- `recovery/templates/runtime/` - sanitized Administrator/Worker configs, launchers, lock helper, and bounded agent definitions.

The kit intentionally excludes all auth tokens/files, Claude OAuth state, API keys, Git credentials, browser/profile data, Codex databases/logs/sessions/memories, machine installation IDs, and private Design assets outside their authorized storage. Connector IDs and machine/device IDs are treated as re-discoverable bindings, not authority.

A replacement machine may preserve C0-C9 as durable historical gate closures, but may not use a local capability until the recovered machine verifies that capability's realization. Tool-version/hash drift requires explicit revalidation; the bootstrap never silently substitutes a new binary or overwrites differing runtime files.

Disposable recovery rehearsal on 2026-09-11 passed from a blank fake user profile: fresh Ryladmin/Project/Website clone topology, fail-closed runtime render, independent verification, live-ref discovery, and idempotent second apply all passed. The rehearsal caught and corrected a manifest rendering typo, a stale Codex hash, an unsafe Git-exit-code comparison, and an invalid requirement for untracked .ensemble-project-root.

## Exact continuation - C10

Before acting, re-resolve live Ryladmin, Project, and relevant Website refs. Read Ryladmin `AGENTS.md`/`CURRENT_STATE.md`, then Project `AGENTS.md`, `CURRENT_STATE.md`, `docs/PROJECT_AUTHORITY.md`, `docs/PROJECT_EXECUTION_QUEUE.md`, `docs/AGENT_TOOLING_CAPABILITY_SNAPSHOT.md`, and `docs/blueprint/CODEX_ADMINISTRATOR_RUNTIME_SPECIFICATION.md`. Reconcile any newer Engineering/provider/validation state before relying on this snapshot.

If the machine/runtime differs from the commissioned realization or has been replaced, complete `docs/ADMINISTRATOR_DISASTER_RECOVERY.md` and `recovery/verify-recovery.ps1` first.

At the last reconciliation, C10 is the Runtime Specification Hook pilot and the sole earned Administrator gate. Recover its exact contract from Project authority. The last recorded contract requires exactly one deterministic protective hook and proof of expected firing, pre-execution blocking of a forbidden disposable action, an allowed action, trust invalidation on hook change where applicable, fail-closed hook failure, and no authority rewrite.

Do not start C11, Automations, provider traffic/spend, validation promotion, Design/ODR adjudication, danger-full-access, automatic merge, or automatic unique-branch deletion from C10. Preserve active Engineering work, unexplained unique refs, detached validation/evidence worktrees, and shared-Git serialization.
