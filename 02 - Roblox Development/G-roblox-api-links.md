---
id: G-roblox-api-links
type: guide
title: Roblox API links — the canonical sources
status: reviewed
updated: 2026-11-01
tags: [sources, docs, api]
source_urls: [ "https://create.roblox.com/docs" ]
confidence: high
verification: reference_only
related: [ "MOC-sources" ]
---

# Canonical Roblox sources

When a note in this vault and the platform documentation disagree, **the documentation wins** — and
that note needs fixing ([[G-knowledge-promotion]]).

| Topic | Canonical page |
|---|---|
| Luau language | https://create.roblox.com/docs/luau |
| Type checking | https://create.roblox.com/docs/luau/type-checking |
| Scripts and placement | https://create.roblox.com/docs/scripting |
| Modules | https://create.roblox.com/docs/scripting/module |
| Client/server model | https://create.roblox.com/docs/projects/client-server |
| Remotes | https://create.roblox.com/docs/scripting/events/remote |
| DataStores | https://create.roblox.com/docs/cloud-services/data-stores |
| Memory stores | https://create.roblox.com/docs/cloud-services/memory-stores |
| Cross-server messaging | https://create.roblox.com/docs/cloud-services/cross-server-messaging |
| Streaming | https://create.roblox.com/docs/workspace/streaming |
| Raycasting | https://create.roblox.com/docs/workspace/raycasting |
| Collisions / groups | https://create.roblox.com/docs/workspace/collisions |
| Animations | https://create.roblox.com/docs/animation/using |
| Audio assets | https://create.roblox.com/docs/audio/assets |
| Publishing | https://create.roblox.com/docs/production/publishing/publish-games-and-places |
| API reference | https://create.roblox.com/docs/reference/engine |

`docs.reference.engine.classes.<Class>` (e.g. `/docs/reference/engine/classes/Humanoid`) is the
per-class reference. When citing a class in a note, link the class page, not the search page.

## How this vault cites

Every `reference` note carries `source_urls` pointing at these pages, and `confidence` describing how
strong the link between note and source is. Notes that restate documentation are `verification:
reference_only` — they are a summary, not an executed test.

DevForum threads appear only as `F`-grade leads, never as authority. See [[SCHEMA]] §6.
