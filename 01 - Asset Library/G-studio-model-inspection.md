---
id: G-studio-model-inspection
type: guide
title: Manual Studio checklist — third-party model and plugin inspection
status: reviewed
updated: 2026-11-01
tags: [assets, models, security, checklist]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 0
related: "G-asset-verification-workflow", "R-content-and-ownership", "G-asset-rejection-log"
---

# Studio: inspecting a model or plugin

A model arrives with scripts. A plugin arrives with **your** permissions. Treat both as untrusted code.

## Model inspection (blank review place, never the real game)

1. New baseplate. Insert the model by ID from the Toolbox.
2. In the Explorer, expand **everything**. Count the scripts.
3. Read every `Script`/`LocalScript`/`ModuleScript`. Look for:

| Pattern | Why it is a red flag |
|---|---|
| `require(<numeric asset id>)` | loads code you cannot read |
| `HttpGet`, `HttpService` | exfiltration |
| `MarketplaceService` / `DataStore` calls | touches money or data |
| `Players:GetPlayers()` + remotes | could affect other players |
| `loadstring` / `RunService:IsStudio` gates | behaviour differs in Studio vs live |
| Obfuscated names or giant string literals | hidden payload |
| Creating `RemoteEvent`s in `ReplicatedStorage` | a channel for a client-side payload |

4. Test the model alone: place it, walk into it, check the Output.
5. Decide: `safety_status: scripts_reviewed` (and say what you saw), or `rejected` ([[G-asset-rejection-log]]).

## Plugin inspection

1. Install **only** from the Creator Store, only if you understand who made it.
2. Read the listing's permissions/description. A plugin can read your files, place scripts and publish.
3. Install in a scratch Studio install if unsure, and remove it afterwards.
4. Never install because an AI, a blog or a comment suggested it — [[AGENTS]] forbids it without your approval.

## What "safe" means here

`safety_status: scripts_reviewed` means *a human read the scripts and found nothing hostile*. It does not mean
the asset is licensed, or correct, or free of subtle bugs. Record what you actually inspected:

```yaml
safety_status: scripts_reviewed
test_evidence: "2026-11-01 blank place; 3 scripts read; one HttpGet removed; no remotes created"
```

Anything you had to remove is a reason to prefer a different asset.

