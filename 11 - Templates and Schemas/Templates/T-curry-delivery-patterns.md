---
id: T-curry-delivery-patterns
type: template
title: Curry delivery inspired integration catalog
status: draft
updated: 2026-11-02
tags: [template, luau, route, delivery]
source_urls: []
confidence: medium
verification: untested
related: [ "R-curry-delivery-pattern-audit", "S-linear-route-progress", "S-world-space-menu-camera" ]
---

# Curry delivery inspired integration catalog

These **Untested:** original adaptations live in `11 - Templates and Schemas/Luau Snippets/`. They do not modify the source place.

| File | Role and integration |
|---|---|
| `linear-route-progress.luau` | Project a position onto a straight segment for UI. Caller handles characters, route configuration, display and server verification. |
| `camera-menu-transition.luau` | Cancel and replace client camera tweens. Host manages camera ownership, saved state, input, focus and cleanup. |
| `delivery-preconditions.luau` | Check booleans derived by trusted server code. Host implements endpoint, ownership, checkpoint validation and durable idempotent completion. |
| `route-marker-blockout.luau` | Original static primitive sign. Host adds text and places it; the post center is the pivot. |

Use the existing progress bar, notification and modal templates as appropriate. None of these helpers is a complete game system. Test in a safe place, including respawn, input, streaming, reduced motion and multiplayer. The source model and audio rights are unknown.
