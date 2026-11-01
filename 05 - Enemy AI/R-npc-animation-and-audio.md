---
id: R-npc-animation-and-audio
type: reference
title: NPC animation handling and state audio cues
status: reviewed
updated: 2026-11-01
tags: [ai, animation, audio]
source_urls: []
confidence: medium
verification: design_only
client_server: server
roblox_services: []
code_blocks: 1
related: "R-animation-loading-and-priorities", "H-door-sound-matrix", "R-npc-state-machine"
---

# NPC animation and audio

The player reads an NPC's intent from three things: its **speed**, its **pose**, and the **sound** it makes.
All three must agree or the NPC feels broken.

## Animation by state

| State | Track | Playback |
|---|---|---|
| Idle | idle | looped, priority Idle |
| Patrol | walk | looped, priority Movement, speed-matched |
| Suspicious | idle + head turn | one-shot, priority Action |
| Investigate | walk (faster) | looped |
| Chase | run | looped, priority Action |
| Search | walk, slow | looped |

Two things that make NPCs look alive: a **dwell** with a head/torso turn (`lookAt` waypoints), and a
**speed-matched** walk track (`PlaybackSpeed = speed / 16`).

## Rig compatibility

An NPC rig needs the same joint names as the animation was authored for. R15 clips on a custom
`AnimationConstraint` rig, or R6 clips on R15, simply do not bind ([[R-animation-loading-and-priorities]]).

## State audio (the cheapest readability win)

| State change | Sound | Where |
|---|---|---|
| Patrol → Suspicious | a short inhale / pause in footsteps | at the NPC |
| → Investigate | footsteps resume, slightly faster | at the NPC |
| → Chase | a distinct vocalisation, once | at the NPC |
| → Recover | breathing / a door of distance | at the NPC |
| Catch | impact + a stinger | at the catch point |

Positional sound on the NPC's root means players can hear *where* it is through a wall — the single most
important audio feature for a stealth game.

## Rules

- Stop the previous track before starting a conflicting one (`track:Stop(0.15)`).
- Do not re-`Play()` a looped track every state tick.
- Chase music belongs to the director, not the NPC ([[H-adaptive-director]]).
- One vocalisation per chase, not per second.

