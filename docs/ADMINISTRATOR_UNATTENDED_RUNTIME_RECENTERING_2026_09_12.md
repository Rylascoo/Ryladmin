# Administrator Unattended Runtime Recentering — 2026-09-12

Status: **DIRECTOR RECENTERING — CONTINUITY ONLY; C10 STILL BLOCKED; C11 NOT ADMITTED**

## Decision

The Director explicitly recentered the Administrator program on its original unattended-operation objective. The primary commissioning sequence is now:

`Q-ADMIN-02 -> C10 eligibility/revalidation -> C11 selected Automation admission -> C12 disaster recovery -> C13 ordinary-limit sustainability`.

Engineering and Design continue under their owning repositories. Administrator involvement in those lanes is limited to bounded continuity/race protection and must not become continuous supervision or a competing writer.

## Current C10 boundary

The preserved C10 falsification remains binding. The commissioned Codex 0.153.4 realization failed open when a `PreToolUse` hook process failed nonzero. The later Director disposition requires upstream source/release evidence of fail-closed handling before another live C10 realization may even be opened.

Fresh upstream inspection on 2026-09-12 still fails that trigger: OpenAI Codex issue #41979 remains open, and current `PreToolUse` source still leaves generic hook-process failures non-blocking and returns `should_block: false` for serialization failure. A newer version number alone is not eligibility evidence.

A user-level ChatGPT condition watch now checks upstream daily and reports only concrete eligibility evidence. This is external discovery assistance permitted by the C10 disposition. It is not part of the commissioned Administrator runtime, is not C11, and creates no Hook, repository, provider, scheduling, or mutation authority.

## C11 preparation candidate

C11 remains unavailable until C10 passes. Preparation may nevertheless identify the likely first admission candidate without enabling it.

Candidate 01 is the existing repository-native `.agents/skills/authority-recovery/SKILL.md` in `Rylascoo/Ensemble-Project`. It is preferred because it already exists as a stable manual Skill, passed C3 deterministic fixtures and a fresh-session usability probe, is read-only, has repeated demonstrated demand, and explicitly cannot fetch/checkout/reset/clean/switch/merge/push/delete or create project authority.

After a future valid C10 pass, C11 should revalidate this exact Skill at live Project authority and measure one bounded read-only admission experiment. The automated realization, if admitted, may detect material authority/ref/CI drift and notify/return only. It must not react by launching work or mutating Git/authority. C11 may still validly conclude `NO AUTOMATION ADMITTED` if the economics do not justify it.

## Continuity transports

- Ryladmin Issue #32 preserves the Director recentering and machine-interruption resume boundary.
- Ryladmin Issue #33 preserves C11 Candidate 01 preparation only.

These Issues are ephemeral continuity transport, not owning Project authority or a second backlog. This document supersedes their continuity purpose once merged into Ryladmin; the Issues may then be closed as transport-complete.
