---
id: P-tpl-access
type: project
title: "PROJECT TEMPLATE — accessibility checklist"
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

# Accessibility checklist — {{Project Name}}

- [ ] Reduced motion honoured (no bob/shake/FOV punch)
- [ ] Reduced flash honoured (no luminance flash; dims instead)
- [ ] No flicker above 3 Hz, ever
- [ ] Text >= 16 px effective, contrast >= 4.5:1
- [ ] Tap targets >= 44x44; nothing interactive in the thumb zones
- [ ] Meaning never conveyed by colour alone
- [ ] Controller: focus enters a modal and returns to the launcher
- [ ] Audio cues have visual equivalents
- [ ] Subtitles/on-screen text for any spoken content

Priority order: photosensitivity, then motion, then reading, then input.

