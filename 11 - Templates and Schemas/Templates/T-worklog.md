---
id: T-worklog
type: template
title: Template — agent work log entry
status: draft
updated: 2026-11-01
tags: [template, agents, handoff]
source_urls: []
confidence: medium
verification: design_only
related: [ "T-handoff", "G-worklog-protocol", "N-AGENTS" ]
---

# Template — agent work log entry

> **Template.** One entry per session, written by the agent that did the work. Copy the block below
> into `09 - AI Agent Knowledge/Work Log/`, replace every `{{placeholder}}`, delete these
> instructions, and run `python scripts/gamedev_kb.py validate`. The protocol is [[G-worklog-protocol]].

Why it exists: the next agent reads the log, not your chat. A change table plus real command output
is what makes the next session cheap; a paragraph of summary is not.

```markdown
---
id: WL-{{YYYYMMDD}}-{{slug}}
type: worklog
title: Work log — {{date}} — {{one-line description of the change}}
status: draft
updated: {{date}}
tags: [worklog, {{area}}]
source_urls: []
confidence: {{low|medium|high}}
verification: {{tested_local|reference_only|design_only|untested}}
tested_at: {{date}}                                  # only when something really ran
test_evidence: "{{command and its real result, one line}}"
agent: {{harness and model, e.g. Hermes Agent (deepseek-flash)}}
related: [ "{{note IDs touched}}" ]
---

# Work log — {{date}} — {{one line}}

## 1. Task

{{What was asked, in one or two lines. Quote the request if it was specific.}}

**Scope I decided:** {{what this session covered — and what I deliberately left out.}}

## 2. What I did

1. {{action}} — {{why}}
2. {{action}} — {{why}}
3. {{action}} — {{why}}

## 3. What changed

| File | Change | Why | Verified by |
|---|---|---|---|
| `{{path}}` | {{added / edited / renamed / deleted}} | {{reason}} | {{command or check, or "not verified"}} |

{{If nothing changed, say "no files changed" and explain what the session produced instead.}}

## 4. How I verified it

| Check | Command | Real result |
|---|---|---|
| {{validate}} | `python scripts/gamedev_kb.py validate` | {{paste the actual count/errors line}} |
| {{index}} | `python scripts/gamedev_kb.py index` | {{paste}} |
| {{tests}} | `python -m unittest discover -s tests` | {{paste}} |

**Not verified:** {{what you did not run and why. "None" is only correct if you really ran everything.}}

## 5. Decisions and assumptions

| # | Decision / assumption | Reason | Reversible? |
|---|---|---|---|
| 1 | {{...}} | {{...}} | {{yes / no, because ...}} |

## 6. Open questions

- {{question}} — {{what would answer it}}

## 7. Logical next steps

Each step names a starting point and an observable "done" condition, so the next agent does not have
to re-derive the plan.

1. **{{step}}** — start at `{{file or command}}` — done when {{observable result}}.
2. **{{step}}** — start at `{{file or command}}` — done when {{observable result}}.
3. **{{step}}** — start at `{{file or command}}` — done when {{observable result}}.

## 8. For the next agent

{{Two or three sentences. What to read first, what to leave alone, and the one thing that would
waste the most time if it were repeated.}}
```

## Filling it honestly

- **Nothing in section 4 may be invented.** Paste real output or write "not run".
- `verification: tested_local` needs `test_evidence`, or `validate` warns
  `tested_without_evidence`. Use `design_only` when no command was run.
- **Section 3 is per file, not per idea.** If you did not touch it, it is not in the table.
- **Three next steps, not ten.** A list of ten is a wish, not a handoff.
- If the session produced reusable knowledge, that knowledge goes into the proper library note with
  its own `verification` label. It does not live only in the work log.
