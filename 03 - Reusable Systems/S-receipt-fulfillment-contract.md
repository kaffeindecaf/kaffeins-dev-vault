---
id: S-receipt-fulfillment-contract
type: system
title: Developer product fulfillment contract
status: draft
updated: 2026-11-02
tags: [monetization, persistence, security, receipts]
source_urls: ["https://create.roblox.com/docs/reference/engine/classes/MarketplaceService"]
confidence: medium
verification: design_only
client_server: server
roblox_services: [MarketplaceService, DataStoreService]
code_blocks: 0
related: [ "S-datastore-player-profile", "R-grow-a-tree-pattern-audit" ]
---

# Developer product fulfillment contract

The v1.0.0 [[S-purchase-fulfillment-center]] supplies an atomic account-store implementation of this
contract with mock receipt tests. Choose one receipt owner; do not install both dispatchers.

## Purpose and source

Deliver a paid product even if the player bought it outside the current UI, a server crashes, or Roblox retries a receipt. The open Grow A Tree place was read in Edit mode on 2026-11-02. `ServerScriptService.ProductPurchaseService` assigns `MarketplaceService.ProcessReceipt`, looks up the player and product, checks `Modules.DataService.HasProcessedReceipt`, grants by product, records the purchase and calls `SaveNow` before returning a decision. `DataService` has `Purchases.ProcessedReceipts` and `ReceiptOrder`; `PersistenceSession` uses a lease and UpdateAsync. These are source observations, not proof that grant and receipt are atomic or that the production system is safe. The complete grant, failure, concurrency and migration paths were not verified.

## Adaptation

Use one central dispatcher for all product IDs; no prompt result should grant the purchase. A durable, idempotent server transaction must couple the entitlement and purchase ID in the same authoritative record, or implement a separately reviewed recovery protocol. Client request context is optional and cannot be required for store-tab purchases. Unknown products, unavailable profiles, lost ownership and persistence failures remain unresolved. The dispatcher template `receipt-dispatcher.luau` deliberately refuses every receipt until an integrator supplies a durable `CommitReceipt` implementation. Do not install it alongside another ProcessReceipt callback or matching bound receipt handlers; review handler precedence and choose one coordinated architecture.

Roblox documents that callbacks can run concurrently on different servers, be retried after a rejoin or another purchase, and that returning PurchaseGranted can itself fail to be recorded. It also describes newer bound receipt handlers. See the [MarketplaceService reference](https://create.roblox.com/docs/reference/engine/classes/MarketplaceService). The template is not a complete purchase system or proof of exactly-once delivery.

## Review before use

- [ ] Purchase ID and entitlement are committed together; retries and concurrent servers cannot duplicate grants.
- [ ] Unknown products, unavailable profile, data failure, server shutdown and rejoin return an unresolved decision and can recover.
- [ ] Test store-tab and in-experience purchases, duplicate delivery, rapid multiple products, session loss, and failures in a safe test experience.
- [ ] Check current Roblox commerce rules, product configuration, disclosure, regional requirements and human review. No purchase was performed here.
