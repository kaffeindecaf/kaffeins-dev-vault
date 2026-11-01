---
id: H-tension-hierarchy
type: principle
title: Tension hierarchy: calm → suggestion → buildup → threat → release
status: reviewed
updated: 2026-11-01
tags: [horror, pacing, design]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 1
related: "H-adaptive-director", "H-safe-room-rhythm", "H-cooldowns-and-rarity"
---

# Tension hierarchy

Horror is a curve, not a constant. If the game is at maximum intensity for ten minutes, the player
adapts and nothing lands again.

## The six states

| State | Player feels | Duration | What is on screen/speaker |
|---|---|---|---|
| **Calm** | safe, curious | 30–90 s | room tone, normal light, no threat cue |
| **Suggestion** | "did I hear that?" | 5–15 s | one ambiguous cue: a distant thud, a shadow, a door that is ajar |
| **Buildup** | "something is coming" | 3–10 s | rhythm: footsteps approaching, light dimming, music layer rising |
| **Threat** | "it's here" | 5–30 s | the pursuer, full audio, chase |
| **Release** | relief, adrenaline drop | 2–5 s | silence cut, safe light, breath |
| **Cooldown** | recovery, re-baseline | 20–45 s | lower intensity than Calm, so Calm feels safe again |

The important sequencing rule: **you cannot go Calm → Threat repeatedly.** After a threat, the next
Suggestion must be quieter than the last one, or the player stops believing the cues.

## Practical mapping in Roblox

- Calm/Buildup: `Lighting.Ambience`/`Brightness` tweens, `SoundGroup.Volume` shifts, an NPC's
  `BrainState` attribute.
- Threat: NPC chase state + music layer + FOV change.
- Release: hard cut to silence (a real `:Stop()` on the music layer, not a fade).
- Cooldown: reduce the director's intensity budget ([[H-adaptive-director]]).

## When it is wrong

- Player dies repeatedly in Threat → the game reads as unfair, not scary.
- Cooldown longer than 45 s → players get bored and start exploring carelessly.
- Suggestion without payoff too often → the cues become noise and the player ignores real threats.

## Test it

Log every state transition with a timestamp for one 10-minute session. Look for: no Calm segment
longer than 90 s, no two Threats within 60 s, and a Cooldown after every Threat.

