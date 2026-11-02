---
id: T-vehicle-progression-patterns
type: template
title: Vehicle and progression integration catalog
status: draft
updated: 2026-11-02
tags: [template, luau, vehicles, progression]
source_urls: []
confidence: medium
verification: untested
related: [ "S-collectible-viewport-preview", "S-zone-timer-contract", "S-sequential-area-gates" ]
---

# Vehicle and progression integration catalog

These **Untested:** original helpers live in `11 - Templates and Schemas/Luau Snippets/`. Configure
values and callbacks for the host game; do not treat a helper as a complete progression or vehicle
system.

| File | Role and required integration |
|---|---|
| `viewport-model-preview.luau` | Client preview of an approved model; the host supplies a container, fallback icon and accessible label. |
| `zone-clock-step.luau` | Server timer math; the host owns state, zone detection, expiry, cleanup and recovery. |
| `sequential-gate-check.luau` | Server precondition checks; the host supplies trusted state, proximity validation, rate limits and durable spend/unlock. |
| `weighted-choice.luau` | Server selection from trusted weights; the host grants and persists idempotently and discloses applicable odds. |
| `vehicle-blockout-model.luau` | Original primitive vehicle concept; it has no seat, constraints, physics or driving logic. |

Test device/input behavior, retries, ownership and performance before use. Verify applicable policy
before using weighted rewards with paid products.
