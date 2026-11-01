---
id: G-animation-owner-checklist
type: guide
title: Animation does not play — ownership and rig checklist
status: reviewed
updated: 2026-11-01
tags: [animation, assets, diagnosis]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 1
related: "R-animation-loading-and-priorities", "B-animation-owner-mismatch", "R-player-character-humanoid-animator"
---

# Animation does not play

1. **ID type** — an `Animation` ID, not a model ID.
2. **Rig** — R15 clip on an R15 rig (`Humanoid.RigType`).
3. **Bone names** — a custom rig with renamed joints binds nothing.
4. **Ownership** — shared with *this* experience? Load it in a same-owner place and check `track.Length`.
5. **Length** — `0` after `Loaded` means it never loaded.
6. **Priority** — a higher-priority track (or stock `Animate`) overriding it.
7. **Weight** — tracks blending to zero.
8. **Right animator** — player and NPC each have their own.

## The one decisive print

```lua
local anim = Instance.new("Animation")
anim.AnimationId = "rbxassetid://0000000000"
local track = humanoid:WaitForChild("Animator"):LoadAnimation(anim)
print("length", track.Length)     -- 0 = access / rig / malformed ID
track:Play()
```

`track.Length` separates "did not load" from "loaded but invisible".

- Length 0 → ownership or ID.
- Length > 0, no visible change → rig, priority, weight.
- Plays then stops → another track took over.

