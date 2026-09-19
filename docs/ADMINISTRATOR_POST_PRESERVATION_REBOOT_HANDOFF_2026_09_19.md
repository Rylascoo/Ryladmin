# Administrator Post-Preservation Reboot Handoff — 2026-09-19

Status: DURABLE CONTINUITY / LOCAL MIGRATION NOT YET EXECUTED

## Exact repository checkpoint

- Owning Project main at handoff: `9971acd06cabc7e5965b6f4c1a5d65168958ca4c`.
- Ryladmin main at handoff: `005d674f5b303f4f7bec04b5436856057a568d5a`.
- FOUNDATION-01 remains draft PR #75 / branch `admin/est-foundation-01` at `77596cdc142fa6c03efef81768acab853161bba0`.
- PR #75 is PARTIAL / NOT COMMISSIONED / NOT MERGE-READY; do not recreate it from main.
- Held Project PR #226 remains unmerged at `dc1780e46ef999eb01e214671486b83186ca04c4`. Other Product/Design chats remain paused.

## Verified local preservation

Owner-context preservation backup:
`C:\Users\Wiryl\Sol Backups\workspace-preservation-20260919T181628Z`.

The full `C:\Users\Wiryl\Sol Dev` snapshot copied 99,156 files / 8.698 GB with zero failed files and zero robocopy mismatches. Only the live generated Edge profile
`Ensemble-Website-Worktrees\appui-firstuse-01-2026-09-17\.tmp\appui-firstuse-02-profile`
was excluded.

Restore evidence proves:
- restored Ryladmin / Project / Website Git databases pass `git fsck --full --strict`;
- PR #75 head, Project main, held PR #226, Website stash `0436b9352073e13941e113f0cc34791731b55de0`, and detached Website checkpoint `53e0b9313b90cbd5cb4e774a5a3b332085e0156e` are present;
- long-path-aware Git status from restored copies exactly matches PR #75 plus all nine non-clean worktrees;
- source→snapshot and snapshot→restore comparisons are exact for those worktrees;
- three local patch files and the standalone C10 fixture restore identically.

Corrected local report:
`C:\Users\Wiryl\.codex\visualizations\2026\09\19\01a0baab-2e5e-7871-9bed-826460b95996\HOST_BACKUP_RESTORE_20260919_01.md`
SHA-256 `C96796EDD49B219A3E8D1AED3829169B76628ABC0C8E43471729EC6A01BA28D4`.
Companion JSON SHA-256 `E7C98D57217934EC7DD0934E2FD128CE27A3BB3CC30969C923FF591FF0D6AFD5`.

The same-disk backup protects the migration, not loss of the machine/SSD.

## Required post-reboot sequence

After the Director restarts SurfSeven and reconnects Remote Desktop Commander:

1. Fresh-resolve GitHub refs and read live Ryladmin/Project authority.
2. Verify the backup/report hashes and the three canonical roots.
3. Verify no stale Website browser/server, Git lock, or other writer remains.
4. Reconfirm the 71 registered worktrees and preservation-priority state without changing them.
5. Determine supported relocation handling for Codex-managed versus manually managed worktrees.
6. Only then execute a separately bounded migration so `C:\Users\Wiryl\Sol Dev` directly contains only:
   - `Ryladmin`
   - `Ensemble-Project`
   - `Ensemble-Website`
   with auxiliary work under a repository-keyed `C:\Users\Wiryl\Sol Work\...` layout.
7. Verify every moved worktree's HEAD/status/common-dir, retain the backup, then return to existing FOUNDATION-01.

No blanket pull/reset/clean/delete, no raw move of Codex-managed worktrees, no app-work takeover, and no PR #75 merge occurs during migration.

## Later Claude review

Claude Code 2.1.267 remains installed with the previously validated binary hash and dedicated `.claude-ensemble` profile. Revalidate authentication before use. Claude should first be used as a bounded independent reviewer of FOUNDATION-01 after workspace preservation/migration is stable; do not create a second writer in the same worktree.

## Fresh-chat resume

Resume Administrator recovery from live Ryladmin authority. Treat this document as a locator, not authority over newer refs. Complete the post-reboot integrity check and controlled workspace migration before resuming FOUNDATION-01 implementation.
