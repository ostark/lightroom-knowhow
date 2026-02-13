# SDK Limitations & Gotchas

## Lua Environment Restrictions

### Restricted Standard Libraries

The Lightroom SDK runs Lua 5.1.5 but with a significantly restricted standard library. Many functions that would allow arbitrary system access are removed.

- `os` -- ONLY: `os.clock()`, `os.date()`, `os.time()`, `os.tmpname()`
  - NO `os.execute()`, `os.exit()`, `os.getenv()`, `os.remove()`, `os.rename()`, `os.setlocale()`
  - Use `LrFileUtils`, `LrDate`, and `LrTasks` instead
  - `LrTasks.execute()` is the SDK replacement for `os.execute()` -- it runs a shell command and returns the exit code. Redirect output to a temp file to capture stdout (see Patterns doc for full example)
- `coroutine` -- ONLY: `coroutine.canYield()`, `coroutine.running()`
  - NO `coroutine.create()`, `coroutine.resume()`, `coroutine.yield()`, `coroutine.wrap()`
- `table` -- All functions EXCEPT `table.getn()`, `table.setn()`, `table.maxn()` (deprecated as of Lua 5.1)
  - Available: `table.concat()`, `table.insert()`, `table.remove()`, `table.sort()`
- `debug` -- ONLY: `debug.getinfo()`
  - NO `debug.sethook()`, `debug.traceback()`, or other debug functions
- `io` -- Available and functional. `io.open()` works for file read/write, `io.popen()` works for shell commands. `LrFileUtils` is still preferred for path-oriented operations
- `package` -- NOT AVAILABLE; Lightroom does not support the Lua 5.1 module system
  - Use `import()` for SDK namespaces and `require()` for plugin-local scripts
- `string` library -- fully available
- `math` library -- fully available

### Restricted Global Functions

- **Available:** `assert()`, `dofile()`, `error()`, `getmetatable()`, `ipairs()`, `load()`, `loadfile()`, `loadstring()`, `next()`, `pairs()`, `pcall()`, `rawequal()`, `rawget()`, `rawset()`, `select()`, `setmetatable()`, `tonumber()`, `tostring()`, `type()`, `unpack()`
- **NOT available:** `collectgarbage()`, `gcinfo()`, `getfenv()`, `module()`, `newproxy()`, `package()`, `setfenv()`

### Info.lua Loader Environment

The `Info.lua` file runs in an even more restrictive environment than regular plugin scripts:
- The `string` namespace is available
- `LOC` function is available for localization
- `WIN_ENV` and `MAC_ENV` are available
- `_VERSION` variable is available
- You CANNOT use `import()` or `require()` in Info.lua
- You CANNOT use any other Lua or Lightroom Classic globals

### Platform Detection

- `WIN_ENV` -- true on Windows, nil on Mac
- `MAC_ENV` -- true on Mac, nil on Windows
- Use these to handle platform-specific paths, line endings, etc.
- `LrSystemInfo` namespace (SDK 3.0+) provides additional platform details including 32-bit vs 64-bit

## Threading & Async Constraints

### Must Use Async Tasks

- Most SDK API calls MUST happen inside `LrTasks.startAsyncTask()`
- Some API functions (e.g., `LrHttp`) are ONLY available when called from within a background task
- Menu item scripts need to create their own tasks if they call task-requiring APIs
- Export/publish callbacks (`processRenderedPhotos`) run in cooperative tasks that Lightroom provides -- you do NOT need to start your own task there
- `LrFunctionContext.postAsyncTaskWithContext()` is available for background tasks that need a function context

### Catalog Access Rules

- Only ONE plugin can have write access at a time
- `catalog:withWriteAccessDo()` blocks until access is available (or times out)
- Write access timeout: use `{ timeout = N }` to avoid infinite waits
- Nested write access calls from same plugin DO work
- Write access from observers: be careful of re-entrancy (use `LrRecursionGuard`)
- Read access is usually implicit; `catalog:withReadAccessDo()` guarantees a consistent snapshot

### No True Multithreading

- `LrTasks.startAsyncTask()` is cooperative, not preemptive
- Long computations block other tasks unless you `LrTasks.yield()` periodically
- HTTP requests (`LrHttp`) implicitly yield
- Each export filter and service provider runs in its own task, allowing parallel processing of photos through the filter chain

## Export & Publish Constraints

### File Format Limitations

- `allowFileFormats` / `disallowFileFormats` control available formats in the Export dialog
- Valid formats: `"JPEG"`, `"PSD"`, `"TIFF"`, `"DNG"`, `"ORIGINAL"`
- Cannot create custom output formats
- Video file formats are determined separately (via `LrExportSettings.applyVideoExportPreset()`)

### Export Dialog Section Control

- `showSections` / `hideSections` control which built-in sections appear
- Valid section identifiers: `exportLocation`, `fileNaming`, `fileSettings`, `imageSettings`, `outputSharpening`, `metadata`, `video`, `watermarking`
- You can specify EITHER show or hide for a category, not both
- If you hide `exportLocation`, Lightroom renders photos into a temporary folder and deletes it when your `processRenderedPhotos` function completes

