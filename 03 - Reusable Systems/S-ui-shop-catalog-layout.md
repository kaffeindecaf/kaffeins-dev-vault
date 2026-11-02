---
id: S-ui-shop-catalog-layout
type: system
title: Shop catalog with cost, benefit, and purchase feedback
status: draft
updated: 2026-11-02
tags: [ui, component, shop, catalog, luau]
source_urls: []
confidence: medium
verification: design_only
client_server: both
roblox_services: [TweenService]
code_blocks: 0
related: [ "R-ui-patterns-ui-layout-project", "S-ui-collection-card-component", "R-menu-patterns", "R-controller-focus" ]
---

# Shop catalog with cost, benefit, and purchase feedback

## Purpose

A browseable panel for in-game currency items. The main `StarterGui.KrissyUI.ShopGui` separates the shop header from `ShopList` (a `ScrollingFrame` with `UIListLayout` and `UIPadding`) and the Robux-specific `ShopRobux` list. `ShopItemTemplate` groups thumbnail, name, description, and price with a currency icon. The separate seasonal experiment uses a top bar, scroll list, bottom preview, and coin/gem totals.

**Choose this layout** when the inventory is larger than a few items, the player needs to compare benefits and prices, or items have long descriptions. A small two-choice purchase can be a compact choice dialog instead. Keep real-money choices visually distinct and follow platform purchase flows.

## Layout

```text
ScreenGui
├── Main HUD (shop button and balance)
└── ShopPanel (centered, size/aspect constrained)
    ├── Header (title, optional progress, close button)
    ├── Currency balances (near the catalog, persistent while scrolling if useful)
    ├── ScrollingFrame (in-game items; UIListLayout + UIPadding)
    │   └── ShopItemTemplate (image, name, benefit, cost + currency icon)
    └── Separate optional real-currency/Robux section
```

The source's centered ShopGui is offset-sized around 556×366 px and has an aspect constraint. Treat that as one desktop reference size, not as a phone-ready measurement. Keep close controls reachable, reserve safe inset space, and avoid placing the cost far from its item's action.

## Why this layout helps

Each item puts the decision fields in one card, while the scroll list provides a stable reading path. Separating in-game currency and Robux prevents currency types from blending. A visible balance lets the player understand affordability before tapping. A post-purchase success/error popup gives feedback without making the card itself carry every animation.

## Secure interaction contract

The client renders catalog data and sends a request containing a stable item id. The server validates the id against its own catalog, checks current balance/ownership, applies the change once, and returns the result. The client must never decrement a local balance as proof of success. Use an existing server-side purchase pipeline and rate-limit requests; this UI note does not provide purchase authority.

## Snippet

Use `ui-item-card.luau` in `11 - Templates and Schemas/Luau Snippets/` to populate visual item cards from already validated catalog data. No purchase remote is embedded in the snippet; wire the action to the project's secure purchase contract.

## Review

- [ ] Item name, concrete benefit, cost, currency, and owned/locked state are visible together.
- [ ] Balance remains visible or can be reached without losing the current item's context.
- [ ] Disabled purchase action says why it cannot run (insufficient balance, owned, unavailable).
- [ ] Purchase request uses stable IDs; the server verifies balance and grants once.
- [ ] Robux uses the official purchase flow and is clearly separate from earned currency.
- [ ] Scroll, focus, safe insets, and panel size work on all target devices.
- [ ] Success/error response is clear and does not depend on sound or color.

## Verification

The catalog hierarchy comes from Studio Edit mode. The layout recipe is a generalized pattern; the open place was not run and no purchase was performed.

## Additional example: Grow A Tree

`StarterGui.SeedShop.MainFrame.ScrollingFrame` has a LayoutOrder-sorted UIListLayout, padding and a card Template. Its client clones cards, assigns order, displays stock, and sends a seed key; the source comments that money and stock are server owned and waits for SeedData. Its scroll frame is wider than its parent by property, so check clipping and safe areas rather than copying dimensions. The replicated `UI.ShopTemplate` contains name, bio, stock, preview, Buy, RobuxBuy and Gift controls. Runtime, server purchase validation and product flows were not audited. See [[R-grow-a-tree-pattern-audit]] for evidence and rights limits.
