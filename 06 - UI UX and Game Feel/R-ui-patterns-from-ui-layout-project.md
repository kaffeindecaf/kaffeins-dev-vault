---
id: R-ui-patterns-ui-layout-project
type: reference
title: UI patterns extracted from the ui layout project
status: draft
updated: 2026-11-02
tags: [ui, ux, roblox-studio, project-observation, patterns]
source_urls: []
confidence: medium
verification: design_only
client_server: client
code_blocks: 0
related: [ "R-responsive-matrix", "R-ui-style-guide-tokens", "S-ui-button-component", "S-ui-slider-component", "S-ui-progress-bar-component", "S-ui-collection-card-component", "S-ui-shop-catalog-layout", "S-ui-modal-dialog", "H-ui-horror-overlay-composition" ]
---

# UI patterns extracted from the ui layout project

Read-only inspection of Roblox Studio place **ui layout** (place ID `138561306478412`) in Edit mode on 2026-11-02. The observations below are from the Explorer hierarchy, instance properties, and image/sound property values. The place was not played, and these patterns have not been visually checked at runtime or across devices. This is a project reference, not a claim that each prototype is finished or production-ready.

## Explorer map

| Location | Observed contents | Interpretation |
|---|---|---|
| `StarterGui.KrissyUI` | `MainFrame`, `IndexGui`, `ShopGui`, SFX | The main collectible HUD and two modal panels are arranged as one player UI. |
| `StarterGui.KrissyPopups.PopupContainer` | title, description, rarity labels | A separate notification surface, populated by `KrissyPopupClient`. |
| `StarterPlayer.StarterPlayerScripts` | `UIController`, `IndexController`, `ShopClient`, `KrissyPopupClient`, `KrissyClient`, `EventEffects` | Client-side UI and presentation scripts. |
| `ReplicatedStorage.RemoteEvents` | `UpdateClient`, `RequestPurchase`, `RequestIndexData`, `KrissyFound`, etc. | Client UI communicates through remotes; purchase and progression truth must remain server-owned. |
| `ReplicatedStorage.UIAssets.RarityGradients` | rarity keyed `UIGradient` objects | Reusable presentation assets can be stored separately from the widgets that use them. |
| `Workspace.meatyhorrorUIbackground` | GUI-like hierarchy with a textured horror panel and image buttons | A design experiment is stored under Workspace, not a live `StarterGui` screen in this place. |
| `Workspace.christmasUI` | GUI, remotes, scripts, sounds, and item images under folders named after services | A separate seasonal shop prototype/asset bundle; it is grouped in Workspace and should be treated as staged content. |
| `Workspace.UiSparkleEffect` | ScreenGui folder, test frame, sparkle module | A visual effect experiment, not part of the main HUD hierarchy. |

## Main collectible HUD composition

`MainFrame` is transparent, 154×408 px in the inspected properties, positioned with scale near the lower right (`Position` X 0.91, Y 0.80) and anchored at `(0.5, 0.85)`. It contains `IndexButton`, `ShopButton`, and `CoinContainer`, with a `UIAspectRatioConstraint`. The buttons have explicit child labels and icons, rounded corners, strokes, gradients, and their own aspect constraints. The currency count and coin icon form a compact status group.

The index and shop are centered modal panels around 556×365 px. Both have aspect constraints; the index also has a `UISizeConstraint`. The index groups a header and found count, progress bar, collection grid, and close button. The shop groups a header/progress area, a scrolling in-game currency list, a separate Robux list, and a close button. This separation keeps scanning, current progress, and exit affordance in predictable locations.

## Component patterns and why they work

