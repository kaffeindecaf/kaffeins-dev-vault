---
id: G-studio-audio-test
type: guide
title: Manual Studio checklist — audio playback
status: reviewed
updated: 2026-11-01
tags: [assets, audio, studio, checklist]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 0
related: "G-asset-verification-workflow", "R-sound-service-3d", "H-ambience-layering"
---

# Studio: does this sound play?

A 3-minute procedure, run in a **clean test place** owned by the same account/group as the target experience.

## Procedure

1. New baseplate place, owned by the right account/group.
2. `StarterPlayer/StarterPlayerScripts` → `LocalScript`:

```lua
-- Untested: test harness, do not ship
local SoundService = game:GetService("SoundService")
local s = Instance.new("Sound")
s.SoundId = "rbxassetid://PASTE_ID_HERE"
s.Volume = 0.4
s.Parent = SoundService
s:Play()
print("state", s.IsPlaying, "length", s.TimeLength, "id", s.SoundId)
s.Ended:Once(function() print("ended ok") end)
```

3. Play (F5). Read the Output.

## What the results mean

| Observation | Meaning |
|---|---|
| Audio plays, Output clean | accessible; record `access_status: shared` |
| `TimeLength == 0`, silence | did not load — access, moderation or malformed ID |
| `Failed to load sound`, authorization error | restricted to another experience |
| Plays but wrong content | the ID points at a different asset than the name suggests |
| Plays, cuts off early | the asset itself is short; not a bug |

## Record it

```yaml
studio_status: tested_studio
verification: tested_studio
access_status: shared
access_evidence: "2026-11-01 clean place, id 0000, played 3s, Output clean"
test_evidence: "same"
```

Then, separately, judge quality: length, loopability, loudness relative to the mix
([[H-ambience-layering]]).

## Do not

- Do not test in the game's real place with a live player base.
- Do not conclude "works" from the Output being empty if you were out of earshot — check `IsPlaying` and
  `TimeLength`.

