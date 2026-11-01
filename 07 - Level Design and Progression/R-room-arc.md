---
id: R-room-arc
type: reference
title: Room arc: introduction, exploration, reveal, challenge, release
status: reviewed
updated: 2026-11-01
tags: [level, pacing, arc]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 0
related: "H-tension-hierarchy", "R-safe-room-threat-zone", "R-puzzle-catalog"
---

# Room arc

A room is a 20-second story, not a box. The arc keeps the player moving without a quest marker.

| Beat | What the room does | Duration |
|---|---|---|
| Introduction | sightline from the entrance tells the player what this room is for | 0–3 s |
| Exploration | objects to inspect; the loot or clue is findable but not obvious | 3–15 s |
| Reveal | the thing that makes it interesting (a body-shaped absence, a locked door, a noise) | at ~60% of the room |
| Challenge | the interaction: a lock, a puzzle, a threat entering | 15–40 s |
| Release | the exit, and a breath (the corridor is calmer) | last 2–5 s |

## Implementation notes

- **Introduction** is the most-skipped beat: if the player walks in and cannot tell the room's purpose in
  3 seconds, they will ignore it.
- **Reveal** must be physical (an object, a light, a sound), not a UI popup.
- **Challenge** scales with the room's importance: a loot room's lock can be hard; a corridor's should be
  nothing.
- **Release** is a corridor or a short safe beat; do not chain two challenge rooms back to back.

## Anti-patterns

- Every room has a lever and a locked door (rhythm becomes a metronome).
- The reveal is at the entrance, so exploration has no purpose.
- No release: the player leaves a challenge and immediately enters another, and the tension curve flattens.

See [[R-safe-room-threat-zone]] · [[H-tension-hierarchy]].