### Color Space Restrictions

- `allowColorSpaces` / `disallowColorSpaces` control available color spaces
- Valid color spaces: `"sRGB"`, `"AdobeRGB"`, `"ProPhotoRGB"`

### Rendition Limits

- `LrLimitNumberOfTempRenditions` in Info.lua controls whether Lightroom throttles temporary image files on disk during export
- When true, the plugin is expected to remove temporary rendition files when done with them
- Each rendition creates a temporary file on disk -- watch disk space during large exports
- Available in SDK 5.0+

### Export Destination

- `canExportToTemporaryLocation` -- if true, adds "Temporary folder" option to Export To popup (default is false)
- If you hide the `exportLocation` section, temporary folder behavior happens automatically
- Available in SDK 2.0+

### Publish Service Constraints

- Publish is a superset of export: a publish service can define everything an export service can, plus additional items
- A publish service keeps track of what has been published previously (new, changed, deleted)
- Must call `rendition:recordPublishedPhotoId()` after successful upload to track published state
- `metadataThatTriggersRepublish` must be specified to auto-detect changes requiring republish
- Deleting from a published collection does not delete from the catalog
- Smart collections in publish services: limited predicate support
- Cannot control Publishing Manager dialog settings via presets (unlike export services)
- Can provide default values via `exportPresetFields` defaults or `startDialog` callback
- Publish service settings are remembered between sessions via `exportPresetFields`, but cannot be saved/loaded as named presets

### Post-Process Action (Export Filter) Constraints

- Each post-process action can define only ONE section for the Export dialog
- Filter sections are always inserted after built-in sections and before "bottom" sections from the Export Service Provider
- Export Filter Providers cannot define their own presets (but their settings are included in Export Service presets)
- Each filter MUST generate a photo conforming exactly to the specifications provided (format, path) -- it must never provide a different format than requested
- If a filter cannot process a photo, it must call `renditionToSatisfy:renditionIsDone(false, message)`

## UI Constraints

### No Custom Windows

- Can only use `LrDialogs.presentModalDialog()` or `LrDialogs.presentFloatingDialog()`
- All dialogs are modal except floating dialogs (SDK provides both)
- Cannot create persistent toolbars or panels (except in Web module via web engine)
- Export dialog sections are the primary UI extension point
- Plugin Manager dialog sections are another extension point
- No tray/dock icons or system-level UI

### View Factory Limitations

- No HTML/web views within Lightroom UI
- Limited set of controls: `checkbox`, `color_well`, `combo_box`, `edit_field`, `group_box`, `popup_menu`, `push_button`, `radio_button`, `slider`, `static_text`, `tab_view`, `picture`, and layout containers (`row`, `column`, `view`, `spacer`)
- No tree views, no data grids, no custom drawing or canvas
- No drag-and-drop support in plugin UI
- `f:picture` supports PNG, JPEG from plugin resources
- Container types: `view`, `group_box`, `tab_view`/`tab_view_item`, `column`, `row`, `spacer`

### Binding Limitations

- Observable tables only fire on direct property changes
- Nested table changes (modifying `table.subtable.key`) do NOT fire observers
- Must replace the entire sub-table or use a flat key structure
- Observer callbacks run synchronously -- avoid heavy work in them
- Property tables must be created within a function context so Lightroom can clean up notifications
- The `synopsis` binding in dialog sections must specify the bound table explicitly (it is not part of the view hierarchy where `propertyTable` is automatically the default)

## File System Constraints

- Use `LrFileUtils`/`LrPathUtils` when convenient, but `io` (including `io.open` and `io.popen`) is available in Lightroom plugin runtime.
- `LrTasks.execute()` can run shell commands but is limited
- No file watching/monitoring capability
- `LrFileUtils` provides path-oriented helpers; direct file I/O via `io.open()` is available, and process piping via `io.popen()` is also available.
- All paths are specified in platform-specific syntax
- `LrPathUtils` handles platform-appropriate path manipulation

## Network Constraints

- `LrHttp` supports GET, POST, multipart POST
- `LrHttp` MUST be called from within a background task
- No WebSocket support
- No persistent connections
- No built-in OAuth flow (must implement manually with `LrHttp` + `LrDialogs` for auth)
- HTTPS is supported
- `LrSocket` exists but is poorly documented -- primarily for communication with external processes on localhost
- `LrFtp` provides FTP connection support (both namespace and class)

## Catalog Constraints

- No SQL access to catalog database (it is SQLite internally but not exposed)
- Search/filter via `catalog:findPhotos()` has limited predicate support (must match the criteria/operations defined for smart collections)
- Cannot create virtual folders or modify folder structure
- Cannot modify other plugins' metadata
- Cannot intercept or modify import operations
- No direct access to preview/thumbnail cache
- Custom metadata values are stored only in Lightroom's database -- cannot link to XMP values or save with image files
- Custom metadata fields are limited to simple per-photo values -- no complex data types (e.g., spreadsheets)

