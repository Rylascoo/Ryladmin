# C9A R3 Plan-Mode Output-Routing Hypothesis — 2026-09-12

Status: **MATERIALLY CHANGED HYPOTHESIS IDENTIFIED — LIVE R3 REMAINS BLOCKED PENDING EXPLICIT PROJECT/DIRECTOR OPENING**

This is Administrator continuity/research only. It does not authorize a C9A live call, config mutation, retry, C10/C11 progression, repository mutation, provider traffic, or automation.

R1 and R2 both used Claude Code `2.1.267`, high effort, a 180-second hard bound, empty tools, strict MCP isolation, no persistence/browser, first-party Pro auth, and `--permission-mode plan` / no-prompt posture. R1 timed out twice; R2 removed native StructuredOutput but still timed out once, so packet size alone and native StructuredOutput alone were falsified as sufficient explanations.

Fresh supervised evidence adds a different mechanism. PP-ENG-CLAUDE-01A used a 29,057-byte fixed packet under the same plan/no-prompt tool-less posture. It completed normally but stopped after preliminary analysis and said it would write the full findings to a plan file despite having no file tools. No plan file was created.

A separate manual C9-style advisory packet then asked for R3 hypothesis analysis while explicitly requiring all useful output inline. Packet SHA-256 `0A5306422F299D2CC4E3AB7A443C5EA208A16EB21C5BDAA14E5155BB7DD15F1B`, 29,279 bytes. Result SHA-256 `238BC8481F366D9F07504274A3FABEB2E51C9CD4F06F20929B0E8D3EA6D252A5`, 4,765 bytes. It completed in one turn (`duration_api_ms=42831`) on `claude-sonnet-5`, first-party provider, with zero web requests, zero subagents and zero permission denials.

That advisory explicitly reported that `--permission-mode plan` had placed it in a real Plan Mode whose higher-priority operating constraint required substantive output through a named plan file, and it rejected the inline response contract as conflicting with that mode. The named plan file did not exist afterward because tools were disabled.

Historical C9 also used plan mode and completed successfully, so plan mode alone is not claimed as a universal sufficient cause. The new falsifiable hypothesis is narrower: **in the current headless/tool-less C9A-style task shape, Plan Mode can redirect or suppress the direct advisory-result path required by C9A and materially contribute to timeout/nonconforming-output behavior.**

R3 should therefore change one primary mechanism only: replace `--permission-mode plan` with a non-Plan permission posture such as `dontAsk`, while retaining `--permission-prompts none`, empty tools, strict MCP isolation, Claude `2.1.267` exact executable identity, first-party Pro auth, high effort, 180-second bound, no native `--json-schema`, `--max-turns 1`, ordinary JSON capture plus local schema validation, no persistence/browser/slash commands, zero automatic retry, sealed timeout telemetry and before/after repository snapshots.

Before any live R3 call, a separate exact candidate must prove offline that the command line contains no Plan Mode, the tool surface remains empty, alternate credential routes are absent, scratch remains outside worktrees, local result validation works, failure telemetry seals before fail-closed exit, and repository mutation is detected. The candidate and its decision must pass normal Project review/validation first.

R3 passes only if one separately authorized live packet returns a locally valid structured advisory result within the frozen bound, uses the admitted first-party subscription route, shows no unauthorized capability use, seals result/runtime telemetry, performs no retry, and leaves repository/Git state identical. Timeout, plan-file diversion, malformed/local-schema-invalid output, unauthorized capability use, or repository-state change falsifies R3 and authorizes no same-realization retry.

This R3 realization is materially different from R1/R2 because the suspected mechanism is now the headless Plan Mode output-routing contract itself, not packet size or native StructuredOutput. C9 remains the commissioned manual advisory plane; C9A remains uncommissioned; C10 remains falsified; C11+ remain blocked.
