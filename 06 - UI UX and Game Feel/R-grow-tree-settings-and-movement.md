---
id: R-grow-tree-settings-and-movement
type: reference
title: Grow A Tree settings and sprint integration observations
status: draft
updated: 2026-11-02
tags: [ui, settings, movement, accessibility]
source_urls: ["https://create.roblox.com/docs/reference/engine/classes/ContextActionService"]
confidence: medium
verification: design_only
related: [ "R-grow-a-tree-pattern-audit", "S-sprint-stamina", "S-datastore-player-profile", "R-controller-focus" ]
---

# Grow A Tree settings and sprint integration observations

## Observed in Studio Edit mode

`StarterPlayer.StarterPlayerScripts.SettingsController` finds `StarterGui.SettingsUI.MainFrame.Content.SettingsList` at runtime, renders settings and sends key plus boolean via `ReplicatedStorage.Shared.UpdatePlayerSetting`. `ServerScriptService.Modules.SettingsService` checks a whitelist and types and invokes a rate guard before `DataService.SetSetting`; the data service stores boolean preferences and publishes player attributes. This is static source inspection, not evidence of successful persistence or every option's actual effect.

`StarterPlayer.StarterPlayerScripts.Core.MovementController` combines held LeftShift with a touch toggle, sends sprint intent, and changes camera FOV from the server response. `ServerScriptService.SprintServer` accepts boolean requests, applies a cooldown, sets Humanoid WalkSpeed and sends state; it also watches WalkSpeed changes. This describes the inspected implementation, not a claim that its enforcement prevents all exploits. Hard resetting WalkSpeed can conflict with other buffs or movement systems; a central speed resolver is a useful adaptation.

## Reuse and alternatives

Use a labelled toggle for binary preferences and a slider for continuous volume. A toggle should state ON/OFF in text, use `Activated`, restore focus, leave room for localization and reconcile rejection or a fresh server value. `ui-setting-toggle.luau` is an untested client presentation adapter; wire its callback to an existing validated settings contract. A local-only setting needs no server write unless persistence is wanted. Check long labels, contrast, touch targets, gamepad navigation, keyboard and reduced-motion behavior; none were tested here.

For sprint, distinguish held keyboard input from a touch toggle, clear intent on focus loss, respawn and teardown, and show the approved state. `sprint-intent-handler.luau` is an untested server handler with injected speed policy and response callback, not an anti-cheat or complete movement controller. Compose buffs and restrictions on the server and restore state on respawn. Roblox's [ContextActionService reference](https://create.roblox.com/docs/reference/engine/classes/ContextActionService) says its binding methods are not recommended for new work and points to the Input Action System; choose and verify the current input approach for the project. Check gamepad, touch cancellation, latency, accessibility and multiple speed modifiers in a safe test place. No performance was measured.
