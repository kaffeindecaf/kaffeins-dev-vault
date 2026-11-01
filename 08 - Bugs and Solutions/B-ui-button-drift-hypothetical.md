---
id: B-ui-button-drift-hypothetical
type: bug
title: Button drifts off-centre when the window resizes
status: reviewed
updated: 2026-11-01
tags: [ui, layout, responsive]
source_urls: []
confidence: medium
verification: design_only
severity: low
hypothetical: true
client_server: both
code_blocks: 1
related: "G-ui-buttons-drift", "R-responsive-matrix", "R-udim2-scale-vs-offset"
---

> ⚠️ **Hypothetical case, not a real incident.** Written from general Roblox behaviour to teach the
> diagnostic path. No log below came from a real session. Do not cite it as evidence.

# Button drifts off-centre on resize

## Observed
A centred "Play" button sits correctly at 1920×1080, appears ~40 px right of centre at 1366×768 and is half
off-screen in phone landscape.

## Reproduction
1. Open the menu at 1920×1080.
2. Switch the device emulator to 667×375.
3. The offset is proportional to viewport width.

## Diagnosis
`Size = UDim2.fromOffset(220, 56)`, `Position = UDim2.fromScale(0.5, 0.5)`, `AnchorPoint = (0,0)`.
`Position` puts the **top-left** corner at the parent's centre, so the button appears shifted right by half
its width. At 1920 the author compensated with `Position.X.Scale ≈ 0.44`, which only matches one resolution.

## Cause
Scale position + offset size + default anchor.

## Fix
```lua
button.AnchorPoint = Vector2.new(0.5, 0.5)
button.Position = UDim2.fromScale(0.5, 0.5)
button.Size = UDim2.fromOffset(220, 56)
```

## Verification
Across the 8 viewports in [[R-responsive-matrix]]: the button centre is within 2 px of the screen centre and
its size never changes.

## Regression prevention
Review rule: "a scale position needs a matching anchor". [[G-ui-buttons-drift]] has the full diagnosis.

