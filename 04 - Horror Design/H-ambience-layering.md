---
id: H-ambience-layering
type: principle
title: Ambience layering and the volume hierarchy
status: reviewed
updated: 2026-11-01
tags: [horror, audio, mixing]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 1
related: "R-sound-service-3d", "H-room-tone-palettes", "H-door-sound-matrix", "H-tension-hierarchy"
---

# Ambience layering

Four layers, each with a job and a fixed relative loudness. Mixing by ear per sound is how a game ends
up with footsteps louder than the monster.

## Layers

| Layer | Content | Relative level | Loops |
|---|---|---|---|
| 1. Room tone | hum, air, building creak (very quiet) | −22 dB | yes, seamless |
| 2. Weather / exterior | rain, wind, distant traffic | −16 dB | yes |
| 3. Detail | clocks, dripping, electrical buzz, radio static | −12 dB, positional | yes |
| 4. Events | stingers, creaks, footsteps, the threat | −4 dB to 0 dB | no |

The room tone is what makes a *cut to silence* audible — you have to remove something to create
silence.

## Transitions

- Crossfade ambience over 1.5–3 s; anything faster reads as a mistake.
- Change the room tone at a **threshold** (a doorway), not gradually across the whole room, or it
  sounds like a volume automation bug.
- Duck layers 1–3 by 40–60% for the duration of a stinger, then restore over 2 s.

```lua
-- Untested: one mixer, category groups
local function duck(group, factor, seconds)
    local target = group:GetAttribute("BaseVolume") or group.Volume
    group:SetAttribute("BaseVolume", target)
    group.Volume = target * factor
    task.delay(seconds, function() group.Volume = group:GetAttribute("BaseVolume") end)
end
```

## Roblox specifics

- `SoundGroup` per layer, `SoundService` for 2D beds; positional detail needs a `Sound` on a part or
  attachment ([[R-sound-service-3d]]).
- `Sound.PlaybackSpeed` changes pitch *and* loop length; a 0.95 speed loop will drift out of sync with
  a 1.0 one.
- `Sound.Looped = true` with a clip that has a gap at the end produces a rhythmic click — check the
  loop point before using it as a bed.

## The rule that matters

**Silence is a layer.** Author a "nothing" state explicitly (all layers ducked to −40 dB) so you can
cut to it on purpose, and so you notice when a bug leaves the game silent forever.

