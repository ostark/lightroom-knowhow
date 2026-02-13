# Namespace APIs

Namespaces are the primary way to access Lightroom Classic SDK functionality. They are imported using the `import` function and provide static utility functions organized by domain.

```lua
local LrXxx = import 'LrXxx'
```

The SDK defines namespaces as Lua tables containing suites of functions. Lightroom Classic does not use Lua 5.1's module system. Some namespaces (LrFtp, LrView, LrXml, LrFunctionContext) also act as classes and can create object instances.

---

## LrApplication

Application-wide information; provides access to the active catalog.

```lua
local LrApplication = import 'LrApplication'
```

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `LrApplication.versionString()` | string | Lightroom version as a human-readable string |
| `LrApplication.versionTable()` | table | Version as `{major, minor, revision, build}` |
| `LrApplication.macVersion()` | string or nil | macOS version string (nil on Windows) (verify with API reference) |
| `LrApplication.winVersion()` | string or nil | Windows version string (nil on macOS) (verify with API reference) |
| `LrApplication.activeCatalog()` | LrCatalog | Returns the current LrCatalog object |
| `LrApplication.currentModuleName()` | string | Name of the active module: `"develop"`, `"library"`, `"slideshow"`, `"print"`, `"web"`, `"map"`, `"book"` (verify with API reference) |
| `LrApplication.switchToModule(moduleName)` | void | Switch to a named module (verify with API reference) |
| `LrApplication.developPresetFolders()` | table | Returns develop preset folders as LrDevelopPresetFolder objects |

### Usage

```lua
local LrApplication = import 'LrApplication'
local catalog = LrApplication.activeCatalog()
local version = LrApplication.versionTable()
-- version.major, version.minor, version.revision, version.build
-- Use for version-gating features: if version.major >= 6 then ... end
```

**Note:** In the restricted `Info.lua` loader environment, you cannot use `import` to access `LrApplication`. However, the `_VERSION` variable in that context contains most of the version information otherwise available through `LrApplication.versionTable()`.

---

## LrBinding

Allows you to define data relationships between UI elements and observable property tables.

```lua
local LrBinding = import 'LrBinding'
```

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `LrBinding.makePropertyTable(context)` | LrObservableTable | Create an observable property table bound to a function context |
| `LrBinding.negativeOfKey(keyName)` | binding | Binds to the Boolean opposite or numeric negation of a key value. Works bidirectionally. |
| `LrBinding.keyIsNil(keyName)` | binding | Sets a Boolean property to true when the key value is nil. One-way only (table to property). |
| `LrBinding.keyIsNotNil(keyName)` | binding | Sets a Boolean property to true when the key value is not nil. One-way only. |
| `LrBinding.keyEquals(keyName, value)` | binding | Sets a Boolean property to true when the key equals the specified value. One-way only. |
| `LrBinding.keyIsNot(keyName, value)` | binding | Sets a Boolean property to true when the key does not equal the specified value. One-way only. (verify with API reference) |
| `LrBinding.andAllKeys(...)` | binding | Sets a Boolean property to true when all specified Boolean keys are true. One-way only. |
| `LrBinding.orAllKeys(...)` | binding | Sets a Boolean property to true when any of the specified Boolean keys is true. One-way only. |
| `LrBinding.kUnsupportedDirection` | constant | Return value for custom transform functions indicating that a particular direction of binding is not supported |

### Usage

```lua
local LrBinding = import 'LrBinding'
local LrFunctionContext = import 'LrFunctionContext'

LrFunctionContext.callWithContext("example", function(context)
    local properties = LrBinding.makePropertyTable(context)
    properties.url = "http://www.example.com"
    properties.isEnabled = true
end)
```

### Binding Functions in Views

```lua
-- Simple negation (bidirectional)
visible = LrBinding.negativeOfKey("LR_export_useSubfolder")

-- Key equality check (one-way: table -> property)
visible = LrBinding.keyEquals("format", "jpeg")

-- Combine multiple Boolean keys
enabled = LrBinding.andAllKeys("setting1", "setting2")
```

**Key concept:** Observable tables must be created within a function context (`LrFunctionContext.callWithContext()`), which ensures proper cleanup of notifications. The `LrBinding` functions other than `negativeOfKey` work only with Boolean values and only in one direction (bound table to bound property).

---

## LrColor

Both a namespace and a class. Allows access to color values, specified using RGB or grayscale values or by name.

```lua
local LrColor = import 'LrColor'
```

### Constructor

| Constructor | Returns | Description |
|-------------|---------|-------------|
| `LrColor(r, g, b)` | LrColor | Create color from RGB values (0.0-1.0 range) |
| `LrColor(r, g, b, a)` | LrColor | Create color with alpha channel (verify with API reference) |
| `LrColor(grayValue)` | LrColor | Create grayscale color (verify with API reference) |
| `LrColor('red')`, `LrColor('green')`, etc. | LrColor | Create from named color (verify with API reference) |

### Usage

```lua
local LrColor = import 'LrColor'

-- RGB color
local red = LrColor(1, 0, 0)
local black = LrColor(0, 0, 0)

-- Used in view properties
f:static_text {
    title = "Warning",
    text_color = LrColor(1, 0, 0),  -- red text
}
```

**Note:** LrColor objects are used throughout the view system for `text_color`, `frame_color`, and other color-related properties.

---

## LrDate

Allows you to create and manipulate date-time values.

```lua
local LrDate = import 'LrDate'
```

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `LrDate.currentTime()` | number | Current time as a numeric timestamp |
| `LrDate.timeFromComponents(year, month, day, hour, minute, second, timezone)` | number | Construct a time value from components |
| `LrDate.timestampToComponents(time)` | multiple | Decompose a time value into year, month, day, hour, minute, second |
| `LrDate.timeToUserFormat(time, formatString)` | string | Format a time value for display. Uses `strftime`-style format strings (e.g. `"%Y-%m-%d"`, `"%m-%d-%Y %H:%M:%S"`) |
| `LrDate.timeToW3CDate(time)` | string | Format as W3C/ISO 8601 date string |
| `LrDate.timeToIsoDate(time)` | string | Convert a numeric timestamp to ISO date string. Useful for smart collection `captureTime` criteria |
| `LrDate.timeFromExif(exifDateString)` | number | Parse an EXIF date string into a time value |

### Usage

```lua
local LrDate = import 'LrDate'
local now = LrDate.currentTime()
local formatted = LrDate.timeToW3CDate(now)
```

**Note:** The `os` standard namespace in Lightroom's Lua environment is restricted to `clock()`, `date()`, `time()`, and `tmpname()`. Use `LrDate` for all other date/time operations.

---

## LrDialogs

Allows you to show messages in predefined modal dialogs and create custom dialog boxes.

```lua
local LrDialogs = import 'LrDialogs'
```

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `LrDialogs.message(title, message, style)` | void | Display an alert dialog. Style is `"info"`, `"warning"`, or `"critical"`. Has a single OK button. |
| `LrDialogs.confirm(title, message, okVerb, cancelVerb, otherVerb)` | string | Confirmation dialog. Returns `"ok"`, `"cancel"`, or `"other"`. Optional third button via `otherVerb`. |
| `LrDialogs.presentModalDialog(params)` | string | Display a fully customized modal dialog. Returns `"ok"` or `"cancel"`. |
| `LrDialogs.presentFloatingDialog(context, params)` | void | Display a non-modal (floating) dialog |
| `LrDialogs.runOpenPanel(params)` | table or nil | Platform Open File dialog. **Always returns a table of paths** (even when `allowsMultipleSelection = false`), or `nil` if cancelled. Access first result with `result[1]`. |
| `LrDialogs.runSavePanel(params)` | string or nil | Platform Save File dialog. Returns file path or nil if cancelled. |
| `LrDialogs.showBezel(message, fadeDelay)` | void | Overlay notification (bezel message) that fades after delay (verify with API reference) |
| `LrDialogs.showError(message)` | void | Display a simple error message with OK button |
| `LrDialogs.attachErrorDialogToFunctionContext(context)` | void | Wraps an error dialog around a function context so thrown errors are shown to the user |
| `LrDialogs.showModalProgressDialog(params)` | void | Progress dialog (verify with API reference -- community-discovered) |

### presentModalDialog Parameters

```lua
local result = LrDialogs.presentModalDialog {
    title = "My Dialog",          -- dialog title (not bindable)
    contents = viewHierarchy,     -- LrView hierarchy
    actionVerb = "OK",            -- text for action button
    cancelVerb = "Cancel",        -- text for cancel button (or "< exclude >" to hide)
    accessoryView = aView,        -- optional accessory view
    resizable = true,             -- user can resize (optional)
    save_frame = "myDialogFrame", -- save size as plugin setting (optional)
}
```

### runOpenPanel Parameters

```lua
local paths = LrDialogs.runOpenPanel {
    title = "Select Files",
    canChooseFiles = true,
    canChooseDirectories = false,
    allowsMultipleSelection = true,
    fileTypes = { "jpg", "png" },  -- allowed file extensions
}
```

### runSavePanel Parameters

```lua
local path = LrDialogs.runSavePanel {
    title = "Save As",
    requiredFileType = "txt",
}
```

### Usage

```lua
local LrDialogs = import 'LrDialogs'

-- Simple message
LrDialogs.message("Export Complete", "All photos uploaded.", "info")

-- Confirmation
local answer = LrDialogs.confirm("Delete?", "Remove selected photos?", "Delete", "Cancel")
if answer == "ok" then
    -- proceed with deletion
end

-- Custom dialog (requires function context)
LrFunctionContext.callWithContext("myDialog", function(context)
    LrDialogs.attachErrorDialogToFunctionContext(context)
    local f = LrView.osFactory()
    local props = LrBinding.makePropertyTable(context)
    local contents = f:row { ... }
    local result = LrDialogs.presentModalDialog {
        title = "Custom Dialog",
        contents = contents,
    }
end)
```

**Important:** The `LrDialogs` namespace is NOT available in the shutdown task environment (`LrShutdownApp`). Dialog titles are not part of LrView objects and cannot be bound to data.

---

## LrErrors

Allows you to format Lua error strings to be used in error dialogs.

```lua
local LrErrors = import 'LrErrors'
```

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `LrErrors.throwUserError(message)` | never | Throw a user-facing error with a localizable message. Displayed in the standard error dialog. |
| `LrErrors.throwCanceled()` | never | Throw a cancellation error, indicating the user cancelled an operation. |
| `LrErrors.isCanceledError(error)` | boolean | Check if an error was a cancellation (verify with API reference) |

### Usage

```lua
local LrErrors = import 'LrErrors'

-- Throw a user-visible error
LrErrors.throwUserError(LOC "$$$/MyPlugin/Error=Something went wrong.")

-- Throw a cancellation
LrErrors.throwCanceled()
```

**Key distinction:** `LrErrors.throwUserError()` produces a user-friendly error dialog, while the built-in Lua `error()` function produces an internal error dialog (less user-friendly). The standard error dialog behavior is provided by `LrDialogs.attachErrorDialogToFunctionContext()`, which `LrTasks.startAsyncTask()` calls automatically.

---

## LrExportSettings

Allows you to check or set image file format settings for an export operation.

```lua
local LrExportSettings = import 'LrExportSettings'
```

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `LrExportSettings.applyVideoExportPreset(settings, preset)` | void | Apply a video export preset to export settings (verify with API reference) |
| `LrExportSettings.videoExportPresets` | table | Available video export presets (returns LrVideoExportPreset objects) (verify with API reference) |

**Note:** Primarily used internally for export preset management. See the API Reference for full details on available settings keys.

---

## LrFileUtils

Allows you to manipulate files and folders in the file system in a platform-independent manner.

```lua
local LrFileUtils = import 'LrFileUtils'
```

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `LrFileUtils.exists(path)` | string or false | Returns `"file"`, `"directory"`, or `false` |
| `LrFileUtils.isReadable(path)` | boolean | Check if a file is readable |
| `LrFileUtils.isWritable(path)` | boolean | Check if a file is writable |
| `LrFileUtils.readFile(path)` | string | Read entire file contents as a string |
| `LrFileUtils.delete(path)` | void | Delete a file |
| `LrFileUtils.createDirectory(path)` | void | Create a directory (verify with API reference) |
| `LrFileUtils.directoryEntries(path)` | iterator | Iterator over all entries in a directory |
| `LrFileUtils.files(path)` | iterator | Iterator over files only (excludes subdirectories) |
| `LrFileUtils.chooseUniqueFileName(path)` | string | Append a number to avoid filename collisions |
| `LrFileUtils.fileAttributes(path)` | table | Returns `{fileSize, lastModificationDate}` (verify with API reference) |
| `LrFileUtils.resolveAllAliases(path)` | string | Resolve macOS aliases and symlinks |
| `LrFileUtils.move(src, dst)` | void | Move a file from src to dst (verify with API reference) |

### Unverified Methods

These are commonly referenced in community code but may not be in the official API:

| Method | Returns | Description |
|--------|---------|-------------|
| `LrFileUtils.writeFile(path, data)` | void | Write string to file (verify with API reference -- may not exist) |
| `LrFileUtils.copy(src, dst)` | void | Copy a file (confirmed by SamsTools plugin -- works in practice) |

