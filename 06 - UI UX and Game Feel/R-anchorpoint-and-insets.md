---
id: R-anchorpoint-and-insets
type: reference
title: AnchorPoint, constraints and device insets
status: reviewed
updated: 2026-11-01
tags: [ui, responsive, mobile]
source_urls: []
confidence: medium
verification: design_only
client_server: client
code_blocks: 1
related: "R-mobile-safe-areas", "R-responsive-matrix", "R-udim2-scale-vs-offset"
---

# Constraints and insets

Four things shrink the usable screen: the notch/safe area, the top bar, the touch controls, and the
on-screen keyboard. Ignoring them produces UI under the notch and buttons under the thumb.

## ScreenGui properties that matter

| Property | Set | Why |
|---|---|---|
| `IgnoreGuiInset` | `false` (default) | keeps content below Roblox's top bar |
| `ScreenInsets` | `DeviceSafeInsets` | respects notches on modern phones |
| `ResetOnSpawn` | `false` | stops UI rebuild + connection leak per life |
| `DisplayOrder` | explicit per layer | modals above HUD, fades above modals |

## GuiService insets

```lua
-- Untested
local GuiService = game:GetService("GuiService")
local topLeft, bottomRight = GuiService:GetGuiInset()
-- usable area in pixels:
local viewport = workspace.CurrentCamera.ViewportSize
local safe = Vector2.new(viewport.X - topLeft.X - bottomRight.X,
                         viewport.Y - topLeft.Y - bottomRight.Y)
```

Note: `ScreenGui:GetGuiInset()` does not exist on every build; `GuiService:GetGuiInset()` does.

## The 44 px rule

Any tap target is at least **44×44 px** (Apple's guideline, and a good Roblox floor). A 20 px icon in a
44 px frame, with padding, is the pattern.

| Element | Min size |
|---|---|
| Tap button | 44×44 |
| Spacing between tappable things | 8 px |
| Text over a busy background | add a scrim at 60–80% opacity |

## Landscape vs portrait

A phone in portrait has ~55% of the horizontal space. Two options: (a) author a portrait layout, or
(b) lock orientation in game settings and design landscape only. Decide once; a UI that half-adapts is
worse than one that is simply landscape.

See [[R-mobile-safe-areas]] · [[R-responsive-matrix]].

