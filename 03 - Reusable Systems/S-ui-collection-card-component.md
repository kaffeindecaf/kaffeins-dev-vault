---
id: S-ui-collection-card-component
type: system
title: Collection card for found and undiscovered entries
status: draft
updated: 2026-11-02
tags: [ui, component, collection, inventory, luau]
source_urls: []
confidence: medium
verification: design_only
client_server: client
roblox_services: [TweenService]
code_blocks: 0
related: [ "R-inventory-slots-tooltips", "R-responsive-matrix", "S-ui-progress-bar-component" ]
---

# Collection card for found and undiscovered entries

For a 3D card variant, see [[S-collectible-viewport-preview]].

## Purpose

A repeatable card for a discovery book, index, museum, or collectible catalog. Keep thumbnail, name,
description and found state in a consistent hierarchy with a clear empty/undiscovered treatment.

**Choose this card** when many entries share the same fields and users benefit from scanning a grid. Use a row layout for long descriptions or only a few items. Use explicit category tabs/filters when the collection is too large to scan in one view.

## Data contract

Each record provides a stable id, name, short description, optional image, and a boolean found state. The UI displays a neutral silhouette/placeholder for undiscovered items and a check or “found” label when complete. The server remains the source of truth for discoveries; a client copy is only a rendered view.

## Suggested hierarchy

```text
Frame (card template)
├── UICorner + UIStroke
├── ImageLabel (Thumbnail)
├── TextLabel (NameLabel)
├── TextLabel (DescriptionLabel)
└── ImageLabel + TextLabel (FoundTick and/or found state)
```

Place cards in a `UIGridLayout` inside a `ScrollingFrame`; calculate `CellSize` from available
content width with sensible minimums. Do not use a linear list layout for a collection grid.

## Snippet

See `ui-item-card.luau` in `11 - Templates and Schemas/Luau Snippets/` for a renderer that clones a supplied template, populates named children, and connects an optional `Activated` button. It does not create the surrounding scrolling/grid container.

## Interaction and motion

On hover or focus, use a slight thumbnail emphasis and reveal additional description without moving
the card sideways. Preserve original positions and cancel or reverse active tweens to avoid sticky
states. Tune touch timing and ZIndex in the target interface.

## Review

- [ ] Found and undiscovered states are distinguishable without color alone.
- [ ] Placeholder images reveal no hidden entry content if discovery is meant to be a surprise.
- [ ] Long names and descriptions wrap or truncate with a way to inspect the full text.
- [ ] Layout cell size and count adapt on phone portrait and landscape.
- [ ] Keyboard/gamepad focus moves predictably through the grid.
- [ ] Large collections virtualize or paginate if profiling shows excessive instances.

## Verification

The suggested structure is a reusable design. The renderer is `Untested:` in Studio.
