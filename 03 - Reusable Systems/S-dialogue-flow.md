---
id: S-dialogue-flow
type: system
title: Dialogue flow and branching consequences
status: reviewed
updated: 2026-11-01
tags: [systems, narrative, ui]
source_urls: []
confidence: medium
verification: design_only
client_server: server
roblox_services: [None]
dependencies: []
code_blocks: 1
related: "S-objective-tracker", "R-remotes-and-validation", "S-checkpoints"
---

# Dialogue

A dialogue is a graph: nodes with text, one or more choices, and effects. Keep the graph as data (a
table) and the runner as a pure function, so a writer can add lines without touching code.

## Data

```lua
-- Untested
local DIALOGUE = {
    greeting = {
        text = "You shouldn't be here.",
        choices = {
            { label = "Who are you?", next = "who" },
            { label = "Leave", next = nil, effects = { setFlag = "left_early" } },
        },
    },
    who = {
        text = "The one who locks the door.",
        choices = { { label = "…", next = nil, effects = { setFlag = "knows_name" } } },
    },
}
```

## Runner (server)

```lua
-- Untested
function Dialogue.start(player, entry)
    Session[player] = { node = entry, startedAt = os.clock() }
    push(player, entry)
end

function Dialogue.choose(player, choiceIndex)
    local session = Session[player]
    if not session then return end
    local node = DIALOGUE[session.node]
    local choice = node.choices[choiceIndex]
    if not choice then return end                      -- index from the client: validate
    if choice.effects then applyEffects(player, choice.effects) end
    if choice.next then
        session.node = choice.next
        push(player, choice.next)
    else
        Session[player] = nil
    end
end
```

## Consequences must be server-side

A dialogue choice that grants an item, opens a door or sets a flag is a state change. The client sends
**only the choice index**; the server resolves it against its own copy of the graph.

## Failure modes

- Sending the full node text from the client → an exploiter can reach nodes you never showed.
- Choice index unvalidated → nil index error or reaching an end node early.
- Dialogue open during a round-end / while dead → force-close on those events.
- Session not cleared on disconnect → leak per-player.

## Test cases

1. Walk the graph to an ending → session cleared.
2. Send choice index 99 → ignored, no error.
3. Choice with an effect → effect applied exactly once.
4. Disconnect mid-dialogue → session gone.
5. Round end while open → dialogue closes, no stuck input.

