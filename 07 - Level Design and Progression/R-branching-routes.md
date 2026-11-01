---
id: R-branching-routes
type: reference
title: Branching routes and multiplayer bottlenecks
status: reviewed
updated: 2026-11-01
tags: [level, routes, multiplayer]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 0
related: "R-floorplan-patterns", "R-clue-placement-and-softlock", "H-multiplayer-fairness"
---

# Branching

A branch is a choice with a cost. If both branches are equal, it is decoration.

## Branch types

| Type | Cost difference | Reads as |
|---|---|---|
| Risk | one is patrolled | meaningful for a stealth game |
| Time | one is longer | fine, but only if time matters |
| Reward | one has loot | good for heists |
| Information | one reveals a code | good for puzzles |
| One-way | cannot return | a commitment (use sparingly) |

## Bottleneck rules

- **Never fewer than two exits** from any room a player can be chased into.
- Doorways are bottlenecks by definition: keep them ≥ 5 studs and never place a threat spawn inside one.
- In multiplayer, a 4-player party needs 6+ studs to pass without shoving; a 5-stud doorway causes
  collision jams that look like lag.

## Measuring

```text
BFS from entry to exit:
  shortest path:      14 rooms, 190 studs
  alternate path:     17 rooms, 240 studs
  shared nodes:       3 of 14   ← good, the routes genuinely split
```

If the two paths share most nodes, the branch is a corridor with a detour.

## Softlock check

Every branch must be exit-able without backtracking through a locked door. If a branch's only exit can be
locked behind the player, it is a softlock waiting for a player to find it.

