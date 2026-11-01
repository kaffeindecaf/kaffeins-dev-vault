---
id: T-handoff
type: template
title: Template — handoff brief for the next agent
status: draft
updated: 2026-11-01
tags: [template, agents, handoff]
source_urls: []
confidence: medium
verification: design_only
related: [ "T-worklog", "G-worklog-protocol", "N-NEXT-STEPS" ]
---

# Template — handoff brief for the next agent

> **Template.** Use when work stops mid-stream: a limit was hit, a decision needs a human, or the
> next step needs Studio. A work log ([[T-worklog]]) records what happened; this brief records
> **where the next session starts**. Both go in `09 - AI Agent Knowledge/Work Log/`.

```markdown
---
id: WL-{{YYYYMMDD}}-{{slug}}-handoff
type: worklog
title: Handoff — {{what is half-finished}}
status: draft
updated: {{date}}
tags: [worklog, handoff, {{area}}]
source_urls: []
confidence: {{low|medium|high}}
verification: {{design_only|tested_local|reference_only}}
agent: {{harness and model}}
related: [ "{{worklog id}}", "{{notes in flight}}" ]
---

# Handoff — {{what is half-finished}}

## State in five lines

- Last commit: `{{hash}}` — {{subject}}
- Working tree: {{clean / N files modified — list them}}
- Last verified command: `{{command}}` → {{real result}}
- In flight: {{the one thing that is part-done, if any}}
- Blocked on: {{human decision / Studio access / nothing}}

## Read first, in this order

1. [[{{worklog id}}]] — what the last session did and why
2. [[{{note}}]] — the note being edited
3. [[MOC-{{area}}]] — what already exists, so you do not duplicate it

## Next three actions

1. **{{action}}** — run `{{exact command}}` — done when {{observable result}}.
2. **{{action}}** — edit `{{path}}` — done when {{observable result}}.
3. **{{action}}** — run `{{exact command}}` — done when {{observable result}}.

## Do not touch

- `imports/raw/**` — byte-exact research record, hashed in `imports/raw/SOURCE_MANIFEST.json`.
- {{anything else that would be expensive to undo}}

## Traps already hit

| Trap | What it looked like | What worked |
|---|---|---|
| {{...}} | {{...}} | {{...}} |

## Definition of done for this thread

{{The single observable condition that lets the next agent stop. Example: "validate reports 0
errors, the new template appears in MOC-templates, and the entry is in CHANGELOG."}}
```
