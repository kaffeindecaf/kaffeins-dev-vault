---
id: CP-client-server-rules
type: guide
title: Context pack — client/server rules
status: reviewed
updated: 2026-11-01
tags: [context-pack, agents]
source_urls: []
confidence: high
verification: design_only
client_server: both
code_blocks: 0
related: [ "AGENTS", "G-citation-rules" ]
---

# Context pack — client/server rules

The minimum an agent must hold in context before writing gameplay code.

Paste this block (or the note paths) into the agent's context. The rules are the compressed form of the linked
notes — where they conflict, the note wins and this pack needs fixing.

```text
1. Server decides every state a player can benefit from: money, inventory, position effects, visibility,
   round phase. The client requests and renders.
2. A remote never receives a value the server can derive (price, reward, distance). Derive it server-side.
3. Validate in this order: type -> range/shape -> physical possibility -> rate budget -> authority state.
4. Claim/occupancy maps are written **synchronously** before any yield. Clear them on reset, death, disconnect.
5. One writer per property. `WalkSpeed`, `FieldOfView`, `Health` are the usual contested ones.
6. Hidden/invisible is a server attribute, never a client flag.
7. Every connection and instance has an owner that cleans it up (janitor pattern).
8. Client raycasts are presentation only; streaming makes the client's world incomplete.
```

## Sources

- [[R-server-authority-replication]]
- [[R-remotes-and-validation]]
- [[R-request-rate-limiting]]
- [[G-server-authority-checklist]]
- [[R-script-types-and-placement]]

## Using it

```bash
python scripts/gamedev_kb.py context "client server authority" --budget 4000 --out exports/cp-client-server.md
```

A pack is a starting point, not a substitute for reading the note when the answer matters.
