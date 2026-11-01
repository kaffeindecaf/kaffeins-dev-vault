---
id: G-studio-animation-test
type: guide
title: Manual Studio checklist — animation ownership and rig
status: reviewed
updated: 2026-11-01
tags: [assets, animation, studio, checklist]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 0
related: "G-asset-verification-workflow", "R-animation-loading-and-priorities", "G-studio-audio-test"
---

# Studio: does this animation play?

## Procedure

1. Baseplate, default R15 avatar (check Game Settings → Avatar).
2. A `Script` in `ServerScriptService` that loads and plays the animation on a dummy or the player:

```lua
-- Untested: test harness, do not ship
local Players = game:GetService("Players")
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(char)
        local hum = char:WaitForChild("Humanoid")
        local animator = hum:WaitForChild("Animator")
        local a = Instance.new("Animation")
        a.AnimationId = "rbxassetid://PASTE_ID_HERE"
        local track = animator:LoadAnimation(a)
        print("length", track.Length, "id", a.AnimationId)
        track:Play()
        task.delay(3, function() track:Stop() end)
    end)
end)
```

3. Play, read the Output, watch the avatar.

## What the results mean

| Observation | Meaning |
|---|---|
| `length > 0`, pose changes | accessible and rig-compatible |
| `length == 0` | did not load: access, malformed ID, or wrong asset type |
| `length > 0`, no pose change | wrong rig (R15 clip on R6) or a priority override |
| Plays on the wrong bones | custom rig with different joint names |

## Rig check

`print(hum.RigType)` → `Enum.RigType.R15` or `R6`. Re-test with the other rig if it does not bind.

## Record it

```yaml
studio_status: tested_studio
verification: tested_studio
access_status: shared
access_evidence: "2026-11-01 R15 baseplate, track.Length 1.2, pose visible"
```

Do not claim an animation works because a *different* experience uses it — sharing is per experience.

