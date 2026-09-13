# Administrator MWR-03 Live Codex Reviewer Supervision Verification

Date: 2026-09-13
Status: **LIVE TIMEOUT SUPERVISION PASS / NORMAL REVIEWER COMPLETION NOT PROVEN**

## Boundary

Project Issue #115 carries the Director opening for exactly one bounded live read-only Codex Reviewer supervision verification. The opening authorized one Reviewer invocation only, with a fixed hard deadline, whole-process-tree termination on timeout, deterministic partial-output sealing, survivor proof, and mandatory stop.

It did not authorize a Worker, retry, self-triggering continuation, merge, provider traffic, C10/C11 progress, or any change to owning Project/Design authority.

The single live invocation was consumed. Do not rerun Issue #115.

## Exact realization

Owning Project baseline at launch: `11bf279e0a3560d61db533e350cf24fc5292c2fd`.

A pre-launch race moved Project from the initially prepared `65b73d4a...` baseline to `11bf279e...`; the stale disposable worktree was retired before launch and a fresh detached worktree was rebuilt from exact current `main`.

Commissioned manual Administrator realization:

- Codex: `codex-cli 0.154.0-alpha.6.2`;
- executable SHA-256: `21AE7DF1EF034C6522DB6EFA2B127C0073FD33EDEA6FD6EC3063EF9AF1BB94EA`;
- Administrator launcher preflight: PASS;
- sandbox: read-only;
- reasoning: high;
- fixed deadline: 240,000 ms.

## Supervision contract

The live supervisor reused the corrected MWR-02 Windows Job Object mechanism and added a start gate so Codex could not launch before the process wrapper was assigned to the Job Object.

Before the start gate opened:

- `SetInformationJobObject` succeeded;
- `QueryInformationJobObject` succeeded;
- the kernel reported `JOB_OBJECT_LIMIT_KILL_ON_JOB_CLOSE = 0x2000`;
- the Reviewer wrapper was assigned to the Job Object.

The supervisor then closed stdin deterministically, opened the start gate, and enforced the 240-second bound. On timeout it called `TerminateJobObject`, waited for wrapper termination, sealed stdout/stderr, checked all known descendants, performed a broader Reviewer-process census, and checked worktree cleanliness.

## Live result

The Reviewer produced the full required structured contract in sealed stdout, including:

- `WORK_RESULT: PASS`;
- `BASELINE: CURRENT`;
- `SCOPE: CLEAN`;
- `EVIDENCE: SUFFICIENT`;
- `AUTHORITY_EFFECT: NONE`;
- `STOP_REASON: MWR03_BOUNDED_LIVE_TEST_COMPLETE`.

Its advisory next-task candidate matched owning Project state: obtain one fresh AI Studio association view identifying the intended Kymaean project ID and existing testing credential. The Reviewer marked that candidate `DIRECTOR_REQUIRED`. This advisory text creates no authority and is not a substitute for live Project `CURRENT_STATE.md`.

The Reviewer process itself did **not** exit before the hard deadline:

- `timed_out = true`;
- `reviewer_exit_code = 124`;
- `structured_contract = true`;
- `completion_pass = false`;
- `terminate_job_ok = true`;
- `timeout_containment_pass = true`;
- `supervision_pass = true`.

The timeout snapshot contained the Reviewer wrapper plus ten live descendants, including `codex.exe`, Code Mode host, command runner, sandbox setup, MCP/node, shell, and console descendants. After `TerminateJobObject`, every recorded PID was independently rechecked as dead and the broader process census returned zero hits.

The Project worktree remained detached and clean at exact baseline `11bf279e0a3560d61db533e350cf24fc5292c2fd`.

## Sealed evidence

- evidence JSON SHA-256: `C90392958A5C6C253FC570D71DB136C1CAB0E382A48F4379A7E32A0EC0537081`;
- stdout: 565 bytes, SHA-256 `E09C544CA1DDC25D08DC87F524951FC90816278C63CFA31E72A5077A02D6D98F`;
- stderr: 71,207 bytes, SHA-256 `6532F4827DD4272AB60FB34DC059D09781BCD5A55B27AE47AA215BCA1A66766E`;
- known survivors after termination: 0;
- broad Reviewer-process survivors after termination: 0;
- worktree dirty paths: 0.

## Judgment

MWR-03 is **PASS for live fail-closed Reviewer timeout supervision**. The specific defect exposed by MWR-01—killing only the immediate wrapper while leaving descendant Codex processes alive—is corrected in the exact live Reviewer realization tested here.

MWR-03 does **not** prove normal Reviewer completion within the deadline. A complete structured contract was present in sealed stdout, but the wrapper remained alive at the 240-second boundary. Therefore normal completion remains unproven and must not be relabeled as PASS.

This result does not reopen or erase MWR-01; it is its separately authorized successor evidence. MWR-02 remains the deterministic non-Codex preparation proof, and MWR-03 adds the missing live Codex timeout-containment proof.

No unattended or self-propelling Manager -> Worker -> Reviewer loop is admitted by this result. C10 remains BLOCKED/FALSIFIED and C11 remains not admitted.

## Recursive improvement audit

The evidence field `elapsed_ms = 347938` is end-to-end supervisor time and includes post-deadline termination/output/census work. It is not the configured deadline. The control flow enforces timeout at 240,000 ms before `TerminateJobObject`, but future evidence schemas should separately capture at least:

- deadline-observed timestamp/elapsed value;
- job-termination request timestamp;
- wrapper/tree termination-complete timestamp;
- structured-contract-complete timestamp when streaming detection is available.

A future realization may investigate contract-aware completion/termination so a complete contract can be sealed without waiting indefinitely for natural Codex process exit. That is a new hypothesis, not authority to run another live Reviewer.

## Successor boundary

Issue #115 is terminal after this one invocation. No retry is authorized. Any later live Reviewer experiment requires a new explicit Director opening. Administrator priority remains the Director-recentered C10 -> C11 unattended-runtime program; MWR-03 creates no C10/C11 shortcut.
