---
id: Tproject-SESSION_START
type: template
title: "PROJECT TEMPLATE — session start"
status: draft
updated: 2026-11-01
tags: [project-template, session, handoff]
source_urls: []
confidence: medium
verification: design_only
related: [ "G-game-vault-integration", "MOC-projects" ]
---

# Session start — {{Project Name}}

Read these project files before changing anything:

1. `README.md` — project scope and source-of-truth map.
2. `WORKING_RULES.md` — project-specific boundaries and approval points.
3. `HANDOFF.md` — current state, last verified result and next three actions.
4. `OPEN_QUESTIONS.md` — decisions still waiting for the owner.
5. The spec and test plan for the task being continued.

## Before editing

- [ ] Confirm the project root and the exact files in scope.
- [ ] Check whether the same issue or feature already has a note.
- [ ] Identify the expected observable result and how it can be checked.
- [ ] Record any uncommitted Studio or Rojo changes before replacing files.
- [ ] Ask the owner about a decision that changes scope, player-facing behavior or data ownership.

## At session end

- [ ] Record actual changes and checks in `TIMELINE.md`.
- [ ] Update `HANDOFF.md` with current state and the next three exact actions.
- [ ] Update specs, feature notes and open questions affected by the work.
- [ ] Label code that was not run as `Untested:`.
- [ ] Promote reusable patterns to the knowledge base with provenance; leave project details here.

## Current task

- Request: {{...}}
- In scope: {{...}}
- Acceptance check: {{...}}
