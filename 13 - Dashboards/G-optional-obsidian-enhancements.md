---
id: G-optional-obsidian-enhancements
type: guide
title: Optional Obsidian enhancements (nothing installed, nothing required)
status: reviewed
updated: 2026-11-01
tags: [obsidian, plugins, optional]
source_urls: []
confidence: medium
verification: reference_only
client_server: both
code_blocks: 0
related: [ "HOME", "README", "PROJECT_CONFIG" ]
---

# Optional enhancements

**No community plugin is installed and none is required.** Everything in this vault is plain Markdown; the
dashboards are generated files, not queries. This page exists so you can opt in knowingly.

| Enhancement | What it would add | Cost / risk | Recommended? |
|---|---|---|---|
| **Obsidian Bases** (core, newer) | live table views over frontmatter | low — core feature, no install | Optional. The generated `DB-*.md` files already do this statically. |
| **Dataview** | dynamic lists/queries (`TABLE type FROM ...`) | community plugin; queries live in notes and can hide errors | Optional, after the schema stabilises |
| **Templater** | templating with JS expressions | community plugin; runs code in the vault | Optional; the `Tpl-*` files work with the core Templates plugin |
| **Excalidraw** | hand-drawn diagrams | community plugin; `.excalidraw` files are not portable text | Optional; ASCII/Mermaid wireframes are in `G-ui-wireframe-template` |
| **Obsidian Git** | automatic commits/sync | community plugin + a git repo; OneDrive already versions the folder | Not recommended while the vault lives in OneDrive (conflict risk) |

## If you enable Dataview later

Equivalent queries for the generated dashboards:

```text
TABLE type, verification, updated FROM "01 - Asset Library" WHERE type = "asset" SORT updated DESC LIMIT 20
TABLE status, length(rows) FROM "" WHERE id GROUP BY type
```

The static fallbacks in `13 - Dashboards/` remain correct regardless — that is the point of generating them.

## If you enable Templater later

Point it at `11 - Templates and Schemas/Templates/`. The templates use `{{placeholder}}` markers, not Templater's
`<% %>` syntax, so they work in any editor; convert them only if you want interactive prompts.

## Rules if you do install something

1. Read the plugin's permissions; a plugin can read every file and publish.
2. Never install a plugin because a model, a note or a blog told you to ([[AGENTS]]).
3. If a plugin changes how notes render, the vault must still be readable without it.
4. Record the decision in [[DECISIONS]].
