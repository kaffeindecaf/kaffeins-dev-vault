---
id: N-RELEASE-v1.1.0
type: guide
title: Release v1.1.0 — project onboarding and distribution cleanup
status: draft
updated: 2026-11-02
tags: [release, onboarding, privacy, v1]
source_urls: []
confidence: high
verification: reference_only
related: ["N-README", "N-STATUS", "N-SOUL", "N-USER-CHECKLIST", "N-ROADMAP"]
---

# v1.1.0 · 2026-11-02

This release adds reusable project onboarding and cleans the current downloadable tree of
project-specific audit notes and work logs. It retains the v1.0.0 backend systems release.

## Added

- [[SOUL]] guides an AI through choosing a new or existing project, reviewing available context,
  asking a few material follow-up questions, saving confirmed details and honoring a skip option.
- [[checklist]] tracks the user's goals separately from the vault's [[ROADMAP]].
- [[ROADMAP]] now proposes future work for onboarding templates, learning paths, a fictional
  integration example, release auditing and other quality improvements.

## Distribution cleanup

- Source-specific audits and owner-specific work logs are kept in an ignored local archive and are
  not included in the release ZIP.
- Reusable guidance and asset provenance were generalized. Import scripts no longer reintroduce
  source-specific filesystem paths into generated asset notes.
- Raw imported source files remain byte-exact. The current tree was reviewed and validated before
  release.

## Verification and scope

The v1.0.0 backend implementation and its Studio evidence are unchanged. This release adds no new
Roblox runtime code. The onboarding text has not been evaluated in a separate project workspace;
that check remains in [[ROADMAP]] Phase 22. Current vault validation, index and archive inspection
are recorded in [[STATUS]] and [[RELEASE_CHECKLIST]].

Earlier public release archives may still contain content removed from the current tree. Review
them separately before reusing or redistributing those older downloads; see [[ISSUES]] R-06.
