---
id: T-drive-catch-patterns
type: template
title: Drive and Catch inspired integration catalog
status: draft
updated: 2026-11-02
tags: [template, luau, vehicles, progression]
source_urls: []
confidence: medium
verification: untested
related: [ "R-drive-catch-pattern-audit", "S-collectible-viewport-preview", "S-zone-timer-contract", "S-sequential-area-gates" ]
---

# Drive and Catch inspired integration catalog

These are **Untested:** adapted helpers in `11 - Templates and Schemas/Luau Snippets/`, not copies of source scripts. Configure values and callbacks for a separate test place.

| File | Role and required integration |
|---|---|
| `viewport-model-preview.luau` | Client preview of an approved Model. Host supplies container, fallback icon and accessible label, handles lifecycle and validates aspect ratio and invisible geometry. |
| `zone-clock-step.luau` | Server timer math. Host owns state, clock, zone detection, updates, expiry, cleanup and recovery. |
| `sequential-gate-check.luau` | Server-only precondition checks. Host supplies trusted state, proximity validation, rate limit and durable atomic spend/unlock. |
| `weighted-choice.luau` | Server selection from trusted weights. Host grants and persists idempotently; disclose odds and verify applicable policy for paid random rewards. |
| `vehicle-blockout-model.luau` | Original anchored primitive shape for a vehicle concept. It has no seat, constraints, physics or driving logic; its pivot is the body center. |

For model blockouts, see `tree-model-placeholder.luau` and `shop-stand-placeholder.luau` from [[T-grow-tree-snippet-catalog]]. Original source assets were not exported; source ownership and rights have not been established. Review [[R-drive-catch-pattern-audit]] before adapting any source-specific behavior. Test snippets, device and input behavior, loss/retry scenarios, ownership, and performance before use.
