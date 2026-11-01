---
id: N-MASTER-AGENT-PROMPT
type: source
title: MASTER_AGENT_PROMPT — the original build brief (verbatim)
status: reviewed
updated: 2026-11-01
tags: [agents, prompt, spec, reference]
source_urls: []
confidence: high
verification: reference_only
related: [ "AGENTS", "N-ROADMAP" ]
---

> Preserved verbatim as the project's originating brief. It is a *historical specification*, not the current
> state: for what actually exists, read [[STATUS]] and [[ROADMAP]]. Where the brief and reality differ, the
> difference is recorded in [[ISSUES]].

# MASTER PROMPT — Build My Roblox Game Development Knowledge Base

## Your role

You are an expert Roblox Studio developer, Luau engineer, Obsidian knowledge architect, AI automation engineer, game designer, technical researcher, and software testing specialist.

Your assignment is to **build a complete, professional, long-term Game Development Knowledge Base inside Obsidian**.

This is not simply a collection of notes. It must be a functional knowledge infrastructure that I and my AI coding agents can use to research, design, implement, debug, optimize, and maintain Roblox games.

You must **actually build the project**, not merely propose an architecture or generate an empty directory structure.

The project must be organized, extensible, documented, searchable, and usable offline.

You have an accompanying `ROADMAP.md` containing 20 development phases and 430 actionable tasks. **Read it completely before starting and follow it as the project's authoritative task ledger.**

## 1. Project initialization

Create a directory called `GameDev-Knowledge-Base` on my Desktop.

Detect my operating system and actual Desktop path before creating it. Support Windows and Linux. If an existing directory has that name, inspect it and preserve its contents rather than overwriting anything.

Create a fully functional Obsidian vault inside the project directory.

The vault must have a visually organized homepage with links to the different databases, project dashboards, documentation, and knowledge libraries.

Use Markdown, YAML frontmatter, Obsidian links, and conventional files as the primary architecture.

Do not make essential functionality dependent on paid APIs or third-party plugins.

Create and maintain these root documents:

- `HOME.md` — The central knowledge dashboard.
- `README.md` — Setup and usage documentation.
- `ROADMAP.md` — Complete implementation checklist.
- `STATUS.md` — Current development progress.
- `CHANGELOG.md` — Record of changes.
- `ISSUES.md` — Problems, blockers, and unfinished work.
- `DECISIONS.md` — Important architecture decisions.
- `SCHEMA.md` — Metadata schemas and conventions.
- `PROJECT_CONFIG.md` — Project settings and paths.
- `NEXT_STEPS.md` — Exact instructions for continuing development.

Update the roadmap after every completed milestone. Never check off a task that has not been genuinely completed and verified.

## 2. Required knowledge libraries

Build the following major libraries.

### Asset Library

A categorized collection of Roblox assets:

- Horror ambience, footsteps, doors, interactions, and environmental sound effects.
- UI sounds, notifications, hover effects, confirmation sounds, and menu transitions.
- Background music, suspense, stingers, and cinematic audio.
- UI packs, icons, decals, fonts, and visual references.
- Models, props, buildings, furniture, doors, flashlights, and lighting systems.
- R6 and R15 animation IDs, animation packs, rigs, and controllers.
- Particle systems, weather, atmospheric effects, and VFX.
- Reusable Roblox gameplay systems and Creator Store models.

Search for the existing `Roblox_Horror_Asset_Vault_2026-11-01.zip` included with this project. It contains 206 researched Roblox asset IDs.

Import this existing data while preserving its original files, IDs, category assignments, sources, and research evidence.

Each asset should have a dedicated or appropriately indexed note containing its asset ID, type, source URL, suggested uses, tags, verification status, access/permission status, licensing information when known, and implementation notes.

An asset's Creator Store listing does not prove that it is currently usable in my game. Never claim an audio asset is playable, an animation accessible, or a model safe without verification.

Do not confuse sound IDs, animation IDs, plugin IDs, and model IDs.

