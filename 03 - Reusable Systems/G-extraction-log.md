---
id: G-extraction-log
type: guide
title: Extraction log — patterns read out of a shipped place
status: reviewed
updated: 2026-11-01
tags: [extraction, provenance, process]
source_urls: []
confidence: high
verification: reference_only
client_server: both
code_blocks: 0
related: [ "MOC-reusable-systems", "SCHEMA", "ISSUES" ]
---

# Extraction log

On **2026-11-01** I read a live, shipped Roblox experience through the Studio MCP (Edit mode, read-only: no
writes, no playtest started, no source modified) and turned its least game-specific systems into the notes
below.

## What was read

| Source script (in the place) | Bytes | What it gave |
|---|---:|---|
| Round state module | 1.9 KB | [[S-round-phase-machine]] |
| Single-writer persistence module | 21 KB | [[S-delta-save-queue]] |
| Server speed guard | 5.1 KB | [[S-speed-guard]] |
| Noise bus module | 2.9 KB | [[S-noise-bus]] |
| Interaction guard module | 2.2 KB | [[S-interaction-guard]] |
| Carry/inventory script | 40 KB | [[S-world-object-validation]], [[S-config-derivation]] |
| Hiding-spot server script | 12 KB | [[S-occupancy-state-machine]] |
| NPC brain module | 48 KB | structure only (see below) |
| AI config module | 14 KB | tuning shape (see below) |

Read-only evidence: `list_roblox_studios` → two instances, both **Edit**; `search_game_tree` for the inventory;
`script_read` on the seven scripts above; `execute_luau` for function indexes and byte sizes. Nothing was
written and no play session was started.

## How they were universalised

| Original | Kept | Replaced |
|---|---|---|
| currency name / item ids | the delta-write and token logic | `coins`, `xp`, generic item ids |
| place ids, folder names | the validation **order** | `Workspace.Loot`, `u_<userId>` |
| "homeowner" NPC, "closet" | occupancy + release paths | generic `spot`, `Perception.Publish` |
| shop/carry upgrades | the optional-module fallback | `ShopEffects` → `safeRequire(...)` |

## Honesty statement (read this before quoting the code)

- The code is **adapted, not executed here.** Each block is labelled `Untested in this vault`. It ran in the
  source place; the adapted version has not been run anywhere.
- Nothing about **permissions, licensing or asset ownership** was inferred from that place.
- Values are the shipped ones where they are generic (a 0.25 s sample interval), and marked with a sane range.
- Where the source contained a fragile idiom, I kept it **and documented the trap** rather than silently
  "fixing" it — the point is to teach the failure, not to hide it.

## What I deliberately did not extract

| Thing | Why not |
|---|---|
| The 1,349-line NPC brain | 90% is content (patrol data, door logic, catch rules). The transferable parts are already in [[R-npc-state-machine]] and [[R-npc-think-budget]]; copying it would teach a game, not a pattern. |
| The 598-line item spawner | same: rarity tables and model plumbing are content. The pattern is [[S-loot-containers]]. |
| Menu/challenge/achievement services | thin wrappers over the persistence module; the interesting part is [[S-delta-save-queue]]. |
| Any asset ID | the vault records candidates only, and a working ID in one experience is not a licence ([[LICENSES_AND_SOURCES]]). |

## Worth doing next

1. Run one extracted note in a blank place and change its label from `Untested in this vault` to `Tested:` with
   a date. [[S-round-phase-machine]] is the cheapest (no dependencies).
2. Diff the adapted code against the source before trusting it in the source project — the generalisation
   renamed things, and a rename is a bug surface ([[ISSUES]]).
