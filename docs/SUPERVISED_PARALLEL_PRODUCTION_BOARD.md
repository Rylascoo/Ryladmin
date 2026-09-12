# Ensemble Supervised Parallel Production Board

Status: operational Administrator continuity board only. This file does not create Engineering, Design, product, provider, validation, or automation authority. Live owning repositories and their exact active refs always win.

Updated: 2026-09-12

## Purpose

Use available Codex and Claude subscription capacity in parallel before C11 automation is commissioned, while preserving one-writer-per-lane discipline, exact-ref review, and fail-closed integration.

This board is a supervised dispatch surface, not an autonomous scheduler. Manual Claude reviews under the commissioned C9 review plane do not satisfy C9A, C10, or C11 and must not be represented as automated routing.

## Fresh snapshot used to construct this board

- Ryladmin `main`: `b338f268104bf89357f5e00e7aac6a27e5b65e83`.
- Project `main`: `ba02d1689680d8492a4c52675e7aba91935fd2dd`.
- Active Engineering candidate: branch `e0b-mixed-cast-implementation-2026-09-12` has committed implementation checkpoint `d1073fe2c76e2e05f2daac47465f86b48b456a9a`, one commit ahead of Project `main`, no remote branch at snapshot; concurrent Engineering has since added one untracked implementation-audit document, so Claude review packets must target the exact committed SHA rather than local working-copy residue.
- Website `main`: `cc0f98430256f5788fc900c7373ae857ef260e66`.
- Active Design serial: `design/perf-s1-f2-incumbent-stage-comparison-2026-09-12` at exact Website `main`; the worktree was clean at the final board race check.
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
| PP-ENG-01 | ACTIVE | Engineering Sol / Codex | implement + audit + native validate | `e0b-mixed-cast-implementation-2026-09-12@d1073fe2...` | Owning lane reconciles the clean one-commit candidate against the approved E0-B method/decision, runs recursive deterministic audit/tests, updates volatile state, and obtains fresh native Windows ARM64 validation/tagging before any live activation. Provider traffic remains blocked. |
| PP-ENG-CLAUDE-01 | READY | Director-triggered Claude manual review | read-only independent review | exact Project `main@ba02d168...` plus candidate `d1073fe2...` | One-turn fixed-packet audit for contract violations, cast/provenance/rate/model/cost accounting defects, pacing regressions, Core leakage, missing/weak tests, evidence incompatibility, and fail-closed gaps. Return severity-ranked findings with exact file/symbol references. No edits or authority claims. |
| PP-DES-01 | ACTIVE | Design Sol / Codex | design construction + deterministic preflight | `design/perf-s1-f2-incumbent-stage-comparison-2026-09-12@cc0f984...` | Preregister F2 Source-Aligned Header versus exact `PKT-STAGE-CORE-02` incumbent before challenger construction/scoring. Preserve every non-attribution Stage variable; no F2 retune, motion/runtime semantics, history-density/Beat redesign, or implementation authority. |
| PP-DES-CLAUDE-01 | READY | Director-triggered Claude manual review | read-only protocol audit | Website `main@cc0f984...` frozen PERF-S1/F2 authority | Audit the proposed F2-vs-incumbent comparison for hidden confounds, non-attribution drift, accessibility/mechanical gaps, ambiguous scoring law, preregistration leakage, and evidence insufficiency. Do not express aesthetic preference, select a winner, or create Design authority. |
| PP-ADMIN-C9A-R3 | ANALYSIS-READY / LIVE-BLOCKED | Administrator + Codex or manual Claude advisory | architecture/falsification research only | Project C9A R1/R2 evidence + Runtime Specification | Produce a materially changed, falsifiable R3 hypothesis and exact validation plan explaining why it is not the preserved R1/R2 realization. No live Claude invocation, config mutation, retry, or commissioning claim until a separate explicit Director/Project opening exists. |
| PP-XLANE-CLAUDE-01 | READY | Director-triggered Claude manual review | read-only contradiction audit | exact current Project + Website authority roots | Find stale cross-lane pointers, ownership contradictions, sequencing mismatches, and accidental authority leakage. Findings are advisory; owning repos decide corrections. |
| PP-C10-UPSTREAM | BLOCKED | Administrator research | capability watch | future Codex release/source | Reopen only after exact source/release inspection proves `PreToolUse` hook-process failure can block underlying dispatch and Project/Director commissions the exact candidate. 0.154.0 remains ineligible. |

## Recommended concurrency now

Run PP-ENG-01 and PP-DES-01 as the only writing lanes. In parallel, spend Claude capacity first on PP-ENG-CLAUDE-01 because the E0-B candidate is already a stable clean commit, then PP-DES-CLAUDE-01 against the frozen F2 method before Design scoring. PP-ADMIN-C9A-R3 can consume additional reasoning capacity without touching live project work. PP-XLANE-CLAUDE-01 is useful when Claude quota remains after the two lane-specific reviews.

Do not add a second writer to either active lane merely to consume quota. Extra capacity should go to independent review, falsification, test-gap analysis, or future-work preparation.

## Manual Claude review contract

Before each review, verify `CLAUDE_CONFIG_DIR=C:\Users\Wiryl\.claude-ensemble`, claude.ai / first-party subscription auth, and absence of `ANTHROPIC_API_KEY` or cloud-provider routes. Build the packet deterministically from exact refs into Administrator/Claude scratch outside all repositories. Record packet SHA-256 and byte count.

Run one bounded review turn with built-in tools, MCP, subagents, permission prompting, and session persistence disabled. Capture the actual Claude version/model/provider telemetry, turn count, terminal reason, web-search/web-fetch count, output bytes, and output SHA-256. A timeout/error is evidence, not permission to auto-retry.

Expected result schema: overall `PASS`, `PASS_WITH_FINDINGS`, or `FAIL`; ordered findings with severity; exact evidence references; uncertainty/unsupported claims; recommended owning-lane verification; explicit statement that the review created no authority.

## Integration rule

The Administrator or owning Sol independently verifies every actionable finding against the exact owning ref. Adopt only verified corrections. If the implementation/design ref moved after packet construction, rebuild the packet rather than applying stale advice.

## Successor automation boundary

Supervised parallel production is intentionally useful before C9A/C11 succeed. It accumulates real evidence about packet size, review latency, useful task classes, failure modes, and reconciliation cost. Those measurements should inform a future materially changed C9A realization and later C11 automation, but this board itself does not unlock either gate.