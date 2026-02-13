# Agent Instructions (Model-Agnostic)

Use this file as the default runtime guide for any LLM agent working in this repository.

## Primary Sources

1. `docs/sdk-reference/` (main knowledge base)
2. `sdk-source/extracted/` (authoritative SDK HTML extractions)
3. `templates/` (starter plugin scaffolds)

When there is a conflict, prefer sections labeled `Official ... (SDK 11.4)`.

## Recommended Lookup Order

1. `docs/sdk-reference/00-overview.md`
2. Topic-specific file:
   - Export/Publish: `docs/sdk-reference/02-export-publish.md`
   - Metadata: `docs/sdk-reference/03-metadata.md`
   - UI/Views: `docs/sdk-reference/04-ui-views.md`
   - Namespaces: `docs/sdk-reference/07-namespaces.md`
   - Classes: `docs/sdk-reference/08-classes.md`
3. Constraints/Gotchas: `docs/sdk-reference/10-limitations.md`

## Implementation Rules

- Lightroom SDK runtime is Lua 5.1.5.
- Import SDK modules with `import 'LrXxx'`.
- `io` is available, including `io.open()` and `io.popen()`.
- Async work should use `LrTasks.startAsyncTask(...)`.
- Catalog writes must be wrapped in `catalog:withWriteAccessDo(...)`.

## Command Mapping

If your environment does not support Claude slash commands, use these prompt equivalents:

- `/lrc:validate-idea <idea>`:
  "Assess this Lightroom plugin idea using `docs/sdk-reference/` and `10-limitations.md`. Return verdict, plugin type, key APIs, complexity, approach, and risks."

- `/lrc:explain-api <api>`:
  "Look up `<api>` in `docs/sdk-reference/` and explain signature, parameters, return value, example usage, related APIs, and gotchas."

- `/lrc:new-plugin <type>`:
  "Scaffold from `templates/<type>-plugin/` and replace plugin name + toolkit ID."
