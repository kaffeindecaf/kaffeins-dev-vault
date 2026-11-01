---
id: G-replication-debugging
type: guide
title: Replication debugging workflow
status: reviewed
updated: 2026-11-01
tags: [debugging, replication, workflow]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 1
related: "R-server-authority-replication", "S-late-join-sync", "R-attributes-vs-values-vs-config"
---

# Client/server disagreement

The symptom is always "it looks right to me and wrong to them".

## The five questions

1. **Who wrote the value?** Server or client? Grep the write.
2. **Did it replicate?** Set on the server, read on the client after a frame.
3. **Can the client overwrite it?** Anything the client also writes *will* diverge.
4. **Did it replicate in time?** A value set right before a transition can arrive after the client moved on.
5. **Is it the same instance?** A client-side clone looks identical and shares nothing.

## Method

```lua
-- Untested: temporary probe, remove before shipping
print("server", instance[prop])
task.delay(0.5, function() print("server+0.5s", instance[prop]) end)
```

If server and client agree in the log but the screen differs, the value was copied into local state once and
never updated (a read instead of a listener).

## Ranked causes

| Rank | Cause | Tell |
|---|---|---|
| 1 | Client writes state it does not own | a LocalScript in the call stack |
| 2 | Attribute set before the instance replicated | works after respawn, fails on join |
| 3 | `Changed` vs `GetAttributeChangedSignal` mixed | server changed, listener never fired |
| 4 | Remote fired before the client bound its listener | works from round 2 |
| 5 | Streaming | parts missing client-side |
| 6 | Instance identity confusion | a clone edited, the original displayed |

## Prove the boundary

Set on the server, observe the client. Then set on the client, observe the server. Only one direction should
ever agree on your state — if both do, you have two writers.

