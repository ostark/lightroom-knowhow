# Testing Strategy

This document defines a practical testing strategy for Lightroom Classic plugins.

## Core Principle

Most Lightroom plugins do not have a build step.

- Edit Lua/resources in the `.lrdevplugin` folder.
- Reload via Plug-in Manager (or auto-reload on export/publish).
- Re-run the target workflow.
- Verify behavior via UI result + `LrLogger` output.

## Test Layers

## 1. Static Review (Pre-Run)

Before running in Lightroom, verify:

- API usage matches docs in `07-namespaces.md` and `08-classes.md`.
- No prohibited runtime assumptions from `10-limitations.md`.
- Catalog writes are wrapped in `catalog:withWriteAccessDo(...)`.
- Async-sensitive operations run in `LrTasks.startAsyncTask(...)` where required.
- User-visible strings use localization patterns where applicable.

## 2. Development Loop (Fast Integration)

Use `.lrdevplugin` for rapid iteration:

1. Edit plugin code.
2. Reload plugin.
3. Execute one focused scenario.
4. Inspect logs and expected state.

Minimum logging setup:

```lua
local LrLogger = import 'LrLogger'
local logger = LrLogger('MyPlugin')
logger:enable('logfile') -- or "print"
```

## 3. Scenario Tests (Feature Validation)

Define explicit scenario cases per plugin type:

- Export plugin:
  - Default export path and naming.
  - Error during upload/transfer.
  - User cancel mid-run.
- Publish plugin:
  - Initial publish.
  - Re-publish after metadata change.
  - Delete/rename/reparent collection behavior.
- Metadata plugin:
  - Read/write custom fields.
  - Search/filter behavior for searchable fields.
  - Schema migration path.
- Menu plugin:
  - No-selection behavior.
  - Multi-selection behavior.
  - Error handling and recovery.

## 4. Regression Matrix

Run key scenarios across:

- OS: macOS + Windows.
- Lightroom versions: minimum supported (`LrSdkMinimumVersion`) and current target.
- Catalog states:
  - Empty/small catalog.
  - Large catalog.
  - Mixed media (RAW/JPEG/video) if relevant.

## Failure-Path Tests (Required)

Always test:

- Write-lock contention (another operation holds catalog write access).
- Network timeout or server unavailable (for network plugins).
- Invalid credentials / token expiry.
- Missing files / path errors.
- User cancellation (`LrErrors.throwCanceled` and cancel-safe cleanup).
- Plugin reload between operations (state restoration from prefs).

## Test Data

Maintain a lightweight fixture set:

- Small deterministic catalog for routine checks.
- A few photos with known metadata values.
- Optional large catalog for performance checks.

Keep expected outputs documented (IDs, metadata changes, exported filenames, etc.).

## Release Checklist

Before release:

1. Run scenario tests for all supported flows.
2. Run failure-path tests.
3. Enable deprecation checks in `config.lua` during final validation.
4. Review logs for warnings/errors.
5. Verify plugin install/reload path from a clean Lightroom session.
6. Package from tested source state.

## Notes

- Lightroom has no built-in unit test harness for plugin Lua.
- Testing is integration-heavy and behavior-driven.
- The fastest reliable workflow is: small deterministic scenarios + strong logging + repeatable checklists.
