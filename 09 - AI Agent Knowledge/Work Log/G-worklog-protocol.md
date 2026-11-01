---
id: G-worklog-protocol
type: guide
title: Work log protocol — what every agent records and hands on
status: draft
updated: 2026-11-01
tags: [agents, workflow, handoff, worklog]
source_urls: []
confidence: high
verification: reference_only
related: [ "N-AGENTS", "T-worklog", "T-handoff", "N-CHANGELOG", "N-STATUS" ]
---

# Work log protocol

The vault already records **what is known** (library notes), **what changed at release level**
([[CHANGELOG]]) and **what is still open** ([[ISSUES]]). What it did not record was **what the last
agent actually did, and what it would do next**. That is this folder.

One session that changes the vault writes **one** entry here. That entry is the first thing the next
agent reads.

## 1. Where it goes

| Thing | Path | Template |
|---|---|---|
| Session record | `09 - AI Agent Knowledge/Work Log/worklog-YYYY-MM-DD-<slug>.md` | [[T-worklog]] |
| Stop-mid-stream brief | `09 - AI Agent Knowledge/Work Log/worklog-YYYY-MM-DD-<slug>-handoff.md` | [[T-handoff]] |

- File name: `kebab-case`, dated, one slug. Two sessions on one day get two slugs, not one file.
- ID: `WL-YYYYMMDD-<slug>` (handoff: `...-handoff`). `type: worklog`, `status: draft`.
- `status` stays `draft` forever — a work log is a record, not accepted knowledge. To mark that a
  human has read it, set `status: reviewed`; never do that to your own unread output.

## 2. Read before you write

```sh
python scripts/gamedev_kb.py search "worklog" --type worklog --limit 5
python scripts/gamedev_kb.py search "handoff" --type worklog --limit 5
```

Newest entries win. If the newest entry's "next steps" contradicts [[NEXT_STEPS]] or [[ISSUES]], the
work log is the more recent evidence — say so in your own entry instead of silently following either.

## 3. What goes in an entry

Required, because it is what makes the next session cheap:

1. **Task and scope** — what was asked, and what you decided was in and out.
2. **What changed** — a table of file → change → why → verified by. One row per file.
3. **Verification** — the real commands and their real output. `validate`, `index`, and `unittest`
   are the default set. If you skipped one, write "not run" and the reason.
4. **Decisions and assumptions** — with reversibility.
5. **Open questions** — the things you could not settle.
6. **Three logical next steps** — each with a starting point and an observable "done" condition.

Not required: chronology, narration, an account of your reasoning process, or a list of everything
you read. The log is a diff of intent, not a diary.

## 4. Truth rules that apply to the log

- Paste output, do not paraphrase it. "validate passed" is worth nothing; `498 notes checked · 0
  errors` is a fact someone can reproduce.
- If a command failed, the failure goes in the log. A log with no failures is a log that is hiding
  something or a session that did nothing hard.
- Do not record a verification level the work does not have. Editing a Markdown note is
  `tested_local` at best (the validator ran); it is never `tested_studio`.
- Do not copy secrets, tokens, or machine-specific absolute paths into an entry. The vault is
  published.

## 5. Relationship to the other records

| Record | Question it answers | Owner | Lifetime |
|---|---|---|---|
| Work log | What did the last session do, and what is next? | the agent that did the work | appended per session, kept forever |
| [[CHANGELOG]] | What changed in the vault, in release terms? | human maintainer | edited at release points |
| [[STATUS]] | What is the current build state? | human maintainer | overwritten each time |
| [[ISSUES]] | What is open and why? | whoever finds it | open items only |
| Library note | What is true, and how well supported? | reviewers | promoted idea → tested |

If a session produces knowledge, it lands in the right library note with its own `verification`
label **and** gets a work-log entry pointing at it. The work log never becomes the only place a fact
lives.

## 6. Closing a session

```sh
python scripts/gamedev_kb.py validate
python scripts/gamedev_kb.py index
python scripts/build_mocs.py
python scripts/gamedev_kb.py report
```

Then append a dated line to [[CHANGELOG]] ("session log" section), write the work log entry, and — if
work is unfinished — the handoff brief. Update [[NEXT_STEPS]] only if the top-level priorities
actually changed.

## 7. Why not just one big diary file

A single growing log becomes a merge conflict and a wall nobody reads. One file per session keeps
each entry independently reviewable in a pull request, keeps diffs small, and lets an agent search by
date or slug. The folder is small by construction because entries are never rewritten — they are
superseded.
