---
id: R-landmarks-and-orientation
type: reference
title: Landmarks and orientation in low light
status: reviewed
updated: 2026-11-01
tags: [level, navigation, horror]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 0
related: "R-level-blockout-template", "H-tension-hierarchy", "R-floorplan-patterns"
---

# Orientation

A dark level where every corridor looks the same is not atmospheric, it is disorienting — and disoriented
players do not feel fear, they feel annoyed.

## Three landmark tiers

| Tier | Example | Function |
|---|---|---|
| Macro | a staircase, a skylight, a tower | tells you which part of the map you are in |
| Meso | a red door, a painting, a broken piano | tells you which wing |
| Micro | a lamp, a rug, a bucket | tells you which room |

One per room minimum, at the meso tier or above.

## Real cues, ordered by strength

1. **Light.** A lit area is a landmark by definition; a dark area is a directional absence.
2. **Sound.** A dripping pipe identifies the basement; a clock identifies the hall.
3. **Colour.** One room with a slightly warmer light is remembered; five identical rooms are not.
4. **Silhouette.** An object that breaks the skyline (a lamp, a plant, an arch).
5. **Signage.** Weakest — real signage in a horror setting reads as a game.

## Rules

- Every junction has a distinguishable element on each exit. If the player must remember "second left",
  the level failed.
- Landmarks must be visible at the light level the player actually experiences (test in Play, at night
  lighting, on a phone).
- Do not put a landmark where a threat hides; the player will learn to avoid their only navigation aid.

## Test

Ask a playtester to describe the route back to the entry from the farthest room. If they cannot, the
landmarks are too weak — or the route is too long.