## Plugin Lifecycle Gotchas

- `LrInitPlugin` runs once when plugin loads -- avoid heavy work here
- `.lrdevplugin` during development: Lightroom recognizes this suffix but does NOT auto-package it like `.lrplugin` does on macOS
- Plugin reloading via Plug-in Author Tools does NOT reload localization dictionaries -- those are only read on first load or Lightroom restart
- Global state is lost on reload -- use `LrPrefs` for persistence
- `LrForceInitPlugin = true` forces initialization script to run at application startup (even for plugins that only contribute menu items), but requires the plugin to contribute at least a menu item. Available in SDK 4.0+
- `LrShutdownPlugin` script executes only if the plugin was loaded/reloaded through the Plug-in Manager during the current session
- `LrShutdownApp` shutdown function must report progress; if 10 seconds pass without progress, Lightroom assumes it is hung and proceeds with shutdown
- `LrDialogs` namespace is NOT available during the shutdown task (`LrShutdownApp`)
- Plugin errors: Lightroom silently catches most errors; use `LrLogger` to see them
- `LrTasks.startAsyncTask()` automatically attaches an error dialog to the function context; use `LrTasks.startAsyncTaskWithoutErrorHandler()` if you want custom error handling

## Version Compatibility

- `LrSdkVersion` declares the preferred SDK version the plugin was built for
- `LrSdkMinimumVersion` is the minimum SDK version that can run the plugin (defaults to `LrSdkVersion` if not set)
- This allows a plugin to work across multiple Lightroom versions while offering newer features when available
- Newer Lightroom versions may deprecate APIs -- use `config.lua` with `sdkDeprecation.action=throw|log` during development to find deprecated calls
- Deprecated call logging requires configuring `loggers.AgSdkDeprecation` in `config.lua`
- Old plugins may not work in newer Lightroom versions
- SDK version must be >= 2.0 for: `LrPluginName`, `LrPluginInfoProvider`, `LrExportFilterProvider`, `LrMetadataProvider`, `LrMetadataTagsetFactory`, `canExportToTemporaryLocation`
- SDK version must be >= 3.0 for: `LrShutdownPlugin`, `LrEnablePlugin`, `LrDisablePlugin`
- SDK version must be >= 4.0 for: `LrForceInitPlugin`, `LrShutdownApp`, `URLHandler`, `supportsVideo` in filters

## Text Encoding Gotchas

### Unicode LINE SEPARATOR (U+2028)

Lightroom uses Unicode LINE SEPARATOR (U+2028) instead of `\n` for multi-line text in metadata fields (e.g. captions). Plugins sending text to external APIs must convert between the two formats, or line breaks will be lost or garbled. The UTF-8 byte sequence for U+2028 is `0xE2 0x80 0xA8`.

```lua
-- Convert Lightroom text to standard newlines before sending to APIs:
local apiText = string.gsub(lrText, string.char(0xE2, 0x80, 0xA8), "\n")

-- Convert standard newlines back to Lightroom format when importing text:
local lrText = string.gsub(apiText, "\n", string.char(0xE2, 0x80, 0xA8))
```

## Performance Gotchas

- Iterating large photo collections (10,000+) can be slow
- `photo:getDevelopSettings()` is expensive -- cache results when possible
- Batch write operations: do as much as possible inside a single `catalog:withWriteAccessDo()` call
- `LrTasks.yield()` between heavy iterations to keep UI responsive
- Export renditions: each creates a temp file -- watch disk space
- Export filter chain runs in parallel tasks, which helps throughput but means multiple photos can be in process simultaneously by different providers
- `searchable = true` on metadata fields stores them in a separate, indexed table for faster searching -- but strings must not exceed 511 bytes
- The `shouldRenderPhoto()` function is called per-photo per-filter in sequence -- keep it lightweight

## Known Workarounds

- **For file writing:** `LrTasks.execute()` can run shell commands to write files
- **For OAuth:** open browser with `LrHttp.openUrlInBrowser()`, use localhost callback with `LrSocket`
- **For complex UI:** open a web browser with `LrHttp.openUrlInBrowser()` for rich interfaces
- **For background polling:** use `LrTasks.startAsyncTask()` with `LrTasks.sleep()` in a loop
- **For finding deprecated API calls:** configure `sdkDeprecation` in `config.lua`
- **For constructing search descriptors:** build the search as a Smart Collection in Lightroom, export the `.lrsmcol` file, and adapt the Lua table from it
- **For debugging:** use `LrLogger` with either `"print"` (console) or `"logfile"` actions; see also Plug-in Author Tools in the Plug-in Manager for diagnostic output and auto-reload on export


## SDK Documentation Typos (Official)

- `HueAdjustmentMagenha` (expected: Magenta)
- `LuminanceAdjustmentAque` (expected: Aqua)
- `Parametriclights` (expected: ParametricLights)
- `quickDevelopSetWhiteBalacne` (expected: quickDevelopSetWhiteBalance)
