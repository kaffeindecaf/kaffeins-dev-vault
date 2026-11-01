---
id: P-sample-horror-house
type: project
title: "Sample project — The Care Home (concept)"
status: reviewed
updated: 2026-11-01
tags: [project-template]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 0
related: [ "MOC-projects" ]
---

# The Care Home — sample project

> **A worked example, not a claim that a game exists.** It shows how to wire this vault's recipes into a real
> project: which notes to read, what to verify, and what stays unverified. Copy `_PROJECT_TEMPLATE` rather than
> this folder.

## One line
Break into an abandoned care home for a resident's file, while one pursuer and one investigator make the
building a problem.

## Why this sample exists
It is the smallest project that touches: server-authoritative pickups, hiding with cover checks, a pursuer FSM,
an adaptive director, and a responsive HUD — the five systems most likely to be built wrong.

## Systems used (all recipes, all untested code)
| Need | Recipe | Notes |
|---|---|---|
| Interact prompt | [[S-interaction-prompt]] | `ProximityPrompt`, server-validated |
| Take loot | [[S-pickup-server-authoritative]] | claim map before grant |
| Inventory | [[S-inventory-data-model]] | 6 slots, snapshot replication |
| Hide | [[S-hiding-spots]] | closet + crate cover |
| Pursuer | [[R-npc-state-machine]] | FSM with explicit guards |
| Perception | [[R-npc-perception-model]] | 2-point sight, noise events |
| Pacing | [[H-adaptive-director]] | beats from a catalogue |
| HUD | [[R-horror-hud]] + [[R-responsive-matrix]] | verified at 8 viewports |
| Level | [[R-sample-level-abandoned-building]] | full blockout plan |

## What must be verified before this is real
| Thing | Verified? | How |
|---|---|---|
| Any audio candidate | **no** | [[G-asset-verification-workflow]] |
| Chase is escapable | **no** | 5 chases, log survival |
| HUD on a phone | **no** | 3 screenshots |
| Frame time with 2 NPCs | **no** | MicroProfiler |

## Scope discipline
- In: one house, one file, two NPCs, ten minutes.
- Out: multiplayer, monetisation, more than one map — deliberately, until the vertical slice plays.

