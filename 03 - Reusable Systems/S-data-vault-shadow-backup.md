---
id: S-data-vault-shadow-backup
type: system
title: Data Vault shadow backup and session integrity guard
status: draft
updated: 2026-11-02
tags: [systems, backend, reusable, v1]
source_urls: ["https://create.roblox.com/docs/reference/engine/classes/GlobalDataStore","https://create.roblox.com/docs/reference/engine/classes/HttpService"]
confidence: medium
verification: tested_studio
client_server: server
roblox_services: [HttpService]
test_method: Studio Play mock fault harness and scoped runtime checks
tested_at: 2026-11-02
test_evidence: BACKEND_SYSTEMS_TEST_REPORT.md
related: ["T-backend-systems-catalog","SRC-backend-platform-contracts","S-datastore-player-profile","S-save-load-migration"]
---

# Data Vault shadow backup and session integrity guard

Files: `data-vault-guard.luau`, `redacted-webhook-alert.luau` in `11 - Templates and Schemas/Luau Snippets/`. Executed scope is documented below; project integration examples remain untested.

Reject invalid profile snapshots before they reach a save owner. The guard holds a detached, in-memory copy of the last confirmed save, latches a session lock after a failed check, and sends a redacted alert through an injected callback. This is an integrity supervisor; the shadow is lost if the server dies. DataStore version history or a separately designed backup store is needed for durable recovery.

## Contract and installation

Keep one guard per server and use a unique session token as its key. `new(checks, alert)`, `BeforeSave(sessionId, data)`, `Saved(sessionId, snapshot)`, `CanMutate(sessionId)`, and `Forget(sessionId)` are the public API. The validator receives current data and the last confirmed shadow. Customize it for your actual inventory schema; an empty inventory may be legitimate.

Untested: integration sketch; `Guard` is the required module and `saveOwnedSnapshot` is your existing serialized save owner.

```lua
local guard = Guard.new(Guard.DefaultChecks, warn)
local snapshot = guard:BeforeSave(sessionToken, profile.Data)
if snapshot then
    local saved = saveOwnedSnapshot(snapshot)
    if saved then guard:Saved(sessionToken, snapshot) end
end
```

Every mutation, autosave, departure save, release save and shutdown path must honor the lock. A wrapper cannot cancel independent ProfileService/ProfileStore autosaves. Integrate validation into that library's supported ownership pipeline before copying the pattern; never assume skipping a manual save is sufficient. Serialize saves so an earlier valid snapshot cannot be committed after a later integrity failure without an explicit policy.

`redacted-webhook-alert.luau` builds a rate-limited HTTPS sender; supply its endpoint privately at runtime. It disables Discord mentions and logs neither endpoint nor response body. Use fixed diagnostic codes in validators, never player profile contents. Delivery is best effort and untested; configure an approved relay if needed.

## Failure modes and checks

| Failure | Behavior / responsibility |
|---|---|
| Inventory becomes nil, invalid coins, validator throws | Latch lock, return no save snapshot |
| Profile changes after snapshot | Detached snapshot remains stable |
| Save fails | Do not call `Saved`; keep prior shadow |
| Alert fails or is rate-limited | Lock stays active; operator needs another alert channel |
| Lock appears repaired | Remains locked until session ends and recovery is reviewed |
| Host bypasses guard | Protection does not apply |

Studio mock checks cover detached copies, missing inventory and sticky locks. Live autosave races, forced shutdown, actual webhook delivery, inventory-drop policies and recovery from DataStore versions remain project tests. See [[BACKEND_SYSTEMS_TEST_REPORT]].
