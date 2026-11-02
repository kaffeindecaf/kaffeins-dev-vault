---
id: R-pop-popcorn-pattern-audit
type: reference
title: Pop Popcorn — static pattern audit
status: draft
updated: 2026-11-02
tags: [roblox, ui, production, farming, audit]
source_urls: []
confidence: medium
verification: design_only
related: [ "S-bounded-production-pipeline", "S-plot-resource-deposit", "S-receipt-fulfillment-contract", "S-ui-progress-bar-component" ]
---

# Pop Popcorn — static pattern audit

## Provenance and coverage

Read **Pop Popcorn!**, place ID `106719191869339`, in Studio Edit mode on 2026-11-02. The place was not changed or played. Surveyed service-level children in Workspace, StarterGui, StarterPlayer, ReplicatedStorage, ServerScriptService, ServerStorage, ReplicatedFirst, StarterPack, Lighting, SoundService, Teams, TextChatService and MaterialService. Targeted reads covered harvest, plot deposit, production, UI stats, purchases, data and monetization; other scripts and descendant models remain incompletely explored. Runtime behavior, game balance, performance, accessibility and asset rights were not verified.

## Observed patterns and reusable choices

| Need | Evidence in the place | Reusable interpretation |
|---|---|---|
| Gather without exceeding capacity | `ServerScriptService.PopcornGame.HarvestService:125–155` checks model parent, living character, equipped tool attribute, distance (20 studs), per-player cooldown (0.28 s), harvested flag and remaining backpack room; it then clamps gain and sends animation feedback. Touch and remote both call the same server handler. | Centralize server validation for multiple inputs; these checks are observations, not proof against every exploit. See [[S-plot-resource-deposit]]. |
| Deposit at a personal plot | `Workspace.Map.Plots.Plot1.DepositBox`; `PlotService:91–132` creates a prompt with E/ButtonX, 0.2 s hold and 12-stud activation range, checks owner, and transfers only available hopper room. | Communicate empty/full/partial transfer in text; a direct interaction can be preferable to a menu for a single action. Revalidate distance, ownership and availability server-side. |
| Understand backpressure | `ProductionService:376–413` runs one batch loop, checks table capacity before consuming `BatchKernels`, sets MachineBusy, animates machine and conveyor, and places output. `:144–178` assigns the first free numbered slot and lays it out in a grid. | A visible input → processing → bounded output pipeline makes the next constraint legible. Separate authoritative inventory transitions from cosmetic motion and define interrupted-job recovery. See [[S-bounded-production-pipeline]]. |
| See the loop at a glance | `StarterGui.MainHUD.HUD` has CoinsCard, LeftStats (KernelBag and PopcornStorage), MachineStatus, Notifications, TopTeleport and UtilityShopButton. `HUDController:170–194` binds coin/kernel/ready attributes to text and progress fills. | Pair count with bar, label the constrained resource and show why progress stops. Use [[S-ui-progress-bar-component]]; test narrow screens, focus and reduced motion. |
| Select upgrades | `MainHUD.ModalLayer` has Dismiss, ShopMenu, UpgradesMenu and RobuxShopMenu. `PurchaseService:23–94` validates item key, prerequisite, balance and template presence and applies capacity/tool changes on the server. | Cost, benefit and prerequisite belong together; the inspected code alone does not prove durable, concurrent-safe purchases. See [[S-ui-shop-catalog-layout]]. |
| Organize plot assets | `Workspace.Map.Plots` contains five Models; Plot1 has `DepositBox`, `PopCornMachine`, `Conveyer`, `MakePopCorn`, `TablePopCornSell`, `WalkPath` markers and `Spawn`. `ReplicatedStorage.Assets` separates tools, backpacks, sounds, animations and finished products. | Stable named anchors can decouple animation and placement from decorative geometry. Test missing anchors and pivot conventions; use [[S-plot-resource-deposit]]. |

## Assets observed

`ReplicatedStorage.Assets.Anims.ScissorsSwing.AnimationId` = `rbxassetid://98138927538658`; `FarmToolSwing` = `rbxassetid://114566600390989`. `Assets.Sounds.MachineRumble.SoundId` = `rbxassetid://100428402717954`, `CornCut` = `rbxassetid://9118830451`, `PopcornReady` = `rbxassetid://9114058992`. `StarterGui.MainHUD.HUD.CoinsCard.Main.Texture.Image` = `rbxassetid://75030163971865`; the same texture appears in several HUD cards. Identifiers are source observations only; creator, ownership, access and reuse permission are unknown. Models were not exported.

## Persistence and receipt review

`MonetizationService:47–56` routes configured products to `DataService.GrantDeveloperProduct` and defers unknown product, absent player or failed grant. `DataService:136–171` attempts to add coins and record PurchaseId together through UpdateAsync, but keeps only 50 IDs. `DataService:200–214` saves an independently collected snapshot through UpdateAsync without merging the latest record; receipt grant and ordinary save are not shown sharing the `saving` lock. A stale save or concurrent session may overwrite a receipt or balance; trimming permits older retried receipts to fall outside the deduplication window. This is a static risk, not a demonstrated incident. **Receipt verdict: REVIEW** pending concurrency and failure-path verification; do not copy this persistence implementation as a complete fulfillment guarantee. See [[S-receipt-fulfillment-contract]].

The processing loop consumes kernels before several yielding presentation steps and does not visibly check the result of `placeFinishedPopcorn`; interruption or a changed output capacity can lose a batch. Plot reset on release clears stored kernels and production state; whether that is intended persistence policy needs review. These are design and failure questions, not verified runtime bugs.

Test pointer, keyboard, touch and gamepad, localization, safe insets, notification readability, reduced motion, animation and audio options, interrupted production, full output, simultaneous harvest, plot ownership and save failures in a separate safe place. Profile many crops, sound emitters and effects before making performance claims.
