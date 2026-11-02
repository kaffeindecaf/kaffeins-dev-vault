---
id: S-purchase-fulfillment-center
type: system
title: Centralized gamepass and developer product fulfillment center
status: draft
updated: 2026-11-02
tags: [systems, backend, reusable, v1]
source_urls: ["https://create.roblox.com/docs/reference/engine/classes/MarketplaceService","https://create.roblox.com/docs/production/monetization/developer-products"]
confidence: medium
verification: tested_studio
client_server: server
roblox_services: [MarketplaceService, Players, DataStoreService]
test_method: Studio Play mock fault harness and scoped runtime checks
tested_at: 2026-11-02
test_evidence: BACKEND_SYSTEMS_TEST_REPORT.md
related: ["T-backend-systems-catalog","SRC-backend-platform-contracts","S-receipt-fulfillment-contract","S-datastore-player-profile"]
---

# Centralized gamepass and developer product fulfillment center

Files: `purchase-fulfillment-center.luau`, `backend-account-store.luau` in `11 - Templates and Schemas/Luau Snippets/`. Executed scope is documented below; project integration examples remain untested.

Route every developer product receipt through one server callback. Award pure account data and record PurchaseId inside the same UpdateAsync transform. Return PurchaseGranted only after a durable result confirms that receipt is recorded. The shared account owner serializes local writes with a bounded FIFO per-user queue. This orders local enqueues, not the arrival of receipts across different servers.

## Installation and API

`new(accounts, products, grant, findPlayer?)`, `Process(receipt)`, `Install()`, `OwnsPass(player, passId)`, `BindPasses(passRewards, applyEntitlement)`. Keep `findPlayer` at its default outside tests. Product keys are real project ProductIds supplied by the developer; no public asset or purchase identifiers are invented in the catalog.

Untested: project integration sketch with modules and `accounts`/`grant` from the catalog.

```lua
local products = {} -- fill from your own developer product configuration
local center = Center.new(accounts, products, grant)
center:Install() -- exactly one server-side ProcessReceipt owner in the entire game
local stopPassBindings = center:BindPasses(passRewards, function(player, entitlement)
    applyIdempotentCapability(player, entitlement)
end)
```

Do not also install the older receipt dispatcher, another shop's callback or a callback in a second copy of this module. The module prevents duplicate installation through itself; it cannot stop unrelated scripts overwriting MarketplaceService.ProcessReceipt.

Unknown products, offline players, capacity limits, invalid records and ambiguous writes return NotProcessedYet. Preserve mappings for delisted products so pending receipts remain fulfillable. Do not use PromptProductPurchaseFinished to award developer products. The platform controls retry scheduling; this module does not promise an immediate retry.

## Gamepasses and limitations

Pass ownership is queried on join and again after a purchase prompt completes. The completion event only triggers a recheck. Apply a capability idempotently, such as setting an entitlement flag; never add currency each join. Ownership lookup failure returns unknown, and the host should schedule a bounded retry or offer a refresh path. `BindPasses` returns a disconnect function.

| Fault | Contract |
|---|---|
| Same receipt arrives twice, even on another server | Same account receipt marker prevents another data grant |
| Reward saves but request response is lost | Defer; later retry sees receipt |
| Grant callback yields / mutates Instances | Invalid integration; keep transform pure |
| Queue/history is full | Defer rather than acknowledge an unsaved purchase |
| Gamepass lookup fails | Unknown; do not infer ownership |
| Cache writes over account | Forbidden; all writers must share the owner |

Studio mocked duplicate receipts, transform retries, lost save response and unknown products; a separate contention case verified FIFO account-write order. Live Marketplace callback installation, real purchases, gamepass ownership and cross-server races were not exercised.
