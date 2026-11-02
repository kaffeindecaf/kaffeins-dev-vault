---
id: N-SOUL
type: guide
title: SOUL — project onboarding and persistent working context
status: draft
updated: 2026-11-02
tags: [agents, onboarding, projects, workflow]
source_urls: []
---

# SOUL — project onboarding and persistent working context

This file tells an AI how to learn what the user is building, preserve the useful context, and keep
the user's goals visible. Read it and `checklist.md` at the start of project work. `ROADMAP.md`
tracks work on this knowledge vault; `checklist.md` tracks the user's goals for the project being
worked on.

## When to start onboarding

Onboard once when a project first becomes the subject of work, when its profile is missing, or when
the user says the project or its goals have changed. Do not restart onboarding for every task after
the project is established. If the workspace already contains a `SOUL.md`, `checklist.md`, README,
project notes, source files, or a recent work log, inspect those first and preserve them.

When the user asks for a small, self-contained task in an established project, use the existing
profile and start the task. Do not interrupt with onboarding questions whose answers are already in
the files or conversation.

## Onboarding flow

### 1. Establish which project the user means

After a quick read-only inspection of the workspace and its recent handoff, ask one concise opening
question if the project is not already confirmed:

> Are we starting a new game, or continuing an existing game? If it is existing, should I use the
> game in this workspace, or a different project?

Use detected project names in the question when reliable. Do not assume that a knowledge vault,
tooling repository, or sample project is the game the user intends to work on.

### 2. Let the user describe the game

For a new game, invite the user to describe the idea in their own words. For an existing game, ask
what they want to build next and which project files or notes are authoritative. Do not demand a
formal pitch or make the user fill out a long form.

### 3. Think from the available evidence, then ask only the remaining questions

Read the relevant project files and recent notes. Search this vault before re-creating documented
knowledge. Summarize the current understanding briefly, keeping confirmed facts distinct from
inferences. Then ask a small, bundled set of final questions—usually two to five—only where the
answer changes what to build or how to build it.

Choose questions that fit the project. Common topics are the core player loop, target platform and
input, solo or multiplayer scope, the first playable milestone, art or tone, and technical or
content constraints. Skip questions already answered by the user or the project files. Offer a
reasonable default when a detail is low impact; label it as an assumption instead of making the user
decide every detail.

### 4. Save the confirmed understanding

After the user answers, update the **Active project profile** below with what is confirmed. Keep
unanswered or inferred details in **Open questions and assumptions**, explicitly labeled. Record
the project's name, premise, core loop, target platform and input, intended audience, first milestone,
current state and source-of-truth files only when those facts are known. Add the user's durable
preferences and constraints when relevant. Never fabricate decisions, requirements, permissions,
test results, or project state.

Add the user's goals to `checklist.md` at the same time. Keep the profile concise and maintain it as
the project changes; do not let a later guess silently replace a confirmed decision.

## Skip option

The user may say “skip onboarding,” “skip the questions,” or otherwise ask to start without the
interview. Respect that immediately; do not ask them to confirm skipping. Read the available files,
use the task they gave, record only supported facts, mark uncertainty as an assumption, add any
explicit goal to `checklist.md`, and begin. Leave unanswered profile fields blank or marked
“unknown.” The user can fill them in later.

If there is no actionable task after skipping, state the brief assumption you can proceed with and
ask only for the missing action needed to begin.

## Keep `checklist.md` current

`checklist.md` is the user's goal ledger, not a copy of the vault's `ROADMAP.md`.

- Read it at the start of work and carry forward every active goal unless the user changes it.
- Add a goal when the user states an intended outcome. Use a stable short ID and keep the goal
  concrete enough to recognize when it is done.
- Record status, the next action, and observable completion evidence. Use `Not started`, `In
  progress`, `Blocked`, or `Done`.
- Update it when a goal is clarified, work makes meaningful progress, a blocker appears or clears,
  or the goal is completed. Before ending a work session, make sure it reflects the real state.
- Mark a goal `Done` only after its stated outcome is delivered and any agreed verification is
  complete. Keep completed goals in the completed section as a record; do not silently delete them.
- Preserve goals that are still active across sessions. Do not import unrelated tasks from the
  knowledge-base roadmap as if they were the user's game goals.

## Active project profile

No specific game project has been confirmed in this knowledge vault. The vault itself is a Roblox
game-development knowledge base, not a game. Fill this profile only when the user starts or resumes
a particular game project.

- **Project:** Not confirmed
- **Premise and genre:** Unknown
- **Core player loop:** Unknown
- **Target platform and input:** Unknown
- **Players / multiplayer scope:** Unknown
- **First playable milestone:** Unknown
- **Current state and source of truth:** Unknown
- **Confirmed preferences and constraints:** None recorded

### Open questions and assumptions

- No active game project or game-specific goal has been confirmed in this vault.

## Working principles

- Follow the user's latest instruction and the project's local rules; this file does not override
  either.
- Prefer the smallest useful next step and report what changed, what was verified, and what remains.
- Keep project-specific facts in that project's own files. Promote reusable lessons to the shared
  knowledge vault only when they are general and useful.
- Do not touch another project, publish, purchase, install software, alter permissions, or handle
  saved/live game data unless the user clearly authorized that action.
