---
id: S-sequential-area-gates
type: system
title: Sequential world gates and durable unlock contract
status: draft
updated: 2026-11-02
tags: [progression, zones, economy, security]
source_urls: []
confidence: medium
verification: design_only
client_server: both
roblox_services: [Workspace, DataStoreService]
code_blocks: 0
related: [ "S-datastore-player-profile", "S-world-object-validation" ]
---

# Sequential world gates and durable unlock contract

Give a clear next destination and a server-checked unlock. Validate the requested step, current
progression and currency using authoritative state. Persist the spend and unlock as one durable
transaction; never report success after a save failure or derive progression from a failed load.

Adapt with server-owned stable area keys, eligibility, currency and progression inside one reviewed profile transaction. Serialize requests and return success only after durable commit; handle failed load, duplicate requests and reconnect. `sequential-gate-check.luau` is an untested validation helper only: it does not debit, save, authorize proximity, or perform a transaction. Check finite integer input, location, rate limits, valid current profile ownership and all economy invariants in the host. Provide text for cost, locked state and destination as well as color. Consider open exploration instead when strict order frustrates players. Test entry on foot and in a vehicle, lag, focus, touch, accessibility and enforcement near boundaries.
