---
id: S-datastore-player-profile
type: system
title: Player profile persistence — server memory, atomic updates and safe shutdown
status: draft
updated: 2026-11-01
tags: [systems, datastore, persistence, player-data]
source_urls:
  - https://create.roblox.com/docs/cloud-services/data-stores/player-data-purchasing
  - https://create.roblox.com/docs/cloud-services/data-stores/best-practices
  - https://create.roblox.com/docs/cloud-services/data-stores/error-codes-and-limits
confidence: medium
verification: untested
client_server: server
roblox_services: [DataStoreService, Players]
dependencies: []
code_blocks: 2
related: [ "R-datastore-safety", "R-memorystore-messaging", "S-save-load-migration", "SRC-roblox-data-store-player-profile", "G-skill-roblox-core-loop", "PR-datastore-review" ]
---

# Player profile persistence — server memory, atomic updates and safe shutdown

This note connects the existing save/migration recipe to Roblox's current player-data reference.
It is a design reference; the snippets have not been run in Studio.

## Data path

Load a player's profile once at session start, keep the authoritative copy on the server, and save
only at intentional checkpoints: periodic autosave, purchases, player departure and server shutdown.
Do not issue a DataStore request for ordinary gameplay mutations. Roblox's sample uses
`UpdateAsync` for atomic lock-and-write operations and warns that session locking is needed when
multiple servers could otherwise hold stale in-memory copies of one profile.

![Roblox player-data loading flow](https://prod.docsiteassets.roblox.com/assets/data/player-data-purchasing/data-load-diagram.png)

[Source: Implement player data and purchasing systems](https://create.roblox.com/docs/cloud-services/data-stores/player-data-purchasing).
See [[SRC-roblox-data-store-player-profile]] for all reviewed sources and diagrams.

## Example: monotonic high score update

Use an atomic transform when a write depends on the stored value. This narrow example keeps a
numeric high score from moving backwards. It does **not** implement a player session lock, profile
queue, autosave, or shutdown handler. Keep this key separate from a profile key written by a live
session system, or use one single-writer profile module that owns all updates.

Untested:

```lua
local DataStoreService = game:GetService("DataStoreService")
local ScoreStore = DataStoreService:GetDataStore("PlayerScores_v1")

local function saveHighScore(userId: number, candidateScore: number)
	if candidateScore < 0 then
		return false, "invalid_score"
	end

	local key = "u_" .. tostring(userId)
	local ok, result = pcall(function()
		return ScoreStore:UpdateAsync(key, function(current)
			local record = if type(current) == "table" then table.clone(current) else {}
			local previous = tonumber(record.highScore) or 0
			record.highScore = math.max(previous, candidateScore)
			return record
		end)
	end)

	if not ok then
		warn("high score save failed", userId, result)
		return false, result
	end
	return true, result
end
```

The transform is intentionally short, deterministic and non-yielding. `UpdateAsync` can run the
transform against current stored data; do not put `task.wait`, other yielding calls, side effects,
or client-trusted amounts inside it. Validate `candidateScore` on the server before this function.
This single-key example is not a replacement for session locking when a whole player profile is
held in memory across servers.

## Autosave timing example

Roblox recommends spreading periodic requests with a randomized initial offset and bounded jitter.
Keep an autosave interval within the request budget and shorter than the session-lock expiration.

Untested:

```lua
local AUTO_SAVE_INTERVAL = 180

local function startAutosave(player, canSave, savePlayerData)
	task.spawn(function()
		task.wait(math.random() * AUTO_SAVE_INTERVAL)
		while player.Parent do
			if canSave(player) then
				savePlayerData(player)
			end
			task.wait(AUTO_SAVE_INTERVAL)
		end
	end)
end
```

This is adapted from Roblox's published sample and has not been exercised here. Production code
also needs ordered per-key requests, bounded retry with jitter, a dirty-state policy, session-lock
refresh/release, purchase idempotency, and a shared shutdown deadline.

## Required safeguards

- A failed load is not a new profile. Do not save default data after a failed read.
- A session lock and a single writer protect against rapid rejoin and stale server writes.
- `UpdateAsync` counts against both read and write budgets; check the live budget rather than
  assuming the old fixed numbers apply.
- Studio can access the same data as the live experience when API services are enabled. Use a
  separate test experience/store and never toggle live access just to try this snippet.
- For developer products, record the `PurchaseId`, award the item and persist it before returning
  `PurchaseGranted`; make processing idempotent.
- Flush on `PlayerRemoving` and `BindToClose`, but do not depend on shutdown as the only save.

## Evidence checklist

- [ ] Exercise new-profile, existing-profile, read-failure, write-failure, rejoin and shutdown cases
      in an isolated test experience.
- [ ] Confirm cross-server session locking and lock release after failure.
- [ ] Record Studio evidence in the project folder before changing this note to `tested_studio`.

Read with the persistence skill card [[G-skill-roblox-core-loop]] and the review prompt
[[PR-datastore-review]].
