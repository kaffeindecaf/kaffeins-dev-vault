---
id: S-proximity-workspace-streamer
type: system
title: Proximity component culling and network interest routing
status: draft
updated: 2026-11-02
tags: [systems, backend, reusable, v1]
source_urls: ["https://create.roblox.com/docs/workspace/streaming","https://create.roblox.com/docs/reference/engine/classes/RemoteEvent"]
confidence: medium
verification: tested_studio
client_server: both
roblox_services: [CollectionService, Players]
test_method: Studio Play mock fault harness and scoped runtime checks
tested_at: 2026-11-02
test_evidence: BACKEND_SYSTEMS_TEST_REPORT.md
related: ["T-backend-systems-catalog","SRC-backend-platform-contracts","R-streaming-enabled","S-world-object-validation"]
---

# Proximity component culling and network interest routing

Files: `proximity-component-culler.luau`, `interest-event-router.luau` in `11 - Templates and Schemas/Luau Snippets/`. Executed scope is documented below; project integration examples remain untested.

Tag regional Models and suspend their managed client cosmetic work outside a distance threshold. Hysteresis uses a smaller enter distance and a larger exit distance, avoiding boundary flicker. A separate server helper sends optional effect events only to nearby players.

This complements engine instance streaming. It does not override replication, unload server-owned models, hide authoritative collision or stop NPC simulation per player. Configure Roblox StreamingEnabled separately for instance replication.

## API and ownership

Client: `Culler.new(tag, enterDistance, exitDistance, toggle, cap?)`, `Step(position, budget?)`, `Destroy()`. The callback enables/disables only resources explicitly owned by your cosmetic controller. Cache emitters or update subscriptions during component setup; do not scan every descendant on every tick. Registering/removing tags or streaming regions out triggers lifecycle handling.

Untested: local cosmetic setup; `Culler` is the required module.

```lua
local culler = Culler.new("CosmeticRegion", 120, 160, function(model, active)
    local component = regionComponents[model]
    if component then component:SetUpdating(active) end
end)
-- At a bounded cadence, if the character root exists:
-- culler:Step(root.Position, 25)
-- On script teardown: culler:Destroy()
```

The module defaults to 1,000 region records and checks 25 per Step. Choose region size/pivots and update cadence to meet device budgets; very large models need an explicit spatial-volume test instead of center distance. Objects beyond capacity are warned and not registered. Missing a target at first tag registration needs the host to initialize it disabled.

Server: the exported `interest-event-router` function takes `(remote, origin, radius, ...)`. It scans current players and sends only within range. Use a spatial index at larger player counts. Route only optional effects; essential inventory, receipts, room state and gameplay validation must not depend on interest filtering.

| Case | Handling |
|---|---|
| Player hovers near threshold | Hysteresis preserves current state |
| Region removed / streamed out | Disable owned cosmetics, release record |
| Character respawns | Wait for new root; stop old update connection |
| Far-away malicious client requests interaction | Server still checks ownership and distance |
| Client alters culling | Only its own presentation changes |

Studio checked culler enter/stay/exit behavior and cleanup. The event router was load-checked only; real streaming churn, bandwidth reduction and mobile performance remain untested.
