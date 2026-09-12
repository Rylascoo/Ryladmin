# Ensemble Supervised Parallel Production Board

Status: operational Administrator continuity board only. This file does not create Engineering, Design, product, provider, validation, or automation authority. Live owning repositories and their exact active refs always win.

Updated: 2026-09-12

## Purpose

Use available Codex and Claude subscription capacity in parallel before C11 automation is commissioned, while preserving one-writer-per-lane discipline, exact-ref review, and fail-closed integration.

This board is a supervised dispatch surface, not an autonomous scheduler. Manual Claude reviews under the commissioned C9 review plane do not satisfy C9A, C10, or C11 and must not be represented as automated routing.

## Reconciled operating snapshot

- Ryladmin `main` at board creation: `b338f268104bf89357f5e00e7aac6a27e5b65e83`; latest merged continuity before this update: `8bfae4cc1c54d7c4fd0aabbcbe4011cb6790e17e`.
- Project `main`: `8b3e22bbbeaa0004029b007b86e9b504858a7f41` after mechanical merge of the E0-B implementation; owning `CURRENT_STATE.md` still keeps Q-E0B-01 ACTIVE while post-merge closeout is being recorded.
- Engineering implementation branch is retired from the remote after merge. Exact native executable authority remains `d1073fe2c76e2e05f2daac47465f86b48b456a9a` under `validation/e0b-mixed-cast-implementation-native-arm64`; integrated evidence commit `625c82e6eb10f27b653c150eae7a02072d10eac0` is archived as `archive/e0b-mixed-cast-implementation-2026-09-12`. Active owning WIP is the post-merge closeout worktree at `main@8b3e22bb...`, currently carrying a tracked `CURRENT_STATE.md` modification plus one untracked integration-closeout evidence file.
- Website `main`: `cc0f98430256f5788fc900c7373ae857ef260e66`.
- Active Design serial: `design/perf-s1-f2-incumbent-stage-comparison-2026-09-12@c5f84ee106a78fdbd4dd6264df1a552f82d34ddb`, clean. Method 01 and Method 02 both failed technical pre-score ghost-integrity checks with no subjective result; Method 03 is frozen and changes only source-raster completeness to an 871-pixel source/shadow mask while preserving the same F2 translation, anchor, panel, and nine criteria.
- Claude Code commissioned manual-review realization: `2.1.267`, dedicated `C:\Users\Wiryl\.claude-ensemble`, claude.ai first-party Pro subscription boundary.
- Ambient Codex is `0.154.0`; the commissioned Administrator runtime remains pinned separately and C10 stays source-disqualified/blocked on 0.154.0.

Re-resolve all relevant refs immediately before every dispatch. Any movement invalidates an exact-ref packet until rebuilt.

## Dispatch law

1. Exactly one writer owns each active Engineering or Design worktree. Reviewers do not write that worktree.
2. Claude is advisory only. Use fixed exact-ref packets outside repositories, no repository working context, no tools/MCP/subagents/session persistence, no API-key/cloud-provider billing route, and no automatic retry.
3. Codex implementation workers operate only in isolated owning-lane worktrees and obey the owning repository's `AGENTS.md`, `CURRENT_STATE.md`, authority, validation, branch, and shared-Git laws.
4. No manual review or worker output changes authority until the owning Sol/Administrator verifies and durably adopts it through normal repository process.
5. Provider traffic/spend, ODR resolution, Design taste, validation promotion, automatic merge, and automatic unique-branch deletion remain outside this board unless separately authorized by their owning authority.
6. Project `docs/PROJECT_EXECUTION_QUEUE.md` is sequencing only. Website `CURRENT_STATE.md` controls current Design execution when the Project queue is stale.

## Parallel board