### Roblox Development Encyclopedia

Create technical documentation covering modern Roblox development, including:

- Luau syntax, strict typing, ModuleScripts, services, and APIs.
- Client/server architecture and replication.
- RemoteEvents, RemoteFunctions, input validation, and server authority.
- DataStores, player data, persistence, and error handling.
- Physics, raycasting, collision detection, and constraints.
- Animations, character controllers, and Humanoid systems.
- PathfindingService, NPC navigation, and optimization.
- CollectionService, tags, reusable components, and modular design.
- Performance profiling, StreamingEnabled, memory management, and connection cleanup.
- Code architecture, reusable utilities, configuration systems, and testing.

Reference Roblox Creator Hub documentation where appropriate.

Include practical Luau examples, clear script placement instructions, expected results, pitfalls, and troubleshooting information.

### Reusable Systems and Mechanics Cookbook

Create reusable implementation guides for features such as:

- Smart doors, locks, keys, and keycards.
- Interactive pickups and world objects.
- Inventory systems, equipment, and item inspection.
- Flashlight systems with configurable battery mechanics.
- Hiding spots, crouching, crawling, sprinting, and climbing.
- Puzzle systems, switches, pressure plates, and timed events.
- Dialogues, quests, objectives, and checkpoints.
- Multiplayer state management and player synchronization.
- Camera effects, interaction prompts, notifications, and configurable settings.

Each system should explain its architecture, dependencies, API, server/client responsibilities, implementation, failure cases, performance concerns, and tests.

Create working reference implementations for high-priority systems. Clearly distinguish tested code from untested examples.

### Horror Design Encyclopedia

Create an extensive library of horror game development knowledge:

- Suspense and anticipation.
- Environmental storytelling.
- Player uncertainty and exploration.
- Audio-driven tension.
- Adaptive horror pacing.
- Lighting, shadows, fog, and atmosphere.
- Safe rooms and intensity cooldowns.
- Environmental scares and unpredictable events.
- Non-graphic jumpscare design.
- Multiplayer horror dynamics.

Design an **Adaptive Horror Director** capable of responding to player activity and controlling the frequency, intensity, and selection of environmental events, audio cues, lighting variations, and enemy pressure.

Document its inputs, outputs, states, decision rules, cooldowns, multiplayer behavior, testing strategy, and accessibility settings.

### Enemy AI Encyclopedia

Include finite-state machines, behavior trees, utility AI, pathfinding, perception systems, line-of-sight checks, hearing, investigation, patrols, searching, chasing, and NPC communication.

Create reference architectures for different enemy behaviors.

Document efficient update scheduling, path recalculation, stuck detection, navigation fallback, multiplayer handling, and debugging.

Prioritize server-authoritative behavior and efficient CPU usage.

### UI/UX Design Library

Create a database of Roblox UI design patterns:

- Main menus, pause screens, settings, inventories, and HUDs.
- Interaction indicators, tooltips, notifications, loading screens.
- UI animations, transitions, typography, color palettes, and icons.
- Responsive Roblox interfaces using AnchorPoint, UDim2, UI constraints, and UIScale.
- Mobile, desktop, controller, and different aspect-ratio layouts.
- Accessibility, text scaling, readable contrast, and reduced-motion settings.

Include reusable design tokens, UI recipes, wireframe templates, and troubleshooting guides.

Specifically document common issues such as buttons moving incorrectly when resizing and interfaces stretching unexpectedly.

### Game Feel and VFX Cookbook

Document camera shake, head bob, tweens, blur, color correction, depth of field, Atmosphere, particles, post-processing, audio ducking, flashlight flicker, and glitch/VHS-style effects.

Explain how to achieve effects within Roblox's actual rendering capabilities.

Include performance notes and accessibility alternatives for intense visual effects.

### Level Design and Procedural Generation

Create guides for:

