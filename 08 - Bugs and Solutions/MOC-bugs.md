---
id: MOC-bugs
type: moc
title: Bugs and solutions — index
status: reviewed
updated: 2026-11-01
tags: [bugs, index]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 0
related: "B-datastore-failure", "G-replication-debugging", "G-profiling-workflow"
---

# Bugs and solutions

Every entry is either a **hypothetical case** (labelled, written to teach a diagnostic path) or a **workflow**
for finding the cause yourself. This vault was built without touching a Roblox place, so it contains no
"we fixed this in production" entries — inventing those would be dishonest.

## Hypothetical cases

| Case | Class | Severity |
|---|---|---|
| [[B-ui-button-drift-hypothetical]] | layout / responsive | low |
| [[B-audio-not-playing]] | asset access | high |
| [[B-animation-owner-mismatch]] | asset access / rig | high |
| [[B-datastore-failure]] | data loss | **critical** |
| [[B-remote-exploit-hypothetical]] | security | **critical** |
| [[B-streaming-out-nil]] | client/server mismatch | high |
| [[B-tween-fighting]] | conflicting writers | medium |
| [[B-sound-service-volume]] | lifecycle / leak | medium |
| [[B-duplicate-input-binding]] | input | medium |

## Workflows

- [[G-replication-debugging]] — client and server disagree
- [[G-profiling-workflow]] — frame time, memory, GPU
- [[G-datastore-failure-checklist]] — data did not save
- [[G-animation-owner-checklist]] — animation does not play
- [[G-asset-verification-workflow]] — is this asset usable at all?
- [[G-server-authority-checklist]] — review before shipping a remote

## Severity labels

| Label | Meaning |
|---|---|
| `critical` | loses money, data, or enables cheating |
| `high` | blocks a mechanic or a player |
| `medium` | visible defect with a workaround |
| `low` | cosmetic |

Find by **symptom**, not cause: players report "the door doesn't open", not "the remote rejects the payload".

