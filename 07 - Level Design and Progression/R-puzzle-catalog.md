---
id: R-puzzle-catalog
type: reference
title: Room-based puzzle catalogue with reset paths
status: reviewed
updated: 2026-11-01
tags: [level, puzzles, design]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 0
related: "R-puzzle-dependency-graph", "S-puzzle-framework", "R-clue-placement-and-softlock"
---

# Puzzle catalogue

Nine puzzle types that work in a 3D house, each with the reset path that makes it fair.

| # | Puzzle | Input | Solution space | Reset |
|---|---|---|---|---|
| 1 | Key/lock | item | trivial | item returned on round reset |
| 2 | Keypad code | 4 digits | 10⁴, clue reveals | code re-randomised per round |
| 3 | Fuse/valve sequence | ordered switches | N! but guided by labels | switches reset |
| 4 | Weighted plates | positions of objects | physical | objects reset to spawn |
| 5 | Colour/light matching | matching pairs | combinatorial | lights reset |
| 6 | Rotating valves to align pipes | rotation | continuous | valves reset |
| 7 | Timed sequence | actions within a window | order + timing | timer cleared |
| 8 | Hidden compartment | find the thing | search | compartment closes |
| 9 | Environmental cause | understand a system (cut power to open a magnetic lock) | insight | power restored |

## Accessibility rules

- Every puzzle must be solvable with **one input method** (a player using only a controller).
- No puzzle may depend on colour alone; add a shape/symbol.
- No puzzle may depend on audio alone; add a visual tell.
- Time limits: ≥ 20 s for a first-time player, and no failure state that ends the run.

## Anti-softlock rules

1. No item can be destroyed, dropped, or carried out of the puzzle's zone.
2. Every puzzle has a reset control within ~10 studs.
3. A puzzle that can be failed must fail to a *resettable* state, never to a dead end.
4. Multiplayer: two players must not be able to lock each other out (e.g. one holds a plate, the other
   leaves with the key).

See [[R-puzzle-dependency-graph]] · [[S-puzzle-framework]] · [[R-clue-placement-and-softlock]].

