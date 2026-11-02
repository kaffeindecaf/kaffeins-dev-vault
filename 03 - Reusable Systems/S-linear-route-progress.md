---
id: S-linear-route-progress
type: system
title: Linear route progress and authoritative delivery
status: draft
updated: 2026-11-02
tags: [progression, delivery, ui, security]
source_urls: []
confidence: medium
verification: design_only
client_server: both
roblox_services: [Workspace]
code_blocks: 0
related: [ "R-curry-delivery-pattern-audit", "S-ui-progress-bar-component", "S-interaction-guard", "S-checkpoints" ]
---

# Linear route progress and authoritative delivery

Show progress along a straight route with a text distance and fill. Choose a segment projection for a straight corridor; a curved or branching route needs ordered checkpoints or path-distance mapping instead. Static source: `StarterGui.CurryGui.ProgressBar.ProgressUpdater` uses the character's X coordinate divided by 138783. Its limits and delivery mismatches are documented in [[R-curry-delivery-pattern-audit]].

`linear-route-progress.luau` is an untested pure projection helper. The client may use it for display, but it does not measure travel history or verify arrival. Server completion must independently check the authorized player, active objective, item ownership, valid endpoint/proximity, progress/checkpoints, rate limits and already-delivered state. Serialize or persist a reward transaction where needed. Avoid using client progress or a mere touch as proof of a completed journey. Rebind character references on respawn and define whether progress regresses, survives death or uses a high-water mark.

Use count text alongside color and fill; handle zero-length segments, localization, safe insets and keyboard/touch/gamepad access. Test lateral shortcuts, teleportation, respawn, alternate paths, high latency and long-distance streaming. No runtime or performance result is established here.
