---
id: Tproject-WORKING_RULES
type: template
title: "PROJECT TEMPLATE — working rules"
status: draft
updated: 2026-11-01
tags: [project-template, safety, workflow]
source_urls: []
confidence: medium
verification: design_only
related: [ "G-game-vault-integration", "Tproject-SECURITY_CHECKLIST" ]
---

# Working rules — {{Project Name}}

Fill this file with project-specific rules. The knowledge base's [[AGENTS]] and [[SCHEMA]] still
govern any notes written in that vault.

## Source of truth

- Project design and decisions: {{path}}
- Game code and place: {{path or Studio place name}}
- Reusable Roblox references: the shared knowledge base, linked by note ID
- Backups: {{path and frequency}}

## Change boundaries

- Edit only: {{approved project paths}}
- Do not edit: {{protected paths and why}}
- Studio changes: {{save/backup expectations}}
- External actions requiring the owner's direction: publish, permission changes, purchases, uploads

## Evidence and code labels

- `Tested:` means it was run in the named environment and evidence is recorded.
- `Untested:` means it was not run in the target environment.
- Do not infer asset access, license permission or runtime behavior from a listing or code inspection.
- Record reproduction steps and expected results before calling a bug fixed.

## Communication

- Explain the cause and planned change before broad or risky edits.
- Keep changes narrow enough to review and record the files changed.
- End each work session with a timeline entry and an updated handoff.
