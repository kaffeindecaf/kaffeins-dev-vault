---
id: N-AGENTS
type: guide
title: AGENTS — the contract for AI agents working in this vault
status: draft
updated: 2026-11-01
tags: [agents, rules, safety]
source_urls: []
---

# AGENTS — read this before you touch anything

You are working inside a **knowledge vault**, not a game project. It documents Roblox development;
it is not a place where game code runs.

## 1. Boundaries

- **Write only inside this vault root.** Never touch unrelated folders or any Roblox place unless the
  user explicitly asks in that message.
- `imports/raw/**` is **read-only**: it is the research record, byte-exact and hashed
  (`imports/raw/SOURCE_MANIFEST.json`). Never "clean it up".
- The public tree omits the local raw manifest because it contains a machine-specific path; see
  `imports/SOURCE_MANIFEST_PUBLIC.json` for the sanitized hash record.
- Never edit `.obsidian/` without explicit approval.
- Do not install software, plugins, or packages; do not publish, purchase, upload, or change
  permissions or accounts. Ask.
- Never write secrets into a note, an export, or a commit. `.env`-like files are excluded from
  indexing and must stay that way.

## 2. Read before you write

1. [[SCHEMA]] — required frontmatter, IDs, controlled values.
2. The MOC for the area you are touching ([[MOC-start-here]] lists them).
3. `python scripts/gamedev_kb.py search "<topic>"` — do not re-invent what is already documented.
4. If the topic is specific to a game project, that project's vault is the source of truth, not this one.

## 3. Truth rules (the part that actually matters)

- **Never invent an asset ID, a URL, a test result or a permission.** An ID you cannot find is
  "not found". A test you did not run is `untested`. A page you did not open is not "verified".
- **A Creator Store listing is not permission.** `source_grade: D` means a page existed on the
  research date. `access_status` and `license_status` stay `unknown` until someone checks in Studio.
- **Do not upgrade evidence.** If you did not execute it, it is `design_only` or `reference_only`.
  If you executed it in Studio, set `tested_studio` **and** `test_evidence` with a path/date.
- **State the confidence you actually have.** `confidence: low` is a professional answer.
- **Distinguish your recollection from the vault.** A remembered API detail is a hypothesis; cite
  a `SRC-*` note or say it is unchecked.

## 4. Tagging what you write

Every new note needs valid frontmatter per [[SCHEMA]] (`id`, `type`, `title`, `status`, `updated`,
`tags`). Code blocks get a label line immediately above them:

```text
Tested:      ran in Studio, evidence recorded
Untested:    compiles by inspection only
Pseudocode:  structure, not runnable
```

## 5. Knowledge promotion

`idea → draft → reviewed → tested` (see [[G-knowledge-promotion]]). A draft written by an agent is
**not** accepted knowledge. Never mark `reviewed` on your own output unless a human or a test
confirmed it.

## 6. When you finish

- Update the note you changed, append to [[CHANGELOG]], and record anything unresolved in [[ISSUES]].
- Re-run `python scripts/gamedev_kb.py validate` and `index`; paste the real output.
- Report: what changed, what you verified and how, what is still open. No adjectives.
- Template for the wrap-up: [[T-session-wrapup]].

## 7. Tool access

This vault is designed for **filesystem + CLI** access, which every agent harness has. Nothing here
requires a special integration. Per-harness briefs (Hermes, Claude Code, Codex, Gemini CLI, OpenCode)
live in [[MOC-agent-knowledge]]; they differ in commands, not in rules. If a harness cannot read
files, it can still be given the output of `context`.
