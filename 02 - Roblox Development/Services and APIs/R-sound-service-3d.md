---
id: R-sound-service-3d
type: reference
title: SoundService, Sound and 3D audio placement
status: reviewed
updated: 2026-11-01
tags: [audio, sound, 3d]
source_urls: [ "https://create.roblox.com/docs/reference/engine/classes/Sound", "https://create.roblox.com/docs/audio/assets" ]
confidence: medium
verification: reference_only
related: [ "H-ambience-layering", "G-asset-verification-workflow" ]
---

# Sound and where to put it

| Parent | Behaviour | Use for |
|---|---|---|
| `SoundService` | 2D, no attenuation | UI, music beds, narration |
| a `BasePart` | 3D from that part's position | world sources: doors, footsteps, ambience emitters |
| an `Attachment` | 3D from the attachment's world position | sounds that must follow a moving rig |
| `PlayerGui` / a `ScreenGui` | 2D for that player | per-player UI feedback |

A sound's audibility falls off by `RollOffMinDistance`/`RollOffMaxDistance` with
`RollOffMode = Inverse` (default), `Linear` or `LinearSquare`. `Volume` is 0–10 but anything over ~1
clips when several sources stack.

## Play a sound correctly

```lua
-- Untested
local function playAt(pos: Vector3, soundId: string, volume: number)
    local part = Instance.new("Part")
    part.Anchored, part.CanCollide, part.CanQuery, part.CanTouch = true, false, false, false
    part.Transparency = 1
    part.Size = Vector3.new(0.2, 0.2, 0.2)
    part.CFrame = CFrame.new(pos)
    part.Parent = workspace

    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://" .. soundId
    s.Volume = volume
    s.RollOffMaxDistance = 60
    s.Parent = part
    s:Play()
    s.Ended:Once(function() part:Destroy() end)
    task.delay(10, function() if part.Parent then part:Destroy() end end)  -- safety net
end
```

## Rules

1. **Preload before the scare.** `ContentProvider:PreloadAsync({sound})` during a loading screen;
   a first-play hitch at the wrong moment kills tension.
2. **Do not `:Play()` a looping sound every frame.** Set `Looped = true` and let it run; toggle
   `Volume` or `Playing` instead.
3. **`Sound.SoundId` must be `rbxassetid://<digits>`** — a bare number is silently ignored, which is
   indistinguishable from a permission failure in the Output window.
4. **Audio privacy:** an ID existing does not mean it plays. Check the Output panel for
   `Failed to load sound` and asset-permission errors. See [[G-asset-verification-workflow]].
5. **`SoundGroup` is your mixer.** One group per category (Ambience / SFX / UI / Music), then you can
   duck the whole category (`SoundGroup.Volume`) instead of 20 sounds.

## Ducking example

```lua
-- Untested: lower ambience while a stinger plays
local ambience = SoundService:FindFirstChild("AmbienceGroup")
local original = ambience.Volume
ambience.Volume = original * 0.35
task.delay(3, function() ambience.Volume = original end)
```

See [[H-ambience-layering]] for how the layers should relate, [[H-sound-occlusion-notes]] for what
Roblox cannot do (real occlusion).