### Usage

```lua
local LrFileUtils = import 'LrFileUtils'

if LrFileUtils.exists("/path/to/file.jpg") == "file" then
    local content = LrFileUtils.readFile("/path/to/file.jpg")
end

-- Iterate over files in a directory
for filePath in LrFileUtils.files("/path/to/directory") do
    -- process each file
end
```

**Note:** Use `LrFileUtils` in place of the restricted `os` namespace for file operations. The `os` namespace in Lightroom only provides `clock()`, `date()`, `time()`, and `tmpname()`.

---

## LrFtp

Both a namespace and a class. The namespace functions allow you to work with paths and settings for FTP connections. The class represents an FTP connection.

```lua
local LrFtp = import 'LrFtp'
```

### Namespace Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `LrFtp.create(params)` | ftpConnection | Create an FTP connection object (factory function) |
| `LrFtp.appendFtpPaths(base, addition)` | string | Append FTP path components |

### Object Methods (on ftpConnection)

| Method | Returns | Description |
|--------|---------|-------------|
| `ftpConnection:path()` | string | Get the current remote path |
| `ftpConnection:putFile(localPath, remoteName)` | boolean | Upload a file (verify with API reference) |
| `ftpConnection:getFile(remotePath, localPath)` | boolean | Download a file (verify with API reference) |
| `ftpConnection:removeFile(remotePath)` | boolean | Delete a remote file (verify with API reference) |
| `ftpConnection:makeDirectory(path)` | boolean | Create a remote directory (verify with API reference) |

### Usage

```lua
local LrFtp = import 'LrFtp'

-- Namespace function
local fullPath = LrFtp.appendFtpPaths("/base", "subfolder")

-- Object creation and usage
local ftpConn = LrFtp.create(server, port, passive)
ftpConn:putFile(localPath, remoteName)
```

**Note:** LrFtp is one of the few SDK components that acts as both a namespace (with static functions like `appendFtpPaths`) and a class (with instance methods on connections via colon notation).

---

## LrFunctionContext

Both a namespace and a class. Provides a mechanism for making function calls with defined cleanup and error-handling behavior.

```lua
local LrFunctionContext = import 'LrFunctionContext'
```

### Namespace Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `LrFunctionContext.callWithContext(name, function(context) end)` | varies | Execute a function with a cleanup context. The context object is passed as the first parameter. |
| `LrFunctionContext.postAsyncTaskWithContext(name, function(context) end)` | void | Execute a function asynchronously with a cleanup context |

### Context Object Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `context:addCleanupHandler(fn)` | void | Register a cleanup function, called regardless of how the wrapped function terminates |
| `context:addFailureHandler(fn)` | void | Register a failure handler, called only when the wrapped function throws an error |

### Usage

```lua
local LrFunctionContext = import 'LrFunctionContext'
local LrDialogs = import 'LrDialogs'

LrFunctionContext.callWithContext("myTask", function(context)
    -- Attach error reporting
    LrDialogs.attachErrorDialogToFunctionContext(context)

    -- Add cleanup handler (runs regardless of success/failure)
    context:addCleanupHandler(function()
        -- cleanup resources
    end)

    -- Add failure handler (runs only on error)
    context:addFailureHandler(function(msg)
        -- handle the error
    end)

    -- Your code here
end)
```

**Key concepts:**
- You do not create `LrFunctionContext` instances directly. They are created by the calling functions and exist only for the lifetime of the call or task.
- If you attach multiple cleanup or error handlers, they are called in **reverse order** of attachment.
- Observable property tables (`LrBinding.makePropertyTable()`) must be created within a function context so Lightroom can clean up notifications.
- `LrTasks.startAsyncTask()` automatically calls `LrDialogs.attachErrorDialogToFunctionContext()`, ensuring errors are reported. Use `LrTasks.startAsyncTaskWithoutErrorHandler()` to provide your own error reporting.

---

## LrHttp

Allows you to send and receive data using HTTP. Must be used within a task (async context).

```lua
local LrHttp = import 'LrHttp'
```

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `LrHttp.get(url, headers)` | body, headers | HTTP GET request. Returns response body and headers. |
| `LrHttp.post(url, body, headers)` | body, headers | HTTP POST request. Returns response body and headers. |
| `LrHttp.postMultipart(url, content, headers)` | body, headers | Multipart POST for file uploads (verify with API reference) |
| `LrHttp.openUrlInBrowser(url)` | void | Open a URL in the user's default web browser |

### Usage

```lua
local LrHttp = import 'LrHttp'

-- Must be called from within a task
LrTasks.startAsyncTask(function()
    local body, headers = LrHttp.get("https://api.example.com/data")
end)

-- Open URL (can be called from anywhere)
LrHttp.openUrlInBrowser("https://www.adobe.com")
```

**Important:** HTTP functions (`get`, `post`, `postMultipart`) are only available when called from within a background task. Use `LrTasks.startAsyncTask()` or `LrFunctionContext.postAsyncTaskWithContext()` to create a task context.

---

## LrLocalization

Allows you to localize your plug-in for use in multiple languages.

```lua
local LrLocalization = import 'LrLocalization'
```

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `LrLocalization.currentLocale()` | string | Returns the current UI language code (e.g., `"en"`, `"de"`, `"fr"`, `"ja"`) |

### Usage

```lua
local LrLocalization = import 'LrLocalization'
local locale = LrLocalization.currentLocale()
if locale == "de" then
    -- German-specific behavior
end
```

**Note:** For string localization, use the global `LOC` function with ZStrings rather than checking the locale directly. See the localization documentation for details.

---

## LrLogger

Both a namespace and a class. Provides logging capability for debugging plug-ins.

```lua
local LrLogger = import 'LrLogger'
```

### Constructor

```lua
local logger = LrLogger('myPluginLogger')
```

The constructor takes a name string that identifies the logger (and the log file name when writing to disk).

### Object Methods

| Method | Description |
|--------|-------------|
| `logger:enable(action)` | Enable logging. `action` is `"print"` (console output), `"logfile"` (write to disk), or a custom function |
| `logger:trace(msg)` | Log a trace-level message |
| `logger:debug(msg)` | Log a debug-level message |
| `logger:info(msg)` | Log an info-level message |
| `logger:warn(msg)` | Log a warning-level message |
| `logger:error(msg)` | Log an error-level message |
| `logger:fatal(msg)` | Log a fatal-level message |
| `logger:tracef(fmt, ...)` | Log a formatted trace message |
| `logger:debugf(fmt, ...)` | Log a formatted debug message |
| `logger:infof(fmt, ...)` | Log a formatted info message |
| `logger:warnf(fmt, ...)` | Log a formatted warning message |
| `logger:errorf(fmt, ...)` | Log a formatted error message |
| `logger:fatalf(fmt, ...)` | Log a formatted fatal message |
| `logger:quickf(level)` | Returns a convenience function for formatted logging at the specified level. Usage: `local log = logger:quickf('info'); log("Processing %s", name)` |

**Note:** The `f`-suffixed methods (`tracef`, `debugf`, `infof`, `warnf`, `errorf`, `fatalf`) accept `string.format`-style format strings directly, e.g. `logger:debugf("Processing %d of %d: %s", i, total, name)`. This avoids manual string concatenation and is more efficient when logging is disabled.

### Usage

```lua
local LrLogger = import 'LrLogger'
local logger = LrLogger('libraryLogger')
logger:enable("print")   -- output to platform console
-- or
logger:enable("logfile")  -- output to disk

logger:trace("Starting export process")
logger:warn("Something unexpected happened")
```

### Log File Locations

When using `"logfile"` mode:
- **Windows:** `<user_home>\Documents\LrClassicLogs\<loggerName>.txt`
- **macOS:** `~/Documents/LrClassicLogs/<loggerName>.txt`

### Console Viewers

When using `"print"` mode, use a platform console viewer:
- **macOS:** Console app (`/Applications/Utilities/Console.app`) or Xcode
- **Windows:** WinDbg or Microsoft Developer Studio

---

## LrMath

Provides additional basic math operations not otherwise available in the Lua 5.1 language.

```lua
local LrMath = import 'LrMath'
```

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `LrMath.round(number)` | number | Round to nearest integer (Lua 5.1 does not include a round function natively) |

---

## LrMD5

Provides MD5 digest services.

```lua
local LrMD5 = import 'LrMD5'
```

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `LrMD5.digest(string)` | string | Compute the MD5 hash of a string |

### Usage

```lua
local LrMD5 = import 'LrMD5'
local hash = LrMD5.digest("some string")
```

---

## LrPasswords

Provides a mechanism to store passwords in a secure fashion using the operating system's credential store.

```lua
local LrPasswords = import 'LrPasswords'
```

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `LrPasswords.retrieve(serviceName)` | string or nil | Retrieve a stored password from the OS keychain |
| `LrPasswords.store(serviceName, password)` | void | Store a password in the OS keychain |

### Usage

```lua
local LrPasswords = import 'LrPasswords'

-- Store credentials
LrPasswords.store("com.myplugin.ftpserver", "mypassword")

-- Retrieve later
local password = LrPasswords.retrieve("com.myplugin.ftpserver")
```

---

## LrPathUtils

Allows you to manipulate file-system path strings in a platform-appropriate way. All paths are in platform-specific syntax.

```lua
local LrPathUtils = import 'LrPathUtils'
```

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `LrPathUtils.child(parent, child)` | string | Join path components |
| `LrPathUtils.parent(path)` | string | Get the parent directory |
| `LrPathUtils.leafName(path)` | string | Get the filename (leaf) from a path |
| `LrPathUtils.extension(path)` | string | Get the file extension |
| `LrPathUtils.removeExtension(path)` | string | Return path without file extension |
| `LrPathUtils.replaceExtension(path, newExt)` | string | Replace the file extension |
| `LrPathUtils.standardizePath(path)` | string | Normalize a path string |
| `LrPathUtils.getStandardFilePath(name)` | string | Get system paths by name: `"home"`, `"documents"`, `"desktop"`, `"pictures"`, `"temp"`, `"appData"` |
| `LrPathUtils.isAbsolute(path)` | boolean | Check if a path is absolute |
| `LrPathUtils.isRelative(path)` | boolean | Check if a path is relative |

### Usage

```lua
local LrPathUtils = import 'LrPathUtils'

local home = LrPathUtils.getStandardFilePath("home")
local filePath = LrPathUtils.child(home, "myfile.txt")
local ext = LrPathUtils.extension(filePath)            -- "txt"
local name = LrPathUtils.leafName(filePath)             -- "myfile.txt"
local dir = LrPathUtils.parent(filePath)                -- home directory path
local newPath = LrPathUtils.replaceExtension(filePath, "jpg")
```

---

## LrPhotoInfo

Allows you to get information about individual photo files on disk, such as dimensions and EXIF data.

```lua
local LrPhotoInfo = import 'LrPhotoInfo'
```

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `LrPhotoInfo.fileAttributes(path)` | table | Returns EXIF/metadata information from an image file on disk |

---

## LrPrefs

Allows you to define persistent preferences for your plug-in.

```lua
local LrPrefs = import 'LrPrefs'
```

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `LrPrefs.prefsForPlugin()` | table | Returns a persistent, observable preferences table for the current plug-in |

### Usage

```lua
local LrPrefs = import 'LrPrefs'
local prefs = LrPrefs.prefsForPlugin()

-- Set a preference
prefs.lastServer = "ftp.example.com"

-- Read a preference (survives plugin reload and Lightroom restart)
local server = prefs.lastServer
```

**Key properties:**
- Preferences **survive** plug-in reload and Lightroom Classic restart.
- The preferences table is **observable** -- you can bind UI elements to preference values, and you can add observers to be notified of changes.
- Each plug-in has its own separate preferences table (scoped by plugin identifier).

---

## LrProgressScope

Both a namespace and a class. Allows you to provide feedback to the user about the progress of a long-running task.

```lua
local LrProgressScope = import 'LrProgressScope'
```

### Constructor

```lua
local progress = LrProgressScope {
    title = "Processing photos...",
    functionContext = context,  -- optional, ties to a function context
}
```

### Object Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `progress:setCaption(text)` | void | Set the caption text shown in the progress indicator |
| `progress:setPortionComplete(done, total)` | void | Update progress (e.g., `progress:setPortionComplete(5, 10)` for 50%) |
| `progress:done()` | void | Mark the progress as complete |
| `progress:isCanceled()` | boolean | Check if the user has cancelled the operation |
| `progress:cancel()` | void | Programmatically cancel the progress scope |

### Usage

```lua
local LrProgressScope = import 'LrProgressScope'

local progress = LrProgressScope {
    title = "Uploading photos",
}
for i, photo in ipairs(photos) do
    if progress:isCanceled() then break end
    progress:setPortionComplete(i - 1, #photos)
    progress:setCaption("Uploading photo " .. i .. " of " .. #photos)
    -- upload logic
end
progress:done()
```

**Note:** In export operations, use `exportContext:configureProgress()` instead of creating your own `LrProgressScope` -- the export context's rendition iterator automatically updates the progress indicator.

---

## LrRecursionGuard

Both a namespace and a class. Provides a simple recursion guard to prevent infinite recursion in property observers.

