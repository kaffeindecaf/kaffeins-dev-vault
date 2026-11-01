---
id: R-script-types-and-placement
type: reference
title: Script, LocalScript and ModuleScript — placement and execution context
status: reviewed
updated: 2026-11-01
tags: [architecture, scripts, replication]
source_urls: [ "https://create.roblox.com/docs/scripting" ]
confidence: medium
verification: reference_only
related: [ "R-server-authority-replication", "R-module-dependencies" ]
---

# Script types and where they run

| Class | Runs on | Runs when |
|---|---|---|
| `Script` | server | it is a descendant of a server-run container |
| `LocalScript` | one client | a player's client has it under `StarterPlayerScripts`, `StarterCharacterScripts`, `StarterGui`, `ReplicatedFirst`, or the player's `PlayerGui`/`Backpack` |
| `ModuleScript` | wherever it is required | on `require`, once per context |

A `Script` in `ReplicatedStorage` does **not** run. A `LocalScript` on the server does not run. Most
"my code does nothing" reports are this table.

## Where things go

```text
ServerScriptService/          server systems (rounds, data, NPCs, validation)
  Systems/
    GameManager (Script)
    PlayerData (ModuleScript)
ReplicatedStorage/            shared, read-only by convention
  Modules/                    pure logic both sides may require
  Remotes/                    RemoteEvents/RemoteFunctions
  Config/                     tunables
StarterPlayer/
  StarterPlayerScripts/       client systems that live for the session (input, camera, HUD logic)
  StarterCharacterScripts/    per-character scripts (respawn behaviour)
StarterGui/                   UI hierarchy; LocalScripts inside ScreenGuis
ServerStorage/                server-only models, backups, secrets
```

## Rules that prevent whole classes of bug

1. **Server owns the world.** Anything a client can change locally must be re-validated server-side
   ([[R-server-authority-replication]]).
2. **`ResetOnSpawn = false`** on HUD ScreenGuis, or your UI rebuilds and leaks connections every
   respawn.
3. **One router per direction.** Many small remotes is fine; many listeners on one remote is how you
   get duplicate handlers (and double-executed purchases).
4. **Character scripts die with the character.** The classic cleanup bug is a `StarterCharacterScripts`
   script connecting to something that outlives it — the connection then points at a destroyed
   Humanoid.
5. **`require` is cached per context**, so a module required by client and server holds *different*
   state. Never put authoritative data in a shared module.

## Detecting context

```lua
-- Untested
local RunService = game:GetService("RunService")
if RunService:IsServer() then
    -- authoritative path
else
    -- presentation path
end
```

Use that only for shared modules. Prefer separate scripts with explicit placement over runtime
branching — it is easier to audit, and a reviewer can see at a glance what runs where.

Next: [[R-server-authority-replication]] · [[R-remotes-and-validation]] · [[R-module-dependencies]].
