---
id: N-ONBOARDING-EXAMPLES
type: guide
title: Project onboarding examples
status: draft
updated: 2026-11-02
tags: [onboarding, projects, agents]
source_urls: []
---

# Project onboarding examples

Use [[SOUL]] at the start of work on a project with no established context. Read the project files
first, then ask only what is still unknown and material to the next deliverable. These examples
demonstrate the conversation shape; they are not project facts to copy.

## Starting a new game

**AI:** Are we starting a new game, or continuing an existing one?

**User:** New game. I want a cooperative cave exploration game where teams bring back artifacts.

**AI:** I understand the loop as preparing, exploring together, and extracting artifacts. Which
platform/input should the first playable target, and what is the smallest milestone you want to build?

After the user answers, save confirmed facts in the project profile and record the explicit next
outcomes in its checklist. Leave other fields unknown.

## Continuing an existing game

**AI:** I found the project profile and current goals. The next milestone is a playable inventory
flow, and the source of truth is the project design folder. Should I continue with that milestone?

**User:** Yes. Focus on the item transfer screen.

Proceed from existing documented decisions. Ask a follow-up only if a missing detail changes the
screen's behavior or implementation. Update the checklist when scope or evidence changes.

## Skipping questions

**User:** Skip onboarding. Add a basic pause menu to the current project.

**AI:** I’ll use the existing files and make a pause menu. Input behavior is not documented, so I’ll
keep that as an assumption and flag the choice for review.

Start work immediately. Record only the task the user stated, preserve unknowns as unknown, and do
not turn assumptions into confirmed project facts.
