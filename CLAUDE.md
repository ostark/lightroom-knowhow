# Claude Adapter (Minimal)

Use this file only as a lightweight adapter for Claude-specific tooling.
The canonical project guidance is in `README.md`.

## Required Workflow

1. Search `docs/sdk-reference/` first.
2. Prefer sections labeled `Official ... (SDK 11.4)` when there is a conflict.
3. Always check `docs/sdk-reference/10-limitations.md` before proposing implementation.
4. Use `templates/` to scaffold plugin code.

## Critical Rules

- Runtime: Lua 5.1.5 (no Lua 5.2+ features).
- SDK modules use `import 'LrXxx'` (not `require`).
- `io` is available, including `io.open()` and `io.popen()`.
- Use `LrTasks.startAsyncTask(...)` for async work.
- Catalog mutations must be inside `catalog:withWriteAccessDo(...)`.
