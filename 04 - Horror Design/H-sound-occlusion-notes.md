---
id: H-sound-occlusion-notes
type: reference
title: Sound occlusion and indoor/outdoor transitions in Roblox
status: reviewed
updated: 2026-11-01
tags: [audio, mixing, feasibility]
source_urls: []
confidence: medium
verification: design_only
client_server: both
roblox_services: []
code_blocks: 1
related: "H-ambience-layering", "R-sound-service-3d", "H-room-tone-palettes"
---

# Occlusion (and what Roblox cannot do)

Real engines low-pass a sound when a wall is between you and it. Roblox does not do this automatically
for `Sound` instances: there is no built-in occlusion, no geometry-aware reverb, no room acoustics.

## What you get for free

- **Distance attenuation** (`RollOffMinDistance`, `RollOffMaxDistance`, `RollOffMode`).
- **Doppler** on moving sources (`Sound.PlaybackSpeed` can fake it).
- **`SoundGroup` volume + effects**: `EqualizerSoundEffect` (low-pass), `DistortionSoundEffect`,
  `ReverbSoundEffect` (a fixed algorithm), `PitchShiftSoundEffect`.
- **`SoundService.AmbientReverb`** — a global room type (`Cave`, `Hallway`, `Room`…). Global, not
  per-room.

## Faking occlusion (the cheap version)

```lua
-- Untested: low-pass a source when a wall is between it and the listener.
local function occlude(sound, listenerPos, sourcePos)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = { listener.Character, sound.Parent }
    local blocked = workspace:Raycast(listenerPos, sourcePos - listenerPos, params)
    local eq = sound:FindFirstChildOfClass("EqualizerSoundEffect")
    if eq then
        eq.HighGain = blocked and -18 or 0
        eq.MidGain = blocked and -6 or 0
    end
end
```

Do this at 4–8 Hz per important source, never per frame per source.

## Indoor/outdoor transitions

- Swap the ambience bed at a doorway ([[H-ambience-layering]]).
- Change `SoundService.AmbientReverb` on zone entry — it is global, so it affects every sound; that is
  acceptable for a small house and wrong for a large map.
- Duck the exterior layer by 20–40% inside; the *absence* of wind is a strong "I am inside" cue.

## What to tell your sound designer

"Roblox has no occlusion; keep the near/far contrast in the asset itself (close = dry and detailed,
far = muffled and washy)." That single instruction prevents most of the "why does it sound flat"
complaints.

