---
id: G-datastore-failure-checklist
type: guide
title: Data did not save — diagnosis checklist
status: reviewed
updated: 2026-11-01
tags: [datastore, persistence, diagnosis]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 1
related: "R-datastore-safety", "S-save-load-migration", "B-datastore-failure"
---

# Data did not save

## 1. Is it Studio?
Studio uses a separate DataStore scope and needs API access enabled. If it persists in Studio but not live (or
vice versa), this is the answer.

## 2. Did the write happen?
```lua
local ok, err = pcall(STORE.SetAsync, STORE, key, data)
print("write", ok, err)
```
A throttled write throws; a `pcall` that swallows it is silent data loss.

## 3. Read it back
`GetAsync` immediately after `SetAsync` can return cached data. Read from another server or after a delay.

## 4. Is something else writing?

| Suspect | Check |
|---|---|
| Two modules writing one key | grep `SetAsync` |
| "Save on leave" racing an autosave | log both with timestamps |
| `BindToClose` not running | shutdown only, ~30 s budget |

## 5. Is the key stable?
`"u_" .. UserId` — not the name (renameable), not a session id.

## 6. Did a schema change break a read?
A renamed field reads nil → UI shows 0 → a save writes 0. This *looks* like data loss and is
([[S-save-load-migration]]).

## 7. Budget exhausted?
Writes are limited per key and per minute; a 5-second autosave across 30 players can exceed it. Dirty-flag and
batch instead.

## Stop rule
If you are about to "reset the store to fix it", stop — that is destructive and usually unnecessary. Snapshot a
sample key first, with the owner's approval.

