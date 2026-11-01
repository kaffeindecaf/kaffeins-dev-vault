---
id: R-udim2-scale-vs-offset
type: reference
title: UDim2 Scale vs Offset and responsive anchors
status: reviewed
updated: 2026-11-01
tags: [ui, responsive, layout]
source_urls: []
confidence: medium
verification: design_only
client_server: client
code_blocks: 1
related: "G-ui-buttons-drift", "G-ui-unintended-widening", "R-responsive-matrix"
---

# Scale vs Offset

`UDim2` is `(X.Scale, X.Offset, Y.Scale, Y.Offset)`. Scale is a fraction of the **parent's** size; offset
is a raw pixel count. Almost every responsive bug is a misuse of that pair.

## The rules

| Goal | Use | Why |
|---|---|---|
| Panel fills 80% of the screen | `UDim2.fromScale(0.8, 0.8)` | follows the screen |
| Panel has a fixed comfortable width (a button) | offset, e.g. 220×56 | touch target must not shrink |
| Text that should scale | `UITextSizeConstraint` + scale-based parent | keeps proportions |
| Margin of 24 px | offset 24 | consistent physical gap |

**Never** mix a scale size with an offset position that assumes a particular resolution. That is the
"everything is fine on my monitor" bug.

## AnchorPoint

`AnchorPoint` decides which point of the frame sits at `Position`. `(0,0)` = top-left, `(0.5,0.5)` = centre,
`(1,1)` = bottom-right.

```lua
-- Untested: a centred modal that stays centred at any aspect
modal.AnchorPoint = Vector2.new(0.5, 0.5)
modal.Position = UDim2.fromScale(0.5, 0.5)
modal.Size = UDim2.fromScale(0.6, 0.5)
modal.SizeConstraint = Enum.SizeConstraint.RelativeYY   -- keeps the modal's aspect stable
```

`RelativeYY` is the single most useful constraint for panels: it sizes relative to the **smaller** axis, so
a wide monitor does not stretch a panel into a thin strip.

## UIScale

```lua
-- Untested: keep a 1280x720 authored layout at physical size on any DPI
local scale = math.min(viewport.X / 1280, viewport.Y / 720)
uiScale.Scale = math.clamp(scale, 0.75, 1.5)
```

Clamp it. Unclamped `UIScale` makes text absurdly large on 4K and unreadable on a small phone in
portrait.

## Diagnostic question

"Does this layout survive 4:3, 16:9, 21:9, and phone portrait?" If you cannot answer from the numbers
alone, the layout is not responsive yet. See [[R-responsive-matrix]] and
[[G-ui-buttons-drift]].

