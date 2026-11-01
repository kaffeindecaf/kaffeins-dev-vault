---
id: P-tpl-sot
type: project
title: "PROJECT TEMPLATE — source of truth"
status: reviewed
updated: 2026-11-01
tags: [project-template]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 0
related: [ "MOC-projects" ]
---

# Source of truth — {{Project Name}}

The most expensive confusion in a shared project is two copies of the truth.

| Question | Answer lives in |
|---|---|
| What does the code do? | {{the place / the repo}} — never a note |
| Why does it do that? | this folder |
| How do I build mechanic X? | the vault's `MOC-reusable-systems` |
| Is asset Y usable? | the vault's asset note + `ASSET_VERIFICATION_REPORT` |
| What is the current state of the work? | `Tproject-HANDOFF.md` in this folder |

## Rules
- Notes describe intent; code is the implementation. When they disagree, the code is the fact and the note is a
  bug.
- Do not copy a vault recipe into this folder and then edit the copy — link to it, and note your deviations here.
- Secrets never enter either.