| Pattern | Project evidence | Why it helps | Choose it when |
|---|---|---|---|
| Persistent side HUD actions | `MainFrame` with separate Index, Shop, and currency controls | Frequent destinations stay visible and distinct; icon and text layers give both recognition and naming. | Players repeatedly open collection/shop surfaces while exploring. Keep it smaller or move it for thumb reach on phones. |
| Centered constrained modal | `IndexGui` and `ShopGui`, centered anchor, aspect constraint; index adds size constraint | The focal task is visually separated from the world and its content can be grouped by purpose. | A finite task such as browsing, settings, or collection review needs focus. Test the minimum size and scrolling on narrow screens. |
| Collection grid card | `Grid` contains five `Template` frames; each has thumbnail, name, description, found mark, corner/stroke/gradient | Repeated cards share a visual grammar; a found marker and text can communicate state without relying only on color. | Players compare many collectible or catalog entries. Use a real grid layout and responsive cell sizing in a production rebuild. |
| Shop item row/card | `ShopItemTemplate` has thumbnail, name, description, price and currency icon; `UIListLayout` and `UIPadding` organize the scroll list | Every entry exposes identity, benefit, and cost together, reducing memory and back-and-forth. | There are enough purchasable items to justify browsing. Make unavailable/owned/insufficient-funds states explicit. |
| Progress track plus fill | Index `ProgressBarBackground` + `ProgressFill`; shop header has a similar pair and count labels | A changing visual value is paired with textual progress, which supports quick reading and color-independent meaning. | Completion is a motivating goal and the numerator/total can be shown nearby. |
| Contextual pickup popup | `KrissyPopups` labels and `KrissyPopupClient` payload include name/reward/rarity/already-found state | Feedback arrives near the triggering event without requiring a panel to stay open; a queue avoids overlapping multiple notices. | Short-lived rewards or errors need acknowledgement. Keep the message brief and dismissible/non-blocking. |
| Themed image composition | Horror background experiment layers rust/flesh/vein/gear/drip assets around two image buttons | A small, cohesive set of high-salience textures establishes a strong genre mood. | A horror menu is meant to feel diegetic or tactile. Leave contrast and action targets clear; do not copy the whole screen into a low-contrast HUD. |

Related component recipes: [[S-ui-button-component]], [[S-ui-slider-component]], [[S-ui-progress-bar-component]], [[S-ui-collection-card-component]], [[S-ui-shop-catalog-layout]], and [[S-ui-modal-dialog]]. Horror layering is described in [[H-ui-horror-overlay-composition]]. General constraints and responsive checks remain in [[R-responsive-matrix]], [[R-anchorpoint-and-insets]], and [[R-mobile-safe-areas]].

## Observed project image and sound IDs

These are values read from instances in this place, not verified Creator Store listings, reusable rights grants, or guarantees that the assets load for another experience. Keep their source and permission state project-specific; check each asset in Studio before reuse.

| Explorer use | Asset value |
|---|---|
| Main index button icon | `rbxassetid://133911157456859` |
| Main shop button icon | `rbxassetid://100110850394371` |
| Currency/coin icon (main HUD and shop price) | `rbxassetid://112311213688560` |
| Close icon (index and shop panels) | `rbxassetid://134283334398200` |
| Robux catalog item image | `rbxassetid://113401643966035` |
| Seasonal shop items (three `ImageButton`s) | `rbxassetid://74814833364493` |
| Seasonal shop Santa hat | `rbxassetid://135949971228214` |
| Seasonal full-screen image | `rbxassetid://126279448108035` |
| Horror texture: flesh | `rbxassetid://106007764806678` |
| Horror texture: gear | `rbxassetid://83649906888158` |
| Horror texture: drip | `rbxassetid://5401154786` |
| Horror texture: rust panel | `rbxassetid://130978676698587` |
| Horror texture: vein | `rbxassetid://74696688473613` |
| Horror texture: shape | `rbxassetid://6423018614` |
| Horror image buttons: teeth / heart | `rbxassetid://7712114605` / `rbxassetid://7516199736` |
| Shared pickup / buy sounds | `rbxassetid://139388336352342` / `rbxassetid://1210852193` |
| Seasonal UI click / error / hover / purchase / sparkle | `15675059323`, `4612384231`, `139800881181209`, `10066947742`, `124632947773544` (each observed as a SoundId URI) |

## Limits and design cautions

- The main collection card frames are named `Template1` through `Template5`; no `UIGridLayout` was visible in the inspected grid subtree. A production collection grid should use an explicit layout object or positions derived from data and tested cell sizes, rather than depending on editor placement.
- The main frame and modal sizes are offset-only in the observed properties. Their aspect/size constraints help, but do not prove phone or tablet fit. Follow the vault's screen matrix and check text scaling, safe areas, touch targets, controller navigation, and extreme aspect ratios.
- Several text objects in the project use `TextScaled`; cap scaling with a `UITextSizeConstraint` and verify long/localized strings. Never set text height from one short label alone.
- Client UI may animate and request actions, but it must not decide currency, ownership, purchase success, or saved collection state. Verify remote arguments, rate limits, and balances on the server.
- No image or sound ID above was checked for external access, licensing, moderation, or Studio load status.

## Evidence and follow-up

**Observed:** Explorer paths and readable properties in Studio Edit mode; an in-memory read-only walk listed non-empty `Image`/`Texture` and `SoundId` property values. No place instances or scripts were modified. `KrissyPopupClient` and the main UI controller were read; the adapted code snippets in this vault are separate and have not been run.

**Not done:** no Play/Test session, screenshot capture from a game viewport, device simulator run, interaction test, license check, or contrast audit. These patterns stay `design_only` until manually reviewed; snippets stay `Untested:` until run in a sandbox place.
