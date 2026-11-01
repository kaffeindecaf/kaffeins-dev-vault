---
id: R-procgen-constraints
type: reference
title: Procedural generation constraints that preserve solvability
status: reviewed
updated: 2026-11-01
tags: [level, procgen, design]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 0
related: "R-seeded-generation", "R-floorplan-patterns", "R-level-playtest-checklist"
---

# Procedural generation

Random layouts are easy; **solvable, tense** random layouts are the actual problem.

## Hard constraints (check every generated layout)

| Constraint | Rule |
|---|---|
| Connectivity | one connected component; no orphan rooms |
| Exits | ≥ 2 per room, except the entry and the objective room |
| Path length | shortest entry→exit within 8–20 rooms |
| Loop existence | at least one cycle (a loop) so fleeing is possible |
| Safe room | exactly one, reachable, not adjacent to the climax |
| Objective reachable | with the items granted by the level, verifiable by traversal |
| Threat spawn | not inside the player's start room, not inside a safe room |
| Density | per-room object budget respected |

## Soft constraints (score and choose)

- corridor length variance (too uniform = maze-like)
- number of dead ends (a few is good for tension, many is frustrating)
- landmark distribution (one per wing)
- loot distribution (not all in one room)

## Generate → validate → retry

```text
attempt = 0
repeat
    layout = generate(seed + attempt)
    attempt += 1
until valid(layout) or attempt > 50
if not valid(layout) then fall back to a hand-authored default layout end
```

A hand-authored fallback is mandatory: the worst case must be a playable level, not an error.

## What not to randomise

- The tutorial's first room.
- The safe room's identity (players must recognise it).
- Landmark objects (a piano that moves every round destroys orientation).

See [[R-seeded-generation]] for reproducible debugging.

