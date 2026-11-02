---
id: N-START-HERE
type: moc
title: START HERE — how to use this vault
status: reviewed
updated: 2026-11-01
tags: [start, guide]
source_urls: []
---

# 👋 Start here

## If you are a person

1. Read [[HOME]] — it is the map.
2. Want an asset? Go to [[MOC-asset-library]], then [[G-asset-verification-workflow]] — **most
   candidates will not work in your game until you check them.**
3. Want to build a mechanic? [[MOC-reusable-systems]] has the recipe, the server/client split, the
   failure cases and the test list.
4. Before you trust an API claim: [[MOC-roblox-development]] + [[G-roblox-api-links]].
5. Stuck on a weird bug? [[MOC-bugs]] first — it may already be written down.

## If you are an AI agent

Read [[AGENTS]], then `python scripts/gamedev_kb.py search "<topic>"`. Cite note paths in your
answer. Never invent IDs or test results. Report `untested` when you did not run it.

## The three-state honesty rule

| State | What it means | How it is marked |
|---|---|---|
| Written | a human or agent wrote it | `status: draft` |
| Sourced | points at a real source | `source_urls` filled + `confidence` |
| Verified | actually executed | `verification: tested_studio` + `test_evidence` |

Anything that is not verified must not be described as working. The whole vault follows this: 206
asset records are `untested`, every code block is labelled, and `TEST_REPORT.md` records only
commands that really ran.

## Where the game-specific truth lives

This vault is **reusable knowledge**. For any game project, use that project's own files and Studio
place as the source of truth. Keep the boundary: portable recipe here, project-specific facts there.
