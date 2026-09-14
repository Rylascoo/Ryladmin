# Administrator Runtime Authority Foundation — 2026-09-13

Status: **RYLADMIN RUNTIME-AUTHORITY ADOPTION PACKAGE; ACTIVE RUNTIME UNCHANGED**

## Authority basis

Project PR #128 merged at `dc248cdf921d31b300a5c201d0bee2ca741755e0` and delegates Administrator Runtime + Continuity Authority to `Rylascoo/Ryladmin`. Last reconciliation for this promotion observed Project `main@7959ffe59da72f735f86d4aec602224899577903`; that later ref is a continuity snapshot, not a replacement for the exact delegation provenance. `Rylascoo/Ensemble-Project` remains superior for Administrator policy, security/authority boundaries, orchestration law, C0-C13 gates, and the single project queue.

Ryladmin therefore may canonically version only the executable realization of already-approved Administrator law. It does not become product, Engineering, Design, provider, validation, experiment, ODR, or backlog authority.

## Exact current source capture

The package introduces `runtime/current/` as the exact non-secret source snapshot of the currently commissioned SurfSeven Administrator runtime and `runtime/CURRENT_SOURCE_MANIFEST.json` as its source-integrity manifest. The manifest pins Project policy ref `dc248cdf...`, Codex `0.154.0-alpha.6.2` / SHA-256 `21AE7DF1...B94EA`, and byte/hash identity for 13 runtime files.

Final source-manifest SHA-256 is `B2A1C907B4C4A28AAF749C7E24AEA9829AC30286667FCBC1527B613CB014F9B4`. `runtime/verify-source.ps1 -InstalledRoot C:\Users\Wiryl\.codex-ensemble` returned `SOURCE_FILE_COUNT=13`, `SOURCE_HASHES=PASS`, `PRIVATE_STATE_EXCLUSION=PASS`, `POWERSHELL_PARSE=PASS`, `INSTALLED_BYTE_IDENTITY=PASS`, and `RYLADMIN_RUNTIME_SOURCE_VERIFY=PASS`. Repository `.gitattributes` pins `runtime/**` to LF so exact source hashes survive Windows/Linux checkout; an independent staged-Git-blob audit rehashed all 13 `runtime/current/` blobs and returned `INDEX_RUNTIME_BYTE_IDENTITY=PASS`.

The captured source includes Administrator/Worker launchers, shared-Git lock, hardened Reviewer child/supervisor, runtime configuration, role profiles, and the current local runtime manifest. Credential/auth/session/browser/plugin/database material is excluded.

The active machine-local `C:\Users\Wiryl\.codex-ensemble` tree was not modified by this adoption package.

## Migration boundary

The existing `recovery/templates/runtime/` tree remains a generic replacement-machine recovery template from an earlier realization. It is not silently promoted as the current runtime and is not allowed to overwrite the surviving commissioned installation. A later portability/install package must reconcile recovery rendering to `runtime/current/`, validate deterministic installation on a disposable target, and preserve rollback.

Administrator self-modification remains A/B: the currently admitted runtime judges an isolated candidate; candidate code cannot overwrite the active runtime before audited merge, explicit installation, and successor revalidation.

## Multi-agent boundary

Q-ADMIN-03 is a parallel-operations foundation, not multi-agent runtime admission. Native Codex subagents remain disabled. MA-01 is the first eligible Scout-subagent gate only after this Ryladmin adoption and Website Design Relay adoption are durable. C10/C11, Hooks, Automations, provider authority, automatic retry/merge, and self-triggering execution are unchanged.

## Closeout requirements

Before promotion: run `runtime/verify-source.ps1` against the repository source and commissioned installed runtime; scan for credential/token/private-state indicators; run `git diff --check`; and recursively audit authority language. Promotion itself must use the normal isolated branch/PR barrier. Installation of a future runtime successor is a separate gated action.

## 2026-09-14 adoption-audit addendum

The final promotion audit re-resolved Project `main@7959ffe59da72f735f86d4aec602224899577903` and Website `main@2654fdc2b319aa76bcac3d4c9237d0882c0528c4`. The 13-file canonical runtime source still matched the installed SurfSeven runtime byte-for-byte, with private-state exclusion and PowerShell parse checks passing.

A read-only production Reviewer invocation used during the adoption audit exposed a new deadline-terminal defect in the currently installed reviewer supervisor. The configured 240-second deadline elapsed without a terminal evidence artifact while a descendant Codex process remained active after the intermediate child process was no longer present. Manual containment completed with zero related survivors and no Project worktree mutation. See `docs/ADMINISTRATOR_REVIEWER_SUPERVISION_DEADLINE_DEFECT_2026_09_14.md`.

This does not convert the source-adoption package into a runtime-successor repair. `runtime/current/` deliberately remains the exact installed source snapshot. The Reviewer path is suspended until a later A/B successor package repairs and revalidates the newly observed topology; MA-01 remains uncommissioned.
