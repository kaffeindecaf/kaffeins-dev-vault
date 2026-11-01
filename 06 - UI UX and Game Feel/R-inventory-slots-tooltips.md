---
id: R-inventory-slots-tooltips
type: reference
title: Inventory slots, tooltips and drag/drop
status: reviewed
updated: 2026-11-01
tags: [ui, inventory, patterns]
source_urls: []
confidence: medium
verification: design_only
client_server: client
code_blocks: 1
related: "S-inventory-data-model", "R-text-scaling-overflow", "R-mobile-safe-areas"
---

# Inventory UI

The grid must be readable at a glance in a dark scene, on a phone, with 6 slots.

## Slot anatomy

| Part | Size | Notes |
|---|---|---|
| Frame | 72×72 (offset) or a `UIListLayout` cell | 44 px touch floor; 72 is comfortable |
| Icon | 80% of the frame | never stretch — use a 1:1 `UIAspectRatioConstraint` |
| Count badge | bottom-right, `text-caption` | hidden when 1 |
| Rarity border | 2 px stroke | colour + a corner glyph (never colour alone) |
| Selected state | 2 px accent stroke + slight scale (1.02) | |

## Tooltip

Show on hover (desktop) and on **tap-and-hold** (touch) — not on tap, which would fight selection.

```lua
-- Untested: tooltip positioned inside the viewport
local function place(tooltip, anchorObject)
    local abs, size = anchorObject.AbsolutePosition, anchorObject.AbsoluteSize
    local vp = workspace.CurrentCamera.ViewportSize
    local x = math.clamp(abs.X, 8, vp.X - tooltip.AbsoluteSize.X - 8)
    local y = abs.Y + size.Y + 8
    if y + tooltip.AbsoluteSize.Y > vp.Y - 8 then
        y = abs.Y - tooltip.AbsoluteSize.Y - 8        -- flip above
    end
    tooltip.Position = UDim2.fromOffset(x, y)
end
```

Clamping the tooltip inside the viewport is the difference between "polished" and "broken at the screen
edge".

## Drag/drop (desktop only)

Drag/drop is a desktop affordance. On touch, use tap-to-select then tap-to-place. Implementing only drag
means the majority of your players cannot reorder anything.

## Rules

- The client never mutates the inventory; it sends an intent and renders the server's snapshot
  ([[S-inventory-data-model]]).
- Empty slots are visible (a subtle frame), not gaps — gaps read as a bug.
- Capacity should be obvious ("4/6") without opening a second panel.

