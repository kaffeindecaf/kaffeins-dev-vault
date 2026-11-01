---
id: R-tween-patterns
type: reference
title: TweenService — patterns, cancellation and cleanup
status: reviewed
updated: 2026-11-01
tags: [tween, ui, juice]
source_urls: [ "https://create.roblox.com/docs/reference/engine/classes/TweenService" ]
confidence: medium
verification: reference_only
related: [ "R-ui-transitions-tween", "R-janitor-cleanup" ]
---

# TweenService

One property goal per `Tween`: a `TweenInfo` and a table of target properties. Anything you can
tween is a number, `UDim2`, `Vector3`, `CFrame`, `Color3` or `bool` — you cannot tween between two
different `TweenInfo`s and expect it to blend.

```lua
-- Untested
local TweenService = game:GetService("TweenService")
local fade = TweenService:Create(panel, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    { BackgroundTransparency = 1 })
fade:Play()
```

## The four rules that stop tween bugs

1. **Keep a handle and cancel it.** Two tweens on the same property fight; the loser is whichever
   started earlier. `if current then current:Cancel() end` before starting the next.
2. **`Completed` fires on cancel too.** Check `tween.PlaybackState == Enum.PlaybackState.Completed`
   before running "it finished" logic (e.g. destroying the panel).
3. **Never tween a property another script also owns.** Camera FOV, `WalkSpeed`, and
   `BlurEffect.Size` are the classic contested ones — assign a single writer per property.
4. **Clean up on death/close.** A tween holding a reference to a destroyed `Instance` errors quietly
   in the output and stops the follow-up logic.

```lua
-- Untested: single-writer tween controller
local Controller = {}
local active = {}

function Controller.to(instance, info, props)
    local key = tostring(instance)
    if active[key] then active[key]:Cancel() end
    local t = TweenService:Create(instance, info, props)
    active[key] = t
    t:Play()
    return t
end
```

## Game-feel numbers that read well

| Effect | Duration | Easing |
|---|---|---|
| UI hover / press | 0.08–0.15 s | Quad Out |
| Panel open | 0.18–0.28 s | Back Out (small overshoot) |
| Modal close | 0.12–0.18 s | Quad In |
| Camera shake decay | 0.2–0.4 s | Sine Out |
| FOV punch on sprint | 0.25–0.4 s | Sine Out |

## Accessibility

Anything that moves, flashes or shakes needs an off switch and a reduced-motion path
([[R-reduced-motion-policy]]). A tween is the easy case: set the duration to 0.

See [[R-ui-transitions-tween]] for cancellable UI sequences and [[R-runservice-update-loops]] for
per-frame effects that a tween cannot express.
