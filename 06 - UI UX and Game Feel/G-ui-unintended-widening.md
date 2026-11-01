---
id: G-ui-unintended-widening
type: guide
title: Troubleshooting: UI stretches or widens unexpectedly
status: reviewed
updated: 2026-11-01
tags: [ui, troubleshooting, layout]
source_urls: []
confidence: medium
verification: design_only
client_server: client
code_blocks: 1
related: "G-ui-buttons-drift", "R-udim2-scale-vs-offset", "R-text-scaling-overflow"
---

# UI widens / stretches unexpectedly

## Symptom

A panel that is 400 px wide in Studio becomes 900 px on a wide monitor; text stretches sideways; an icon
becomes an ellipse.

## Causes

| Cause | Signature | Fix |
|---|---|---|
| `Size` uses Scale on X only | width tracks the screen, height fixed | use `UIAspectRatioConstraint` or `RelativeYY` |
| `UITextLabel.TextScaled = true` with a wide parent | font grows to fill the width | add `UITextSizeConstraint` with a `MaxTextSize` |
| Missing `UIAspectRatioConstraint` on an image | image stretches | constraint with `AspectRatio = w/h` |
| `AutomaticSize` on both axes | layout feedback loop | constrain one axis |
| `UIListLayout` with `FillDirection = Horizontal` and `HorizontalAlignment = Center` | children push the content box wider | set `AutomaticSize = Y` only |
| `UIScale` inside a scaled parent | double scaling | one scale per branch |

## The aspect-lock recipe

```lua
-- Untested: a card that keeps 16:9 at any size
local c = Instance.new("UIAspectRatioConstraint")
c.AspectRatio = 16 / 9
c.AspectType = Enum.AspectType.FitWithinMaxSize
c.DominantAxis = Enum.DominantAxis.Width
c.Parent = card
```

`DominantAxis` decides which dimension wins. Wrong dominant axis = the card fits the wrong dimension and
overflows.

## Text specifically

```lua
-- Untested
label.TextScaled = true
local c = Instance.new("UITextSizeConstraint")
c.MaxTextSize = 28
c.MinTextSize = 14
c.Parent = label
```

Without `MinTextSize`, long strings become unreadably small instead of wrapping. Prefer `TextWrapped = true`
plus a size ceiling over pure `TextScaled`.

## Verify

Take a screenshot at 4:3, 16:9 and 21:9 and compare a known element's width in pixels to its height. If
the ratio changed, this is your bug.

