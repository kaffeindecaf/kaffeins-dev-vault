---
id: T-project
type: template
title: Template — project workspace README
status: reviewed
updated: 2026-11-01
tags: [template]
source_urls: []
confidence: medium
verification: design_only
---

# Template — project workspace README

> **Template.** Copy the block below into a new note, replace every `{placehold}`, and delete these
> instructions. Copy _PROJECT_TEMPLATE and fill this in first; everything else links from here.

```markdown
---
id: P-{{slug}}
type: project
title: {{Project Name}}
status: idea
updated: {{date}}
tags: [project]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 0
related: [ "MOC-projects" ]
---

# {{Project Name}}

## One line
{{what the player does, in one sentence}}

## Source of truth
| Thing | Where |
|---|---|
| Code | {{Studio place or repo; this vault is documentation, not code}} |
| Design | this folder |
| Assets | ASSET_MANIFEST in this folder |

## Scope
- In: {{...}}
- Out: {{...}}   <- write this first

## Milestones
| # | Milestone | Done when | Status |
|---|---|---|---|
| 1 | {{...}} | {{observable}} | not started |

## Risks
| Risk | Mitigation |
|---|---|
| {{...}} | {{...}} |

## Links
- Systems used: {{S-* notes}}
- Open questions: ISSUES.md in this folder
```
