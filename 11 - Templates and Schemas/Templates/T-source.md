---
id: T-source
type: template
title: Template — source record
status: reviewed
updated: 2026-11-01
tags: [template]
source_urls: []
confidence: medium
verification: design_only
---

# Template — source record

> **Template.** Copy the block below into a new note, replace every `{placehold}`, and delete these
> instructions. One note per external source worth citing; the vault cites these, not the internet in general.

```markdown
---
id: SRC-{{slug}}
type: source
title: {{source title}}
status: reviewed
updated: {{date}}
tags: [source]
source_urls: [ "{{url}}" ]
confidence: {{high|medium|low}}
verification: reference_only
client_server: both
code_blocks: 0
related: [ "MOC-sources" ]
---

# {{Source title}}

| Field | Value |
|---|---|
| URL | {{url}} |
| Publisher / author | {{name, only if shown}} |
| Accessed | {{date}} |
| Type | {{official doc / tutorial / forum post / other}} |

## What it establishes
- {{claim, short paraphrase}}

## What it does not establish
{{limits: version, platform, scope, opinion vs fact}}

## Used by
- {{note that cites this}}

## Notes
{{anything that will go stale soon; the access date is the anchor}}
```
