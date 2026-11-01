---
id: B-duplicate-input-binding
type: bug
title: Pressing C once does nothing (two scripts toggle crouch)
status: reviewed
updated: 2026-11-01
tags: [input, character, diagnosis]
source_urls: []
confidence: medium
verification: design_only
severity: medium
hypothetical: true
client_server: both
code_blocks: 1
related: "S-crouch-and-crawl", "R-script-types-and-placement", "G-replication-debugging"
---

> ⚠️ **Hypothetical case, not a real incident.** Written from general Roblox behaviour to teach the
> diagnostic path. No log below came from a real session. Do not cite it as evidence.

# Toggle appears to do nothing

## Observed
`C` produces no visible crouch; pressing twice quickly briefly crouches.

## Diagnosis
Both `StarterCharacterScripts.Crouch` and a stock `StarterCharacterScripts.LocalScript` bind `C` and each
toggles: `true` then `false` in the same frame. The net effect is "nothing".

## Cause
Duplicate input binding — the most common bug class in a project that grew by copy-paste.

## Fix
One owner per key: disable/remove the duplicate, keep the better implementation.

## Verification
One press → crouch; next press → stand. Local and server attributes agree.

## Regression prevention
An input map listing every key, owner and context, in the project's `SYSTEM_DEPENDENCIES`. Adding a binding
means editing the map.

