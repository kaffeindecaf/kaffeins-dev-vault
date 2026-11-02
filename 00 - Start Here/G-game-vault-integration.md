---
id: G-game-vault-integration
type: guide
title: Project vault workflow — connect game work to reusable knowledge
status: draft
updated: 2026-11-01
tags: [projects, workflow, handoff, integration]
source_urls: []
confidence: medium
verification: design_only
related: [ "MOC-start-here", "MOC-projects", "N-SCHEMA" ]
---

# Project vault workflow — connect game work to reusable knowledge

This guide combines a reusable project-session workflow with this vault's Roblox reference library.
The knowledge base remains the shared source for
reusable systems, asset records, references and templates. Each game's project folder remains the
source of truth for that game's design, decisions, current state and Studio evidence.

## What belongs where

| Information | Keep it in | Rule |
|---|---|---|
| Reusable Roblox APIs, recipes, bugs and design patterns | This vault's libraries | Cite sources and keep verification status accurate. |
| A specific game's goals, specifications and decisions | Its project folder | Link to reusable notes by stable note ID; avoid copying their contents. |
| Current session state and next actions | Project handoff and timeline | Record only work that happened and the exact stopping point. |
| Asset candidates | This vault's asset catalog | A listing is not access, license or Studio approval. |
| Game-specific asset use and observed result | Project asset manifest | Link to the catalog entry and record project-specific evidence. |

## Session loop

1. Read the project README, working rules, latest handoff, open questions and the relevant spec.
2. Search this vault for existing systems, source notes and asset records before proposing new material.
3. State the cause, planned change and observable acceptance check before implementation.
4. Make and verify the authorized change in the actual project environment. Label anything not run as untested.
5. Update the project timeline, handoff, feature or bug record, and the knowledge base only when a
   pattern is reusable beyond that one project.

## Promote reusable knowledge carefully

When a project yields a general pattern, write a separate knowledge-base note. Remove project-only
names, paths, identifiers and secrets; keep a provenance note describing where the pattern came
from; and mark the adapted code `Untested:` until it is run in a suitable environment. A successful
run in the source project does not prove the extracted version works here.

## Starter files

Use these project templates for session continuity and decision tracking:

- [[Tproject-SESSION_START]]
- [[Tproject-WORKING_RULES]]
- [[Tproject-TIMELINE]]
- [[Tproject-OPEN_QUESTIONS]]
- Existing structure: [[Tproject-README]], [[Tproject-HANDOFF]], [[Tproject-ROADMAP]], [[Tproject-TEST_PLAN]]

The workflow is designed to keep each game's decisions, state and evidence in its own project
folder. Game-specific example content does not belong in the reusable library.
