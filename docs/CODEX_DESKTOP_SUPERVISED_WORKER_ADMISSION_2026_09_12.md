# Codex Desktop Supervised Worker Admission Audit — 2026-09-12

Status: **READ-ONLY PILOT PASS - MUTATING PILOT NOT YET RUN; NOT AN ADMINISTRATOR RUNTIME; NOT AUTOMATED**

This record is Ryladmin continuity only. It does not create Engineering, Design, provider, validation, product, ODR, deployment, scheduling, or background-execution authority. It admits one new Director-operated execution surface for bounded supervised work after fresh owning-repository recovery.

## SurfSeven realization census

- Installed Windows package: `OpenAI.Codex_26.903.9818.0_arm64__2p2nqsd0c76g0` (`OpenAI.Codex` version `26.903.9818.0`).
- UI executable: packaged `ChatGPT.exe`; the app was running during this audit.
- Active desktop Codex backend: `C:\Users\Wiryl\AppData\Local\OpenAI\Codex\bin\ce5c3815ab7ed349\codex.exe`.
- Active desktop backend reports `codex-cli 0.153.4`; SHA-256 `A3350CBD7D0247865F91025ED9CD516D389FFE1A23748401DE3AFBF4DFEDDAB8`.
- Packaged `app\resources\codex.exe` has the same SHA-256 as the active backend.
- Active `codex-code-mode-host.exe` SHA-256: `47BD821D66E2DC5894708DB1A9626346441995B782276D0B177669F836E85D11`.
- Ambient standalone CLI remains `codex-cli 0.154.0`, SHA-256 `DC6D744D747A50F8CAF7F08817E0CCC9B09781F6269DEC3609E2F9FBE036233D`.
- Commissioned Administrator Codex remains separately pinned at `0.153.4`, SHA-256 `77F792476FE0DEF726503F02A7C55F485E562DD7AD8801FE61DC8F4BF9991D20`.
- These three Codex executables are distinct realizations. Desktop Codex must never substitute for the pinned Administrator binary or ambient CLI evidence.

The default user Codex profile is productive rather than fail-closed: `model = "gpt-5.6-sol"`, `model_reasoning_effort = "low"`, `sandbox_mode = "workspace-write"`, Windows sandbox `elevated`, and `sandbox_workspace_write.network_access = true`. The configured trusted-project set includes `Ensemble-Project` and the broader `C:\Users\Wiryl\Sol Dev` tree. Therefore opening a canonical project root casually is outside this admission.

## Current OpenAI capability evidence

OpenAI currently documents the Windows Codex desktop app as a command center for multiple agents, with local folders/repositories/terminals/developer tools, reviewable diffs, and built-in isolated worktrees. OpenAI also states that the app shares Codex configuration/history with CLI and IDE surfaces and that Codex usage can be consumed through a ChatGPT plan.

Official sources checked on 2026-09-12:

- `https://openai.com/index/introducing-the-codex-app/`
- `https://help.openai.com/en/articles/20001275/`
- `https://help.openai.com/en/articles/11369540`

Those product capabilities do not establish Ensemble repository law, worktree-retirement law, shared-Git locking, provider restrictions, or validation authority. This admission therefore wraps the app inside existing Administrator discipline instead of treating its native worktree/agent features as automatically safe for Ensemble.

## Admission boundary

Desktop Codex is eligible as a **Director-operated supervised worker surface**. It is not the Administrator, an owning Sol, C9A, C10, C11, or an autonomous scheduler.

For the initial admission:

- Administrator creates the exact isolated worktree and branch under the shared-Git lock before the Director opens anything in desktop Codex.
- The Director opens only that exact worktree folder in the Codex desktop app; canonical Project/Website roots and validation/evidence checkouts remain off-limits.
- Exactly one writer owns an owning lane at a time. Desktop Codex may replace the active writer for a bounded work package; it may not become a second simultaneous writer in the same lane.
- App-managed worktree creation/deletion is **not admitted** yet, despite native product support.
- Desktop Codex may edit files and run bounded local build/test commands inside the admitted worktree.
- Git is read-only inside the desktop worker for the first pilots: `status`, `diff`, `log`, `show`, and `rev-parse` are acceptable. No `add`, `commit`, `push`, `pull`, `fetch`, `merge`, `rebase`, `reset`, `checkout/switch`, branch/tag mutation, or worktree lifecycle.
- Administrator retains commit/push/PR/archive/retirement operations under the existing shared-Git lock and owning-repository law.
- No provider credentials, provider traffic, secret discovery, external API use, browser/CDP, Computer Use, plugin action, or arbitrary network research is admitted in the first pilot unless a later exact work package explicitly opens it.
- Cloud handoff, Remote Control, Automations, and unattended/background desktop-agent operation remain outside this admission.

## Supervised dispatch procedure

1. Fresh-resolve live Ryladmin plus the owning Project/Website authority and verify that the target lane is not concurrently owned by another writer.
2. Choose one bounded work package with exact base SHA, explicit allowed paths, expected tests, forbidden surfaces, and a clear stop condition.
3. Administrator creates the isolated branch/worktree using the shared-Git lock and verifies clean exact-base state.
4. Record the current desktop package version, active Codex backend path/version/hash, and relevant user-profile sandbox/network posture before dispatch.
5. Director opens the exact worktree folder in desktop Codex and supplies the fixed work package. The packet must prohibit Git lifecycle and every capability not explicitly admitted above.
6. Desktop Codex edits/tests only inside the worktree and returns a summary, tests run, and remaining risks. It leaves the worktree uncommitted for Administrator audit.
7. Administrator independently checks status, complete diff, unexpected paths, test evidence, repository/ref invariants, and shared-lock state.
8. If acceptable, Administrator performs commit/push/PR/archive/lifecycle steps under normal repository law. If not acceptable, preserve evidence and fail closed; do not hide or reset unexplained changes.
9. Retire the worktree only after the owning lane's normal archive/ancestry/evidence conditions are satisfied.

## First-pilot acceptance contract

A first mutating desktop-worker pilot passes only if the app stays within the exact admitted worktree, changes only authorized paths, performs no prohibited Git/ref operation, performs no network/provider/credential action, returns usable local test evidence, and leaves canonical roots plus all other registered worktrees unchanged. Administrator must be able to reproduce the final status/diff independently before integration.

Failure to meet any condition leaves desktop Codex available for read-only analysis but does not admit it as a mutating worker until a materially corrected pilot is defined.

## Future capabilities requiring separate admission

Native app-managed worktrees; agent-created commits or remote Git operations; multiple simultaneous mutating agents in one owning lane; browser/CDP or Computer Use; plugins/apps with external actions; Remote Control/cloud handoff; background Automations; provider credentials/traffic; or any use of desktop Codex as an Administrator/C9A/C10/C11 substitute each require their own explicit gate and evidence.

The immediate value is therefore supervised subscription-backed production: the Administrator can prepare exact worktrees and packets while the Director uses the official desktop Codex app to consume available Codex capacity on real project work without weakening current repository or authority boundaries.


## First read-only pilot result

`PP-CODEX-DESKTOP-RO-01` passed the supervised read-only boundary. Durable audit: `docs/PP_CODEX_DESKTOP_RO_01_RESULT_2026_09_12.md`. The pass admits further read-only fixed-packet work only; mutating-worker admission still requires the separate isolated-worktree pilot above.
