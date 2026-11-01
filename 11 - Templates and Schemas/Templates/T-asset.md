---
id: T-asset
type: template
title: Template — candidate asset record
status: reviewed
updated: 2026-11-01
tags: [template]
source_urls: []
confidence: medium
verification: design_only
---

# Template — candidate asset record

> **Template.** Copy the block below into a new note, replace every `{placehold}`, and delete these
> instructions. Frontmatter matches what scripts/import_assets.py generates, so a hand-made asset note validates identically.

```markdown
---
id: A-{{asset_id}}
type: asset
title: "{{asset name}}"
status: idea
updated: {{date}}
tags: [{{asset_type}}, asset-candidate]
category: "{{research category}}"
asset_id: "{{asset_id}}"          # STRING, exact digits, no separators
asset_type: {{audio|animation|model|decal|image|mesh|plugin|unknown}}
usage_uri: "rbxassetid://{{asset_id}}"   # audio/animation only
source_grade: {{D|G|R|F|I|S}}
listing_status: {{listed|not_listed|unknown}}
access_status: unknown            # shared|restricted|blocked only with access_evidence
license_status: unknown
safety_status: uninspected
studio_status: not_tested
verification: untested
confidence: low
source_urls: [ "{{listing url}}" ]
related: [ "MOC-asset-library" ]
---

# {{asset name}}

**Candidate, not an approved asset.** {{what the research recorded}}

| Field | Value |
|---|---|
| Asset ID | `{{asset_id}}` |
| Type | `{{asset_type}}` |
| Evidence grade | `{{grade}}` — {{what that grade means}} |
| Source | {{url}} |
| Suggested use | {{use}} |

## How it would be used
- Form: {{Sound / Animation / Toolbox insertion / plugin}}
- {{exact usage note, including the wrong way to use it}}

## Verification checklist
- [ ] Listing resolves and matches name/type
- [ ] Access confirmed for this experience
- [ ] Quality judged in context
- [ ] Rights checked ([[LICENSES_AND_SOURCES]])
- [ ] Outcome recorded here and in ASSET_VERIFICATION_REPORT

## Provenance
```json
{{verbatim source row}}
```
```
