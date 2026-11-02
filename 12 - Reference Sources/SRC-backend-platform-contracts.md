---
id: SRC-backend-platform-contracts
type: source
title: Backend system platform contracts — primary documentation
status: draft
updated: 2026-11-02
tags: [source, backend, roblox, luau]
source_urls: ["https://create.roblox.com/docs/reference/engine/classes/GlobalDataStore","https://create.roblox.com/docs/reference/engine/classes/MarketplaceService","https://create.roblox.com/docs/production/monetization/developer-products","https://create.roblox.com/docs/cloud-services/memory-stores","https://create.roblox.com/docs/reference/engine/classes/MessagingService","https://create.roblox.com/docs/workspace/streaming","https://create.roblox.com/docs/reference/engine/classes/RemoteEvent","https://create.roblox.com/docs/reference/engine/classes/UnreliableRemoteEvent","https://create.roblox.com/docs/reference/engine/classes/Animator","https://create.roblox.com/docs/reference/engine/classes/AnimationTrack","https://create.roblox.com/docs/reference/engine/classes/HttpService","https://create.roblox.com/docs/cloud-services/data-stores/error-codes-and-limits","https://luau.org/library/"]
confidence: medium
verification: reference_only
accessed: 2026-11-02
related: ["T-backend-systems-catalog"]
---

# Backend system platform contracts

Primary pages opened on 2026-11-02 while implementing [[T-backend-systems-catalog]]. This records documentation evidence separately from runtime evidence in [[BACKEND_SYSTEMS_TEST_REPORT]]. The owner's supplied Gemini list supplied feature ideas, not executable code or authoritative API guarantees.

| Primary source | Relevant contract |
|---|---|
| [GlobalDataStore](https://create.roblox.com/docs/reference/engine/classes/GlobalDataStore) | UpdateAsync operates on one key; its transform may be repeated and must not yield. Preserve metadata/user associations when replacing a record. |
| [MarketplaceService](https://create.roblox.com/docs/reference/engine/classes/MarketplaceService), [Developer products](https://create.roblox.com/docs/production/monetization/developer-products) | Receipt processing and gamepass ownership have different flows. Durable receipt acknowledgment and replay protection belong in the server fulfillment owner. |
| [Memory stores](https://create.roblox.com/docs/cloud-services/memory-stores) | Suitable for ephemeral cross-server coordination; expiring hints do not replace durable transaction records. |
| [MessagingService](https://create.roblox.com/docs/reference/engine/classes/MessagingService) | Wake-ups must tolerate best-effort delivery. |
| [Instance streaming](https://create.roblox.com/docs/workspace/streaming) | Engine-managed replication and client cosmetic culling address different layers. |
| [RemoteEvent](https://create.roblox.com/docs/reference/engine/classes/RemoteEvent), [UnreliableRemoteEvent](https://create.roblox.com/docs/reference/engine/classes/UnreliableRemoteEvent) | Instrument supported public sends/listeners explicitly. Application estimates do not reveal the exact compressed network representation. |
| [Animator](https://create.roblox.com/docs/reference/engine/classes/Animator), [AnimationTrack](https://create.roblox.com/docs/reference/engine/classes/AnimationTrack) | Capture active tracks and replay their sampled timing on separate ghost animators. Asset availability still requires runtime testing. |
| [HttpService](https://create.roblox.com/docs/reference/engine/classes/HttpService) | JSON encoding is local; actual requests have failure/enablement considerations and must keep credentials server-only. |
| [Data store errors and limits](https://create.roblox.com/docs/cloud-services/data-stores/error-codes-and-limits) | Size and request constraints require budgets, not unbounded retry loops. |
| [Luau standard library](https://luau.org/library/) | Weak tables, debug tracebacks, table copies and separate wall/monotonic clock uses. |

## Implementation choices, not platform promises

The outbox/inbox saga, history caps, token buckets, 60-second leak grace, sampling budgets, UTC day policy and exact account schema are original design decisions. The documentation does not certify those choices or establish that the modules are production-safe.

A successful Studio mock test cannot prove durable multi-server semantics, paid delivery, heap root attribution, actual wire bytes or device performance. All such claims retain explicit limits in their system note. No external package was installed or source implementation copied. The local test runner follows Roblox's unit-test skill format and is attributed in its header.
