---
id: G-player-privacy
type: guide
title: Player privacy — what not to log or store
status: reviewed
updated: 2026-11-01
tags: [privacy, logging, safety]
source_urls: []
confidence: medium
verification: design_only
client_server: server
code_blocks: 1
related: [ "R-logging-and-tracing", "AGENTS" ]
---

# Player privacy

Roblox games run under platform policy and, in many regions, privacy law. The cheap rule: **store what the
game needs to function, log nothing about the person.**

## Do not log

- Free-text a player typed (chat, naming, custom messages) beyond what you need for moderation
- IPs, device identifiers, or anything you would not show the player
- Session tokens, cookies, API keys (obviously — but they appear in logs most often via error dumps)
- Other players' user ids in a message a client can read

## Do not store

| Data | Verdict |
|---|---|
| `UserId` as a key | fine (it is the join key) |
| Display name | avoid as a key; it changes |
| Purchase history | needed for owned items, keep minimal |
| Precise play-time logs per player | only if a feature uses it, and say so somewhere the player can read |
| Anything from outside Roblox | out of scope for a game |

## Logging errors safely

```lua
-- Untested: truncate and strip before logging
local function safeArg(v)
    local ok, s = pcall(tostring, v)
    if not ok then return "<unprintable>" end
    return string.sub(s, 1, 64)
end
```

A remote that logs the full client payload lets an attacker write whatever they want into your logs (log
injection), and can dump a player's data into a place others can read.

## Consent and clarity

If you collect anything beyond the platform default, say so in the game's description, in plain language. The
bar is "would I be comfortable if a player read this page?" — [[AGENTS]] applies it to the vault too: no secrets
in notes or exports.
