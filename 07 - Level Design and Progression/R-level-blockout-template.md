---
id: R-level-blockout-template
type: guide
title: Level blockout template
status: reviewed
updated: 2026-11-01
tags: [level, blockout, template]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 0
related: "R-floorplan-patterns", "R-landmarks-and-orientation", "S-puzzle-framework"
---

# Blockout template

Fill this before any art exists. A grey-box level that plays well is worth more than a beautiful one that
does not.

## Room record

```text
Room:            kitchen
Purpose:         loot + a hiding spot + one clue
Size:            18 x 6 x 14 studs (W H D)
Entrances:       north (from corridor), east (to dining)
Exits:           east
Cover:           1 island, 1 pantry door
Light:           one ceiling fixture, switchable
Noise sources:   fridge hum, clock
Player sightline: from the north door you can see the pantry but not the east door
Threat access:   yes, via corridor; no, via dining (locked)
Checkpoint:      no
```

## Rules of thumb

| Dimension | Value | Why |
|---|---|---|
| Corridor width | 6–8 studs | 3 studs is cinematic but a chase feels unfair |
| Doorway width | 5–7 studs | agent radius 2.5 needs 5+ |
| Ceiling height | 9–12 studs | lower = oppressive, higher = spaces to hide vertically |
| Room size | 12×12 to 24×24 | below 12 feels like a closet, above 24 you lose tension |
| Sightline length | ≤ 30 studs indoors | beyond that, the player stops reading the room |

## Sightlines first

Draw (ASCII is fine) what a player sees standing at each entrance. If a room can be understood completely
from the doorway, there is no reason to enter it — which is fine for a corridor, fatal for a loot room.

## Locked/opened states

Every room must answer: what is the state before the player arrives, after they take the loot, and after
they leave? Level design in a heist/horror game is largely about **the state change the player causes**.

## Deliverable

A blockout note per room, plus a top-down map with:
- room rectangles, doors, cover
- light positions
- loot spawn points
- safe zones
- NPC patrol routes

