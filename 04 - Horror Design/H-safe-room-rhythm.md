---
id: H-safe-room-rhythm
type: principle
title: Safe rooms, intensity cooldowns and decompression
status: reviewed
updated: 2026-11-01
tags: [horror, pacing, design]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 1
related: "H-tension-hierarchy", "S-camera-and-headbob", "H-adaptive-director"
---

# Safe rooms and decompression

A safe room is a promise you must keep: **no threat, ever, inside**. Break it once and the room stops
working for the rest of the game.

## What makes a room read as safe

| Signal | Implementation |
|---|---|
| Warm light | higher colour temperature, brighter than the corridor, steady (no flicker) |
| Enclosure | one entrance, visible, no windows to a threat space |
| Sound | room tone only, no detail layer, no stingers |
| Scale | smaller and lower-ceiling than the path (unconsciously "safer") |
| Affordance | something to do: a save point, a box of supplies, a mirror |

## Rhythm

```text
Explore (90 s) → pressure rises → Threat (20 s) → escape → Safe room (20–40 s) → Explore (harder)
```

The safe room is where the player *voluntarily* stays a moment longer than needed — that pause is the
release. If the room is boring, they leave in 2 s and the pacing never resets.

## Implementation rules

- A `SafeZone` part/folder with `CollectionService` tag; the NPC controller must query it before every
  acquire, and the director must suspend beats inside it.
- Never teleport a threat into a safe room to "increase pressure". That is the one unforgivable move.
- Safe room while the round ends should still be safe (no last-second straggler spawn).

## Failure modes

- Safe zone geometry too small → the player is safe, their hat is not, and a catch lands at the door.
- NPC path finds *through* the safe room → it walks in on patrol. Exclude the zone from the nav area or
  gate the patrol path.
- Director still plays ambience stingers inside → the room feels like everywhere else.

