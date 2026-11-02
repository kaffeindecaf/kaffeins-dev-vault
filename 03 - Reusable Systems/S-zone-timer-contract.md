---
id: S-zone-timer-contract
type: system
title: Server-owned timer with safe-zone pauses
status: draft
updated: 2026-11-02
tags: [systems, timers, zones, vehicles]
source_urls: []
confidence: medium
verification: design_only
client_server: both
roblox_services: [Workspace]
code_blocks: 0
related: [ "R-drive-catch-pattern-audit", "S-ui-progress-bar-component", "S-interaction-guard" ]
---

# Server-owned timer with safe-zone pauses

A time-limited trip creates a legible risk budget while safe areas let the player decide without pressure. Use when the pause rules are intuitive and communicated; a deadline may fit better when the trip should never pause. `ServerScriptService.Modules.Services.VehicleTimeService` computes time server-side, checks spawner pad coordinates in each part's local space and treats the next gate area as safe; it sends HUD updates at a throttled cadence. Read statically in [[R-drive-catch-pattern-audit]], not tested.

`zone-clock-step.luau` is an untested pure state-step helper: the host supplies monotonic times and the current pause state, snapshots and a separate server-owned expiration action. It does not detect zones or award anything. Define boundaries, transitions, server authority, leaving/respawn behavior and delayed frame handling. A sampled pause state can miscount time between samples; transition timestamps or more frequent validated zone updates may be needed. Send snapshots on state changes and at a measured cadence; clients interpolate display only. Test overlapping and rotated zones, lag, rejoin, clock discontinuities, exploit attempts and accessible time warnings.
