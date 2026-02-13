# Lightroom SDK Knowledge Baseline

Created: 2026-02-13
Last updated: 2026-02-13
Purpose: Measure learning progress as new material is provided.

## Current Knowledge Level: DETAILED / WORKING KNOWLEDGE

### Sources Incorporated
1. **SDK Programmer's Guide** (208 pages, 12,169 lines) — fully extracted into 12 reference files
2. **SamsTools.lrplugin** (GitHub, full source) — real-world patterns for catalog ops, batch metadata, collections
3. **Pixieset.lrplugin** (compiled bytecode, string analysis) — publish service patterns, AWS upload, collection management
4. **samrambles.com guide** (community tutorial series) — practical tips and patterns
5. **John Ellis Debugging Toolkit** — debugging approach reference
6. **500pxPublisher.lrplugin** (GitHub, full source) — advanced publish service: OAuth, composite remote IDs, cross-collection sync, comments, programmatic dialog dismissal, virtual copy handling
7. **lua-console-lightroom-plugin** (GitHub, full source) — loadstring() scope, LrTasks.pcall, re-entrant dialogs, accessoryView, platform-specific patterns
8. **pixid-lightroom-plugin** (GitHub, full source) — programmatic export (LrExportSession constructor), LrFtp, io.popen, rating-as-state-machine
9. **ssh-lightroom-plugin** (GitHub, full source) — publish service with SSH/SCP upload
10. **collection-creator-lrplugin** (GitHub, full source) — collection creation patterns
11. **akrabat.com collections tutorial** — corrected API signatures for createCollection/createCollectionSet

### What I Know (Confident)
- Plugin folder structure (.lrplugin / .lrdevplugin) and all Info.lua entries (~20+ keys)
- Lua 5.1.5 environment with specific restrictions (no os.execute, limited debug, no table.maxn)
- `io` library IS available (confirmed by real plugins), including `io.popen()` for shell commands
- `dofile`/`loadfile` ARE available
- `loadstring()` compiled functions inherit full SDK global scope including `import()`
- `debug` only exposes `getinfo()` (not sethook/traceback)
- All 27 SDK namespaces with method signatures (LrApplication, LrCatalog, LrHttp, LrTasks, etc.)
- All 25 SDK classes with methods (LrPhoto, LrCollection, LrPublishService, etc.)
- Import system: `local LrX = import 'LrX'` (NOT Lua's require)
- Async pattern: `LrTasks.startAsyncTask` + `LrFunctionContext.callWithContext`
- Combined: `LrFunctionContext.postAsyncTaskWithContext()` (simpler alternative)
- `LrDialogs.attachErrorDialogToFunctionContext()` for convenience error handling
- `LrTasks.pcall()` required (NOT plain pcall) for yield-aware protected calls in async contexts
- Catalog thread safety: `withWriteAccessDo` / `withReadAccessDo` / `withPrivateWriteAccessDo`
- `withWriteAccessDo` supports `{ timeout = N, asynchronous = true }` option
- Batch metadata: `catalog:batchGetRawMetadata(photos, keys)` / `batchGetFormattedMetadata()`
- `catalog:addPhoto(filePath)` — programmatic photo import
- Export pipeline: 5 stages with rendition iteration pattern (processRenderedPhotos)
- Programmatic export via `LrExportSession` constructor (no UI needed)
- Publish service: full lifecycle, 30+ callbacks, collection management, UI customization
- Advanced publish: OAuth via URLHandler, composite remote IDs, cross-collection sync via `addPhotoByRemoteId`
- `metadataThatTriggersRepublish` with `default = false` and plugin metadata keys
- `shouldDeletePhotosFromServiceOnDeleteFromCatalog` — return `nil` to suppress dialog
- `shouldDeletePublishedCollection` — can return `"cancel"` to prevent deletion
- `validatePublishedCollectionName` callback for collection rename validation
- `LR_cantExportBecause` — property to block export with custom message
- `LR_editingExistingPublishConnection` — detect new vs. editing existing publish connection
- `LR_canSaveCollection = false` — make collection settings read-only
- `LrDialogs.stopModalWithResult(contentsView, "ok")` — programmatic dialog dismissal
- `presentModalDialog` supports `accessoryView` parameter and re-entrant loop pattern
- LrView declarative UI with data binding (LrBinding, observable tables)
- LrDialogs: showInfo, showError, confirm, runOpenPanel, runSavePanel, presentModalDialog, showModalProgressDialog
- Metadata providers: fields, tagsets, schema versioning, search integration
- Web engine plugins: LuaPages, Live Update, tagsets
- ZStrings and LOC function for localization
- Collection APIs: `createCollection(name, parent)` (2 params), `createCollectionSet(name, parent, canReturnExisting)` (3 params)
- Collection hierarchy: `getChildCollectionSets()`, `getChildCollections()`, recursive traversal
- `photo:getContainedPublishedCollections()` — find all publish collections containing a photo
- Smart collection creation with search descriptors
- Unicode LINE SEPARATOR (U+2028) — Lightroom uses this instead of `\n` in metadata; must convert for APIs
- Platform-aware file opening via `LrShell.openFilesInApp()` (different signatures macOS vs Windows)
- `LrExportMenuItems` / `LrLibraryMenuItems` accept single-table shorthand
- Plugin delivery and debugging (Console.app, LrLogger, .lrdevplugin hot-reload)
- LrFtp: `LrFtp.create(preset, true)` + `putFile()` + `disconnect()`
- `exportSession:recordRemoteCollectionId()` / `recordRemoteCollectionUrl()`

### What I Know Partially (May Have Errors)
- Full list of develop setting keys and valid value ranges (SDK guide lists some, not all)
- LrDevelopController methods — documented but not verified with real code
- Smart collection predicate syntax — have examples but full field list unclear
- LrSocket / LrXml APIs — documented from guide but no real-world examples
- Exact SDK version differences (documented LR 3-6+ changes but gaps in recent versions)
- Plugin distribution / signing requirements (documented but not tested)
- Performance limits (max photos in batch, concurrent renditions — documented but not benchmarked)
- HTTP method override (`_method` param) for PUT/DELETE via POST in LrHttp

### What I Don't Know (Gaps)
- Undocumented Lightroom-internal APIs (beyond SDK public surface)
- Full list of all raw/formatted metadata key names (only common ones documented)
- Exact error behavior when SDK constraints are violated (just crashes? error dialog?)
- Plugin compatibility with Lightroom CC (cloud) vs Classic
- macOS vs Windows behavioral differences beyond path handling and LrShell
- Third-party library integration approaches (what Lua rocks work in the sandbox?)

### Self-Assessment Score
- Architecture & structure: 9/10
- Core APIs (methods, params): 8/10
- Export/Publish providers: 9/10
- Metadata providers: 7/10
- UI (LrView/LrBinding): 8/10
- Develop settings: 4/10
- Utility APIs: 8/10
- Edge cases & debugging: 7/10
- Real-world patterns: 9/10
- **Overall: ~8/10**

### How to Improve Further
- Get hands-on experience building and testing a plugin in actual Lightroom
- Document all raw/formatted metadata key names from actual API introspection
- Test edge cases: large catalogs, virtual copies, offline files, etc.
- Explore LrDevelopController more deeply with real develop presets
- Analyze more plugins with unique patterns (Day-One journal export, ClarifaiTagger AI integration, lightroom-llama)
