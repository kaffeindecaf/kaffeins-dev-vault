---
id: T-session-wrapup
type: template
title: Template — AI session wrap-up
status: reviewed
updated: 2026-11-01
tags: [template]
source_urls: []
confidence: medium
verification: design_only
---

# Template — AI session wrap-up

> **Template.** Copy the block below into a new note, replace every `{placehold}`, and delete these
> instructions. End every session with this. It is what makes the next session cheap.

```markdown
---
id: N-{{slug}}
type: report
title: Session wrap-up — {{date}}
status: reviewed
updated: {{date}}
tags: [session, handoff]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 0
related: [ "STATUS", "CHANGELOG" ]
---

# Session wrap-up — {{date}}

## Completed
| Task ID | What | Evidence |
|---|---|---|
| {{P00-01}} | {{what}} | {{command output or file}} |

## Changed files
- `{{path}}` — {{what changed}}

## Verified
| Check | Command | Result |
|---|---|---|
| validate | `python scripts/gamedev_kb.py validate` | {{0 errors}} |

## Not verified / open
- {{what you did not run, and why}}

## Blockers
- {{blocker, or none}}

## Next three actions
1. {{...}}
2. {{...}}
3. {{...}}
```
