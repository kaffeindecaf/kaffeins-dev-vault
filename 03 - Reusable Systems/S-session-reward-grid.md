---
id: S-session-reward-grid
type: system
title: Session reward grid with server-owned claims
status: draft
updated: 2026-11-02
tags: [ui, rewards, progression, luau]
source_urls: []
confidence: medium
verification: design_only
client_server: both
roblox_services: [ReplicatedStorage, Players]
code_blocks: 0
related: [ "R-grow-a-tree-pattern-audit", "S-objective-tracker", "S-ui-collection-card-component" ]
---

# Session reward grid with server-owned claims

Show a finite sequence of time-based rewards, the next wait, and an explicit claim state. Choose a grid for a small set of comparable rewards; a scrolling list is better when labels or the number of rewards vary widely. This is an adaptation of the static observations in [[R-grow-a-tree-pattern-audit]], not copied game code.

## Evidence and contract

`StarterGui.PlaytimeRewards.MainFrame.RewardGrid` uses a LayoutOrder-sorted UIGridLayout and `Reward1` through `Reward6`; its controller renders countdown, READY! or CLAIMED, a claimed count and next-reward timer. `ServerScriptService.PlaytimeRewardServiceV2` holds the six thresholds and rewards, tracks session start and claims per player, validates index and elapsed time, and uses a per-player lock. It clears session state on PlayerRemoving. The client estimates elapsed time each second and invokes a claim; the server response replaces the displayed snapshot. This is session state, not proof that claim markers persist across sessions. Grant calls and asynchronous saves were read, but their failure and durability semantics were not verified.

For a reusable design, use stable reward keys, not array indices, for persisted claims. The server derives eligibility and reward from its own configuration, enforces request limits and serializes concurrent claims. Define failure and retry semantics with the persistence system; do not claim exactly-once durability without an atomic/idempotent grant protocol. The client renders snapshots and sends only an intent; local time is a hint. `session-reward-card.luau` is an **untested** presentation-only template; integrate it with an existing trusted server contract.

## Accessibility and review

Text communicates waiting, ready and claimed without color alone. Provide clear focus order and restored focus on close, keyboard/gamepad activation, touch-sized targets, safe areas, readable countdowns, and localization space. Respect reduced motion. Update visible timers at an appropriate cadence and disconnect handlers on teardown; profile before optimizing. Verify server timing, retries, double claims, reconnects, grant failures, narrow screens and actual input methods in a safe test place.
