---
id: SRC-creator-hub-cross-server-messaging
type: source
title: "Cross-server messaging"
status: reviewed
updated: 2026-11-02
tags: [source, official, roblox]
source_urls: [ "https://create.roblox.com/docs/cloud-services/cross-server-messaging", "https://create.roblox.com/docs/reference/engine/classes/MessagingService/SubscribeAsync" ]
confidence: high
verification: reference_only
client_server: both
code_blocks: 0
related: [ "MOC-sources", "G-roblox-api-links" ]
---

# Cross-server messaging

| Field | Value |
|---|---|
| URL | https://create.roblox.com/docs/cloud-services/cross-server-messaging |
| Publisher | Roblox (Creator Hub — official) |
| Accessed | 2026-11-02 (setup guide and delivery contract opened during backend work) |
| Type | official documentation |

## What it establishes

- MessagingService delivers topic messages between servers
- Delivery is best effort and not guaranteed. Do not use a message as the only durable record.

The earlier at-least-once claim was corrected during v1.0.0 work. See the
[SubscribeAsync contract](https://create.roblox.com/docs/reference/engine/classes/MessagingService/SubscribeAsync)
and [[SRC-backend-platform-contracts]].

## What it does not establish

- It is a summary of the page's topic, not a full transcription. The page is canonical; this note is an index entry.
- Documentation describes current platform behaviour and changes without notice — the access date above is the
  only guarantee.
- It does not establish that any specific asset ID in this vault is usable.

## Used by

Notes in [[MOC-roblox-development]] cite this source. See [[G-roblox-api-links]] for the full index.
