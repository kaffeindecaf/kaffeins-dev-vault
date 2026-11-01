---
id: P-tpl-security
type: project
title: "PROJECT TEMPLATE — security checklist"
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

# Security checklist — {{Project Name}}

- [ ] Every remote: no client-derivable values, type/range checks, per-player budget
- [ ] Claims/occupancy cleared on reset, death, disconnect
- [ ] One writer per replicated property
- [ ] Admin commands gated by user id from a server-only list
- [ ] Studio-only grants do not survive into a published build
- [ ] No secrets in the place, notes, logs or repo
- [ ] Imported models/plugins inspected before use
- [ ] Debug tracing disabled before publish

Full reasoning: vault `G-server-authority-checklist`.

