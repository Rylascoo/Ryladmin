# Ensemble Administrator Disaster Recovery

Status: continuity/bootstrap contract only. This document never replaces `Rylascoo/Ensemble-Project`, `Rylascoo/Ensemble-Website`, their `CURRENT_STATE.md` files, or Director authority.

## Purpose

This contract preserves the commissioned Ensemble Administrator operating discipline after total loss of SurfSeven or its local runtime. A replacement Windows ARM64 machine should be able to reconstruct the non-secret runtime, recover live repository authority, and resume from the current earned gate without trusting chat history or silently replaying completed gates.

The recovery kit lives in `recovery/`. Its executable surfaces are `bootstrap-ensemble-admin.ps1` and `verify-recovery.ps1`; `RECOVERY_BASELINE.json` records a historical, non-authoritative commissioning snapshot; `templates/runtime/` contains sanitized fail-closed runtime templates.

## Two kinds of state

**Durable gate history** lives in the owning repositories, merged evidence, archive tags, and hosted CI. Hardware loss does not erase a gate that was already durably closed. At the C9 recovery baseline, C0-C9 are closed by Project evidence and C10 is the next Administrator gate, subject to a fresh live-authority read.

**Local capability realization** is machine-specific. A replacement machine must re-prove its architecture, tool binaries, config rendering, authentication class, repository paths, connector bindings, and safety defaults before those capabilities are used. Never treat a new laptop as equivalent to SurfSeven merely because the files were restored.

## Recovery authority order

1. Clone or fetch `Rylascoo/Ryladmin` only as the recovery notebook.
2. Read Ryladmin `AGENTS.md`, `CURRENT_STATE.md`, and this contract.
3. Clone/fetch `Rylascoo/Ensemble-Project`; read its root `AGENTS.md` and `CURRENT_STATE.md` first.
4. Clone/fetch `Rylascoo/Ensemble-Website`; read its root `AGENTS.md` and `CURRENT_STATE.md` when Design state matters.
5. Resolve current remote refs, live worktrees/branches, hosted CI, queue, validation ledger, and the active Administrator gate from the owning repositories.
6. Treat every SHA in `RECOVERY_BASELINE.json` as a historical checkpoint until freshly reconciled.

## What must never be backed up into Git

Never copy or commit ChatGPT/Codex tokens, `auth.json`, Claude OAuth/session data, Anthropic API keys, Git credentials, browser cookies/history/passwords, personal Edge/Chrome profiles, personal `.claude` state, connector authorization secrets, Windows credential-store material, or private Design assets that are not already deliberately governed in an authorized repository/Drive surface.

Do not copy `.codex-ensemble` SQLite databases, session history, logs, memories, goals, installation IDs, capability SIDs, or model caches. They are disposable machine state, not project memory.

If a local-only evidence directory is lost, say so. Repository/CI/tag evidence remains durable; evidence that existed only on the lost machine must be reacquired or reproduced under current authority. Never reconstruct missing evidence from memory and label it original.

## Replacement-machine sequence

1. Use a Windows ARM64 machine and apply current OS/security updates.
2. Install Git, a supported PowerShell, and the prerequisites needed by current Project law.
3. Clone Ryladmin and run `recovery/bootstrap-ensemble-admin.ps1` without `-Apply` first.
4. Install the tool versions recorded by the baseline when still obtainable. If an exact pinned binary is unavailable, stop and revalidate the replacement version before updating the baseline; never silently substitute it.
5. Run the bootstrap with `-Apply`, supplying the exact Codex and Python executable paths and, only after reconnecting it, the current GitHub connector ID.
6. The bootstrap may clone missing repositories and render non-secret runtime files. It must never reset, clean, rebase, detach, or otherwise move an existing repository checkout.
7. Reauthenticate ChatGPT/Codex interactively using the forced ChatGPT login path. Never restore copied Codex credentials.
8. If Claude review capability will be used, install the admitted Claude Code version or revalidate a successor, create the dedicated `.claude-ensemble` home, run normal `claude auth login`, and verify `claude.ai` subscription authentication with no `ANTHROPIC_API_KEY` route.
9. Reinstall/start the admitted Remote Desktop Commander version and authorize the replacement device interactively. A prior device UUID is historical only.
10. Reconnect the GitHub integration with the minimum admitted permissions; connector IDs are machine/account bindings, not authority.
11. Run `recovery/verify-recovery.ps1` and resolve every FAIL/ACTION_REQUIRED item before Administrator execution.
12. Fresh-read Project/Website authority again immediately before resuming the current earned gate.

## Fail-closed recovery rules

- `recovery/bootstrap-ensemble-admin.ps1` requires `-Apply` before it writes runtime files or clones missing repositories.
- Existing repositories are inspected, never moved. A dirty checkout is reported; it is not cleaned automatically.
- The historical detached Project root on SurfSeven is evidence of that machine's topology, not a universal checkout instruction. Re-establish any detached-validation-root convention only after reading current Project law.
- Browser/CDP, Hooks, Automations, multi-agent, memories, goals, computer use, remote plugins, and open-world app access remain disabled in the recovered default config. Later capabilities are enabled only for the gate or task that currently authorizes them.
- No provider credential or provider traffic is introduced by recovery.
- Recovery never promotes native validation or converts browser/hosted evidence into a stronger rung.
- A rendered config with a missing connector remains usable only in the more restrictive connector-disabled posture.
- Tool-version or binary-hash drift is a revalidation event, not permission to edit the expected value until the owning workflow accepts the new realization.

## Historical C9 anchor

The Administrator C9 closeout candidate was `9db16f96dbd2e612b200e2f7ae45ba5a0afe8484`, merged by Project PR #74 as `78026f3fae040dabcdd55fe0adc331c06ffa2b21`; post-merge Validation #653 passed. Archive tag `archive/q-admin-02-c9-claude-review-closeout-2026-09-11` has annotated tag object `97c6424e4af07bf91788dc4ce52532d0fbe45ac5` and peels to the candidate.

That anchor proves the historical C9 closure and the corrected C8 evidence. It does not freeze later Engineering or Design state. At kit creation, Project main had already advanced beyond the C9 merge; replacement recovery must therefore fetch current authority before deciding what work is next.

## Recovery acceptance

Recovery is acceptable only when the verification script confirms the core repository/runtime safety surface and a human/Administrator separately confirms any interactive authentication or connector actions it reports as required. After that, the normal repository bootstrap procedure—not this recovery document—determines the next action.

Reference rehearsal: on 2026-09-11 the kit successfully reconstructed a disposable blank-user realization, cloned fresh owning repositories, passed erify-recovery.ps1, and passed a second idempotent bootstrap apply. That rehearsal is evidence for the kit logic only; every replacement machine must still run its own verification.
