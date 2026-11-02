---
id: R-drive-catch-pattern-audit
type: reference
title: Drive and Catch brainrots — static pattern audit
status: draft
updated: 2026-11-02
tags: [roblox, ui, vehicles, collectibles, audit]
source_urls: []
confidence: medium
verification: design_only
related: [ "S-collectible-viewport-preview", "S-zone-timer-contract", "S-sequential-area-gates", "S-receipt-fulfillment-contract" ]
---

# Drive and Catch brainrots — static pattern audit

## Provenance and coverage

Read 2026-11-02 in Studio Edit mode: **Drive and Catch brainrots!**, place ID `85444403695282`. The place was not modified or played. Service-level children were surveyed for Workspace, StarterGui, StarterPlayer, ReplicatedStorage, ServerScriptService, ServerStorage, ReplicatedFirst, StarterPack, Lighting, SoundService, Teams, TextChatService and MaterialService. Follow-up reads covered selected index, preview, car, timer, area, spin, data and monetization scripts. The remaining scripts, model descendants, visual output, all runtime states and other services were not exhaustively inspected.

## Observed architecture and reusable ideas

| Player need | Observed source | Adaptation and limits |
|---|---|---|
| Navigate and compare | `StarterGui.HUD` has Bottom, Left, Right, Top and Values frames. Left contains Index, Rebirth and Shop buttons. `StarterGui.FRAMES` holds separate index, shop, sell, rebirth, time and carry panels. | Persistent destinations and focused panels can reduce navigation effort; check safe areas, touch size, controller focus and close behavior on devices. No runtime layout was checked. |
| Discover collectibles | `StarterGui.FRAMES.IndexFrame.List` is a ScrollingFrame with UIListLayout sorted by LayoutOrder, UIPadding, aspect constraint and hidden Template. `IndexController` sorts by income then name, clones entries, renders rarity, unlock status and a count per mutation. | Use stable IDs and textual found counts; alternatives include a virtualized list or static icon for large catalogs. [[S-collectible-viewport-preview]] records the 3D preview. |
| Drive into a timed area | `Workspace.Code.Zones` groups Spawners, Other and Bases; `VehicleTimeService` treats spawner pads and a region near the next locked gate as safe. It calculates elapsed time server-side and throttles HUD updates; comments describe approximately ten updates per second, not a measurement. | Server owns the clock; client interpolates the display. Choose explicit safe-zone and reset semantics; inspect [[S-zone-timer-contract]]. |
| Progress through a world | `Workspace.Map.Stages` contains folders 1–8 and `Map.Gates` has eight rarity-named models. `AreaService` checks sequential level and cash, saves unlocks and pushes unauthorized players back. | Communicate next destination and eligibility before a gate; use [[S-sequential-area-gates]] for a failure-aware adaptation. Save and spend are not proven atomic. |
| Enter and control a vehicle | `ServerStorage.Assets.Car.Vehicle` includes `DriveSeat`, `Chassis`, four named wheels, four Thrusters, configuration and scripts. `CarService` validates the requesting player's tracked car, character, seat occupant and network readiness before assigning network ownership. | Separate driver controls, camera and HUD (`StableCarController`, `CarCamera`, `CarMobileControls`, `DriveHud`); assignment of network ownership is not a substitute for server validation. Physics, re-entry and devices were not tested. |
| Weighted wheel | `SpinService` chooses from `SpinConfig.Rewards` weights on the server, checks loaded state, cooldown and busy status, saves consumption, then grants and announces. | The client should animate the server result, not choose it. Because the save precedes the grant, interruption or grant failure needs recovery; the fallback itself is not checked for success. Paid random rewards need current policy and odds review. |
| Organize models | `ReplicatedStorage.Items` contains Normal (49 models) and Galaxy, Gold, Lava, Diamond (87 each); `Normal` contains duplicate `Bobrito Bandito` names. `ServerStorage.Assets` separates car, billboard and particles, while backups are in `DevelopmentBackups`. | Prefer stable item/variant IDs and an explicit fallback; duplicate names make name-only lookup ambiguous. Replicated models are client-visible; validate rights and memory before reuse. |

## Observed asset identifiers

`StarterGui.HUD.Left.IndexButton.Icon` = `rbxassetid://117910110173046`; `ShopButton.Icon` = `rbxassetid://102925170008522`; `FRAMES.IndexFrame.List.Template.Studs` = `rbxassetid://85697657610499`. `ReplicatedStorage.Items.Normal.Ballerina Cappuccina.Mesh` has MeshId `rbxassetid://109064107200773`, TextureID `rbxassetid://114029733376487`; its `Anims.Idle` is `rbxassetid://101947446200332`. `ServerStorage.Assets.Car.Vehicle.EngineBlock.Running` references `http://www.roblox.com/asset/?id=391824568`. These values were read from the place, not verified for access, authorship or reuse permission. No asset was exported.

## Reliability and review

`StorageProvider` uses session-only memory in Studio and blocks its live SetAsync after failed load; its production proxy uses SetAsync without a shown session lock. This is a partial observation, not a complete data audit. `AreaService` can deduct cash and mark the area unlocked even when a subsequent save fails. `SpinService` persists consumption before reward delivery. Both warrant failure and reconnect tests and an atomic/idempotent transaction design.

The receipt review found a failure path: `MonetizationService:251–262` returns PurchaseGranted even when the time grant reports failure, and `:239–248` does so for an already-maxed carry limit. Whether compensation is intended is not established. Its `processedTokens` table is in-memory (`:19`, `:213–221`), not durable receipt-ID idempotency. Client prompt-finished handlers inspected only clear or refresh UI; they were not observed granting. See [[S-receipt-fulfillment-contract]]. No purchase was made. The broader receipt flow and game-pass logic need human review.

Accessibility, long text, camera motion, flashing effects, touch, keyboard, gamepad, network behavior, and performance are unverified. Offer reduced motion, clear text as well as color, and meaningful focus order; measure preview and physics costs instead of asserting performance gains.
