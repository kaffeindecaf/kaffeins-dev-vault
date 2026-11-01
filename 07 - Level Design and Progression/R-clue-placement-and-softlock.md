---
id: R-clue-placement-and-softlock
type: reference
title: Clue placement, redundancy and anti-softlock
status: reviewed
updated: 2026-11-01
tags: [level, puzzles, quality]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 0
related: "R-puzzle-catalog", "R-puzzle-dependency-graph", "S-puzzle-framework"
---

# Clues and softlocks

A softlock is any state where the player cannot progress and cannot tell why. It is the most expensive kind
of bug: it does not error, it just ends the session.

## The three-clue rule

Every required piece of information appears in three forms, in three places:

| Form | Example | Why |
|---|---|---|
| Environmental | a keypad with worn digits 4, 7, 2, 9 | the observant player needs nothing else |
| Documented | a note with the code | the thorough player gets confirmation |
| Inferable | a radio says "the twenty-fourth" | the player who is stuck gets a nudge |

Any *one* of them alone is a softlock risk; all three is a puzzle that respects the player.

## Redundancy placement

- One clue **in the room** (must be findable in ~20 s of looking).
- One clue **on the path** the player already walked (so backtracking is not required).
- One **repeatable** source (an audio line that replays, a note that can be re-read).

## Anti-softlock checklist

- [ ] No item can be destroyed or permanently dropped
- [ ] No door can be locked behind the player with the key on the other side
- [ ] No puzzle can be reset into an unsolvable state
- [ ] Every timed puzzle can be retried
- [ ] Multiplayer: no single player's absence blocks progress
- [ ] A reset exists within 10 studs of every puzzle
- [ ] Round reset restores every puzzle's authored state

## Detecting softlocks in playtests

Ask the tester to play without help for 10 minutes and note the first moment they stand still for more than
20 seconds. That moment is either atmosphere or a missing clue — you cannot tell from the video alone, so
ask them what they were looking for.