```lua
local LrRecursionGuard = import 'LrRecursionGuard'
```

### Constructor

```lua
local guard = LrRecursionGuard()
```

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `guard:isGuarded()` | boolean | Returns true if currently inside a guarded call (verify with API reference) |
| `guard:performWithGuard(fn)` | varies | Execute a function with the recursion guard active (verify with API reference) |

### Usage

Useful when a property observer modifies another property that triggers additional observers, potentially causing infinite recursion.

---

## LrShell

Provides access to shell functions of the platform file browser (Finder on macOS, Windows Explorer on Windows).

```lua
local LrShell = import 'LrShell'
```

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `LrShell.openFilesInApp(fileList, applicationPath)` | void | Open files using a specific application. On Windows, pass empty string as file and target as app to open with default handler. On macOS, use `"open"` as the application. |
| `LrShell.openPathsViaCommandLine(paths, app)` | void | Launch via command line (verify with API reference) |
| `LrShell.revealInShell(path)` | void | Show a file/folder in Finder (macOS) or Explorer (Windows) |

### Usage

```lua
local LrShell = import 'LrShell'
LrShell.revealInShell("/path/to/exported/photo.jpg")
```

---

## LrStringUtils

Provides string manipulation utilities, including Unicode-aware operations.

```lua
local LrStringUtils = import 'LrStringUtils'
```

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `LrStringUtils.trimWhitespace(str)` | string | Trim whitespace from both ends |
| `LrStringUtils.upper(str)` | string | Convert to uppercase (Unicode-aware) |
| `LrStringUtils.lower(str)` | string | Convert to lowercase (Unicode-aware) |
| `LrStringUtils.encodeBase64(str)` | string | Base64 encode a string |
| `LrStringUtils.decodeBase64(str)` | string | Base64 decode a string |
| `LrStringUtils.numberToString(num)` | string | Convert a number to a string (verify with API reference) |
| `LrStringUtils.numberToStringWithSeparators(num)` | string | Convert a number to string with locale-appropriate thousands separators (verify with API reference) |

### Usage

```lua
local LrStringUtils = import 'LrStringUtils'

local lower = LrStringUtils.lower("HELLO")  -- "hello"
local encoded = LrStringUtils.encodeBase64("secret data")
local trimmed = LrStringUtils.trimWhitespace("  spaces  ")  -- "spaces"
```

**Note:** `LrStringUtils.upper()` and `LrStringUtils.lower()` are Unicode-aware, unlike Lua's built-in `string.upper()` and `string.lower()`.

---

## LrSystemInfo

Provides information about the environment in which Lightroom Classic is running.

```lua
local LrSystemInfo = import 'LrSystemInfo'
```

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `LrSystemInfo.appVersion()` | string | Lightroom Classic version info (verify with API reference) |
| `LrSystemInfo.memoryUsage()` | number | Current memory usage (verify with API reference) |
| `LrSystemInfo.summaryString()` | string | System summary string (verify with API reference) |

**Note:** First available in SDK version 3.0. Can provide information about whether the platform is 32-bit or 64-bit. The global Boolean variables `WIN_ENV` and `MAC_ENV` provide a simpler way to determine the current platform.

---

## LrTasks

Allows you to start and manage tasks that run cooperatively on Lightroom Classic's main UI thread.

```lua
local LrTasks = import 'LrTasks'
```

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `LrTasks.startAsyncTask(function() end)` | void | Run a function asynchronously. Automatically attaches an error dialog to the function context. |
| `LrTasks.startAsyncTaskWithoutErrorHandler(function() end)` | void | Run a function asynchronously without the automatic error dialog, allowing custom error handling. |
| `LrTasks.canYield()` | boolean | Check if the current context can yield |
| `LrTasks.yield()` | void | Yield to other tasks, allowing the UI to update |
| `LrTasks.sleep(seconds)` | void | Pause execution for the specified number of seconds |
| `LrTasks.execute(command)` | number | Run a shell command via the platform-specific shell. Returns the exit code. |

### Usage

```lua
local LrTasks = import 'LrTasks'

-- Async task with automatic error handling
LrTasks.startAsyncTask(function()
    -- HTTP calls, long operations, etc.
    local body, headers = LrHttp.get("https://example.com/api")
    LrTasks.yield()  -- let UI update
end)

-- Execute external tool
local status = LrTasks.execute('mytool "' .. pathOrMessage .. '"')

-- Sleep
LrTasks.sleep(2)  -- pause for 2 seconds
```

**Critical concepts:**
- **Most SDK calls must happen within async tasks.** Functions in namespaces like `LrHttp` are only available when called from within a background task.
- `LrTasks.startAsyncTask()` automatically calls `LrDialogs.attachErrorDialogToFunctionContext()`, so thrown errors are reported to the user.
- Use `LrTasks.startAsyncTaskWithoutErrorHandler()` to provide your own error handling.
- `LrTasks.execute()` sends a command string to the platform shell (`cmd.exe` on Windows, `bash` on macOS). Be careful to escape special characters in file paths. This is the replacement for the restricted `os.execute`. Returns exit code (0 = success). On Windows, wrap the entire command in double quotes. To capture output, redirect to a temp file (e.g., via `LrPathUtils.getStandardFilePath("temp")`) and then read it with `LrFileUtils.readFile()`.
- Many plug-in callback functions (e.g., in export/publish APIs) are already called from within tasks that Lightroom creates.

---

## LrView

Both a namespace and a class. The namespace functions allow you to obtain the factory object, create bindings, and share placement values. The class models a node tree for UI elements.

```lua
local LrView = import 'LrView'
```

### Namespace Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `LrView.osFactory()` | factory | Get a platform-specific view factory for creating UI elements |
| `LrView.bind(key)` | binding | Create a binding expression linking a view property to a key in an observable table |
| `LrView.bind(table)` | binding | Complex binding with `{key, bind_to_object, transform}` |
| `LrView.share(identifier)` | shared value | Share a property value across the view hierarchy by identifier |

### Factory Object Methods (Container Types)

| Method | Description |
|--------|-------------|
| `f:view { ... }` | Basic containment frame, no visual representation |
| `f:row { ... }` | Horizontal layout container |
| `f:column { ... }` | Vertical layout container |
| `f:group_box { title, ... }` | Visible containment frame with optional title |
| `f:tab_view { ... }` | Container for tabbed pages |
| `f:tab_view_item { title, identifier, ... }` | A tabbed page within a tab_view |
| `f:spacer { width, height }` | Empty spacing element |

### Factory Object Methods (Control Types)

| Method | Description |
|--------|-------------|
| `f:static_text { title, ... }` | Non-editable text display |
| `f:edit_field { value, ... }` | Editable text input |
| `f:checkbox { title, value, checked_value, unchecked_value, ... }` | Checkbox with label |
| `f:radio_button { title, value, checked_value, ... }` | Radio button |
| `f:popup_menu { value, items, ... }` | Drop-down selection menu |
| `f:combo_box { value, items, ... }` | Editable combo box (text field with dropdown) |
| `f:push_button { title, action, ... }` | Clickable button |
| `f:slider { value, min, max, ... }` | Sliding value control |
| `f:color_well { value, ... }` | Color picker (verify with API reference) |
| `f:separator { fill_horizontal }` | Horizontal separator line (verify with API reference) |
| `f:scrolled_view { ... }` | Scrollable container (verify with API reference) |
| `f:picture { value, ... }` | Image display (verify with API reference) |
| `f:catalog_photo { photo, ... }` | Display a catalog photo (verify with API reference) |
| `f:password_field { value, ... }` | Password input field (verify with API reference) |

### Factory Layout Helper Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `f:control_spacing()` | number | Standard spacing between controls |
| `f:label_spacing()` | number | Standard spacing between a label and its control |
| `f:dialog_spacing()` | number | Standard spacing for dialog margins (verify with API reference) |

### Common View Properties

All views share these general properties:
- `visible` -- Boolean or binding, controls visibility
- `enabled` -- Boolean or binding, controls whether the control is interactive
- `bind_to_object` -- The default observable table for bindings in this view and children
- `place` -- Layout mode: `"horizontal"`, `"vertical"`, `"overlapping"`
- `fill_horizontal` / `fill_vertical` -- Expand to fill available space
- `width` / `height` / `width_in_chars` -- Size specifications
- `alignment` -- `"left"`, `"right"`, `"center"`
- `margin` -- Margin around the view (verify with API reference)

Control-specific properties include:
- `title` -- Display text (localizable with `LOC`)
- `value` -- The control's data value (often bound)
- `font` -- Font specification
- `text_color` -- An LrColor object
- `frame_color` -- An LrColor object (for group_box, etc.)

### Usage

```lua
local LrView = import 'LrView'
local bind = LrView.bind  -- common shortcut

local f = LrView.osFactory()
local contents = f:column {
    spacing = f:control_spacing(),
    bind_to_object = props,
    f:row {
        spacing = f:label_spacing(),
        f:static_text {
            title = "Name:",
            alignment = "right",
            width = LrView.share("label_width"),
        },
        f:edit_field {
            value = bind("userName"),
            width_in_chars = 20,
        },
    },
    f:checkbox {
        title = "Enable feature",
        value = bind("isEnabled"),
    },
}
```

### Complex Binding

```lua
value = LrView.bind {
    key = "slider_value",
    bind_to_object = myTable,          -- optional override
    transform = function(value, fromTable)
        if fromTable then
            return value > 100  -- table -> view: show when over 100
        else
            return LrBinding.kUnsupportedDirection  -- view -> table: not supported
        end
    end,
}
```

**Key concepts:**
- When extending Export/Publishing Manager dialogs, the factory object is passed to `sectionsForTopOfDialog(viewFactory, propertyTable)` and `sectionsForBottomOfDialog()`.
- When creating standalone dialogs from menu items, import the namespace and call `LrView.osFactory()` to get the factory.
- `LrView.share()` synchronizes a property value across the hierarchy (commonly used for aligning label widths).
- `LrView.bind()` creates reactive data bindings. The default bound table is inherited down the view hierarchy.

---

## LrXml

Both a namespace and a class. The namespace functions allow you to create XML builder objects and parse XML documents into read-only DOM objects.

```lua
local LrXml = import 'LrXml'
```

### Namespace Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `LrXml.createXmlBuilder()` | builder | Create an XML builder object for constructing XML documents |
| `LrXml.parseXml(xmlString)` | DOM object | Parse an XML string into a read-only DOM object |

### DOM Object Methods (verify with API reference)

| Method | Returns | Description |
|--------|---------|-------------|
| `dom:name()` | string | Element name |
| `dom:text()` | string | Text content |
| `dom:attributes()` | table | Element attributes |
| `dom:childAtIndex(n)` | DOM object | Child element at index n |
| `dom:childCount()` | number | Number of child elements (verify with API reference) |

### Builder Object Methods (verify with API reference)

The builder object allows programmatic construction of XML documents. See the API Reference for full details.

### Usage

```lua
local LrXml = import 'LrXml'

-- Parse XML
local dom = LrXml.parseXml('<root><item name="test">Hello</item></root>')
local child = dom:childAtIndex(1)
local name = child:name()       -- "item"
local text = child:text()       -- "Hello"
local attrs = child:attributes() -- {name = "test"}

-- Build XML
local builder = LrXml.createXmlBuilder()
-- (see API Reference for builder methods)
```

---

## Summary Table

| Namespace | Type | Primary Purpose |
|-----------|------|-----------------|
| LrApplication | Namespace | App-wide info, active catalog access |
| LrBinding | Namespace | Data binding between UI and observable tables |
| LrColor | Namespace + Class | Color values (RGB, grayscale, named) |
| LrDate | Namespace | Date-time creation and manipulation |
| LrDialogs | Namespace | Modal dialogs, alerts, confirmations, file choosers |
| LrErrors | Namespace | Error throwing and classification |
| LrExportSettings | Namespace | Export preset management |
| LrFileUtils | Namespace | Platform-independent file system operations |
| LrFtp | Namespace + Class | FTP connections and path manipulation |
| LrFunctionContext | Namespace + Class | Error handling and cleanup context management |
| LrHttp | Namespace | HTTP requests (GET, POST, multipart), URL opening |
| LrLocalization | Namespace | Current locale detection |
| LrLogger | Namespace + Class | Debug logging to console or file |
| LrMath | Namespace | Additional math operations (round) |
| LrMD5 | Namespace | MD5 hashing |
| LrPasswords | Namespace | Secure password storage via OS keychain |
| LrPathUtils | Namespace | Platform-appropriate path manipulation |
| LrPhotoInfo | Namespace | Image file metadata from disk |
| LrPrefs | Namespace | Persistent, observable plug-in preferences |
| LrProgressScope | Namespace + Class | Progress indicators for long-running tasks |
| LrRecursionGuard | Namespace + Class | Recursion prevention in observers |
| LrShell | Namespace | Finder/Explorer integration, opening external apps |
| LrStringUtils | Namespace | String utilities (trim, case, Base64) |
| LrSystemInfo | Namespace | System and platform information |
| LrTasks | Namespace | Async task management, sleep, shell execution |
| LrView | Namespace + Class | UI construction, data binding, layout |
| LrXml | Namespace + Class | XML building and parsing |

