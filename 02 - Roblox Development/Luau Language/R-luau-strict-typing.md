---
id: R-luau-strict-typing
type: reference
title: Strict typing with --!strict (and when not to)
status: reviewed
updated: 2026-11-01
tags: [luau, types, quality]
source_urls: [ "https://create.roblox.com/docs/luau/type-checking" ]
confidence: medium
verification: reference_only
related: [ "R-luau-language-overview" ]
---

# Strict typing

Type annotations are erased at runtime; they cost nothing and catch the class of bug that is hardest
to see in a playtest (a nil that only happens when a player leaves mid-tween).

## The three modes

| Directive | Behaviour |
|---|---|
| *(none)* | no checking |
| `--!nonstrict` | checks what it can infer, allows unknown (`any`) |
| `--!strict` | full checking; unknown types become errors |

Put the directive on **line 1** of the script. It applies per-script, not per-folder.

## Useful patterns

```lua
--!strict
-- Untested: annotated for correctness, not compiled here.

type Item = {
    id: string,
    name: string,
    value: number,
    tags: { string }?,      -- optional
}

export type Inventory = {
    slots: { Item? },       -- fixed-size array with holes is legitimate here
    capacity: number,
}

local Inventory = {}

function Inventory.new(capacity: number): Inventory
    local slots = table.create(capacity, nil) :: { Item? }
    return { slots = slots, capacity = capacity }
end

function Inventory.count(inv: Inventory): number
    local n = 0
    for _, item in inv.slots do
        if item then n += 1 end
    end
    return n
end

return Inventory
```

## Where strict typing pays for itself

- Public module APIs (`export type`), because the caller gets autocomplete and the next agent gets a
  contract.
- Anything touching `Instance` lookups: `local part = workspace:FindFirstChild("Door") :: BasePart?`
  forces you to handle the nil.
- Config tables: `type Config = { ... }` catches a typo'd key that would otherwise be silently nil.

## Where it costs more than it gives

- Quick throwaway scripts, and code that fights `Instance` polymorphism (tweening a union of types).
- Generated code and snippets meant to be pasted into a place where `--!strict` would now flag the
  rest of that file.

Practical rule used in this vault: **strict for modules, annotated-but-not-strict for one-off
scripts.** Never mix — a file without the directive still benefits from annotations.

## Casts are a promise, not a check

`x :: BasePart` tells the analyzer to trust you. If `x` is nil at runtime it is still nil — cast after
you have checked, not instead of checking.

See also: [[R-module-dependencies]] · [[G-luau-code-review-checklist]].
