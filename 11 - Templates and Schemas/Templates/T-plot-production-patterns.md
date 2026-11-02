---
id: T-plot-production-patterns
type: template
title: Plot-based production integration catalog
status: draft
updated: 2026-11-02
tags: [template, luau, production, farming]
source_urls: []
confidence: medium
verification: untested
related: [ "S-bounded-production-pipeline", "S-plot-resource-deposit" ]
---

# Plot-based production integration catalog

These **Untested:** original helpers live in `11 - Templates and Schemas/Luau Snippets/`. They are
not complete source scripts; the host game owns authorization, persistence and recovery.

| File | Purpose and integration |
|---|---|
| `bounded-transfer.luau` | Computes a partial transfer; the server validates ownership and commits both values together. |
| `production-plan.luau` | Chooses input-waiting, output-full or ready; the host owns job locking, reservation, persistence and recovery. |
| `slot-grid-offset.luau` | Calculates a local grid offset; the host applies transforms and collision/placement checks. |
| `crop-blockout-model.luau` | Creates an original primitive crop blockout; the host supplies placement, interaction and art. |

Test interruption, capacity changes, plot reassignment, concurrency, devices and persistence failure in
a separate safe place before integration.