---

## Verification Notes

Methods marked with **(verify with API reference)** were not explicitly documented in the SDK Programmers Guide but are commonly referenced in examples or community resources. Consult the official Lightroom Classic SDK API Reference (`LR_SDK/API Reference/index.html`) for definitive method signatures and return types.

The Programmers Guide focuses on concepts and usage patterns rather than exhaustive API listings. The companion API Reference (HTML format included with the SDK) provides complete method signatures, parameter types, and return value documentation for every namespace and class.

---

<!-- BEGIN OFFICIAL_NAMESPACES -->
## Official Namespace API (SDK 11.4)

Authoritative method list extracted from official module HTML. Conflicts with earlier prose should be resolved in favor of this section.

### Namespace Index

- `LrApplication` (15 methods)
- `LrApplicationView` (21 methods)
- `LrBinding` (8 methods)
- `LrColor` (6 methods)
- `LrDate` (14 methods)
- `LrDialogs` (14 methods)
- `LrErrors` (3 methods)
- `LrExportSettings` (7 methods)
- `LrFileUtils` (24 methods)
- `LrFtp` (15 methods)
- `LrFunctionContext` (12 methods)
- `LrHttp` (5 methods)
- `LrLocalization` (4 methods)
- `LrLogger` (18 methods)
- `LrMD5` (1 methods)
- `LrMath` (3 methods)
- `LrPasswords` (2 methods)
- `LrPathUtils` (14 methods)
- `LrPhotoInfo` (1 methods)
- `LrPrefs` (1 methods)
- `LrProgressScope` (21 methods)
- `LrRecursionGuard` (2 methods)
- `LrSelection` (26 methods)
- `LrShell` (3 methods)
- `LrSlideshow` (2 methods)
- `LrSocket` (5 methods)
- `LrSounds` (2 methods)
- `LrStringUtils` (12 methods)
- `LrSystemInfo` (11 methods)
- `LrTasks` (7 methods)
- `LrTether` (8 methods)
- `LrUndo` (4 methods)
- `LrXml` (17 methods)

### LrApplication

**Type:** Namespace

| Method Signature | Description |
|---|---|
| `LrApplication.activeCatalog()` | Retrieves the catalog that is currently open in Lightroom. |
| `LrApplication.addDevelopPresetForPlugin( plugin, presetName, presetValue )` | Adds a preset hidden within a plug-in. These presets are stored in a special folder called "Plugin Develop Presets." They do not appear in the presets panel in the Develop module, and cannot be retrieved by ID. To apply the preset, use `LrPhoto:applyDevelopPresetFromPlugin`. To retrieve, use `LrApplication:getDevelopPresetsForPlugin()`. |
| `LrApplication.appStoreReceiptHash()` | Retrieves a unique identifier that is keyed to the Mac App Store receipt. Intended to aid in plug-in registrations for app store builds of Lightroom, where there is no serial number available. |
| `LrApplication.backupAtNextShutdown( pluginId )` | Requests a catalog backup to be performed next time Lightroom closes. This does not alter the backup periodicity already in place, other than by affecting the recorded time for last backup, if the user does not choose to skip the backup via the dialog at shutdown time. |
| `LrApplication.developPresetByUuid( uuid )` | Retrieves a develop preset from its unique identifier. Does not retrieve presets added using `LrApplication:addDevelopPresetForPlugin`. |
| `LrApplication.developPresetFolders()` | Retrieves all defined develop preset folders. |
| `LrApplication.filenamePresets()` | Reports available file-naming presets. |
| `LrApplication.getDevelopPresetsForPlugin( plugin, uuid )` | Retrieves a specific develop preset, or all develop presets associated with this plug-in. |
| `LrApplication.macAddressHash()` | Retrieves a unique identifier that is keyed to the MAC address of the system running Lightroom. Intended to aid in plug-in registrations for app store builds of Lightroom, where there is no serial number available. |
| `LrApplication.metadataPresets()` | Reports available metadata presets. The returned table contains the name of each metadata property along with its string ID. |
| `LrApplication.purchaseSource()` | Returns a string identifying the manner in which the Lightroom instance was obtained. Intended to aid in plug-in registrations for app store builds. |
| `LrApplication.serialNumberHash()` | Retrieves a unique identifier that is keyed to the Lightroom serial number. Can be used to implement plug-in registrations. |
| `LrApplication.versionString()` | Retrieves the current version of the application as a user-displayable string (for instance, "2.0"). |
| `LrApplication.versionTable()` | Retrieves the current version of the application as a table that can be parsed. |
| `LrApplication.viewFilterPresets()` | Reports available view-filter presets. |

### LrApplicationView

This namespace provides access to the application's view state, including the active module, main view mode, secondary view mode, and zoom level. Access the functions directly from the imported namespace.

| Method Signature | Description |
|---|---|
| `LrApplicationView.cycleLoupeViewInfo()` | Changes the Loupe View Info style. Only works in Library and Develop modules. First supported in version 7.4 of the Lightroom SDK. |
| `LrApplicationView.fullscreenHidePanels()` | Changes the screen mode to Full Screen and Hide Panels. First supported in version 7.4 of the Lightroom SDK. |
| `LrApplicationView.fullscreenPreview()` | Changes the screen mode to Full Screen Preview. First supported in version 7.4 of the Lightroom SDK. |
| `LrApplicationView.getCurrentModuleName()` | Returns the name of the currently active module. First supported in version 6.0 of the Lightroom SDK. |
| `LrApplicationView.getSecondaryViewName()` | Returns the name of the view currently showing on the secondary screen, or nil of the secondary display is not on. First supported in version 6.0 of the Lightroom SDK. |
| `LrApplicationView.gridView()` | Opens Grid View. First supported in version 7.4 of the Lightroom SDK. |
| `LrApplicationView.gridViewStyle()` | Changes the Grid View Style. First supported in version 7.4 of the Lightroom SDK. |
| `LrApplicationView.isSecondaryDisplayOn()` | Returns true if the secondary window is currently on. First supported in version 6.0 of the Lightroom SDK. |
| `LrApplicationView.nextScreenMode()` | Changes the Screen Mode. First supported in version 7.4 of the Lightroom SDK. |
| `LrApplicationView.showSecondaryView( viewName )` | Shows a view on the secondary screen, or hides the secondary screen if the given view was previously being shown. First supported in version 6.0 of the Lightroom SDK. |
| `LrApplicationView.showView( viewName )` | Switches the app's view mode. First supported in version 6.0 of the Lightroom SDK. |
| `LrApplicationView.switchToModule( moduleName )` | Switches between modules. First supported in version 6.0 of the Lightroom SDK. |
| `LrApplicationView.toggleLoupe()` | Toggle Loupe View while in Library. First supported in version 7.4 of the Lightroom SDK. Must be used with in Library. |
| `LrApplicationView.toggleSecondaryDisplay()` | Toggles the the secondary window on/off. First supported in version 6.0 of the Lightroom SDK. |
| `LrApplicationView.toggleSecondaryDisplayFullscreen()` | Toggles fullscreen mode for the secondary window. First supported in version 6.0 of the Lightroom SDK. |
| `LrApplicationView.toggleZoom()` | Zooms toggles between zoomed in and zoomed out. Only works in Library and Develop modules. First supported in version 6.0 of the Lightroom SDK. |
| `LrApplicationView.zoomIn()` | Zooms in to next level. Only works in Library and Develop modules. First supported in version 6.0 of the Lightroom SDK. |
| `LrApplicationView.zoomInSome()` | Zooms in one small step. Only works in Library and Develop modules. First supported in version 6.0 of the Lightroom SDK. Deprecated API - included for avoiding breakage of plugins |
| `LrApplicationView.zoomOut()` | Zooms out to next level. Only works in Library and Develop modules. First supported in version 6.0 of the Lightroom SDK. |
| `LrApplicationView.zoomOutSome()` | Zooms out one small step. Only works in Library and Develop modules. First supported in version 6.0 of the Lightroom SDK. Deprecated API - included for avoiding breakage of plugins |
| `LrApplicationView.zoomToOneToOne()` | Zooms to 100%. Only works in Library and Develop modules. First supported in version 10.0 of the Lightroom SDK. |

### LrBinding

This namespace allows you to create observable properties tables, and to define common relationships between UI elements and data property values. Access these functions directly from the imported namespace. The `makePropertyTable()` function creates an observable table, in which you can store program data that you can associate with dynamic values in your UI. Use the transformation functions as the `value` argument to LrView.bind(). These functions perform very common transformations between the source value of a binding (that is, the value whose change triggered a notification, typically an export-settings value in a property table) and the destination value (the other end of the binding, typically a view property such as "visible" or "enabled"). Bindings can work in both directions; that is, a change in the bound table affects the value of the view property, and changing the view property affects the table's key value. However, these functions (except as noted) create one-way bindings. They only change the bound view property when a bound table's key value changes, not the reverse. For example, this creates a binding that hides the control when the value of "mySetting" becomes true: `binding = { visible = LrBinding.negativeOfKey( "mySetting" ) }`

| Method Signature | Description |
|---|---|
| `LrBinding.andAllKeys( optObject, keys )` | Creates a binding that determines if the values of all the source keys evaluate to true. The return value is placed in the bound view property, which must be Boolean. First supported in version 1.3 of the Lightroom SDK. |
| `LrBinding.keyEquals( key, compareValue, optObject )` | Creates a binding that determines if the source value is equal to a comparison value. The return value is placed in the bound view property, which must be Boolean. First supported in version 1.3 of the Lightroom SDK. |
| `LrBinding.keyIsNil( key, optObject )` | Creates a binding that determines if the source value is not present. The return value is placed in the bound view property, which must be Boolean. First supported in version 1.3 of the Lightroom SDK. |
| `LrBinding.keyIsNot( key, compareValue, optObject )` | Creates a binding that determines if the source value is not equal to a comparison value. The return value is placed in the bound view property, which must be Boolean. First supported in version 1.3 of the Lightroom SDK. |
| `LrBinding.keyIsNotNil( key, optObject )` | Creates a binding that determines if the source value is present. The return value is placed in the bound view property, which must be Boolean. First supported in version 1.3 of the Lightroom SDK. |
| `LrBinding.makePropertyTable( functionContext )` | Creates a table that automatically sends notifications whenever values in the table are changed. You can set this as the bound table for an `LrView` object, or pass it as the `optObject` to any of the `LrBinding` functions. You can also call addObserver() on this table to register any object for notification when values in this table are changed. You must call this function with a function context, so that Lightroom can remove notifications when the table is no longer needed. First supported in version 1.3 of the Lightroom SDK. |
| `LrBinding.negativeOfKey( key, optObject )` | Creates a binding that negates the source value, if it is Boolean or numeric. For a value of any other type, the transformation returns nil. This is a two-way binding; changes in the view property also place the negated value in the bound table key. First supported in version 1.3 of the Lightroom SDK. |
| `LrBinding.orAllKeys( optObject, keys )` | Creates a binding that determines if the values of any of the source keys evaluate to true. The return value is placed in the bound view property, which must be Boolean. First supported in version 1.3 of the Lightroom SDK. |

### LrColor

This class encapsulates color values, specified using RGB or grayscale values, or by name. Use the imported namespace as a constructor; access the functions through the created objects.

| Method Signature | Description |
|---|---|
| `LrColor( ... )` | Creates an `LrColor` object. Set the color values using a number in the range [0..1]. For red, green, and blue, 1 is saturation. For alpha (transparency), 0 is fully transparent and 1 is fully opaque. For a grayscale value, 0 is white and 1 is black. You can also specify a color by name. First supported in version 1.3 of the Lightroom SDK. |
| `color:alpha()` | Retrieves the alpha (transparency) value of this color. First supported in version 1.3 of the Lightroom SDK. |
| `color:blue()` | Retrieves the blue value of this color. First supported in version 1.3 of the Lightroom SDK. |
| `color:green()` | Retrieves the green value of this color. First supported in version 1.3 of the Lightroom SDK. |
| `color:red()` | Retrieves the red value of this color. First supported in version 1.3 of the Lightroom SDK. |
| `color:type()` | Reports the type of this object. First supported in version 4.1 of the Lightroom SDK. |

### LrDate

**Type:** Namespace

| Method Signature | Description |
|---|---|
| `LrDate.currentTime()` | Retrieves the current date and time as a Cocoa date stamp; that is, a number of seconds since midnight UTC on January 1, 2001. |
| `LrDate.formatLongDate( time )` | Converts a timestamp to the user's preferred long date format. The exact format varies with user preferences and language settings, but is something like "December 31, 2009". |
| `LrDate.formatMediumDate( time )` | Converts a timestamp to the user's preferred medium date format. Something like "Dec 31, 2009". |
| `LrDate.formatMediumTime( time )` | Converts a timestamp to the user's preferred medium time format. Something like "9:12:34 PM". |
| `LrDate.formatShortDate( time )` | Converts a timestamp to the user's preferred short date format. Something like "12/31/09". |
| `LrDate.formatShortTime( time )` | Converts a timestamp to the user's preferred short time format. Something like "9:12 PM". |
| `LrDate.timeFromComponents( year, month, day, hour, minute, second, timeZone )` | Composes a time stamp from the component values. |
| `LrDate.timeFromPosixDate( time )` | Converts a Unix/Posix-style date timestamp to a Mac-style timestamp. |
| `LrDate.timeToIsoDate( time )` | Converts a timestamp to an ISO formatted date (not including the time). |
| `LrDate.timeToPosixDate( time )` | Converts a Mac-style timestamp to a Unix/Posix-style date timestamp. |
| `LrDate.timeToUserFormat( time, format, isGMT )` | Converts a timestamp to a specified date-time format. The result is produced with the current user's locale, which cannot be changed. By default the result applies the local timezone. |
| `LrDate.timeToW3CDate( time )` | Converts a timestamp to a W3C formatted date and time. |
| `LrDate.timeZone()` | Retrieves the current time zone and reports whether that zone is currently observing daylight savings time. |
| `LrDate.timestampToComponents( time, optTimeZone )` | Converts a Cocoa date stamp to its components (individual values for year, month, day, and so on). |

