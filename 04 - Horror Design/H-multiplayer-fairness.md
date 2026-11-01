---
id: H-multiplayer-fairness
type: principle
title: Multiplayer horror fairness
status: reviewed
updated: 2026-11-01
tags: [horror, multiplayer, design]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 1
related: "R-multiplayer-targeting", "H-adaptive-director", "R-reduced-motion-policy"
---

# Multiplayer horror

Co-op horror has a problem single-player does not: **the scare must be shared, but the experience must
stay fair for the weakest player.**

## Rules

1. **Replicated cues, local presentation.** The door creak plays at the door for everyone. A
   flash-flicker stinger applies only to the player it targets, and only if their settings allow it.
2. **Intensity cap = the minimum across the group.** If one player has reduced-flash on, no one in that
   server gets full-screen flashes. This is the only way a settings menu stays honest in co-op.
3. **Never punish a player for another's scare.** A stinger should not cause damage, trigger a trap, or
   reset progress for someone who was not looking at it.
4. **Downed players still see something.** Spectating a black screen for 3 minutes is worse than a
   mild scare.
5. **Threat targeting needs anti-oscillation.** If the NPC switches targets every 0.2 s it reads as
   broken: require a minimum dwell time (2–3 s) before switching ([[R-multiplayer-targeting]]).
6. **Split parties.** If players are in different rooms, the director should favour the *group*:
   beats that are perceivable from both, or none.

## The unfair patterns to avoid

| Pattern | Why it feels bad |
|---|---|
| A trap that only triggers for one player, silently | "why did I lose?" |
| A jumpscare that interrupts input (a menu, a grab) | it removes agency, not comfort |
| Scaling threat with player count but not safe-room time | 4 players = 4× pressure, same recovery |
| A player who joined late gets no context and eats the first threat | late-join snapshot must include the current intensity state |

## Test plan

1. 2 players in the same room → both see/hear the same cue at the same time (±100 ms).
2. 2 players in different rooms → the chosen beat is audible/visible from both, or skipped.
3. One player with reduced motion → verify no flash/camera-shake in that client, and the cap propagates.
4. Repeated threat target switches → never faster than the dwell time.

