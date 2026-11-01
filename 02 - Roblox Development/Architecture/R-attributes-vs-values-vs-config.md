---
id: R-attributes-vs-values-vs-config
type: reference
title: Attributes vs ValueObjects vs ModuleScript config
status: reviewed
updated: 2026-11-01
tags: [architecture, state, config]
source_urls: [ "https://create.roblox.com/docs/studio/properties#instance-attributes" ]
confidence: medium
verification: reference_only
related: [ "R-collectionservice-tags", "S-config-module" ]
---

# Where state and config live

| Mechanism | Replicates | Editor friendly | Good for |
|---|---|---|---|
| `Attribute` | yes (server→client) | yes, in Properties | per-instance state and small per-instance config |
| `ValueObject` (`NumberValue`…) | yes | yes (a part in the tree) | legacy; useful when a designer needs a visible knob |
| `ModuleScript` table | read locally, not replicated | no (text) | single source of global tuning |
| Server table (in a `Script`) | **no** | no | authoritative runtime state |

## The rule used across this vault

- **Global tuning → one `Config` module**, server-required. Prices, timings, damage, XP. No asset IDs
  hardcoded inside logic ([[S-config-module]]).
- **Per-instance state → attributes.** A door's `Locked`, `OpenFraction`, a camera's `CircuitId`.
  Attributes replicate, are observable via `GetAttributeChangedSignal`, and survive if you inspect
  the instance in Studio.
- **Authoritative player state → server table**, mirrored to the client only as a view. A
  `NumberValue` in the player's `PlayerGui` that the client can set is not authority.

## Attributes have real limits

- Only number, string, boolean, `UDim`, `UDim2`, `BrickColor`, `Color3`, `Vector2`, `Vector3`,
  `CFrame`, `NumberSequence`, `ColorSequence`, `Rect`, `Font`. **Not** tables, not `Instance`.
- `GetAttributeChangedSignal` fires on the server for server-set attributes; clients see replicated
  changes, one frame later in the worst case.
- Attribute names are case-sensitive, 100 chars max, and cannot start with `RBX`.

For structured data use JSON in a string attribute (ugly, works) or a server table + targeted remote
(better, more code).

## The trap: config in the wrong context

```lua
-- Untested: BAD. Client-side module holding authority.
-- ReplicatedStorage.Config.Prices is visible to exploiters AND editable by them locally.
```

Prices and rewards must be server-side (`ServerScriptService` or `ServerStorage`) or the client can
price its own purchase. The *display* copy of a price can be replicated; the *charged* price comes
from the server.

## Audit question

For every tunable value: *if the client sets this to something else, does anything break?* If yes, it
is authority, and it must not live in `ReplicatedStorage`.

Next: [[S-config-module]] · [[R-server-authority-replication]].