### LrDialogs

**Type:** Namespace

| Method Signature | Description |
|---|---|
| `LrDialogs.attachErrorDialogToFunctionContext( context )` | Invokes an error dialog if an error results from the execution of a function in a given context. |
| `LrDialogs.confirm( message, info, actionVerb, cancelVerb, otherVerb )` | Invokes a modal dialog for confirmation. Displays a message, with an action button, a cancel button, and optionally one other button. |
| `LrDialogs.message( message, info, style )` | Invokes a modal dialog to display a message, with a single "OK" button that dismisses the dialog. |
| `LrDialogs.messageWithDoNotShow( args )` | Invokes a message dialog that prompts for an action, and includes a "Do not show" checkbox. If the user has seen this dialog before and selected "Do not show," returns without showing the dialog. |
| `LrDialogs.presentFloatingDialog( plugin, args )` | Invokes a custom dialog box as a floating dialog. The contents are defined by an `LrView` hierarchy of containers and controls. |
| `LrDialogs.presentModalDialog( args )` | Invokes a custom dialog box as a modal dialog. The contents are defined by an `LrView` hierarchy. The bottom shows OK and Cancel buttons, and optionally a third button or custom accessory view. |
| `LrDialogs.promptForActionWithDoNotShow( args )` | Invokes a dialog that prompts for an action, and includes a "Do not show" checkbox. If the user has previously selected "Do not show," returns the previously selected action without showing the dialog. |
| `LrDialogs.resetDoNotShowFlag( actionPrefKey )` | Resets one or both "Do not show" flags, as previously set by calls to `messageWithDoNotShow()` or `promptForActionWithDoNotShow()`. |
| `LrDialogs.runOpenPanel( args )` | Invokes the platform Open File dialog. |
| `LrDialogs.runSavePanel( args )` | Invokes the platform Save File dialog. |
| `LrDialogs.showBezel( message, fadeDelay )` | Shows a message in a window that quickly fades away. Only one bezel is visible at any given time; the latest call overrides any existing bezel. |
| `LrDialogs.showError( errorString )` | Invokes a modal dialog that displays an error message. |
| `LrDialogs.showModalProgressDialog( params )` | Shows a modal progress dialog. This dialog remains visible (and blocks all other LR UI elements) until the progress scope is marked completed or canceled. |
| `LrDialogs.stopModalWithResult( dialog, result )` | Dismisses a modal dialog that is currently displayed. Can be used to simulate the user clicking a button. |

### LrErrors

This namespace allows you to format Lua error strings that can be used in error dialogs. The built-in Lua `error()` function is also available in the Lightroom Lua environment. Access the functions directly from the imported namespace.

| Method Signature | Description |
|---|---|
| `LrErrors.isCanceledError( errorString )` | Reports whether an error string returned from a protected call (pcall) represents a user cancellation. First supported in version 1.3 of the Lightroom SDK. |
| `LrErrors.throwCanceled()` | Throws an error indicating that a task was canceled by the user. First supported in version 1.3 of the Lightroom SDK. |
| `LrErrors.throwUserError( text )` | Throws an error with a given message. Use the function `LrDialogs.attachErrorDialogToFunctionContext()` to show a standard error dialog that displays this text. First supported in version 1.3 of the Lightroom SDK. |

### LrExportSettings

This namespace allows you to check or set an image file format for an export operation, and (as of Lightroom 4.0) it also provides access to `LrVideoExportPreset` objects which represent the presets available for video export. These objects, in turn, can be used to access the names of the video export presets, as shown in the Export Dialog, as well as the strings used to represent each preset in export settings (`export_videoPreset` property). Access the functions directly from the imported namespace.

| Method Signature | Description |
|---|---|
| `LrExportSettings.addVideoExportPresets( definition, pluginObject )` | Adds to the available presets for video export in the export/publish dialog in the form of additional entries in the 'Format' and 'Quality' popup menus in the Video section. The video export preset file (.epr) is required to be generated with Adobe Media Encoder. First supported in vesion 4.0 of the Lightroom SDK. |
| `LrExportSettings.applyVideoExportPreset( exportSettings, preset )` | Applies the specified video export preset to the 'exportSettings' property table. Typically used while constructing properties for an LrExportSession instantiation. First supported in version 4.0 of the Lightroom SDK. |
| `LrExportSettings.extensionForFormat( format )` | Retrieves the proper file extension to use for a file format. First supported in version 1.3 of the Lightroom SDK. |
| `LrExportSettings.removeVideoExportPreset( presetObject, pluginObject )` | Removes a custom video export preset previously added by this plug-in via addVideoEXportPresets. This call will return true if successful, false otherwise. Only presets added by this plug-in can be removed. First supported in version 4.0 of the Lightroom SDK. |
| `LrExportSettings.supportableVideoExportFormats()` | Retrieves an array of tables, each of which describes a format supportable for video export. First supported in version 4.0 of the Lightroom SDK. |
| `LrExportSettings.videoExportPresets()` | Retrieves the `LrVideoExportPreset` objects associated with the available presets for video export. First supported in version 4.0 of the Lightroom SDK. |
| `LrExportSettings.videoExportPresetsForPlugin( pluginObject )` | Returns a list of custom video export presets previously added by this plug-in via addVideoEXportPresets. First supported in version 4.0 of the Lightroom SDK. |

### LrFileUtils

**Type:** Namespace

| Method Signature | Description |
|---|---|
| `LrFileUtils.chooseUniqueFileName( path )` | Creates a path string that (if written to) would not overwrite any existing file. If the given path does not refer to an existing file, it is returned unchanged. Otherwise, the last component is altered (e.g., `"/MyDir/MyFile.jpg"` might become `"/MyDir/MyFile-2.jpg"`). |
| `LrFileUtils.copy( srcPath, destPath )` | Copies a file from one location to another. The parent directory at the destination must already exist. Fails if a file with the same name already exists at the destination. |
| `LrFileUtils.createAllDirectories( path )` | Creates a directory at a given path, recursively creating any parent directories that do not already exist. |
| `LrFileUtils.createDirectory( path )` | Creates a directory at a given path. The parent directory must already exist. |
| `LrFileUtils.delete( path )` | Immediately deletes the file or directory at a given path. If the path refers to a directory, all of the contents are deleted. Use with care; in most cases, `moveToTrash()` is preferred. |
| `LrFileUtils.directoryEntries( pathToFolder )` | Iterates through the files and folders that are immediate children of the folder. Use in a for loop: |
| `LrFileUtils.exists( path )` | Reports whether a given path indicates an existing file or directory. |
| `LrFileUtils.fileAttributes( path )` | Retrieves the file attributes for the file or directory at a given path. |
| `LrFileUtils.files( pathToFolder )` | Iterates through the files that are immediate children of the folder. Skips any folders inside this folder. Use in a for loop: |
| `LrFileUtils.hasNoVisibleFiles( path )` | Reports whether a given path refers to a directory that contains no visible files. The definition of "visible" differs between Mac OS and Windows. |
| `LrFileUtils.isDeletable( path )` | Reports whether a file or directory can be deleted. |
| `LrFileUtils.isEmptyDirectory( path )` | Reports whether a given path refers to a directory that contains no files. |
| `LrFileUtils.isReadable( path )` | Reports whether a path indicates a readable disk file. |
| `LrFileUtils.isWritable( path )` | Reports whether a path indicates a writable disk file. |
| `LrFileUtils.makeFileWritable( path )` | Makes a file writeable, if possible. |
| `LrFileUtils.move( srcPath, destPath )` | Moves a file from one location to another. The parent directory at the destination must already exist. Fails if a file with the same name already exists at the destination. |
| `LrFileUtils.moveToTrash( path )` | Moves a file or directory to the system trash or recycle bin. |
| `LrFileUtils.pathsAreOnSameVolume( path1, path2 )` | Reports whether two paths are on the same volume (meaning you could move from one path to the other without copying). |
| `LrFileUtils.readFile( path )` | Reads the contents of a file into memory. Use this in preference to the built-in Lua `io` namespace if the path might contain non-ASCII characters. |
| `LrFileUtils.recursiveDirectoryEntries( pathToFolder )` | Iterates through all files and folders that are anywhere inside the folder (recursive). Use in a for loop: |
| `LrFileUtils.recursiveFiles( pathToFolder )` | Iterates through all files that are anywhere inside the folder (recursive). Looks inside all sub-folders but does not return folder entries themselves. |
| `LrFileUtils.resolveAlias( path )` | Resolves an alias (Mac OS) or shortcut (Windows). |
| `LrFileUtils.resolveAllAliases( path )` | Resolves all aliases and shortcuts in this path and returns the resulting path (the actual file location). Resolves aliases at any location in the path string. Can be time consuming. |
| `LrFileUtils.volumeAttributes( path )` | Retrieves information about the disk volume containing a given path. |

### LrFtp

This namespace and class allows you to send and receive data using FTP. The namespace contains a factory function, `LrFtp.create()`, for creating an `ftpConnection` object. Use this object to connect to remote FTP servers, check for directories and files on the remote system, and upload files. All of these methods block during the network interaction, and must be called from within an asynchronous task started by `LrTasks`. Functions to access FTP settings and work with FTP paths are called directly from the imported namespace.

| Method Signature | Description |
|---|---|
| `LrFtp.appendFtpPaths( root, child )` | Appends two paths together for use in FTP. Often an FTP preset contains a parent directory in which the user wants to put multiple subdirectories. Use this function to generate the final destination directory for upload by combining the parent directory with the child directory. The function ensures that a single directory separator is inserted between the two path parts. If the child path starts with a '/' then the root path is not used. It ensures the result ends in a trailing '/', unless the result is the empty string. It does not resolve relative paths using '..' or '.'. First supported in version 1.3 of the Lightroom SDK. |
| `LrFtp.create( params, autoNegotiate )` | Creates and return an FTP connection object (`ftpConnection`). This method must be called from within within an asynchronous task started by `LrTasks`. First supported in version 1.3 of the Lightroom SDK. |
| `LrFtp.ftpPathValidator( view, inValue )` | A validator function for use in `LrView` UI control definitions. Backslashes are converted to forward slashes, and a notice is presented to the user. If the value contains a new-line character, everything after and including the new-line is removed. First supported in version 1.3 of the Lightroom SDK. |
| `LrFtp.makeFtpPresetPopup( params )` | Creates and returns a pop-up menu view object for accessing FTP presets. First supported in version 1.3 of the Lightroom SDK. |
| `LrFtp.queryForPasswordIfNeeded( ftpSettings )` | Prompts the user for a password, but only if the preset was created with 'store password' unchecked. First supported in version 2.0 of the Lightroom SDK. |
| `ftpConnection:disconnect()` | Disconnects this connection from the server. Once disconnected, this connection cannot be reused. This method must be called from within an asynchronous task started by `LrTasks`. Throws an exception in the event of an error. First supported in version 1.3 of the Lightroom SDK. |
| `ftpConnection:exists( filename )` | Tests for the existance of a file or directory on the remote system. at the current `ftpConnection.path`. This method must be called from within an asynchronous task started by `LrTasks`. First supported in version 1.3 of the Lightroom SDK. |
| `ftpConnection:getContents( remoteFileName )` | Retrieves the contents of a file or directory on the remote server and returns it as a string. If the remote name is a path separator character ('/'), a file listing for the current `ftpConnection.path` will be returned. This method must be called from within an asynchronous task started by `LrTasks`. Throws an exception in the event of an error. First supported in version 1.3 of the Lightroom SDK. |
| `ftpConnection:makeDirectory( directoryName )` | Creates a directory on the remote server. The current `ftpConnection.path` must exist on the server as a directory. There must not exist any file or directory of this name at the destination location. This method must be called from within an asynchronous task started by `LrTasks`. Throws an exception in the event of an error. First supported in version 1.3 of the Lightroom SDK. |
| `ftpConnection:pRemoveDirectory( directoryName )` | Removes a directory on the remote server. The same as `removeDirectory()`, except that it returns success or failure rather than throwing an exception. First supported in version 1.3 of the Lightroom SDK. |
| `ftpConnection:pRemoveFile( filename )` | Removes a file on the remote server. The same as `removeFile()`, except that it returns success or failure rather than throwing an exception. First supported in version 1.3 of the Lightroom SDK. |
| `ftpConnection:putFile( theLocalFilePath, destFileName )` | Sends a file from the local filesystem to the remote server. To specify an upload destination, set the connection to a given directory by setting the path property. The upload destination must already exist as a directory. This method must be called from within an asynchronous task started by `LrTasks`. Throws an exception in the event of an error. First supported in version 1.3 of the Lightroom SDK. |
| `ftpConnection:removeDirectory( directoryName )` | Removes a directory on the remote server. The current `ftpConnection.path` must exist on the server as a directory. There must exist an empty directory with this name at the destination location. This method must be called from within an asynchronous task started by `LrTasks`. Throws an exception on error. First supported in version 1.3 of the Lightroom SDK. |
| `ftpConnection:removeFile( filename )` | Removes a file on the remote server. The current `ftpConnection.path` must exist on the server as a directory. There must exist a file with this name at the destination location. This method must be called from within an asynchronous task started by `LrTasks`. Throws an exception in the event of an error. First supported in version 1.3 of the Lightroom SDK. |
| `ftpConnection:toTable()` | Converts the properties of this FTP connection back into a Lua table, the same as the one passed to `LrFtp.create()` to create the object. First supported in version 1.3 of the Lightroom SDK. |

