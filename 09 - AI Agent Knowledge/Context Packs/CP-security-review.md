---
id: CP-security-review
type: guide
title: Context pack — security review
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

# Context pack — security review

Hold this before approving a remote, an admin tool or a purchase path.

Paste this block (or the note paths) into the agent's context. The rules are the compressed form of the linked
notes — where they conflict, the note wins and this pack needs fixing.

```text
1. Ask: "if a hostile client sent the worst possible payload right now, what happens?"
2. Prices, rewards and distances are server config. A client-supplied price is a critical bug.
3. Per-player token bucket on every remote; deny cheaply and count denials.
4. Admin tools: authority by user id from a server-only config; parse only after the check.
5. Studio-only grants are still grants — gate on IsStudio and admin, never on admin alone in a published build.
6. No secrets in notes, exports or logs; truncate client payloads before logging.
7. Never install a plugin or execute an imported model's scripts without a human decision.
8. Report severity honestly: critical = money, data or cheating.
```

## Sources

- [[G-server-authority-checklist]]
- [[R-request-rate-limiting]]
- [[B-remote-exploit-hypothetical]]
- [[G-admin-command-pattern]]
- [[R-content-and-ownership]]

## Using it

```bash
python scripts/gamedev_kb.py context "client server authority" --budget 4000 --out exports/cp-client-server.md
```

A pack is a starting point, not a substitute for reading the note when the answer matters.
