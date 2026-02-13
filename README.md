# Lightroom Classic SDK Knowledge Base

Structured Lightroom Classic SDK documentation and templates for building plugins.

This repository is model-agnostic: Codex, Claude, ChatGPT, Gemini, and local LLMs can all use it.

## Core Files

- `docs/sdk-reference/` — primary knowledge base (`00` to `11`)
- `sdk-source/extracted/` — authoritative extractions from Adobe SDK HTML
- `templates/` — starter plugin templates (`export`, `publish`, `metadata`, `menu`)

## How Any Agent Should Use This Repo

1. Start with `docs/sdk-reference/00-overview.md`.
2. Route by topic:
   - export/publish: `docs/sdk-reference/02-export-publish.md`
   - metadata/tagsets: `docs/sdk-reference/03-metadata.md`
   - UI and bindings: `docs/sdk-reference/04-ui-views.md`
   - namespaces: `docs/sdk-reference/07-namespaces.md`
   - classes: `docs/sdk-reference/08-classes.md`
   - constraints/gotchas: `docs/sdk-reference/10-limitations.md`
3. Prefer sections marked `Official ... (SDK 11.4)` when conflicts exist.
4. For implementation, copy from `templates/` and adapt.

## Slash Commands (Claude) And Cross-LLM Equivalent

The files in `.claude/commands/` are Claude-specific wrappers. Other LLMs can do the same tasks by prompt.

### `/validate-idea <idea>`
- Claude behavior: feasibility assessment using docs + limitations.
- Equivalent prompt for any LLM:
  - "Assess this Lightroom plugin idea for feasibility using `docs/sdk-reference/` and `10-limitations.md`. Return: verdict, plugin type, key APIs, complexity, approach, risks."

### `/explain-api <api>`
- Claude behavior: lookup and explain a specific API with signature, params, returns, example, gotchas.
- Equivalent prompt for any LLM:
  - "Look up `<api>` in `docs/sdk-reference/` and explain signature, parameters, return value, example usage, related APIs, and limitations."

### `/new-plugin <type>`
- Claude behavior: scaffold from `templates/<type>-plugin/`, then replace plugin name/toolkit ID values.
- Equivalent prompt for any LLM:
  - "Create a new Lightroom plugin from `templates/<type>-plugin/` named `<Plugin Name>` with toolkit ID `<com.example.plugin>` and output folder `<path>`."

## Tool-Specific Files (Minimal)

- `CLAUDE.md` — minimal Claude runtime guidance (kept intentionally short)
- `.claude/commands/` — optional slash-command wrappers
- `.claude/agents/` — optional Claude agent presets

All core SDK knowledge remains in model-neutral Markdown under `docs/` and `sdk-source/extracted/`.
