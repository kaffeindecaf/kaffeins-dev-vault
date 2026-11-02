---
id: S-cross-server-gift-ledger
type: system
title: Cross-server transaction and gift ledger with durable recovery
status: draft
updated: 2026-11-02
tags: [systems, backend, reusable, v1]
source_urls: ["https://create.roblox.com/docs/reference/engine/classes/GlobalDataStore","https://create.roblox.com/docs/cloud-services/memory-stores","https://create.roblox.com/docs/reference/engine/classes/MessagingService"]
confidence: medium
verification: tested_studio
client_server: server
roblox_services: [DataStoreService, MemoryStoreService, MessagingService]
test_method: Studio Play mock fault harness and scoped runtime checks
tested_at: 2026-11-02
test_evidence: BACKEND_SYSTEMS_TEST_REPORT.md
related: ["T-backend-systems-catalog","SRC-backend-platform-contracts","R-memorystore-messaging","S-inventory-data-model"]
---

# Cross-server transaction and gift ledger with durable recovery

Files: `cross-server-gift-ledger.luau`, `backend-account-store.luau` in `11 - Templates and Schemas/Luau Snippets/`. Executed scope is documented below; project integration examples remain untested.

Send integer currency or one uniquely identified item between two durable accounts. The sender atomically debits currency/removes the item and writes a prepared outbox entry. The recipient atomically credits it and writes an inbox receipt. Final acknowledgment marks the sender entry delivered. Repeating the same transfer ID resumes that operation.

This implements a durable outbox/inbox saga, with prepare and delivery stages. Roblox does not supply an atomic commit across two player keys. The transfer can be visibly pending between stages; calling this distributed ACID two-phase commit would overstate its contract.

## API and ownership

`new(accounts, sortedMap?, messaging?)`, `Send(sender, recipient, amount, id)`, `SendItem(sender, recipient, itemId, id)`, `Resume(sender, id)`, `Recover(sender, limit?)`, `PollHints(limit?)`, and `Subscribe()`. All calls are server-only. An item ID identifies a unique instance, not the shared item template; its payload is a serializable table under `account.inventory[itemId]`.

Untested: host wiring; `Accounts` and `Ledger` are the required modules, with an isolated store selected by the project.

```lua
local accounts = Accounts.new(testDataStore)
local ledger = Ledger.new(accounts, giftHintSortedMap, messagingService)
local id = game:GetService("HttpService"):GenerateGUID(false)
-- Retain this ID before starting; reuse it after an unknown response.
local ok, state = ledger:Send(senderUserId, recipientUserId, 25, id)
```

All balance, inventory, purchase and reward writers must use the same account owner. Never run a cached profile `SetAsync` writer against these keys. Failed or unknown results retain escrow; never refund automatically after possible recipient credit. Conflicting IDs or recipient item collisions fail closed.

## Recovery and scale

MessagingService wake-ups and short-lived MemoryStore hints accelerate retries. Neither is durable authority. Recover on sender login, periodically for known active senders, and with a budgeted durable-key reconciliation job for offline senders. A crash between prepare and publishing a hint requires that durable sweep or a later login. `PollHints` alone cannot discover every transfer and repeated first-page hints are not a fair global queue.

Keep inbox/outbox tombstones; deleting them allows old retries to repeat a grant. The account helper refuses capacity overflow. A production archival/compaction design must preserve replay protection before extending this bounded example. This is one-way gifting, not an atomic swap of two players' offers.

| Fault | Expected state |
|---|---|
| Crash before sender prepare | No debit |
| Credit fails | Prepared escrow, retry later |
| Credit commits but response is lost | Inbox prevents duplicate credit on retry |
| Final acknowledgment fails | Retry discovers already credited recipient |
| Recipient cannot accept unique item | Pending escrow, no overwrite |
| Hint expires / message is lost | Durable outbox survives; discovery policy is required |

Studio mocks exercised repeated transforms, ambiguous currency/item credit, conflicting IDs, insufficient funds and recovery. Real multi-server contention, request budgets and worker discovery remain untested. See [[BACKEND_SYSTEMS_TEST_REPORT]].
