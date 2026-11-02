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
related: [ "R-drive-catch-pattern-audit", "S-datastore-player-profile", "S-world-object-validation" ]
---

# Sequential world gates and durable unlock contract

Give a clear next destination and a server-checked unlock. `ServerScriptService.Modules.Services.AreaService` verifies the requested index is next, checks cash, then changes cash and AreaLevel; client-side gate appearance is backed by a server pushback loop. Its current spend and save path is not a durable atomic transaction: it reports success after a save failure, and load failure still derives a level. Preserve those observations rather than copy the failure semantics. See [[R-drive-catch-pattern-audit]].

Adapt with server-owned stable area keys, eligibility, currency and progression inside one reviewed profile transaction. Serialize requests and return success only after durable commit; handle failed load, duplicate requests and reconnect. `sequential-gate-check.luau` is an untested validation helper only: it does not debit, save, authorize proximity, or perform a transaction. Check finite integer input, location, rate limits, valid current profile ownership and all economy invariants in the host. Provide text for cost, locked state and destination as well as color. Consider open exploration instead when strict order frustrates players. Test entry on foot and in a vehicle, lag, focus, touch, accessibility and enforcement near boundaries.