| ID | Status | Primary executor | Mode | Exact current target | Deliverable / stop condition |
| --- | --- | --- | --- | --- | --- |
| PP-ENG-01 | MERGED / POST-MERGE CLOSEOUT WIP | Engineering Sol / Codex | close out integrated validated candidate | Project `main@8b3e22bb...`; executable authority `d1073fe2...`; tag `validation/e0b-mixed-cast-implementation-native-arm64` | E0-B implementation/evidence is mechanically merged. Exact executable `d1073fe2...` remains the native authority; owning phase law still says Q-E0B-01 ACTIVE while the closeout worktree records post-merge evidence. Provider traffic/live activation remain blocked. |
| PP-ENG-CLAUDE-01 | PARTIAL-COMPLETE / NO ADOPTION | Director-triggered Claude manual review | read-only independent review | exact Project `main@ba02d168...` plus candidate `d1073fe2...` | Turn completed normally but violated the required output contract: preliminary observations only, no final disposition or severity-ranked findings. Partial observations were independently verified; no Engineering change was adopted. Durable record: `docs/PP_ENG_CLAUDE_01A_PARTIAL_RESULT_2026_09_12.md`. Do not auto-retry the packet. |
| PP-DES-01 | ACTIVE / METHOD-03 FROZEN | Design Sol / Codex | technical recovery + deterministic preflight | `design/perf-s1-f2-incumbent-stage-comparison-2026-09-12@c5f84ee...` | TECH-01 and TECH-02 are durable technical failures with no Stage result. Method 03 is frozen; exact next is hosted validation before any Method-03 challenger construction, then one challenger plus mandatory pre-score ghost-integrity check. No F2b/design retune or excluded-variable change. |
| PP-DES-CLAUDE-01 | READY AT CLEAN METHOD-03 BOUNDARY | Director-triggered Claude manual review | read-only protocol audit | exact Design serial `c5f84ee...` | A fresh packet may audit Method 03 for hidden non-raster drift, recovery-scope leakage, ghost-check sufficiency, and preregistration integrity. Do not express aesthetic preference, select a winner, or infer Stage authority. Re-resolve immediately before dispatch. |
| PP-ADMIN-C9A-R3 | HYPOTHESIS IDENTIFIED / LIVE-BLOCKED | Administrator + Codex or manual Claude advisory | architecture/falsification research only | `docs/C9A_R3_PLAN_MODE_HYPOTHESIS_2026_09_12.md` | Fresh manual evidence identifies Plan Mode output routing as the materially changed R3 mechanism: replace plan mode with a non-Plan no-prompt posture while keeping the rest of R2 frozen. No live C9A invocation, candidate mutation, retry, or commissioning claim until a separate explicit Project/Director opening and exact candidate validation. |
| PP-XLANE-CLAUDE-01 | READY | Director-triggered Claude manual review | read-only contradiction audit | exact current Project + Website authority roots | Find stale cross-lane pointers, ownership contradictions, sequencing mismatches, and accidental authority leakage. Findings are advisory; owning repos decide corrections. |
| PP-C10-UPSTREAM | BLOCKED | Administrator research | capability watch | future Codex release/source | Reopen only after exact source/release inspection proves `PreToolUse` hook-process failure can block underlying dispatch and Project/Director commissions the exact candidate. 0.154.0 remains ineligible. |

## Recommended concurrency now

Run PP-ENG-01 and PP-DES-01 as the only writing lanes. PP-ENG-CLAUDE-01A is terminal but incomplete and creates no correction obligation. PP-DES-CLAUDE-01 is READY at the current clean Method-03 boundary but must be fresh-resolved immediately before dispatch. Additional read-only Claude capacity may go to PP-ADMIN-C9A-R3 architecture/falsification analysis or PP-XLANE-CLAUDE-01, both of which avoid racing the active writers.

Do not add a second writer to either active lane merely to consume quota. Extra capacity should go to independent review, falsification, test-gap analysis, or future-work preparation.

## Manual Claude review contract

Before each review, verify `CLAUDE_CONFIG_DIR=C:\Users\Wiryl\.claude-ensemble`, claude.ai / first-party subscription auth, and absence of `ANTHROPIC_API_KEY` or cloud-provider routes. Build the packet deterministically from exact refs into Administrator/Claude scratch outside all repositories. Record packet SHA-256 and byte count.

Run one bounded review turn with built-in tools, MCP, subagents, permission prompting, and session persistence disabled. Capture the actual Claude version/model/provider telemetry, turn count, terminal reason, web-search/web-fetch count, output bytes, and output SHA-256. A timeout/error is evidence, not permission to auto-retry.

Expected result schema: overall `PASS`, `PASS_WITH_FINDINGS`, or `FAIL`; ordered findings with severity; exact evidence references; uncertainty/unsupported claims; recommended owning-lane verification; explicit statement that the review created no authority.

## Integration rule

The Administrator or owning Sol independently verifies every actionable finding against the exact owning ref. Adopt only verified corrections. If the implementation/design ref moved after packet construction, rebuild the packet rather than applying stale advice.

## Successor automation boundary

Supervised parallel production is intentionally useful before C9A/C11 succeed. It accumulates real evidence about packet size, review latency, useful task classes, failure modes, and reconciliation cost. Those measurements should inform a future materially changed C9A realization and later C11 automation, but this board itself does not unlock either gate.