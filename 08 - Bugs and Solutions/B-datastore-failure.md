---
id: B-datastore-failure
type: bug
title: Player data resets to defaults after a rejoin
status: reviewed
updated: 2026-11-01
tags: [datastore, persistence, diagnosis]
source_urls: []
confidence: medium
verification: design_only
severity: critical
hypothetical: true
client_server: both
code_blocks: 1
related: "R-datastore-safety", "S-save-load-migration", "G-datastore-failure-checklist"
---

> ⚠️ **Hypothetical case, not a real incident.** Written from general Roblox behaviour to teach the
> diagnostic path. No log below came from a real session. Do not cite it as evidence.

# Data reset after rejoin

## Observed
A player with 40,000 currency rejoins with 0. No user-visible error; an earlier throttling warning sits in the
log.

## Safe reproduction
In a **private test place**, force a `GetAsync` failure with a debug flag, join, rejoin, observe defaults being
saved over the real profile.

## Diagnosis
```lua
local ok, data = pcall(STORE.GetAsync, STORE, key)
local profile = ok and data or DEFAULT_PROFILE   -- ← unreadable becomes "new player"
```
A transient read failure is indistinguishable from "no data", so the code writes defaults.

## Cause
Treating a DataStore error as an empty profile, then saving it.

## Fix
```lua
local ok, data = pcall(STORE.GetAsync, STORE, key)
if not ok then return nil, "load_failed" end     -- never create a profile here
local profile = data or table.clone(DEFAULT_PROFILE)
```
Plus retry with backoff, a session lock, and a "could not load your data, please rejoin" message instead of
silent loss.

## Verification
Force the read failure: the real profile survives. Force a write failure: the dirty flag stays set.

## Regression prevention
A test asserting "load failure never writes". Highest-severity class in the vault
([[R-datastore-safety]], [[S-save-load-migration]]).

