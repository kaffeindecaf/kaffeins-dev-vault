---
id: R-spawn-placement
type: reference
title: Enemy and player spawn placement rules
status: reviewed
updated: 2026-11-01
tags: [level, spawns, fairness]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 0
related: "R-level-blockout-template", "R-npc-state-machine", "H-safe-room-rhythm"
---

# Spawn placement

An unfair spawn is indistinguishable from a bug to the player, and it is the easiest thing to prevent.

## Player spawns

| Rule | Value |
|---|---|
| Distance from any enemy spawn | ≥ 40 studs or out of line of sight |
| Visible exit | the player must see a way forward in the first 2 s |
| No threat within | 8 s of walking at normal speed |
| Facing | toward the level, not toward a wall |
| Collision | no spawn inside geometry (verify with a 6-stud clearance sphere) |

## Enemy spawns

- Never inside the player's current room.
- Never in a safe room.
- At least one route to the player's area, or the threat never arrives and the pacing dies.
- Behind cover from the player's *entry path*, so the enemy is not visible the instant it spawns.
- If an enemy spawns within 20 studs, give the player an audio cue at least 2 s earlier.

## Multiplayer

- Players spawn within 15 studs of each other in co-op (a split spawn is a 30-second solo walk).
- With N players, spawn distance from threats scales: `40 + 5 * (N - 1)`.

## Roblox specifics

- `SpawnLocation.Neutral = true` for shared spawns; `AllowTeamChangeOnTouch` off.
- `SpawnLocation.Duration` > 0 forces a respawn delay — check it is what you intend.
- Spawn parts inside `workspace` may be displaced by another part spawning on top; keep the area clear.

## Verify

Place a debug sphere at every spawn and walk from each to the first threat opportunity; timing under 8 s or
clear line of sight at spawn is a fail.