### LrFunctionContext

**Type:** Namespace and Class

| Method Signature | Description |
|---|---|
| `LrFunctionContext.callWithContext( name, func, ... )` | Calls the main function, then calls all of the cleanup handlers before returning control. If called from within an asynchronous task, uses `LrTasks.pcall()` to make a yield-safe call. If an error is thrown, it is rethrown after the cleanup handlers are called. |
| `LrFunctionContext.callWithContext_noyield( name, func, ... )` | Same as `callWithContext`, but calls the function in a fashion that disables `LrTasks.yield` from working. Use if you need to ensure that the called function is completed as an atomic unit. |
| `LrFunctionContext.callWithEmptyEnvironment( func, ... )` | Runs the main function in a known-safe function environment. Equivalent to `setfenv( func, {} ); return func( ... )`. The function is subjected to `string.dump` for safety; variables from the calling scope (including imported namespaces) do not carry through. |
| `LrFunctionContext.callWithEnvironment( func, env, ... )` | Runs the main function in a caller-provided function environment. Equivalent to `setfenv( func, env ); return func( ... )`. The function is subjected to `string.dump` for safety. |
| `LrFunctionContext.pcallWithContext( name, func, ... )` | Makes a protected call, like Lua's standard `pcall`, but calls all of the cleanup handlers before returning control. If called within an asynchronous task, uses `LrTasks.pcall()`. Cleanup handlers are deferred until the coroutine runs to completion or failure (not called when yielding). |
| `LrFunctionContext.pcallWithContext_noyield( name, func, ... )` | Same as `pcallWithContext`, but disables `LrTasks.yield`. Use to ensure the called function is completed atomically. |
| `LrFunctionContext.pcallWithEmptyEnvironment( func, ... )` | Runs the main function in a known-safe function environment, catching any exceptions. Equivalent to `setfenv( func, {} ); return pcall( func, ... )`. |
| `LrFunctionContext.pcallWithEnvironment( func, env, ... )` | Runs the main function in a caller-provided function environment, catching any exceptions. Equivalent to `setfenv( func, env ); return pcall( func, ... )`. |
| `LrFunctionContext.postAsyncTaskWithContext( name, func )` | Runs the main function in an asynchronous/cooperative task, then calls any cleanup handlers. |
| `functionContext:addCleanupHandler( func )` | Registers a cleanup handler in an instance. This function is called when the main function finishes or throws an error. Cleanup handlers are called in reverse order of registration (last registered is called first). |
| `functionContext:addFailureHandler( func )` | Registers a failure handler in an instance. This function is called only if the main function fails (throws an error). This is a convenience function that wraps your function so it is only called on failure. |
| `functionContext:addOperationTitleForError( title )` | Attaches a string to this function context to be shown in any error dialog triggered by `LrDialogs.attachErrorDialogToFunctionContext`. This string acts as a title to the actual error message. Use the form "Unable to perform operation." |

### LrHttp

**Type:** Namespace

| Method Signature | Description |
|---|---|
| `LrHttp.get( url, headers, timeout )` | Retrieves data over the network using HTTP or HTTPS GET. |
| `LrHttp.openUrlInBrowser( url )` | Opens a URL in the user's preferred web browser. |
| `LrHttp.parseCookie( cookie, decodeUrlEncoding )` | Converts a received "Set-Cookie" field into a Lua table. Each field is a separate table key, with the field's value as the table value. For fields without an explicit value (such as `secure`), the value is set to `true`. |
| `LrHttp.post( url, postBody, headers, method, timeout, totalSize )` | Sends or retrieves data using HTTP or HTTPS POST. Limited to a single chunk of post data. Must be called from within `LrFunctionContext.postAsyncTaskWithContext()`. |
| `LrHttp.postMultipart( url, content, headers, timeout, callbackFn, suppressFormData )` | Sends or retrieves MIME-Multipart data using HTTP or HTTPS POST. Assumes content consists of `form-data` and inserts a `Content-Disposition` header into each MIME part (behavior can be suppressed as of LR 5.0). |

### LrLocalization

This namespace allows you to localize your plug-in for use in multiple languages, using the Adobe ZString mechanism. A ZString uniquely identifies a string usage within an application, allowing you to provide different language versions of the string, depending on the locale. A ZString has this format: `"$$$/ZStringPath/StringKey=This is the English text value"` The ZString mechanism searches a string dictionary for the current locale, matching the path and identifier, then displays the language-specific text. You must supply translation dictionaries for supported languages as part of your plug-in. See the SDK Programmer's Guide for information on how to create translation dictionaries. ZStrings in code should consist entirely of low-ASCII characters. The key should only contain characters in the set "a-ZA-Z0-9/". The value can contain any low-ASCII character. ZStrings allow some common non-low-ASCII characters to be substituted for escape sequences in the strings. For example, the sequence `^C` includes the copyright symbol in that location in the resulting string. The escape character followed by a number (`^1`) is a replacement point, that allows the sequence to be replaced by some other string supplied as an additional argument to `LOC()`. The following escape sequences are available: `^r`: carriage return `^n`: line feed `^B`: bullet `^C`: copyright `^D`: degree `^I`: increment `^R`: registered trademark `^S`: n-ary summation `^T`: trademark `^!`: logical not `^{`: left single quote `^}`: right single quote `^[`: left double quote `^]`: right double quote `^'`: apostrophe `^.`: ellipsis ("...") `^E`: Latin small e with acute accent `^e`: Latin small e with circumflex `^d`: Greek capital delta `^L`: backslash (\) `^V`: vertical bar (|) `^#`: command key (in Mac OS only) `^``: accent grave ("`") `^^`: circumflex ("^") `^0 - ^9`: Replacement point for string arguments. `^U+1234`: Encodes any arbitrary Unicode character by its code point (represented here by "1234"). The code point must always be expressed as four hexadecimal digits.

| Method Signature | Description |
|---|---|
| `LOC( string, ... )` | Finds a localized string by looking up the key in the dictionary for the current locale. This function is an alias for `LrLocalization.translateForPlugin()`, which automatically provides the toolkit ID for the current plug-in. First supported in version 1.3 of the Lightroom SDK. |
| `LrLocalization.currentLanguage()` | Retrieves the language that is currently in use for translation. First supported in version 3.0 of the Lightroom SDK. |
| `LrLocalization.encodeUtf8Character( ch )` | Converts a Unicode code point value into a UTF-8 string. First supported in version 1.3 of the Lightroom SDK. |
| `LrLocalization.translateForPlugin( pluginId, string, ... )` | Finds a localized string by looking up the key in the plug-in's dictionary for the current locale. First supported in version 1.3 of the Lightroom SDK. |

### LrLogger

**Type:** Class and Namespace

| Method Signature | Description |
|---|---|
| `LrLogger( name )` | Creates a new logger or finds and returns an existing one. Loggers are silent until configured with `logger:enable()`. |
| `logger:enable( actions )` | Enables specific log output from this logger. |
| `logger:disable()` | Disables all log output from this logger. Equivalent to `logger:enable( false )`. |
| `logger:trace( ... )` | Feeds log output through the action function defined for 'trace' messages. |
| `logger:tracef( format, ... )` | Feeds log output through the action function defined for 'trace' messages, using `string.format` to prepare the output. |
| `logger:debug( ... )` | Feeds log output through the action function defined for 'debug' messages. |
| `logger:debugf( format, ... )` | Feeds log output through the action function defined for 'debug' messages, using `string.format`. |
| `logger:info( ... )` | Feeds log output through the action function defined for 'info' messages. |
| `logger:infof( format, ... )` | Feeds log output through the action function defined for 'info' messages, using `string.format`. |
| `logger:warn( ... )` | Feeds log output through the action function defined for 'warn' messages. |
| `logger:warnf( format, ... )` | Feeds log output through the action function defined for 'warn' messages, using `string.format`. |
| `logger:error( ... )` | Feeds log output through the action function defined for 'error' messages. |
| `logger:errorf( format, ... )` | Feeds log output through the action function defined for 'error' messages, using `string.format`. |
| `logger:fatal( ... )` | Feeds log output through the action function defined for 'fatal' messages. |
| `logger:fatalf( format, ... )` | Feeds log output through the action function defined for 'fatal' messages, using `string.format`. |
| `logger:quick( ... )` | Creates optimized versions of specified log functions for use in tight loops. Avoids method lookup overhead and becomes a no-op when logging is disabled. |
| `logger:quickf( ... )` | Creates optimized versions of specified log functions for use in tight loops. Unlike `logger:quick`, these functions take `string.format` instructions. |
| `logger:type()` | Reports the type of this object. |

### LrMD5

This namespace provides MD5 digest services. Access the functions directly from the imported namespace.

| Method Signature | Description |
|---|---|
| `LrMD5.digest( data )` | Creates an MD5 digest from a string. First supported in version 1.3 of the Lightroom SDK. |

### LrMath

This namespace provides additional basic math operations not otherwise available in the Lua language. Access the functions directly from the imported namespace.

| Method Signature | Description |
|---|---|
| `LrMath.bitAnd( a, b )` | Performs a bitwise AND on two integers. First supported in version 3.0 of the Lightroom SDK. The values a and b must be numeric and are treated as positive 32-bit integers. The function's behavior when passed non-integer numbers or numbers that fall outside the 32-bit space is undefined. |
| `LrMath.bitOr( a, b )` | Performs a bitwise OR on two integers. First supported in version 3.0 of the Lightroom SDK. The values a and b must be numeric and are treated as positive 32-bit integers. The function's behavior when passed non-integer numbers or numbers that fall outside the 32-bit space is undefined. |
| `LrMath.bitXor( a, b )` | Performs a bitwise exclusive OR on two integers. First supported in version 3.0 of the Lightroom SDK. The values a and b must be numeric and are treated as positive 32-bit integers. The function's behavior when passed non-integer numbers or numbers that fall outside the 32-bit space is undefined. |

### LrPasswords

This namespace provides a mechanism to store passwords in a secure fashion, using services provided by each operating system. The password API allows a plug-in author to associate an encrypted string with a key string. Lightroom scopes the key strings by plug-in ID so that a plug-in cannot access the passwords stored by another plug-in. Access the functions directly from the imported namespace.

| Method Signature | Description |
|---|---|
| `LrPasswords.retrieve( keystring, salt, pluginId )` | Retrieves a plain-text password from the encrypted password storage. First supported in version 3.0 of the Lightroom SDK. |
| `LrPasswords.store( keystring, myPassword, salt, pluginId )` | Stores an encrypted password. First supported in version 3.0 of the Lightroom SDK. |

### LrPathUtils

**Type:** Namespace

| Method Signature | Description |
|---|---|
| `LrPathUtils.addExtension( path, extension )` | Adds a new filename extension to a path. Appends the new extension after any existing extension. |
| `LrPathUtils.child( path, child )` | Combines path elements into a single path. |
| `LrPathUtils.extension( path )` | Retrieves the filename extension (if any) from the path. |
| `LrPathUtils.getStandardFilePath( which )` | Retrieves the path to a standard directory, as defined for the platform. |
| `LrPathUtils.isAbsolute( path )` | Reports whether a path is absolute or relative. Converse of `LrPathUtils.isRelative()`. |
| `LrPathUtils.isRelative( path )` | Reports whether a path is absolute or relative. Converse of `LrPathUtils.isAbsolute()`. |
| `LrPathUtils.leafName( path )` | Retrieves the leaf name from a path. |
| `LrPathUtils.makeAbsolute( path, base )` | Converts a relative path to an absolute path if possible. |
| `LrPathUtils.makeRelative( path, base )` | Converts an absolute path to a relative path if possible. |
| `LrPathUtils.maxPathLength()` | Reports the maximum permissible path length for the current platform. |
| `LrPathUtils.parent( path )` | Retrieves the parent directory of a path. |
| `LrPathUtils.removeExtension( path )` | Removes the filename extension from a path, if it has one. |
| `LrPathUtils.replaceExtension( path, extension )` | Changes the filename extension of a path, replacing any existing extension. |
| `LrPathUtils.standardizePath( path )` | Standardizes a path, resolving links and shortcuts such as `..` (dot dot) and `~` (home). |

