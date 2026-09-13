# E0-B Run 01 Terminal Discovery — 2026-09-12

Status: **ADMINISTRATOR-VERIFIED LOCAL TERMINAL EVIDENCE — OWNING PROJECT CLOSEOUT PENDING**

This file is Ryladmin continuity only. It does not create Engineering, experiment, provider, scoring, successor-phase, or retry authority. `Rylascoo/Ensemble-Project` remains the owning authority.

## Discovery boundary

Administrator read-only census after Project `main@5a0709233c9f897584f8bff849c83db354ac45c1` found the previously absent reserved namespace:

`C:\Users\Wiryl\Sol Dev\Ensemble-Project-Evidence\E0B-Q01-MIX-20260912-01`

The local validator remains exact executable checkout `d1073fe2c76e2e05f2daac47465f86b48b456a9a`. No matching RunId/validator execution process remained active at census time.

Current Project `CURRENT_STATE.md` still says Run 01 is ready and unconsumed. That owning volatile state is therefore stale relative to the verified local terminal evidence and must be reconciled by Engineering/Evidence rather than silently rewritten by Administrator.

## Terminal seal

`run.final.json` records:

- contract `ensemble.e0a.runtime-seal.v1`;
- terminal status `TechnicalFailure`;
- accepted turns `2`;
- estimated spend USD `0.17175080`;
- spend estimate status `WithinVerifiedPricingAssumptions`;
- `hasUnknownProviderUsage=true`;
- final state hash `69e85371060b965c6fb6d5ad48ee446a6195a4d2efb4b533638e396c9bd8968c`;
- final opportunity Character `WREN`.

## Terminal cause

`events.ndjson` and `attempts/E0B-Q01-MIX-20260912-01_ATTEMPT_PERFORMER_003_01/terminal.json` establish:

- turns 1 and 2 committed successfully;
- turn 3 was the WREN Performer opportunity;
- the Performer attempt ended `TechnicalFailure`;
- diagnostic code: `gemini-http-503;status=UNAVAILABLE`;
- response id, returned model, usage, and structured output are null for the failed attempt;
- spend reconciliation therefore records unknown usage and conservatively commits the failed-attempt estimate;
- no retry/replay/fallback occurred in the observed evidence.

This is a provider technical failure, not fictional action and not a contributing 12/12 comparison run.

## Independent integrity verification

Administrator rehashed all 24 artifacts enumerated by `run.final.json`; failures: **0**.

Key fingerprints:

- `run.final.json`: `1F55B01AEB39EE70C99E126B694EC969C7015CAA1F391EADD8546D6F0C618EDD`;
- `run.summary.json`: `3C9D92C61DC41C25785915510438298664748853A939A5CBB78654B718F282D2`;
- `manifest.json`: `A2C5A522D08C9F4955B5951421B7440C42A6A700FB7DE7B5063896AD96B54ED3`;
- `events.ndjson`: `5D35ED9BC9608FC36763A6C99829857252AA72D056F1A8E863C9AE1C650B5C2B`;
- `transcript.json`: `D5044F1F7F8CFA49EDA38001A9243999BDEEDF5DC301E0AD5760DE04A18B751E`.

## Authority consequence

Project authority at `main@5a070923...` says any namespace claim consumes the reserved run, no probe/retry/replay/fallback is authorized, every terminal outcome must be preserved/sealed/audited/ledgered, and only a 12/12 contributing run with complete seal + hard-gate PASS may enter blind scoring.

Administrator therefore treats the following as mechanically established for continuity:

1. the reserved Run 01 namespace is consumed;
2. the observed run is terminal and noncontributing for the 12/12 scoring gate;
3. the same RunId may not be retried, replayed, replaced, or routed through a fallback by Administrator;
4. the exact owning Q-E0B-01 closure/falsification/successor classification remains pending Project Engineering/Evidence reconciliation.

Ephemeral Project transport `Rylascoo/Ensemble-Project#103` carries the terminal audit/closeout request. Existing R3 transport `#100` was updated so its remaining R3 decision evaluation must fresh-recover after the Q-E0B-01 terminal state is reconciled.

No R3/C9A/C10/C11 authority follows from this terminal evidence.
