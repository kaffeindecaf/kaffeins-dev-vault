---
id: WL-20261102-project-onboarding
type: worklog
title: Project onboarding and user goal checklist
status: draft
updated: 2026-11-02
tags: [worklog, agents, onboarding, checklist]
source_urls: []
agent: Codex
confidence: high
verification: tested_local
tested_at: 2026-11-02
test_evidence: worklog-2026-11-02-project-onboarding.md
related: ["N-SOUL", "N-USER-CHECKLIST", "N-AGENTS"]
---

# Project onboarding and user goal checklist

## Task and scope

Add a reusable first-project conversation flow that distinguishes a new game from continuing an
existing one, allows the user to skip onboarding questions, and persists confirmed context and user
goals in separate files. Keep the flow distinct from the knowledge vault's own `ROADMAP.md`.

## Files changed

| File | Change / purpose | Verification |
|---|---|---|
| `SOUL.md` | Added project detection, opening question, context review, focused follow-up questions, skip behavior, project profile, and checklist maintenance rules. | `validate`; manual content review |
| `checklist.md` | Added the user-goal ledger, status rules and entry format; seeded the completed onboarding setup goal. | `validate`; manual content review |
| `AGENTS.md` | Made agents read SOUL/checklist and keep user goals current. | `validate` |
| `09 - AI Agent Knowledge/PR-session-start.md` | Added the onboarding and skip flow to the session-start prompt. | `validate` |
| `HOME.md` | Added discovery links and distinguished the user checklist from the vault roadmap. | `validate` |
| `CHANGELOG.md` | Recorded the feature. | `validate` |
| This work log | Recorded the request, changes and actual local verification. | `validate` |

## Verification

`rtk proxy python scripts/gamedev_kb.py validate`

```text
560 notes checked (8 test fixtures excluded) · 0 errors · 0 warnings
```

`rtk proxy python scripts/gamedev_kb.py index`

```text
indexed 560 notes into config/index.sqlite (engine: fts5)
fingerprint feeef9b80ef45165 — a second run over unchanged files produces the same value
```

These are the actual closure outputs after the work-log file was created and before this transcript
was finalized. The index fingerprint covers that exact file state. `rtk git diff --check` produced
no diagnostics. The automated unittest suite was not run; this change only adds and links Markdown
instructions, and no test run was requested.

## Decisions and assumptions

- The active vault is a knowledge base, not a game. The SOUL profile therefore says no game has
  been confirmed and leaves game-specific details unknown.
- The checklist is for the user's project goals; the existing `ROADMAP.md` remains the vault's own
  task plan.
- Onboarding runs once for a new or unconfirmed project, not on every task. User instructions can
  skip questions immediately.

## Open questions

- No game project or game-specific goals have been confirmed in this vault yet; future onboarding
  will fill in the project profile and active goals.

## Three logical next steps

1. When a game project is first selected, ask whether it is new or existing; done when its identity
   is confirmed in the project profile.
2. After the user describes the game, inspect its source of truth and ask only material unanswered
   questions; done when the confirmed summary is saved in `SOUL.md`.
3. Add the resulting user goals to `checklist.md`; done when every active goal has a status, next
   action and observable completion condition.
