---
id: R-grow-a-tree-pattern-audit
type: reference
title: Grow A Tree — read-only pattern audit
status: draft
updated: 2026-11-02
tags: [roblox, ui, progression, audit]
source_urls: []
confidence: medium
verification: design_only
related: [ "S-ui-shop-catalog-layout", "S-session-reward-grid", "S-tree-query-hitbox", "R-inventory-slots-tooltips" ]
---

# Grow A Tree — read-only pattern audit

## Provenance and scope

Studio identified **Grow A Tree! (UPDATE!)**, place ID `119069675973471`; inspected 2026-11-02 in Edit mode through the Studio bridge. This is a static snapshot, not a playtest or a claim about published behavior. No place edits were made. Names and properties below are observations; design rationales and recommendations are inferences. Asset IDs in the place do not establish ownership, reuse rights, accessibility, or availability.

## Inventory of inspection

Service-level children were surveyed in Workspace, StarterGui, StarterPlayer, ReplicatedStorage, ServerScriptService, ServerStorage, ReplicatedFirst, StarterPack, Lighting and SoundService. Targeted descendants and scripts were read for seed shop, rewards, inventory, notifications, tree assets and hitboxes. Workspace includes many repeated loose props, NPCs, shops, `Seeds`, `Charms`, `World`, `NewMap`, `MainTree`, and `Trees`; identical sibling names make some paths ambiguous. StarterGui contains 33 named ScreenGuis spanning shops, inventory, trading, rewards, settings, tutorial and HUD. StarterPlayerScripts groups Core, Planting, Feedback, Tools, Economy, Shops and World alongside controllers. ReplicatedStorage holds Shared remotes, UI templates, preview models, particles, audio and animations. ServerScriptService holds individual services and Modules; ServerStorage holds seeds, axes, tree templates, growth variants and archived content. ReplicatedFirst has `GrowLoadingScreenController`; StarterPack has no immediate children. Lighting has atmosphere, bloom, color correction and other effects; SoundService has Hover, Click and GlassRunning sounds.

The full descendants, every authored service, all scripts, assets, input handlers, trade, monetization, data persistence, settings and live behavior were **not** exhaustively reviewed. In particular, no device simulator, visual playthrough, security audit, profiling, licensing or purchase test was performed. More coverage is needed before treating this as a complete project audit.

## Patterns observed

| Need | Source and observation | Reusable interpretation and limit |
|---|---|---|
| Browse items and stock | `StarterGui.SeedShop.MainFrame` has TopBar, ScrollingFrame and Close; list has UIListLayout sorted by LayoutOrder with 10-pixel padding, UIPadding and Template. `SeedShopClient` clones and orders cards, sends seed key, then waits for SeedData. | Keep identity, price and stock together; server validates purchases. The scroll frame width is about 1.249 of its parent, so clipping and narrow screens require checking. See [[S-ui-shop-catalog-layout]]. |
| Session goals | `StarterGui.PlaytimeRewards.MainFrame.RewardGrid` has six ordered buttons and UIGridLayout, cell scale 0.31 × 0.47, padding 0.035 × 0.06. Controller supplies countdown, READY and CLAIMED text and the server checks eligibility. | Text plus color communicates state; use a compact grid for a short fixed sequence, a list for long or localized labels. See [[S-session-reward-grid]]. |
| Find owned items | `StarterGui.Custom Inventory.Inventory` contains a scrolling Frame, SearchBox, CategorySidebar and initially hidden CharmPanel; hotBar uses UIGridLayout. | Search and categories support large collections; test empty results, focus, keyboard/gamepad and sidebar fit. No search implementation or authority was verified. See [[R-inventory-slots-tooltips]]. |
| Transient feedback | `StarterGui.HUD.Notifications` has UIListLayout sorted by LayoutOrder and an initially hidden Template. | A managed stack can keep feedback separate from the persistent HUD; actual lifetime and deduplication were not traced. See [[S-notification-system]]. |
| Stage and preview assets | `ServerStorage.New Growth Trees.AppleTree` contains Variation1–3. `ReplicatedStorage.SeedShopPreviewModels` and `TreeIndexModels` hold model collections; `ServerStorage` also has TreeFinals and TreeModels. | Separate server-held gameplay templates from client-visible previews when appropriate; the actual selection and replication paths remain unverified. Duplicate naming and archived variants demand explicit catalog keys. |
| Reliable tree targeting | `ServerScriptService.TreeHitboxService` builds a transparent queryable non-colliding box for fully grown planted trees using config and attributes. | Decouple interaction bounds from ornate geometry; see [[S-tree-query-hitbox]]. This alone does not establish secure hit validation. |

## Asset observations

`StarterGui.SeedShop.MainFrame.ScrollingFrame.Template.Image` is `rbxassetid://8012052454`; `ReplicatedStorage.UI.ShopTemplate.ImageFrame.Image` is `rbxassetid://104142069451642`; `StarterGui.Custom Inventory.Inventory.StudTexture.Image` is `rbxassetid://6927295847`. `StarterGui.PlaytimeRewards.Controller` creates a sound with `rbxassetid://80854650043151`. These are identifiers observed in properties/source, not reusable-license claims; check access, creator, rights, moderation and playback before use. The shop client also uses a viewport preview camera framed from model bounds; loading and performance were not measured.

## Cross-cutting review

Use descriptive text in addition to color, reachable close controls, safe insets, responsive constraints and focus restoration. Check touch targets, mouse, keyboard, gamepad, long translations, screen reader support where available, reduced motion and sensory settings. The place's support for these was not established. Avoid rebuilding cards or previews unnecessarily; measure instance count, image/model memory and render cost on representative devices before claiming any performance benefit. See [[R-responsive-matrix]], [[R-controller-focus]] and [[R-reduced-motion-policy]].
