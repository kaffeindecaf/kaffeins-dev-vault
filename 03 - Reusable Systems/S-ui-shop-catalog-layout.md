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
related: [ "S-ui-collection-card-component", "R-menu-patterns", "R-controller-focus" ]
---

# Shop catalog with cost, benefit, and purchase feedback

## Purpose

A browseable panel for in-game currency items. Separate the shop header, item list and any optional
real-money section. Each item card can group thumbnail, name, description, price and currency icon.

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

Use scale-aware sizing, safe insets and reachable close controls. Do not assume a desktop layout
will fit a phone without responsive checks.

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

This is a reusable layout design, not a verified interface. Test the target project's viewport,
focus, purchase integration and server-side ownership rules before use.
