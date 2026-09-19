# FOUNDATION-01 candidate boundary

This is an **offline, uninstalled partial foundation candidate**, subordinate to
Project `9971acd06cabc7e5965b6f4c1a5d65168958ca4c` and its Q-ADMIN-04 authorization
and quota/write addendum. `runtime/current` still represents commissioned source.
Nothing here admits a new capability or updates the active installation.

`policy.py` implements typed task/grant/result/usage/checkpoint validation, quota
selection, cumulative usage deduplication, exact identity comparison and path
rejection. JSON schemas use a deliberately closed, documented subset validated
without remote schema resolution or third-party packages. Unknown fields, unsupported
schema keywords, NaN and duplicate JSON object keys fail closed.

`entry.py --check --worktree <isolated-root> --expected-head <sha> --tool <path>
--tool-sha256 <sha256>` is the Ryladmin-aware read-only entry. It verifies Git identity,
cleanliness and executable bytes. It has **no launch command**, no passthrough CLI,
no model calls, and no automatic retries or scheduler. A preflight success is not
admission. The recorded commissioned executable is currently missing, so an actual
installed-version check cannot pass. Never substitute an ambient executable.

`writer.py` performs one bounded file replacement after policy validation, exclusive
cooperative locking and a second authority/input check. It is an internal deterministic
prototype, exercised only on disposable non-secret fixtures. Its observations and grant
must come from a trusted independent coordinator. Passing caller-supplied observations
is not authentication. There is intentionally no production writer CLI yet.

The test grant's ADMITTED value is a fixture only. The repository capability snapshot
admits nothing. The writer rejects current source, shared Git, authority/configuration,
foreign worktrees and its own capability/manifest records. Scout and Reviewer cannot
write. This is not OS containment: a malicious same-user process can bypass Python,
race the cooperative lock/path checks, or modify writable candidate code. Native
writer admission requires the separately tested OS boundary, immutable external grant
storage and a trusted coordinator. No live task may use this candidate yet.

Quota observations are fresh for at most 300 seconds (conservative candidate default).
The caller must supply verified required bucket/window identities and reservations.
Missing required windows block admission. Remaining allowance uses the minimum, not
an average. LIGHT enters at <=10%, checkpoint at <=5%, and every window must exceed
15% plus fresh authority/ownership checks before NORMAL resumes. Task estimates and
reservations are percentage points from validated accounting, never converted from
tokens. Unknown estimates prevent dispatch. External consumption can defeat a floor;
no hard token/allowance enforcement is claimed. Checkpoints persist pause and quota
state; the caller must refresh authority rather than replay a saved operation.

The normalization adapter consumes sanitized `account/rateLimits/read`-shaped input;
it neither authenticates nor makes that call. Official interface reference:
https://learn.chatgpt.com/docs/app-server. Supported installed realization remains
**NOT VERIFIED**; the missing pinned executable blocks schema generation and live
metering/model mapping checks. The desktop account tool is a separate observation,
not evidence for the pinned runtime. No raw account/auth/session data belongs in Git.

Run `python -B tools/verify_foundation.py`, `python -B -m unittest discover -s tests -v`
and `pwsh -File runtime/verify-source.ps1`. Candidate source hashes are in
`source-manifest.json`; they prove byte identity only, not provenance or admission.
The workflow runs deterministic tests on Linux and Windows; it does not prove
ARM64 child-process isolation. Branch protection requires authorized admin access.

Remaining FOUNDATION-01 acceptance work: independent candidate review; supported
exact executable recovery/requalification; trusted authority/metering integration;
OS-enforced writer isolation and no-self-grant evidence; branch-protection verification.
Containment/recovery, MA successor openings, installation and unattended resumption
remain subsequent gated work. Preserve paused app leases and old consumed attempts.
