---
id: R-curry-delivery-pattern-audit
type: reference
title: Long-distance curry delivery — static pattern audit
status: draft
updated: 2026-11-02
tags: [roblox, ui, delivery, route, audit]
source_urls: []
confidence: medium
verification: design_only
related: [ "S-linear-route-progress", "S-world-space-menu-camera", "S-pickup-server-authoritative", "R-menu-patterns" ]
---

# Long-distance curry delivery — static pattern audit

## Provenance and coverage

Inspected **walk 138,783 studs to deliver curry**, place ID `125663503991057`, in Studio Edit mode on 2026-11-02. The place was not changed or played. Surveyed Workspace, StarterGui, StarterPlayer, ReplicatedStorage, ServerScriptService, ServerStorage, StarterPack, ReplicatedFirst, Lighting, SoundService, Teams, TextChatService and MaterialService. Workspace has 2,125 immediate children, including 1,223 Parts named Part and many repeated tree and vehicle models; `Workspace.PathParts` contains 100 parts. Inspected delivery, progress, countdown, menu and sample tool scripts, a subset of world models and assets. Most of the 285 Workspace script sources, imported vehicle packages, admin loader, path geometry and all runtime states were not exhaustively reviewed.

## Evidence and reusable choices

| Need | Observed source | Reusable interpretation |
|---|---|---|
| Make a long trip legible | `StarterGui.CurryGui.ProgressBar` has Fill, ProgressLabel and ProgressUpdater. The script clamps the character root X coordinate between 0 and 138783, sets fill scale and shows the numerical distance each RenderStepped. | Pair a progress bar with text, but define route start/end, lateral bounds, respawn and server-trusted completion. Raw world X is a projection, not verified distance walked. See [[S-linear-route-progress]]. |
| Focus a main menu | `StarterGui.3D Menu` contains SurfaceGui surfaces for Play, What's New and Options; `Workspace.MenuParts` holds corresponding geometry and camera anchors. `MainScript` moves a Scriptable camera between anchors, hides other ScreenGuis, then restores their previous Enabled values on Play. | A camera tour can orient players in a small number of physical panels. A conventional screen menu is simpler for keyboard, gamepad, screen-reader and reduced-motion access. See [[S-world-space-menu-camera]]. |
| Signal delivery | `Workspace.DeliveryPoint.DeliveryTouchScript` and another under `Workspace.Model.Finish line.DeliveryPoint` each maintain their own local delivered-player table, play a sound, send a message and remove a CurryBowl if present. The former point is at approximately X=90.65; the nested finish point at X=9175.76. | A clear arrival event and notification reward a long trip. The scripts do not require the tool or check route completion before marking delivery, and the tables are per-script and not persisted. Shared authoritative state is needed for meaningful rewards. |
| Surface temporary status | `StarterGui.ScreenGui.TextLabel.LocalScript` displays a ten-second countdown after `StartCountdown`; it disconnects an earlier RenderStepped handler on restart. A sampled `Workspace.SpeedBoostPart.Script` fires the countdown with a two-second touch debounce; it did not change speed in that script. | Prefer a server-supplied expiration time for a gameplay boost, with a client display only. Confirm all other boost scripts before concluding there is no boost. |
| Carry and organize items | `StarterPack.CurryBowl` is a Tool with Handle; `Custom Inventory` has a scrolling inventory, SearchBox, hotBar and InventoryController. | An inventory can make the carried objective explicit; server-owned completion must check the right item and state. Inventory behavior and controller support were not exercised. |

## Asset observations

`StarterGui.3D Menu.MainScript` creates a transition sound `rbxassetid://14006215368`; the `Play.Play.Tween.Sound` uses `rbxassetid://107677435338382`. `StarterGui.3D Menu.MainMenu.Decoration.Image` is `rbxassetid://124374605028451`. `StarterPack.Air Horn.AirHornSound` is `rbxassetid://109527514822793`; its `Cylinder.001.MeshId` is `rbxassetid://82313933055733`. `Workspace.DeliveryPoint.Sound` is `rbxassetid://127399897082021`. These identifiers are observations, not proof of rights, availability or fitness for reuse; no model was exported.

## Findings needing review

- `ServerScriptService.anti theft script:15–30` attempts to kick players based on dark skin-color brightness, a discriminatory restriction. It accesses `Humanoid.SkinColor`; whether that property access succeeds was not tested. Remove the discriminatory behavior in the game after owner review. No game change was made here.
- `ServerScriptService.DeliveryHandler:1` refers to `ReplicatedStorage.RemoteEvents.DeliverCurryEvent`, but the Edit hierarchy has `ReplicatedStorage.DeliverCurryEvent` directly and no `RemoteEvents` child. `DeliveryReset:2` refers to `deliveredPlayers` without defining it in that script; each touch script owns a separate local table. These are static mismatches and need runtime confirmation.
- `ProgressUpdater` retains the initial HumanoidRootPart rather than reconnecting after respawn; the displayed distance may become stale. Its text label is 1416 pixels wide within a 328-pixel bar, so verify clipping and devices rather than copying the geometry.
- The sample Air Horn script calculates distance from the holder's root to their own tool and sets a shared sound volume; this is not a verified listener-distance attenuation solution. Use positional sound settings and test multiple listeners.
- `Workspace.Adonis_Loader` contains a loader with dynamic `require` calls and the place contains extensive third-party vehicle code. Their contents and rights were not audited; review dependencies in a safe environment before reuse.

No device/input, visual, security, rights, playback, persistence, or performance test was run. Check reduced motion, focus restoration, localization, safe areas, touch targets, keyboard/gamepad access and long-route streaming in a separate safe place.