### LrPhotoInfo

This namespace allows you to get information about individual photo files. These files need not be part of a Lightroom catalog.

| Method Signature | Description |
|---|---|
| `LrPhotoInfo.fileAttributes( path )` | Retrieves the file attributes that describe a photo file at a given path. First supported in version 2.0 of the Lightroom SDK. |

### LrPrefs

This namespace allows you to access a table of preferences that you define and store for your own plug-in. For example: `local prefs = import 'LrPrefs'.prefsForPlugin() prefs.userName = 'John Smith'` Each plug-in has its own namespace for preferences; your preference names do not conflict with other plug-ins or with application preferences. (Except: Plug-ins can potentially share preferences by using a common "plugin ID" on the call to LrPrefs.prefsForPlugin.) Plug-ins do not have access to Lightroom's global preferences. Access the functions directly from the imported namespace.

| Method Signature | Description |
|---|---|
| `LrPrefs.prefsForPlugin( pluginId )` | Retrieves the preferences table for a plug-in. You can store any Boolean, number, or string value as either a key or a value in this table. You can also store tables containing these types. Note: Lightroom may not notice assignments deep in table structures. You may need to reassign a table to ensure that it is stored properly. For example: `prefs.mySetting = {}`: Saved to prefs. `prefs.mySetting[ 44 ] = 'my value'`: May not be saved to prefs unless you trigger changes. `prefs.mySetting = prefs.mySetting`: Causes all earlier changes to be saved. First supported in version 1.3 of the Lightroom SDK. Note: You must use `prefs:pairs()` (where `prefs` is the table returned by this function) to iterate this table. The built-in Lua function `pairs` will not work. |

### LrProgressScope

This class allows you to provide feedback to the user about the progress of a long-running task. An entry in Lightroom's progress area at the top-left of the catalog window is created for each active progress scope. Scopes can be nested; that is, the UI can show progress in a subsidiary task (such as uploading a single photo) that advances the parent task (such as an upload operation for a set of photos) by a given amount. The parent task is identified by a title above the progress bar, and the current task is identified by a caption below it. Use the imported namespace as a constructor; access the functions through the created objects.

| Method Signature | Description |
|---|---|
| `LrProgressScope( params )` | Creates a progress scope object. First supported in version 1.3 of the Lightroom SDK. |
| `progressScope:attachToFunctionContext( context )` | Attaches this progress scope to a function context so that it can be cleared when the function ends, regardless of how the function is terminated. First supported in version 1.3 of the Lightroom SDK. |
| `progressScope:cancel()` | Signals that this operation should be canceled. Called when the user clicks the X at the right end of the progress bar in the catalog window. This does not immediately cancel the operation; that happens when the task polls :isCanceled() and stops the operation in response to a true result. First supported in version 1.3 of the Lightroom SDK. |
| `progressScope:done()` | Marks this progress scope as complete. First supported in version 1.3 of the Lightroom SDK. |
| `progressScope:getParentScope()` | Returns the parent progress scope, if any. First supported in version 4.0 of the Lightroom SDK. |
| `progressScope:getPortionComplete()` | Retrieves the portion of this task that has been marked as completed. First supported in version 1.3 of the Lightroom SDK. |
| `progressScope:isCancelable()` | Reports whether this progress scope can be canceled. First supported in version 1.3 of the Lightroom SDK. |
| `progressScope:isCanceled()` | Reports whether this operation been canceled by the user. First supported in version 1.3 of the Lightroom SDK. |
| `progressScope:isDone()` | Reports whether this progress scope has been completed. First supported in version 1.3 of the Lightroom SDK. |
| `progressScope:isIndeterminate()` | Reports whether this progress scope is indeterminate. When a scope is indeterminate, you cannot determine how much of the task remains to be completed. The function `progressScope:getPortionComplete()` returns -1. First supported in version 1.3 of the Lightroom SDK. |
| `progressScope:isLowUiPriority()` | Reports whether this progress scope has low ui priority. First supported in version 8.4 of the Lightroom SDK. |
| `progressScope:isPausable()` | Reports whether this progress scope can be paused. First supported in version 7.5 of the Lightroom SDK. |
| `progressScope:isPaused()` | Reports whether this operation been paused by the user. First supported in version 7.5 of the Lightroom SDK. |
| `progressScope:pause()` | Signals that this operation should be paused. Called when the user clicks the \ |
| `progressScope:setCancelable( cancelable )` | Allows or disallows user cancellation of this progress scope. First supported in version 1.3 of the Lightroom SDK. |
| `progressScope:setCaption( caption )` | Changes the caption that identifies this child task. First supported in version 1.3 of the Lightroom SDK. |
| `progressScope:setIndeterminate()` | Makes this progress scope indeterminate. When a scope is indeterminate, you cannot determine how much of the task remains to be completed. The function `progressScope:getPortionComplete()` returns -1. Indeterminate progress scopes are only useful in the context of `LrDialogs:showModalProgressDialog()`; they do not display properly in the Lightroom catalog window. First supported in version 1.3 of the Lightroom SDK. |
| `progressScope:setLowUiPriority( inPrior )` | Allows or disallows capability of user to change ui priority of this progress scope. First supported in version 8.4 of the Lightroom SDK. |
| `progressScope:setPausable( pausable, cancelable )` | Allows or disallows capability of user to pause this progress scope. First supported in version 7.5 of the Lightroom SDK. |
| `progressScope:setPortionComplete( amountDone, totalAmount )` | Sets the portion of this task that has been completed. First supported in version 1.3 of the Lightroom SDK. |
| `progressScope:type()` | Reports the type of this object. First supported in version 4.1 of the Lightroom SDK. |

### LrRecursionGuard

This namespace and class provides a simple recursion guard for function execution. The typical case for using this is to prevent a chain of observation handlers from triggering infinite recursion. Use the imported namespace as a constructor; access the functions through the created objects.

| Method Signature | Description |
|---|---|
| `LrRecursionGuard( name )` | Creates a new recursion guard. First supported in version 2.0 of the Lightroom SDK. |
| `recursionGuard:performWithGuard( func, ... )` | Calls a function, but only if we are not already inside a call that has been guarded by this guard. If `recursionGuard.active == true`, does nothing. First supported in version 2.0 of the Lightroom SDK. |

### LrSelection

This namespace provides access to the selection-based commands. Commands in this namespace that modify photos in the "selection" behave just like the main menu commands: if the grid view is currently visible then they apply to all selected photos, otherwise they only apply to the active photo. Access the functions directly from the imported namespace.

