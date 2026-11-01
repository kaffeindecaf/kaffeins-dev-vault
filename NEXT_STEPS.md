---
id: N-NEXT-STEPS
type: guide
title: NEXT_STEPS — the three next actions
status: draft
updated: 2026-11-01
tags: [handoff, next]
source_urls: []
---

# NEXT_STEPS

Written for whoever continues next (human or agent). Each item is concrete and copy-pasteable.

## 0. Read the newest work log first

`09 - AI Agent Knowledge/Work Log/` holds one entry per agent session: what changed, the commands
that actually ran, and the next steps. If its last entry is newer than this file, follow the work log
and update this file rather than the other way round. Protocol: [[G-worklog-protocol]].

## 1. Verify the new persistence example in an isolated place

Use [[S-datastore-player-profile]] and its linked `roblox-core-loop` / `roblox-mcp-workflow` skill
cards. Test only in a separate test experience/store; cover read failure, concurrent update,
session-lock release and shutdown. Save evidence before changing any note to `tested_studio`.

## 2. Verify the assets you actually intend to use

```bash
python scripts/gamedev_kb.py search "door creak" --type asset --limit 10
```

Open each listing in Studio's Creator Store, play the sound in a clean place, then set
`access_status`, `studio_status` and `verification: tested_studio` plus `test_evidence` in the note.
Update `ASSET_VERIFICATION_REPORT.md`. Workflow: [[G-asset-verification-workflow]].
Why first: 209 unchecked candidates are worth less than 5 assets you have actually heard.

## 3. Test one reusable recipe, then refresh local checks

Pick [[S-round-phase-machine]] (five tests) or [[S-pickup-server-authoritative]], use a **blank test
place**, run the listed test cases, and record the evidence before changing the code label. Then run:

```bash
python scripts/gamedev_kb.py validate && python scripts/gamedev_kb.py index && python scripts/gamedev_kb.py report
```

Review remaining items in [[ISSUES]] after these checks. Keep optional P19 extensions deferred until
lexical search is shown to miss a concrete task.

## Keep the habit

After any real work: append [[CHANGELOG]], update [[STATUS]], write a work log entry
([[T-worklog]]; handoff brief [[T-handoff]] if unfinished), and re-run `validate` + `index`.
An entry that says "not run" is worth more than an entry that implies everything passed.
