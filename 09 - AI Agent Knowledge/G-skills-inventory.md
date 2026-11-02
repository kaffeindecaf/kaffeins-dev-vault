---
id: G-skills-inventory
type: guide
title: Skills inventory — what the agent harnesses can load
status: draft
updated: 2026-11-01
tags: [agents, skills, inventory]
source_urls: []
confidence: high
verification: reference_only
client_server: both
code_blocks: 0
related: [ "MOC-agent-knowledge", "AGENTS", "G-extraction-log", "G-skill-roblox-core-loop", "G-skill-roblox-mcp-workflow", "PR-datastore-review" ]
---

# Skills inventory

Two layers of agent knowledge exist, and they are not interchangeable.

| Layer | Where it lives | Scope |
|---|---|---|
| **Skills** | the harness (`~/.hermes/skills/…`, or the equivalent for other agents) | procedural, loaded on demand by trigger |
| **Vault notes** | this vault | reference material an agent reads or searches |

## Universal Roblox skills (game-agnostic, reusable)

| Skill | Use when |
|---|---|
| `roblox-mcp-workflow` | driving Studio over the MCP: tool quirks, safe edit batches, proof-before-done |
| `roblox-core-loop` | building/changing a round loop, economy, persistence, movement guard |
| `roblox-place-audit` | auditing a place for bugs, dead code and false claims |
| `roblox-cross-place-porting` | moving systems between places (scripts vs instances vs geometry) |

Obsidian graph bridges connect runtime skills to concrete notes: [[G-skill-roblox-core-loop]] links
the persistence skill to recipes, while [[G-skill-roblox-mcp-workflow]] links Studio work to the
asset-verification process. The bridge notes do not duplicate the harness skill files.

These universal skills were generalized from project-specific workflows after removing game names,
identifiers and economy details. See [[G-extraction-log]] for the code-generalization method.

## Project-specific skills

Project-specific skills can contain facts that are true only for one game: place identifiers, economy
values, script ownership and current changes. Keep them with that game's own files. **Do not merge
those facts into universal skills**; they become stale and can be mistaken for platform-wide guidance.

Rule of thumb:

- A lesson that would help a *different* game → belongs in a universal skill (fix it there, in one place).
- A fact about one game (id, folder, key, configuration value) → belongs in that game's skill or vault.

## How an agent should use both

1. Load the universal skill for the task shape (`roblox-core-loop` before touching a round loop).
2. Search the vault for the specific recipe or reference (`MOC-reusable-systems`).
3. Only then look at the selected project's own skills and files for its current identifiers and state.

## Keeping them honest

- A skill that describes a behaviour that no longer exists is worse than no skill: it makes a broken feature
  look documented. When the platform changes, patch the skill in the same session.
- Skills are edited where they live, not copied into the vault. This page is an index, not a backup.
