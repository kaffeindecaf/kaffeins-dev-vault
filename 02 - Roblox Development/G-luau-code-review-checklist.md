---
id: G-luau-code-review-checklist
type: guide
title: Luau code review checklist
status: reviewed
updated: 2026-11-01
tags: [review, quality, luau]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 0
related: [ "G-server-authority-checklist", "R-script-types-and-placement", "PR-luau-code-review" ]
---

# Luau review checklist

Ten minutes with this list catches most of what a playtest would find an hour later.

## Placement and context

- [ ] `Script` on the server, `LocalScript` under a client container, `ModuleScript` required (never running alone)
- [ ] No server module required from a client script
- [ ] `ResetOnSpawn = false` on persistent HUDs
- [ ] Character scripts tolerate the character dying and respawning

## Authority

- [ ] Server decides money, inventory, scores, visibility
- [ ] Remotes validate type, range and physical possibility ([[G-server-authority-checklist]])
- [ ] No value accepted from the client that the server can derive
- [ ] Per-player rate limits on remotes

## Correctness

- [ ] `#` used only on sequences
- [ ] `pcall` around external calls (DataStore, HTTP), not around logic
- [ ] Every yield (`WaitForChild`, `MoveToFinished`) has a timeout or a guard
- [ ] No `while true do task.wait() end` for per-frame work

## Resources

- [ ] Connections cleaned on death/leave (janitor)
- [ ] No `Instance.new` per frame
- [ ] Looped sounds stopped on state change
- [ ] No duplicate input bindings for one key

## Quality

- [ ] Types annotated for public module APIs
- [ ] Config values from the config module, not inline literals
- [ ] Debug logging gated by `DebugConfig.ENABLED` (off in release)
- [ ] Error paths warn instead of silently returning

## The three questions

1. If a hostile client sent anything, what breaks?
2. If a player leaves mid-operation, what leaks?
3. If this runs 1000 times, what grows?
