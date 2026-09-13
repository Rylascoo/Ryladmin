# Administrator MWR-02 Process-Supervision Preparation

Date: 2026-09-13
Status: **NON-CODEX PREPARATION PASS / LIVE REVIEWER TEST NOT AUTHORIZED**

## Boundary

This record is Administrator continuity only. It does not create Project, Engineering, Design, provider, validation, C10, C11, scheduling, background, or self-triggering authority.

PP-ADMIN-MWR-01 / Project Issue #112 remains terminally closed as **PARTIAL PASS / REVIEWER SUPERVISION FALSIFIED**. Its Reviewer exceeded the intended bound and the first supervisor failed to terminate the descendant Codex process tree.

PP-ADMIN-MWR-02 therefore tested only the missing process-supervision primitive with deterministic non-Codex fixtures. No live Codex Reviewer process was launched.

## Fixture design

A Windows Job Object supervisor was tested against a deterministic PowerShell parent -> child -> grandchild process tree. The target parent is assigned to the Job Object before a start gate opens, so descendants inherit the job before performing fixture work.

The intended fail-closed properties are:

- normal completion is not killed;
- deadline expiration terminates the entire job tree;
- partial stdout/stderr are sealed after termination;
- known PIDs are verified dead;
- a broader fixture-process census finds no survivors;
- supervisor loss closes the Job Object and kills inherited descendants through `JOB_OBJECT_LIMIT_KILL_ON_JOB_CLOSE`.

## Recursive falsification and correction

The first crash-safety attempt failed: killing the supervisor left parent, child, and grandchild alive. Direct `QueryInformationJobObject` inspection showed the kernel had received `LimitFlags = 0x0`, despite the script intending `KILL_ON_JOB_CLOSE`.
Root cause was PowerShell value-type semantics: mutating the nested native `BasicLimitInformation.LimitFlags` field modified a temporary copy rather than the struct ultimately passed to Windows. The implementation was corrected to copy, modify, and reassign the nested struct.

A fresh kernel query then reported:

`LimitFlags = 0x2000`

which is the intended `JOB_OBJECT_LIMIT_KILL_ON_JOB_CLOSE` flag.

## Passing evidence

Normal-completion control:

- PASS;
- no timeout;
- parent exit code 0;
- zero survivors;
- sealed evidence SHA-256 `574FE451727699295F6FC2FCBA170D229BE22AC3E0BE912653CEA079A794C5F4`.

Explicit-timeout hanging-tree control:

- PASS;
- timeout occurred;
- `TerminateJobObject` succeeded;
- observed parent, child, and grandchild all terminated;
- zero survivors;
- sealed evidence SHA-256 `6BB7E35FA70CE0E8D648F791C33AC14E317E52686257122DBE3817E3BEFA8388`.

Forced-supervisor-death crash test:
- PASS;
- holder PID, parent PID, child PID, and grandchild PID were all observed;
- killing the Job-Object holder caused Windows to terminate the inherited parent/child/grandchild tree;
- known survivor count: 0;
- broader fixture-process hits: 0;
- sealed stdout: 148 bytes, SHA-256 `167508BE15FC5777AE2B372ED09D3EE1E9D1EDFEEA798587D0EDF19D3B806B28`;
- sealed stderr: 97 bytes, SHA-256 `CD5DE9AD902A63A535EB8E2A889ECB9A7EC71768B462657B0DAB9C9FF23E843D`;
- sealed crash evidence SHA-256 `D4F28400603129C4CFD8C3C42B285EEDD3994AB4F8577B3AE531E6890737F68F`.

An independent post-run audit rehashed the fixture scripts and evidence, rechecked all four crash-test PIDs as dead, and found zero broad fixture-process hits.

## Preparation judgment

PP-ADMIN-MWR-02 is **PASS at the deterministic non-Codex preparation layer**. The process-supervision hypothesis that failed PP-ADMIN-MWR-01 now has a concrete Windows Job Object realization that survives normal-completion, explicit-timeout, and supervisor-crash falsification fixtures.

This is not live Codex commissioning evidence. It does not prove that a real Codex Reviewer, its launcher, or every descendant it may create can be supervised correctly until that exact live realization is separately tested.

## Successor boundary

A future live Reviewer verification must be a new bounded experiment with a new explicit Director opening. Its packet should require the exact process-supervision realization to:

1. assign the real Reviewer launcher to the Job Object before opening its execution gate;
2. prove the kernel flag is `0x2000` before launch;
3. enforce the fixed hard deadline;
4. terminate the entire job tree at deadline;
5. wait for termination and seal partial stdout/stderr;
6. prove zero known and broad Reviewer-process survivors;
7. stop after the bounded Reviewer result without dispatching successor work.

Until such an experiment passes, PP-ADMIN-MWR-01 remains falsified for live Reviewer supervision and no unattended/self-propelling Manager -> Worker -> Reviewer loop is admitted.