- Floor plans and room layouts.
- Navigation, landmarks, exploration loops, and branching paths.
- Safe rooms and enemy encounter placement.
- Puzzle dependency graphs.
- Procedurally generated rooms and corridors.
- Deterministic generation for debugging.
- Checkpoints, progression, and rewards.
- Multiplayer navigation and playtesting.

Include example layouts and worked design specifications.

### Bug Graveyard

Create a database for recurring bugs and solutions.

Every genuine bug record must contain:

- The observed problem and environment.
- Reproduction instructions.
- Logs or other evidence.
- Suspected and confirmed causes.
- The solution.
- Verification results.
- Regression prevention.
- Related systems.

Do not represent hypothetical examples as real solved bugs.

### AI Agent Knowledge Library

Create reusable prompts, coding conventions, project rules, context packs, and debugging instructions for Hermes, Codex, Claude Code, Gemini CLI, and OpenCode.

Agents should retrieve relevant information before implementing features and provide references to the notes they used.

Give each agent clear instructions on verification, safe file changes, Roblox coding standards, and preserving existing code.

Do not invent integrations or assume all coding harnesses support the same interfaces.

### Projects, Experiments, and Inspiration

Create project templates containing:

- Project descriptions and game design documents.
- Feature roadmaps, tasks, and dependencies.
- Architecture decisions.
- Asset manifests.
- Testing plans and bug reports.
- Experiment results.
- Release checklists.
- Research and inspiration references.

Link projects back to reusable systems and assets instead of duplicating their documentation.

## 3. Metadata and documentation standards

Create a documented YAML frontmatter schema and templates for every important note type.

Important fields include:

- Stable note ID.
- Title and knowledge type.
- Category and tags.
- Source links.
- Confidence and review status.
- Creation and update dates.
- Dependencies and related notes.
- Code verification status.
- Platform or Roblox rig compatibility.
- Licensing, access, and testing metadata for assets.

Use consistent names, stable IDs, and proper Obsidian links.

Do not invent metadata or verification results. Unknown values must remain explicitly unknown.

Prefer comprehensive, useful documentation over hundreds of empty placeholder files.

## 4. Obsidian interface and navigation

Make the vault attractive and pleasant to browse.

Build a central `HOME.md` dashboard with major categories, current projects, recent updates, useful shortcuts, and outstanding work.

Create category indexes and maps of content.

Provide a normal Markdown navigation experience that works without plugins.

Document optional enhancements using:

- Obsidian Bases.
- Excalidraw.
- Templater.
- Dataview.
- Obsidian Git.

Do not install or enable community plugins without my permission.

Use templates to make adding a new asset, system, bug, experiment, or project easy and consistent.

## 5. Local search and retrieval engine

Build a cross-platform Python CLI called `gamedev_kb.py` inside `scripts/`.

It must make the vault searchable and usable by coding agents.

Implement commands for:

- `doctor` — Check environment and dependencies.
- `validate` — Validate notes, IDs, metadata, and links.
- `index` — Build a local search index.
- `search` — Find relevant notes using keywords and filters.
- `context` — Assemble source-attributed context for an AI agent.
- `asset` — Find an exact Roblox asset ID.
- `export` — Export structured JSON/CSV data.
- `report` — Summarize the vault and verification states.

Prefer a local SQLite FTS5 index with a fallback search implementation.

Ensure retrieval returns note titles, file paths, useful snippets, IDs, verification status, and confidence markers.

The CLI should work without an external AI API.

Provide machine-readable JSON output so different coding agents can incorporate it.

Protect private files and secrets from indexing. Avoid reading outside the vault root.

Document exact usage examples for Windows PowerShell and Linux terminals.

## 6. AI integration and persistent development memory

Design the system so that coding agents can search the vault before building new features.

For example, when I request an inventory system, the agent should:

1. Search the knowledge base for inventory architecture and examples.
2. Retrieve relevant Roblox development standards.
3. Find existing assets or systems that could be reused.
4. Generate a project-specific implementation.
5. Validate code and run available tests.
6. Report what worked and what remains unverified.
7. Propose useful knowledge updates for review.

