---
id: R-ui-style-guide-tokens
type: reference
title: UI style guide: spacing, type scale, colour tokens
status: reviewed
updated: 2026-11-01
tags: [ui, design, tokens]
source_urls: []
confidence: medium
verification: design_only
client_server: client
code_blocks: 1
related: "R-horror-hud", "R-udim2-scale-vs-offset", "R-responsive-matrix"
---

# UI tokens

Hardcoded colours and pixel sizes are how a HUD ends up with five different greens. Define tokens once,
reference them everywhere.

## Spacing scale (4 px base)

| Token | Value | Use |
|---|---|---|
| `space-1` | 4 | icon ↔ label |
| `space-2` | 8 | inside a button |
| `space-3` | 12 | list item padding |
| `space-4` | 16 | panel padding |
| `space-6` | 24 | section gap |
| `space-8` | 32 | screen margin |

## Type scale (relative to a 1080p reference)

| Token | Size | Weight | Use |
|---|---|---|---|
| `text-caption` | 14 | Regular | hints, counts |
| `text-body` | 18 | Regular | descriptions |
| `text-label` | 20 | Medium | buttons, tabs |
| `text-title` | 28 | Bold | panel titles |
| `text-display` | 44 | Bold | round result, timer |

Sizes are **offset at 1080p** and scaled with a `UIScale` or a `UISizeConstraint` — never raw offsets on
a ScreenGui that must work on a phone ([[R-udim2-scale-vs-offset]]).

## Colour tokens

| Token | Role | Note |
|---|---|---|
| `bg-base` | panel background | near-black, not pure black (pure black hides edge detail) |
| `bg-raised` | cards, modals | +6% lightness |
| `text-primary` | main text | ≥ 4.5:1 contrast on `bg-base` |
| `text-muted` | secondary | ≥ 3:1 |
| `accent` | interactive | one accent colour only |
| `warn` | error / locked | never the same hue as `accent` |
| `success` | confirmations | used sparingly in horror |

**Contrast is a hard requirement**, not a preference: 4.5:1 for body text, 3:1 for large text and UI
borders. A dark horror palette fails this routinely — check it.

## Implementation

```lua
-- Untested: one module, frozen.
local Tokens = {
    space = { s1 = 4, s2 = 8, s3 = 12, s4 = 16, s6 = 24, s8 = 32 },
    text  = { caption = 14, body = 18, label = 20, title = 28, display = 44 },
    color = {
        bgBase    = Color3.fromRGB(16, 17, 18),
        bgRaised  = Color3.fromRGB(26, 28, 29),
        textPrimary = Color3.fromRGB(232, 234, 236),
        textMuted = Color3.fromRGB(150, 156, 160),
        accent    = Color3.fromRGB(96, 200, 140),
        warn      = Color3.fromRGB(224, 92, 84),
    },
}
return table.freeze(Tokens)
```

A designer should be able to answer "what colour is a warning" from this file in one look.

