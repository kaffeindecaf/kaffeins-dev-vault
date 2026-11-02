---
id: N-HOME
type: moc
title: HOME — GameDev Knowledge Base
status: reviewed
updated: 2026-11-02
tags: [home, dashboard]
source_urls: []
---

# 🏠 GameDev Knowledge Base · v1.0.0

**Backend systems:** [[T-backend-systems-catalog]] links all ten systems and their Luau modules.
Release notes: [[RELEASE-v1.0.0]]. Executed scope: [[BACKEND_SYSTEMS_TEST_REPORT]].

A working knowledge base for building Roblox games: an asset catalogue, a Luau engineering
encyclopedia, reusable mechanics, horror design, enemy AI, UI patterns, and hard rules for AI agents
that work in this vault. Everything is plain Markdown — it reads correctly in Obsidian *and* in any
editor or on GitHub, with no plugins.

**Start with [[START-HERE]]** if this is your first visit.

## The libraries

| Library | What is in it | Entry |
|---|---|---|
| Asset Library | 209 researched Roblox asset **candidates** — IDs, links, caveats | [[MOC-asset-library]] |
| Roblox Development | Luau, client/server, remotes, DataStores, physics, performance | [[MOC-roblox-development]] |
| Reusable Systems | Mechanics and ten backend systems with contracts, code and scoped tests | [[MOC-reusable-systems]] |
| Horror Design | Tension pacing, ambience, an adaptive director, accessibility | [[MOC-horror-design]] |
| Enemy AI | Server-owned FSM, perception, pathfinding, think budgets | [[MOC-enemy-ai]] |
| UI / UX & Game Feel | Responsive layout, tokens, prompts, camera feel, reduced motion | [[MOC-ui-and-game-feel]] |
| Level Design | Blockouts, routes, puzzles, procedural generation, playtests | [[MOC-level-design]] |
| Bugs & Solutions | Hypothetical-but-labelled failure cases and debug workflows | [[MOC-bugs]] |
| AI Agent Knowledge | AGENTS.md rules, per-tool briefs, prompts, context packs | [[MOC-agent-knowledge]] |
| Projects | Reusable project starter and a sample project | [[MOC-projects]] |
| Templates & Schemas | Note templates with valid frontmatter | [[MOC-templates]] |
| Reference Sources | Where every platform claim comes from | [[MOC-sources]] |
| Dashboards | Generated counts, health and recency | [[MOC-dashboards]] |

## Before you trust anything here

Three states are tracked honestly, and they are not the same thing:

- **written** — someone (usually an AI) wrote it down.
- **sourced** — it links an official source in `source_urls`.
- **verified** — it was actually run, and the evidence path is recorded.

A note that is only *written* says `verification: untested` or `design_only`. **All 209 asset
records are untested candidates.** A Creator Store listing proves an ID exists; it does not prove
the audio plays in your game, that you have permission, or that a model is safe. See
[[G-asset-verification-workflow]].

## Quick commands

```bash
# from the vault root
python scripts/gamedev_kb.py doctor            # environment + what's indexed
python scripts/gamedev_kb.py search "door creak" --limit 5
python scripts/gamedev_kb.py asset 9114145200  # exact ID, string-exact
python scripts/gamedev_kb.py context "server-authoritative pickup" --budget 6000
python scripts/gamedev_kb.py report --write-dashboards
```

Full command reference: [[README]]. Working state: [[STATUS]]. What is left: [[NEXT_STEPS]].

## Housekeeping

- Project onboarding and user goals: [[SOUL]] · [[checklist]] (separate from the vault [[ROADMAP]])
- Rules for AI agents: [[AGENTS]] · decision log: [[DECISIONS]] · metadata rules: [[SCHEMA]]
- Open problems: [[ISSUES]] · change history: [[CHANGELOG]] · licence policy: [[LICENSES_AND_SOURCES]]
- The task ledger this was built against: [[ROADMAP]]
