---
id: R-ui-transitions-tween
type: reference
title: UI transitions with TweenService and cancellation
status: reviewed
updated: 2026-11-01
tags: [ui, motion, tween]
source_urls: []
confidence: medium
verification: design_only
client_server: client
code_blocks: 1
related: "R-tween-patterns", "R-reduced-motion-policy", "R-menu-patterns"
---

# UI transitions

Every panel appears, changes and disappears. Doing that consistently is most of "feels finished".

## The pattern

```lua
-- Untested: open/close with a single handle and a guard
local Transitions = {}
local active = {}

local function tweenPanel(panel, toOpen)
    local key = tostring(panel)
    if active[key] then active[key]:Cancel() end
    local goal = toOpen and UDim2.fromScale(0.5, 0.5) or UDim2.fromScale(0.5, 0.56)
    panel.Visible = true
    panel.GroupTransparency = toOpen and 1 or 0     -- CanvasGroup for group fades
    local t = TweenService:Create(panel, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Position = goal, GroupTransparency = toOpen and 0 or 1 })
    active[key] = t
    t:Play()
    t.Completed:Once(function()
        if t.PlaybackState ~= Enum.PlaybackState.Completed then return end   -- cancelled
        if not toOpen then panel.Visible = false end
    end)
end
```

`CanvasGroup` gives you a one-property group fade (`GroupTransparency`), which beats tweening the
transparency of forty children.

## Timing table

| Transition | Duration | Easing |
|---|---|---|
| Button press feedback | 0.08 | Quad Out |
| Hover | 0.12 | Quad Out |
| Panel open | 0.20–0.26 | Back Out (subtle) |
| Panel close | 0.14–0.18 | Quad In |
| Tab switch | 0.15 | Sine InOut |
| Full-screen fade | 0.35 | Quad InOut |

Above 0.3 s a UI stops feeling responsive; below 0.1 s it looks like a pop.

## Rules

- Cancel before starting (two tweens on one property fight).
- Guard `Completed` against cancellation.
- Hide the panel only after the close finishes; otherwise it vanishes instantly and the tween is wasted.
- Reduced motion: duration 0, no overshoot ([[R-reduced-motion-policy]]).

