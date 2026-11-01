---
id: G-ui-buttons-drift
type: guide
title: Troubleshooting: buttons move when the window resizes
status: reviewed
updated: 2026-11-01
tags: [ui, troubleshooting, layout]
source_urls: []
confidence: medium
verification: design_only
client_server: client
code_blocks: 1
related: "R-udim2-scale-vs-offset", "G-ui-unintended-widening", "R-responsive-matrix"
---

# Buttons drift when resizing

## Symptom

Everything looks right in Studio's 1920×1080 test, then on a phone (or after resizing the device emulator)
a button is off-centre, half off-screen, or overlaps its neighbour.

## Causes, most common first

| # | Cause | Test |
|---|---|---|
| 1 | `Size` in Scale, `Position`/`AnchorPoint` in Offset | resize the emulator slowly — the drift is proportional |
| 2 | `AnchorPoint` left at `(0,0)` on a frame positioned at `Scale 0.5` | the frame's top-left sits at the centre, so it looks 50% shifted |
| 3 | Parent `UIAspectRatioConstraint` with `DominantAxis` unset | children scale on one axis only |
| 4 | `UIScale` on a parent and offset sizes on children | children scale by the *parent's* transform, positions do not |
| 5 | Sibling `UIListLayout` + manual `Position` | the layout owns positions; manual ones are overwritten |
| 6 | `UIPadding` applied twice (parent and child) | gaps grow at scale |

## The fix pattern

```lua
-- Untested: a button that keeps its size and stays in the corner at any resolution
button.AnchorPoint = Vector2.new(1, 1)          -- anchor to its own bottom-right
button.Position = UDim2.new(1, -16, 1, -16)     -- 16 px from the screen's bottom-right
button.Size = UDim2.fromOffset(160, 44)         -- fixed touch target
-- no Scale in Position offsets beyond the 1,1 anchor
```

Rule of thumb: **one axis system per element.** If the element's size is offset, its position should be
offset from an anchored corner. If its size is scale, its position should be scale.

## Diagnose in one pass

1. Set the emulator to 1280×720, screenshot.
2. Set to 2560×1440, screenshot.
3. Overlay: anything whose *distance from a corner* changed is offset+scale mixed. Anything whose *size*
   changed proportionally is scale-based.

## Checklist before shipping

- [ ] 16:9 desktop 1920×1080
- [ ] phone landscape (e.g. 667×375)
- [ ] phone portrait, if supported
- [ ] ultrawide 21:9
- [ ] with the notch inset active

