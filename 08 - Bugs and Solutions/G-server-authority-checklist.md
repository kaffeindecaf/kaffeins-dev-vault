---
id: G-server-authority-checklist
type: guide
title: Server authority review checklist
status: reviewed
updated: 2026-11-01
tags: [security, review, architecture]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 1
related: "R-server-authority-replication", "R-remotes-and-validation", "R-request-rate-limiting"
---

# Server authority checklist

## Per remote
- [ ] Takes **no** value the server can derive (price, reward, damage, distance)
- [ ] Type-checks every argument (`typeof`)
- [ ] Range-checks numbers (NaN, non-integers)
- [ ] Re-checks physical possibility (distance, line of sight, alive, in range)
- [ ] Has a per-player budget ([[R-request-rate-limiting]])
- [ ] Reads authority state server-side (inventory, balance, round phase)
- [ ] Mutates server tables, then replicates the result
- [ ] Counts denials; no print per event

## Per interaction
- [ ] Claim/occupancy maps written **synchronously** before any yield
- [ ] Claims cleared on round reset, death, disconnect
- [ ] "Already claimed" and "too far" are distinct, testable outcomes

## Per state write
- [ ] One writer per property (`WalkSpeed`, `FieldOfView`, `Health`)
- [ ] Client cannot set an authoritative attribute
- [ ] Hidden means hidden **server-side**

## Global
- [ ] No Studio-only remote grants currency unvalidated
- [ ] Debug tracing off in anything published
- [ ] No admin command reachable by non-admins (check authority, not the UI)

## The one question
> "If a hostile client sent the worst possible payload right now, what happens?"