| Method Signature | Description |
|---|---|
| `LrSelection.clearLabels()` | Clears all color labels from the selection. First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.decreaseRating()` | Decreases the rating of the selection. First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.deselectActive()` | Removes the active photo from the selection. First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.deselectOthers()` | Deselects all photos except for the active photo. First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.extendSelection( direction, amount )` | Extends the existing selection, selecting more photos to its beginning or end. Behaves exactly like the Shift+Left/Right Arrow keys in Library grid. First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.flagAsPick()` | Sets the flag state of the selction to pick. First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.flagAsReject()` | Sets the flag state of the selection to reject. First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.getColorLabel()` | Returns the color label assigned to the active photo, one of: "red", "yellow", "green", "blue", "purple", "other", or "none". The underlying metadata values that these names map to will depend on the current Color Label Set. The default label set maps these names to "Red", "Yellow", "Green", "Blue", and "Purple". The return value "other" indicates that the photo has a label that does not match any values in the current set. First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.getFlag()` | Returns the pick flag state of the active photo as a number (-1 = reject, 0 = none, 1 = pick). First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.getRating()` | Returns the rating of the selection as a number (0-5). First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.increaseRating()` | Increases the rating of the selection. First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.nextPhoto()` | Advances the selection to the next photo in the filmstrip. First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.previousPhoto()` | Advances the selection to the previous photo in the filmstrip. First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.removeFlag()` | Clears the flag state of the selection. First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.selectAll()` | Selects all photos in the filmstrip. First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.selectFirstPhoto()` | Selects the first photo in the selection, or in the entire filmstrip if there is no selection. Only available in the Library module. First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.selectInverse()` | Inverts the selection in the filmstrip. First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.selectLastPhoto()` | Selects the last photo in the selection, or in the entire filmstrip if there is no selection. Only available in the Library module. First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.selectNone()` | Deselects all photos in the filmstrip. First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.setColorLabel( label )` | Sets the color label of the selection, one of: "red", "yellow", "green", "blue", "purple", or "none". The underlying metadata values that these names map to will depend on the current Color Label Set. The default label set maps these names to "Red", "Yellow", "Green", "Blue", and "Purple". First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.setRating( rating )` | Sets the rating of the selection. First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.toggleBlueLabel()` | Toggles the state of the Blue color label of the selection. First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.toggleGreenLabel()` | Toggles the state of the Green color label of the selection. First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.togglePurpleLabel()` | Toggles the state of the Purple color label of the selection. First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.toggleRedLabel()` | Toggles the state of the Red color label of the selection. First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.toggleYellowLabel()` | Toggles the state of the Yellow color label of the selection. First supported in version 6.0 of the Lightroom SDK. |

### LrShell

This namespace provides access to some operating-system shell functions (Finder in Mac OS, Windows Explorer in Windows). All paths must be provided in platform-specific syntax.

| Method Signature | Description |
|---|---|
| `LrShell.openFilesInApp( files, appPath )` | Opens one or more files in another application. For example: `LrShell.openFilesInApp( { "/Users/example/myLightroomPlugin.lrplugin/Info.lua" }, "/Applications/TextEdit.app" )` NOTE: Windows has a maximum limit on the length of any command line it can process. In order to avoid this limit, Lightroom may have to split up large batches of files and make multiple calls to your command-line process. Windows documentation suggests that this limit is 8000 characters, but practical testing shows it to be much lower. Lightroom splits command lines that exceed 1500 characters (total length of command-line application name, extra arguments, and file names after escaping). There appears to be no such limit in Mac OS, so this function always causes one and only one invocation of the command-line process. First supported in version 1.3 of the Lightroom SDK. |
| `LrShell.openPathsViaCommandLine( files, appPath, extraArgs )` | Opens one or more files via a command-line process. For example: `LrShell.openFilesInCommandLineProcess( { "/Users/example/myLightroomPlugin.lrplugin/Info.lua" }, "/usr/bin/edit", "-w" )` NOTE: Windows has a maximum limit on the length of any command line it can process. In order to avoid this limit, Lightroom may have to split up large batches of files and make multiple calls to your command-line process. Windows documentation suggests that this limit is 8000 characters, but practical testing shows it to be much lower. Lightroom splits command lines that exceed 1500 characters (total length of command-line application name, extra arguments, and file names after escaping). There appears to be no such limit in Mac OS, so this function always causes one and only one invocation of the command-line process. Note: Due to the implementation of `fork()` in Mac OS, multiple calls to this function are executed sequentially, even if run from separate tasks. First supported in version 3.0 of the Lightroom SDK. |
| `LrShell.revealInShell( path )` | Brings the Finder or Explorer to the foreground and highlights a file. First supported in version 1.3 of the Lightroom SDK. |

### LrSlideshow

This namespace provides access to Slideshow commands. Access the functions directly from the imported namespace.

| Method Signature | Description |
|---|---|
| `LrSlideshow.startSlideshow()` | Begins an impromptu slideshow using the photos currently in the filmstrip. First supported in version 6.0 of the Lightroom SDK. |
| `LrSlideshow.stopSlideshow()` | Stops a running slideshow. First supported in version 6.0 of the Lightroom SDK. |

### LrSocket

This namespace is used to send and receive data from other processes using sockets. Example usage: `local LrSocket = import "LrSocket" local LrTasks = import "LrTasks" import "LrTasks".startAsyncTask( function() LrFunctionContext.callWithContext( 'socket_remote', function( context ) local running = true local sender = LrSocket.bind { functionContext = context, port = 0, -- (let the OS assign the port) mode = "send", onConnecting = function( socket, port ) -- TODO end, onConnected = function( socket, port ) -- TODO end, onMessage = function( socket, message ) -- nothing, we don't expect to get any messages back from a send port end, onClosed = function( socket ) running = false end, onError = function( socket, err ) if err == "timeout" then socket:reconnect() end end, } sender:send( "Hello world" ) while running do LrTasks.sleep( 1/2 ) -- seconds end sender:close() end ) end )`

| Method Signature | Description |
|---|---|
| `LrSocket.bind( params )` | Opens a socket connection (on localhost) for either reading or writing operations. First supported in version 6.0 of the Lightroom SDK. The socket is automatically closed if the plug-in is disabled or removed by the user. |
| `socket:close()` | Closes a socket connection. First supported in version 6.0 of the Lightroom SDK. |
| `socket:reconnect()` | Asks a socket to restablish its connection. First supported in version 6.0 of the Lightroom SDK. |
| `socket:send( message )` | Sends a message via a "send" mode socket. First supported in version 6.0 of the Lightroom SDK. |
| `socket:type()` | Reports the type of this object. First supported in version 6.0 of the Lightroom SDK. |

### LrSounds

This namespace provides functions for playing sounds. Access the functions directly from the imported namespace.

| Method Signature | Description |
|---|---|
| `LrSounds.getSystemSounds()` | Returns an array of system sounds that can be played via playSystemSound. Each element in the array has a "title" attribute to identify it. The list of available sounds is platform-specific. This function must be called from within an asynchronous task started using `LrTasks`. First supported in version 6.0 of the Lightroom SDK. |
| `LrSounds.playSystemSound( systemSound )` | Plays a system sound. This function must be called from within an asynchronous task started using `LrTasks`. First supported in version 6.0 of the Lightroom SDK. |

### LrStringUtils

This namespace provides utility functions for string manipulation. All of these functions assume UTF-8 encoding for strings, unless a different encoding is specifically mentioned in the documentation. Access the functions directly from the imported namespace.

| Method Signature | Description |
|---|---|
| `LrStringUtils.byteString( number, precision )` | Converts a number into a string representation suitable for displaying byte values. The function transforms the number appropriately and adds an indicator for bytes, kilobytes, megabytes, and so on. For example, a number n between 1 and 1024 results in the string "n bytes". A number between 1024 and 1024^2 results in the string "n KB", and so on. The byte indicators are "bytes", "KB", "MB", "GB", "TB", and "PB" First supported in version 1.3 of the Lightroom SDK. |
| `LrStringUtils.compareStrings( string1, string2, treatNumberAsString )` | Compares two strings using the operating system's localized string comparison. This is a wrapper for Lua's `table.sort` function, with this function as the comparator. Optional parameter treatNumberAsString decides whether to treat numbers is strings as numbers or normal string. For example, `LrStringUtils.compareStrings("ab10c", "ab7c")` returns false because 10 > 7 `LrStringUtils.compareStrings("ab10c", "ab7c", true)` returns true because 1 < 7 First supported in version 1.3 of the Lightroom SDK. |
| `LrStringUtils.decodeBase64( string )` | Decodes a string from base-64 encoding. First supported in version 1.3 of the Lightroom SDK. |
| `LrStringUtils.encodeBase64( string )` | Encodes a string in base-64 encoding. First supported in version 1.3 of the Lightroom SDK. |
| `LrStringUtils.isOnlyAscii( string )` | Reports whether a string contains only 7-bit ASCII characters. First supported in version 1.3 of the Lightroom SDK. |
| `LrStringUtils.localizedStringSort( strings )` | Sorts an array of strings in-place, using the operating system's localized string comparison. First supported in version 1.3 of the Lightroom SDK. |
| `LrStringUtils.lower( string )` | Converts a string to lowercase using the operating system's localized case conversion. Unlike the Lua `string.lower` function, this function properly converts characters outside the 7-bit ASCII space. First supported in version 1.3 of the Lightroom SDK. |
| `LrStringUtils.numberToString( number, precision )` | Formats a number as a string with an optional limit on precision. Does not insert separators for thousands. For example, `LrStringUtils.numberToString( 43500, 2 )` returns "43500.00", not "43,500.00"). First supported in version 1.3 of the Lightroom SDK. |
| `LrStringUtils.numberToStringWithSeparators( number, precision )` | Formats a number as a string with thousands separators with an optional limit on precision. Insert thousands separators with the correct grouping according to user locale. For example, `LrStringUtils.numberToString( 43500, 2 )` returns "43,500.00", not "43500.00"). |
| `LrStringUtils.trimWhitespace( string )` | Removes whitespace from the beginning and end of a string. First supported in version 1.3 of the Lightroom SDK. |
| `LrStringUtils.truncate( string, maxBytes )` | Truncates a string to a maximum number of bytes, preserving the validity of the UTF-8 encoding. First supported in version 1.3 of the Lightroom SDK. |
| `LrStringUtils.upper( string )` | Converts a string to uppercase using the operating system's localized case conversion. Unlike the Lua `string.upper` function, this function properly converts characters outside the 7-bit ASCII space. First supported in version 1.3 of the Lightroom SDK. |

### LrSystemInfo

This namespace allows you to gather information about the user's computer and operating system. Access the functions directly from the imported namespace.

| Method Signature | Description |
|---|---|
| `LrSystemInfo.appWindowSize()` | Reports the size of the main Lightroom application window. Return values (number) Width of Lightroom's main application window, in pixels (number) Height of Lightroom's main application window, in pixels |
| `LrSystemInfo.architecture()` | Reports the CPU architecture of the host computer. |
| `LrSystemInfo.displayInfo()` | Reports information about the displays available to the system. |
| `LrSystemInfo.ipAddress()` | Retrieves the IP address of the system running Lightroom. First supported in version 6.0 of the Lightroom SDK. |
| `LrSystemInfo.is64Bit()` | Reports whether the host is running a 64-bit operating system. |
| `LrSystemInfo.isGCOptimizationEnabled()` | Reports whether GC Optimization is enabled or not. |
| `LrSystemInfo.isSyncEnabled()` | Reports whether Sync is enabeld or not. |
| `LrSystemInfo.memSize()` | Reports the amount of physical RAM installed on the host computer. |
| `LrSystemInfo.numCPUs()` | Reports the number of CPUs on the host computer system. Typically counts each core on a multi-core system. |
| `LrSystemInfo.osVersion()` | Reports the version of the current operating system. Use only for reporting purposes. Do not attempt to parse this string. |
| `LrSystemInfo.summaryString()` | Returns a summary of system information. Use only for reporting purposes. Do not attempt to parse this string. |

### LrTasks

**Type:** Namespace

| Method Signature | Description |
|---|---|
| `LrTasks.canYield()` | Reports whether a cooperative task is currently running (a task started with `LrTasks.startAsyncTask()` or similar). If so, you can call `LrTasks.yield()`. |
| `LrTasks.execute( cmd )` | Similar to Lua's built-in `os.execute()` function, but blocks only the task that calls it, instead of blocking the entire application. |
| `LrTasks.pcall( func, ... )` | Simulates Lua's standard `pcall()`, but in a way that allows a call to `LrTasks.yield()` to occur inside it. |
| `LrTasks.sleep( delay )` | Temporarily stops this task and allows other tasks on Lightroom's main UI thread to proceed. This task resumes no earlier than the given number of seconds later. |
| `LrTasks.startAsyncTask( func, optName )` | Starts a function that will run as a cooperative task on Lightroom's main thread. If an error is thrown while this task is executing, shows a standard error dialog. |
| `LrTasks.startAsyncTaskWithoutErrorHandler( func, optName )` | Starts a function that will run as a cooperative task on Lightroom's main thread. This version does NOT automatically show an error dialog on failure. |
| `LrTasks.yield()` | Temporarily stops this task and allows other tasks on Lightroom's main UI thread to proceed. This task will resume at an unspecified time in the relatively near future (usually well under a second). |

### LrTether

This namespace provides control over tethered shooting. Access the functions directly from the imported namespace.

| Method Signature | Description |
|---|---|
| `LrTether.getAdvanceSelectionOnTetheredCapture()` | Returns boolean indicating whether or not each new tethered capture photo is selected. First supported in version 6.0 of the Lightroom SDK. |
| `LrTether.isTetherActive()` | Returns boolean indicating if a tethered capture session is running. First supported in version 6.0 of the Lightroom SDK. |
| `LrTether.numDownloadsPending()` | Returns the number of photos currently being downloaded from the tethered camera. First supported in version 6.0 of the Lightroom SDK. |
| `LrTether.setAdvanceSelectionOnTetheredCapture( advance )` | Sets the preference controlling whether or not each new tethered capture photo is selected. First supported in version 6.0 of the Lightroom SDK. |
| `LrTether.startTether()` | Starts a tethered capture session. First supported in version 6.0 of the Lightroom SDK. |
| `LrTether.stopTether()` | Stops a tethered capture session. First supported in version 6.1 of the Lightroom SDK. |
| `LrTether.triggerCapture()` | Triggers a tethered capture. Does nothing if a tether session is not active. First supported in version 6.0 of the Lightroom SDK. |
| `LrTether.triggerCaptureBlocking()` | Triggers a tethered capture, blocking until finished. This function must be called from within an asynchronous task started using `LrTasks`. First supported in version 6.0 of the Lightroom SDK. |

### LrUndo

This namespace provides access to undo/redo commands. Access the functions directly from the imported namespace.

| Method Signature | Description |
|---|---|
| `LrUndo.canRedo()` | Returns true of the redo command is currently enabled. First supported in version 6.0 of the Lightroom SDK. |
| `LrUndo.canUndo()` | Returns true of the undo command is currently enabled. First supported in version 6.0 of the Lightroom SDK. |
| `LrUndo.redo()` | Redoes the last undone history state. First supported in version 6.0 of the Lightroom SDK. |
| `LrUndo.undo()` | Undoes the last history state. First supported in version 6.0 of the Lightroom SDK. |

### LrXml

This namespace and class allows you create and examine XML documents. The namespace functions allow you to create an XML builder object, and to parse existing XML documents into read-only XML DOM objects. The XML builder object (`builderInstance`) allows you to create and manipulate XML documents. The XML DOM object (`xmlDomInstance`) is read-only, and allows you to examine an existing XML document. Text values added to or retrieved from the XML document will automatically be entity encoded and decoded, where required by the XML 1.1 recommendation. Please refer to the recommendation (especially sections 2.4 and 4.6) for definitions of the entities supported and when their use is required.

| Method Signature | Description |
|---|---|
| `LrXml.createXmlBuilder( omitDeclaration )` | Creates an XML builder object (`builderInstance`) for constructing an XML document. Use the methods of the resulting object to create the document contents, and to serialize the resulting XML into a string. First supported in version 1.3 of the Lightroom SDK. |
| `LrXml.parseXml( xmlString )` | Parses a string containing valid XML to create and return a read-only XML DOM object (`xmlDomInstance`) which you can use to examine the XML content. The returned DOM object is the root of a tree of DOM objects for the XML nodes in the document. Use the `xmlDomInstance` functions to traverse the node tree. The DOM object is an interface to a platform-specific XML parser. There can be variation in how whitespace, XML processing instructions, and other subtle aspects of XML are handled. Use caution when parsing XML. Do not assume elements are at a particular index. Instead, iterate child nodes and test by name and type to find a particular node. For example one parser might return a text node for the whitespace separating two elements, while another removes the whitespace; or one might skip comments while another includes them. First supported in version 1.3 of the Lightroom SDK. |
| `builderInstance:append( otherXmlBuilder )` | Appends all the XML in another `builderInstance` to this one at the current point.The other object must not have any unclosed blocks. First supported in version 1.3 of the Lightroom SDK. |
| `builderInstance:beginBlock( name, attributes )` | Adds an XML opening tag to this XML document. This must be closed later by a call to `endBlock()`. First supported in version 1.3 of the Lightroom SDK. |
| `builderInstance:comment( contents )` | Appends an XML comment to this XML document. First supported in version 1.3 of the Lightroom SDK. |
| `builderInstance:endBlock()` | Adds an XML closing tag to this XML document. This must be balance a preceding call to `beginBlock()`. First supported in version 1.3 of the Lightroom SDK. |
| `builderInstance:serialize()` | Retrieves the complete XML document as a string. First supported in version 1.3 of the Lightroom SDK. |
| `builderInstance:tag( name, value, attributes )` | Adds a single tag to this XML document, with an optional text child node. First supported in version 1.3 of the Lightroom SDK. |
| `builderInstance:text( value )` | Adds a text node to this XML document. First supported in version 1.3 of the Lightroom SDK. |
| `xmlDomInstance:attributes()` | Retrieves the attributes of this element node. First supported in version 1.3 of the Lightroom SDK. |
| `xmlDomInstance:childAtIndex( index )` | Retrieves a child of this element node by index. First supported in version 1.3 of the Lightroom SDK. |
| `xmlDomInstance:childCount()` | Reports the number of children of this element node. First supported in version 1.3 of the Lightroom SDK. |
| `xmlDomInstance:name()` | Retrieves the name of the `xml` node from this XML document. First supported in version 1.3 of the Lightroom SDK. Return values (string) The name of the `xml` node. (string) The namespace of the `xml` node. |
| `xmlDomInstance:serialize()` | Converts the XML encapsulated by this object into its string representation. The result does not include an XML declaration. First supported in version 1.3 of the Lightroom SDK. |
| `xmlDomInstance:text()` | Retrieves the text of the `xml` node from this XML document. First supported in version 3.0 of the Lightroom SDK. |
| `xmlDomInstance:transform( xsltString )` | Transforms this XML into string output by applying an XSLT transformation. Depending on the operating system, the result of the transform can contain different amounts and/or kinds of whitespace. To normalize the result, apply a substitution pattern such as this: `string.gsub( result, "[\r\n ]+", " " )` This must be called on the root node. Note: The error messages from this function can be misleading. If you see the message "out of memory", you may want to review the application or OS console for other messages that may be more helpful. First supported in version 1.3 of the Lightroom SDK. |
| `xmlDomInstance:type()` | Retrieves the type of the `xml` node from this XML document. First supported in version 1.3 of the Lightroom SDK. |
<!-- END OFFICIAL_NAMESPACES -->
