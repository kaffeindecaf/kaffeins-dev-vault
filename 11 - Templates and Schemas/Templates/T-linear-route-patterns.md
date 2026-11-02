---
id: T-linear-route-patterns
type: template
title: Linear route integration catalog
status: draft
updated: 2026-11-02
tags: [template, luau, route, delivery]
source_urls: []
confidence: medium
verification: untested
related: [ "S-linear-route-progress", "S-world-space-menu-camera" ]
---

# Linear route integration catalog

These **Untested:** original helpers live in `11 - Templates and Schemas/Luau Snippets/`. They are
building blocks, not complete game systems.

| File | Role and integration |
|---|---|
| `linear-route-progress.luau` | Project a position onto a straight segment for UI. The host owns character references, route configuration, display and server verification. |
| `camera-menu-transition.luau` | Cancel and replace client camera tweens. The host owns camera state, input, focus and cleanup. |
| `delivery-preconditions.luau` | Check trusted server-side prerequisites. The host validates endpoint, ownership, checkpoints and durable idempotent completion. |
| `route-marker-blockout.luau` | Build an original primitive sign. The host supplies text, placement and visual design. |

Test respawn, alternate paths, streaming, reduced motion, input access and multiplayer behavior in a
safe test place before use.
