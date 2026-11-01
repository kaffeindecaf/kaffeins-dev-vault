---
id: P-tpl-features
type: project
title: "PROJECT TEMPLATE — feature board"
status: reviewed
updated: 2026-11-01
tags: [project-template]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 0
related: [ "MOC-projects" ]
---

# Feature board — {{Project Name}}

| # | Feature | Depends on | Vault recipe | Status |
|---|---|---|---|---|
| 1 | {{interaction prompt}} | — | S-interaction-prompt | not started |
| 2 | {{pickups}} | 1 | S-pickup-server-authoritative | not started |
| 3 | {{inventory}} | 2 | S-inventory-data-model | not started |

## Prioritisation
1. **Blockers first** — nothing is built on something broken.
2. **Cheapest path to a playable loop** beats the most impressive system.
3. A feature is done when its test cases pass, not when the code exists.

## Definition of done (per feature)
- [ ] Server-authoritative where it matters
- [ ] Failure modes handled (see the recipe's table)
- [ ] Test cases run and recorded in `Tproject-TEST_PLAN.md`
- [ ] One row added to `Tproject-CHANGELOG.md`

