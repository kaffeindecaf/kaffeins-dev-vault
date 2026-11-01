---
id: G-reading-order
type: guide
title: Reading order — humans, agents, and the three-minute version
status: reviewed
updated: 2026-11-01
tags: [start, guide, agents]
source_urls: []
confidence: high
verification: reference_only
client_server: both
code_blocks: 0
related: [ "HOME", "AGENTS", "MOC-start-here" ]
---

# Reading order

## Three minutes (anyone)

1. [[HOME]] — the map.
2. [[README]] — how to run the search CLI.
3. [[STATUS]] — what actually exists today, including what does not.

## Ten minutes (about to build something)

4. [[MOC-asset-library]] — and read the warning at the top before you pick an asset.
5. [[G-asset-verification-workflow]] — the five checks that turn a candidate into a usable asset.
6. The recipe for your mechanic in [[MOC-reusable-systems]].

## A full session (an AI agent)

7. [[AGENTS]] — boundaries, truth rules, what needs approval.
8. [[SCHEMA]] — frontmatter before you write a single note.
9. The MOC for the area, then `python scripts/gamedev_kb.py search "<topic>" --json`.
10. Before finishing: `validate`, `index`, and append [[CHANGELOG]].

## The one paragraph version

This vault is a **lookup with memory**: 206 asset candidates, 24 engineering notes, 20 mechanic recipes, 17
horror-design notes, 14 AI notes, 20 UI notes and 14 level-design notes — plus the rules that keep an AI from
inventing a permission, a test result or an asset ID. Nothing in it has been run in Roblox Studio. Treat
`untested` as the default state of the world, and verify what you ship.
