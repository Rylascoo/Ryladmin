# Administrator Supervised Codex Workflow Commissioning — 2026-09-13

Status: **COMMISSIONED FOR MANUAL SUPERVISED PRODUCTION USE**

## Authority boundary

This record commissions a manual operating realization of existing Project orchestration law. It creates no Engineering, Design, provider, validation, ODR, merge, queue, C10, C11, Hook, Automation, scheduling, background, polling, or self-triggering authority. Owning repositories and the Director remain authoritative.

The admitted control pattern is:

`Administrator Manager -> isolated top-level Codex Worker -> fresh read-only Codex Reviewer -> Administrator reconciliation -> STOP`

A Worker may run only for an already-authorized bounded work package. Reviewer invocation is conditional on the applicable review class. The Reviewer returns evidence only and never fixes while reviewing. The outer Administrator reconciles the result before any next dispatch.

## Earned basis

- C4 commissioned separate top-level workspace-write Worker execution because native child inheritance could not preserve the required asymmetric permissions.
- C5 commissioned shared-Git serialization and isolated branch/worktree lifecycle.
- MWR-01 falsified immediate-child-only Reviewer timeout cleanup.
- MWR-02 proved corrected Windows Job Object supervision with kernel-confirmed `JOB_OBJECT_LIMIT_KILL_ON_JOB_CLOSE=0x2000`, explicit timeout termination, supervisor-death cleanup, output sealing, and zero fixture survivors.
- MWR-03 proved the corrected mechanism against a real Codex Reviewer: the Reviewer exceeded the 240-second bound, the full live process tree was terminated, zero known/broad survivors remained, and the exact worktree remained unchanged. Normal Reviewer completion was not proven by MWR-03.

## Production Reviewer realization

Machine: SurfSeven. Dedicated runtime root: `C:\Users\Wiryl\.codex-ensemble`.

- child launcher: `bin\ensemble-reviewer-child.ps1`
- child SHA-256: `8EF97B1268ABBFBBA782642B27EE20B2B8EB0793A64980D921C80BD421E0E0DE`
- supervisor: `bin\ensemble-reviewer-supervisor.ps1`
- supervisor SHA-256: `6C21CE7645E244E4A4127FF1853F904F533FCF1FBCEBFF537ACA4F53AA8A524A`
- runtime manifest SHA-256 after admission: `5653FFA4BC9A1DEDC1055CC255532126A6E4054290F78A811152A6830AF96C00`
- Codex realization remains `codex-cli 0.154.0-alpha.6.2`, executable SHA-256 `21AE7DF1EF034C6522DB6EFA2B127C0073FD33EDEA6FD6EC3063EF9AF1BB94EA`.

The supervisor rejects canonical repository roots, wrong expected HEADs, unadmitted local script/hash drift, changed `.codex/config.toml`, and evidence output outside Administrator scratch. It permits a legitimately dirty post-Worker worktree, seals its full before-state, and requires an identical after-state.

## Fail-closed mechanics

Before Codex can launch, the supervisor creates a Windows Job Object, sets and kernel-queries `KILL_ON_JOB_CLOSE`, launches a gated child wrapper, assigns that wrapper to the Job Object, and only then opens the gate. The prompt is sent after the gate opens so a large prompt cannot deadlock against a child that is not yet consuming stdin.

On deadline, the supervisor snapshots descendants, calls `TerminateJobObject`, waits for wrapper exit, seals stdout/stderr, closes the Job Object, verifies every recorded PID dead, performs a broad command-line survivor census, and verifies the worktree seal is unchanged. Unexpected supervisor exceptions also terminate/wait the Job Object tree before handle close.

Production review success is deliberately stricter than MWR-03 experimental supervision success. `review_pass=true` requires: normal exit before deadline, exit code 0, complete structured contract, identical before/after worktree seal, zero known survivors, and zero broad Reviewer-process survivors. A safely contained timeout is classified separately and returns nonzero; containment safety never becomes review success.

## Deterministic admission evidence

No Worker or Reviewer model invocation was used to admit this production wrapper.

- PowerShell AST parse: zero errors for child and supervisor.
- static safety/invariant audit: 16/16 PASS.
- no-model `-Check` at exact Project `fd9185126b19aab36244c43471ad9a9abab4c8ae`: PASS.
- wrong HEAD negative control: rejected.
- canonical root negative control: rejected.
- output outside Administrator scratch negative control: rejected.
- dirty post-Worker worktree control: accepted and deterministically sealed.
- negative-control evidence SHA-256: `1492F171EAFA3FB18D486F67FE99867157232D6CC5FEAF03F135C57BBA61C34F`.
- disposable admission worktree retired; shared-Git lock residue returned to zero.

## Operating law

Ordinary supervised Reviewer invocations are now normal manual production mechanics under an already-authorized work package; they are not reruns of single-use Project Issue #115 and do not require a fresh Director opening solely because a Reviewer is being invoked. The outer Administrator still race-checks authority, creates the bounded dispatch, owns shared Git mechanics, reconciles returned evidence, and stops before any next dispatch.

This commissioning does **not** authorize recursive execution. A Reviewer may recommend a next task but cannot launch it. A Worker may not create/remove worktrees, mutate shared Git metadata, merge, push, authorize provider traffic, promote validation, or close owning authority. No automatic retry is admitted.

Any materially changed supervision mechanism, permission broadening, autonomous chaining, self-triggering behavior, retry loop, Hooks/Automations enablement, or attempt to cross owning-lane/provider/validation authority remains separately gated. C10 remains blocked/falsified and C11 remains not admitted.

## Recursive audit result

Final audit found no remaining material authority leakage, duplicate backlog/state surface, imaginary automation, stale-runtime substitution, cross-lane write hazard, validation/provider inflation, worktree-lifecycle leak, avoidable Director middleware for ordinary reviews, or worthwhile in-scope simplification. The commissioned workflow is therefore the normal pre-automation Codex Administrator operating mode.
