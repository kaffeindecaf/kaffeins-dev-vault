---
id: R-text-scaling-overflow
type: reference
title: Text scaling, long strings and overflow
status: reviewed
updated: 2026-11-01
tags: [ui, text, accessibility]
source_urls: []
confidence: medium
verification: design_only
client_server: client
code_blocks: 1
related: "G-ui-unintended-widening", "R-ui-style-guide-tokens", "R-responsive-matrix"
---

# Text

Text is the cheapest thing to get wrong and the most annoying to fix late.

## The three properties that matter

| Property | Effect |
|---|---|
| `TextScaled` | font grows to fill the frame (needs a ceiling) |
| `TextWrapped` | wraps instead of clipping |
| `TextTruncate` | cuts with `...` (or `AtEnd`/`AtWord`) |

Recommended default: `TextWrapped = true`, `TextScaled = false`, a fixed size from the type scale, plus
`UITextSizeConstraint` when the line must shrink to fit.

## The overflow cases

| Case | Handling |
|---|---|
| Player name 20 chars into a 120 px label | `TextTruncate = AtEnd` |
| Locale expansion (+30% for German) | design for 1.3× the English string |
| Currency 1,234,567 | format with separators; reserve width for 8 digits |
| Long item description in a tooltip | wrap + cap at 3 lines + "…" |
| Dynamic count badge | `AutomaticSize` on X with a max width |

```lua
-- Untested: compact number formatting
local function fmt(n)
    if n >= 1e9 then return string.format("%.1fB", n / 1e9) end
    if n >= 1e6 then return string.format("%.1fM", n / 1e6) end
    if n >= 1e4 then return string.format("%.1fK", n / 1e3) end
    return tostring(math.floor(n))
end
```

Make the formatter live in one module — three implementations of "1.2K" is how the HUD shows 1.2K and the
shop shows 1234.

## Accessibility

- Minimum body size 16 px at 1080p; 14 px only for non-critical captions.
- Contrast ≥ 4.5:1 ([[R-ui-style-guide-tokens]]).
- Never convey meaning by colour alone (a red number needs an icon or a sign).
- Line length ≤ ~60 characters for readability.

See [[G-ui-unintended-widening]] for the `TextScaled` failure in detail.

