---
id: R-level-playtest-checklist
type: guide
title: Level playtest checklist
status: reviewed
updated: 2026-11-01
tags: [level, playtest, quality]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 0
related: "R-level-blockout-template", "G-npc-test-matrix", "R-puzzle-catalog"
---

# Playtest checklist

Run this on every level change. Record observed results only — a checklist you tick from memory is fiction.

## Navigation

- [ ] Player reaches the objective without help, in the intended time (±30%).
- [ ] Player can return to the entry from the far end.
- [ ] Every junction is distinguishable ([[R-landmarks-and-orientation]]).
- [ ] No doorway is blocked by a prop or a closed door that cannot be opened.

## Stuck states

- [ ] No place where the player can wedge between geometry.
- [ ] No place where the player can fall out of the map.
- [ ] Every climbable surface has a way back down.
- [ ] No place where a pursuer can trap a player with no exit.

## Puzzles

- [ ] Each puzzle solved by a first-time player within 20–120 s.
- [ ] Every puzzle resets ([[R-puzzle-catalog]]).
- [ ] No clue is required that is not on the path ([[R-clue-placement-and-softlock]]).

## Threat

- [ ] No spawn within sight of the player spawn.
- [ ] Chases are escapable (measure: the player survived at least once per 5 chases).
- [ ] Safe rooms are safe for a full 60 s.

## Performance

- [ ] Frame time within budget with the full threat state active ([[H-profiling-budgets]]).
- [ ] No streaming pop-in inside the level ([[R-streamingenabled]]).

## Multiplayer

- [ ] Two players can pass each other in every corridor.
- [ ] A late joiner sees a consistent world ([[S-late-join-sync]]).

## Evidence

For each fail: room, position, what happened, screenshot. A failing item without a position cannot be fixed.

