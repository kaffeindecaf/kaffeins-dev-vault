---
id: S-config-module
type: system
title: One config module instead of hardcoded numbers
status: reviewed
updated: 2026-11-01
tags: [systems, architecture, config]
source_urls: []
confidence: medium
verification: design_only
client_server: server
roblox_services: [None]
dependencies: []
code_blocks: 1
related: "R-module-dependencies", "R-attributes-vs-values-vs-config", "R-server-authority-replication"
---

# Config module

Tuning belongs in one file that a designer can edit and a reviewer can diff. Hardcoded numbers inside
logic are how a game ends up with three different round lengths.

## Shape

```lua
-- Untested
local Config = {}

Config.Round = {
    duration = 300,
    intermission = 15,
    minPlayers = 1,
}

Config.Movement = {
    walk = 16,
    sprint = 32,
    crouch = 6.4,
    staminaDrainSeconds = 8,
    staminaRefillSeconds = 12,
}

Config.Economy = {
    sellMultiplier = 1.0,
    xpPerSale = 12,          -- no magic numbers in the sale code
}

return table.freeze(Config)  -- prevent accidental runtime mutation
```

`table.freeze` is the cheap guarantee that nothing writes to config at runtime; a mutation attempt
errors visibly instead of silently changing balance mid-round.

## Server vs replicated

- **Authority values** (prices, rewards, damage) live in a **server-only** config.
- **Presentation values** (animation ids, display strings, colours) may be replicated to the client.
- Never duplicate the same number in both; the client copy is generated from the server value and
  pushed in the snapshot if it is needed for display.

## Naming

`Config.<System>.<value>`, singular nouns, units in the name when ambiguous (`durationSeconds`,
`rangeStuds`, `volumeDb`). A reviewer should be able to read a config and understand the game.

## Failure modes

- Config required from a client script but stored in `ServerScriptService` → require error at runtime.
- Two configs for the same system (old + new) → both get edited, one is dead.
- Config changed between rounds without a reset → half the players on old values.

## Test cases

1. Freeze works: writing `Config.Round.duration = 1` errors.
2. Every system reads its numbers from config (grep for literals).
3. Client display values match server authority values in the snapshot.

