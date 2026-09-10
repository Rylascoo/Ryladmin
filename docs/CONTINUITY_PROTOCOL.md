# Ryladmin Continuity Protocol

## Purpose

Ryladmin prevents Administrator workflow loss across ChatGPT fresh chats. It preserves operational continuity while delegating all project meaning to the repositories and connected sources that actually own that meaning.

## Source precedence

For Administrator state: live owning repository authority > exact local Git/machine evidence > Ryladmin current continuity > prior Ryladmin history > chat history.

For Ensemble Engineering/product/provider/validation state, `Rylascoo/Ensemble-Project` remains authoritative according to its own bootstrap law. For Design state, `Rylascoo/Ensemble-Website` and its connected Drive assets remain authoritative according to their own law.

Ryladmin may point to, summarize, or timestamp those sources, but a summary is always a snapshot and must be revalidated.

## Required fresh-chat recovery

A fresh Administrator chat must:

1. resolve Ryladmin live `main` and read root `AGENTS.md` plus `CURRENT_STATE.md` through EOF;
2. resolve Ensemble Project live `main`, read its bootstrap/current-state/authority/queue surfaces, and determine the sole earned Administrator gate;
3. recover local runtime and worktree truth when machine state matters;
4. recover current GitHub CI/ref truth when promotion or validation evidence matters;
5. distinguish active Engineering and Design work from Administrator worktrees before any cleanup;
6. continue the recorded gate only after reconciling stale snapshots.

## Update triggers

Update Ryladmin `CURRENT_STATE.md` when any of these occurs:

- an Administrator commissioning gate closes or a new one becomes earned;
- the commissioned runtime's security/profile/launcher realization changes materially;
- a fresh-chat handoff is imminent while a gate is incomplete;
- a material defect, failed attempt, or fallback mechanism changes the exact continuation point;
- local topology or another lane changes in a way a fresh Administrator must distinguish from residue.

Routine test output and transient logs do not belong here unless needed to identify an unresolved continuation boundary.

## Data discipline

Never store credentials, API keys, auth tokens/files, private user content, copied provider payloads containing private data, or secrets. Prefer hashes, exact refs, thread/run identifiers, public repository paths, non-secret machine paths, and concise evidence outcomes.

## Closure discipline

Before a handoff is considered complete, `CURRENT_STATE.md` must state: the last reconciled authoritative ref as a snapshot; completed Administrator gates; sole active/next earned gate; any unresolved defect/fallback; machine-local realization needed to resume; preserved worktrees/branches that must not be mistaken for residue; and the next deterministic actions.

A new chat must never ask the Director to restate facts recoverable from these sources.