Build a controlled process for turning successfully tested implementations and bug fixes into reusable documentation.

Unverified AI output must not automatically become accepted technical knowledge.

All changes to canonical documentation should be traceable and reviewable.

Keep the system compatible with different coding agents by providing straightforward filesystem and CLI interfaces.

Semantic search, embeddings, and MCP integration can be added as optional enhancements after the offline lexical search system is working correctly.

## 7. Coding, security, and quality standards

Use modern Luau practices and clear modular architecture.

For multiplayer gameplay, validate client requests on the server.

Document cleanup of event connections, performance budgets, error handling, and safe data persistence.

Do not insert unreviewed third-party scripts into Roblox experiences.

Inspect Creator Store models and plugins for potentially unsafe scripts and dependencies before using them.

Do not automatically install software, publish games, change permissions, spend money, or access unrelated private files.

Keep API keys and credentials out of logs, indexes, and version control.

Preserve original data before migration.

Use backups and diffs for bulk changes.

## 8. Testing and verification

Implement automated tests for the local knowledge-base tools.

At minimum, verify:

- Metadata and frontmatter validation.
- Unique note IDs.
- Accurate asset ID lookup.
- Import count preservation.
- Search functionality.
- Source references.
- Export consistency.
- Broken-link detection.
- Sensitive-file exclusions.
- Path traversal and symlink boundaries.
- Duplicate-import handling.
- Recovery from malformed or corrupted inputs.

Also create a manual Roblox Studio verification workflow for audio, animations, and third-party models.

Do not claim Roblox Studio tests passed unless they were actually executed.

Provide actual test results in `TEST_REPORT.md`.

## 9. Development roadmap

Read and follow the supplied `ROADMAP.md`.

Implement the project in priority order.

Start with project discovery, safe file operations, directory structure, metadata schemas, navigation, and importing existing asset data.

Next create meaningful Roblox and horror-development knowledge, templates, reusable recipes, agent rules, and local search.

Then add project workflows, optional Obsidian enhancements, verification tools, security hardening, and end-to-end testing.

Use the roadmap's task IDs and acceptance gates.

After each development phase, update `ROADMAP.md`, `STATUS.md`, `CHANGELOG.md`, and `ISSUES.md`.

If a feature cannot be completed, leave a precise explanation of the blocker and a reproducible next step.

## 10. Final deliverables

The completed project should provide:

1. A real Obsidian-compatible GameDev Knowledge Base on my Desktop.
2. Organized asset, Roblox, horror, UI, AI, and game-design libraries.
3. Accurate import of the existing 206 Roblox asset candidates.
4. Substantive notes, templates, recipes, and technical examples.
5. A usable local search and retrieval CLI.
6. Integration documentation for my coding agents.
7. Functional project templates and development workflows.
8. Tests and verification reports.
9. Clearly documented configuration, installation, and usage instructions.
10. An updated roadmap accurately reflecting progress.

## 11. Execution instructions

**Begin building immediately.**

Do not stop after proposing a plan or creating folders.

Inspect the environment, read the roadmap, create the vault, build the foundational systems, and work through the tasks in dependency order.

Make the project useful as early as possible. Build one complete working vertical slice before expanding into the entire encyclopedia.

Make reasonable technical decisions without asking unnecessary questions, but request explicit approval for destructive changes, purchases, external uploads, or software installations.

At every milestone, leave the project usable.

When you finish a work session, provide:

- Completed task IDs and changed files.
- Actual verification and test results.
- Imported asset and created-note counts.
- Remaining blockers and limitations.
- The next three concrete tasks.

**The end goal is a powerful, carefully organized, continually improvable Game Development Knowledge Base that allows my AI agents to build Roblox games faster, reuse existing knowledge, avoid repeating mistakes, and produce better code.**

Start with Phase 00 of `ROADMAP.md` and continue executing.
