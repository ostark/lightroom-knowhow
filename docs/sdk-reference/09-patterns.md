# Common Patterns

## Async Task Pattern
Most SDK operations must run in async tasks. This is the fundamental pattern:

```lua
local LrTasks = import 'LrTasks'
local LrFunctionContext = import 'LrFunctionContext'

LrTasks.startAsyncTask(function()
    LrFunctionContext.callWithContext('myOperation', function(context)
        -- SDK calls go here
        -- context provides cleanup and error handling
    end)
end)
```

### Why Async?
- Lightroom's main thread is the UI thread
- Long operations block the UI
- SDK operations that access the catalog MUST be async
- Menu item scripts automatically run in async context

## Catalog Access Pattern
### Write Access
```lua
catalog:withWriteAccessDo("Action Name", function(context)
    -- modify photos, collections, metadata here
    photo:setRawMetadata('rating', 5)
end)
```

### Timeout Option
```lua
catalog:withWriteAccessDo("Action Name", function(context)
    -- modifications
end, { timeout = 10 }) -- wait up to 10 seconds for access
```

### Read Access
Usually implicit — reading doesn't require explicit read access in most cases. Use `withReadAccessDo` when you need guaranteed consistency:
```lua
catalog:withReadAccessDo(function(context)
    local photos = catalog:getTargetPhotos()
    -- read operations
end)
```

## Error Handling Pattern
```lua
LrFunctionContext.callWithContext('myOp', function(context)
    context:addFailureHandler(function(status, message)
        LrDialogs.showError("Error: " .. message)
    end)
    context:addCleanupHandler(function()
        -- always runs, whether success or failure
    end)
    -- main logic
end)
```

### User Cancellation
```lua
local LrErrors = import 'LrErrors'

if userWantsToCancel then
    LrErrors.throwCanceled()
end

-- Check for cancellation errors:
local success, result = LrTasks.pcall(function()
    -- operation
end)
if not success then
    if LrErrors.isCanceledError(result) then
        -- user canceled, clean up silently
    else
        -- real error
        LrDialogs.showError(result)
    end
end
```

## Progress Reporting Pattern
```lua
local LrProgressScope = import 'LrProgressScope'

LrFunctionContext.callWithContext('export', function(context)
    local progress = LrProgressScope {
        title = "Exporting photos",
        functionContext = context,
    }

    local photos = catalog:getTargetPhotos()
    for i, photo in ipairs(photos) do
        if progress:isCanceled() then
            LrErrors.throwCanceled()
        end
        progress:setPortionComplete(i - 1, #photos)
        progress:setCaption("Processing " .. photo:getFormattedMetadata('fileName'))

        -- do work

        progress:setPortionComplete(i, #photos)
    end
    progress:done()
end)
```

## Export Rendition Iteration Pattern
The core pattern for processing exported photos:
```lua
function exportServiceProvider.processRenderedPhotos(functionContext, exportContext)
    local nPhotos = exportContext.exportSession:countRenditions()
    local progress = exportContext:configureProgress { renderPortion = 0.5 }

    for i, rendition in exportContext:renditions { stopIfCanceled = true } do
        local success, pathOrMessage = rendition:waitForRender()

        if success then
            local filePath = pathOrMessage
            -- upload or process the rendered file
            -- ...

            -- For publish services, record the remote ID:
            if exportContext.publishService then
                rendition:recordPublishedPhotoId(remoteId)
                rendition:recordPublishedPhotoUrl(remoteUrl)
            end
        else
            -- render failed
            rendition:uploadFailed(pathOrMessage)
        end
    end
end
```

## Logging Pattern
```lua
local LrLogger = import 'LrLogger'
local logger = LrLogger('MyPlugin')
logger:enable('print') -- or 'logfile'

-- Use throughout code:
logger:info("Starting export")
logger:debugf("Processing photo: %s", photo:getFormattedMetadata('fileName'))
logger:warn("Connection timeout, retrying")
logger:error("Upload failed: " .. errorMessage)
```

## Data Binding Pattern (UI)
```lua
local LrView = import 'LrView'
local LrBinding = import 'LrBinding'
local bind = LrView.bind

LrFunctionContext.callWithContext('dialog', function(context)
    local props = LrBinding.makePropertyTable(context)
    props.username = ""
    props.savePassword = false

    local f = LrView.osFactory()
    local contents = f:column {
        f:row {
            f:static_text { title = "Username:" },
            f:edit_field { value = bind 'username', width_in_chars = 20 },
        },
        f:checkbox {
            title = "Save password",
            value = bind 'savePassword',
        },
    }

    local result = LrDialogs.presentModalDialog {
        title = "Login",
        contents = contents,
    }

    if result == "ok" then
        -- use props.username, props.savePassword
    end
end)
```

## Observer Pattern
```lua
props:addObserver('selectedFormat', function(properties, key, newValue)
    if newValue == 'JPEG' then
        properties.qualityVisible = true
    else
        properties.qualityVisible = false
    end
end)

-- In UI:
f:slider {
    value = bind 'jpegQuality',
    min = 0, max = 100,
    visible = bind 'qualityVisible',
}
```

## HTTP Upload Pattern
```lua
local LrHttp = import 'LrHttp'

-- Simple GET
local body, headers = LrHttp.get(url)

-- POST with JSON
local body, headers = LrHttp.post(url,
    '{"key": "value"}',
    { { field = "Content-Type", value = "application/json" } }
)

-- Multipart file upload
local filePath = "/path/to/photo.jpg"
local content = {
    { name = "file", filePath = filePath, fileName = "photo.jpg", contentType = "image/jpeg" },
    { name = "title", value = "My Photo" },
}
local body, headers = LrHttp.postMultipart(url, content)
```

## Persistent Preferences Pattern
```lua
local LrPrefs = import 'LrPrefs'
local prefs = LrPrefs.prefsForPlugin()

-- Store
prefs.lastExportPath = "/some/path"
prefs.serverUrl = "https://example.com"

-- Retrieve (persists across sessions)
local savedPath = prefs.lastExportPath
```

## Menu Item Script Pattern
```lua
-- In a file referenced by LrLibraryMenuItems:
local LrApplication = import 'LrApplication'
local LrDialogs = import 'LrDialogs'
local LrTasks = import 'LrTasks'

LrTasks.startAsyncTask(function()
    local catalog = LrApplication.activeCatalog()
    local photo = catalog:getTargetPhoto()

    if not photo then
        LrDialogs.showError("No photo selected")
        return
    end

    -- do something with photo
    catalog:withWriteAccessDo("My Action", function()
        photo:setRawMetadata('rating', 5)
    end)

    LrDialogs.showBezel("Done!", 2)
end)
```

## Combined Async + Context Pattern
```lua
-- Simpler alternative to nesting startAsyncTask + callWithContext:
LrFunctionContext.postAsyncTaskWithContext("myOperation", function(context)
    LrDialogs.attachErrorDialogToFunctionContext(context)

    local progress = LrProgressScope { title = "Working..." }
    progress:attachToFunctionContext(context)

    -- Your code here
end)
```

## Batch Metadata Retrieval Pattern
```lua
-- Much more efficient than calling getRawMetadata on each photo individually:
local catalog = LrApplication.activeCatalog()
local photos = catalog:getTargetPhotos()

-- Get specific fields for all photos at once
local batchRaw = catalog:batchGetRawMetadata(photos, {"path", "uuid", "isVirtualCopy"})
local batchFormatted = catalog:batchGetFormattedMetadata(photos, {"fileName", "dateCreated"})

-- Access results by photo object
for i, photo in ipairs(photos) do
    local raw = batchRaw[photo]
    local formatted = batchFormatted[photo]
    logger:infof("Photo: %s at %s", formatted.fileName, raw.path)
end
```

## File I/O Pattern
```lua
-- io.open IS available in the Lightroom SDK despite some docs suggesting otherwise
local fh, err = io.open(filePath, "w")
if fh == nil then
    error("Cannot write to file: " .. err)
end
context:addCleanupHandler(function() fh:close() end)
fh:write(data)
```

## Blocking Export with Custom Message
```lua
-- Set LR_cantExportBecause to prevent export with a message
function exportServiceProvider.startDialog(propertyTable)
    propertyTable:addObserver('loggedIn', function(props, key, value)
        if not value then
            props.LR_cantExportBecause = "You haven't logged in yet."
        else
            props.LR_cantExportBecause = nil
        end
    end)
end
```

## Collection Hierarchy Traversal
```lua
-- Recursively walk collection sets and collections
local function dumpSet(set, depth)
    logger:infof("%s[Set] %s", string.rep("  ", depth), set:getName())
    for _, childSet in ipairs(set:getChildCollectionSets()) do
        dumpSet(childSet, depth + 1)
    end
    for _, collection in ipairs(set:getChildCollections()) do
        logger:infof("%s[Collection] %s (%d photos)",
            string.rep("  ", depth + 1),
            collection:getName(),
            #collection:getPhotos())
    end
end

-- Walk from catalog root
for _, set in ipairs(catalog:getChildCollectionSets()) do
    dumpSet(set, 0)
end
```

## Smart Collection Creation
```lua
catalog:withWriteAccessDo("Create smart collection", function()
    catalog:createSmartCollection(
        "Photos from 2024",
        {
            {
                criteria = "captureTime",
                operation = "in",
                value = LrDate.timeToIsoDate(startTime),
                value2 = LrDate.timeToIsoDate(endTime),
            },
            combine = "union",
        },
        parentCollectionSet  -- optional parent
    )
end)
```

## LrTasks.pcall Pattern (Yield-Aware Protected Call)
```lua
-- IMPORTANT: Inside async tasks, use LrTasks.pcall() instead of plain pcall()
-- Plain pcall cannot handle yields across coroutine boundaries
LrTasks.startAsyncTask(function()
    local success, result = LrTasks.pcall(function()
        -- Code that may call yielding SDK operations
        -- (LrHttp, catalog:findPhotos, LrTasks.sleep, etc.)
    end)
    if not success then
        if LrErrors.isCanceledError(result) then
            -- user canceled
        else
            LrDialogs.showError(result)
        end
    end
end)
```

## Re-entrant Modal Dialog Pattern
```lua
-- presentModalDialog can be called in a loop for persistent tool dialogs
-- Dialog state persists via bound property table between iterations
LrFunctionContext.callWithContext('toolDialog', function(context)
    local props = LrBinding.makePropertyTable(context)
    props.inputText = prefs.lastInput or ""

    local f = LrView.osFactory()
    local contents = f:column {
        bind_to_object = props,
        f:edit_field { value = bind 'inputText', width_in_chars = 40, height_in_lines = 5 },
    }

    while true do
        local verb = LrDialogs.presentModalDialog {
            title = "My Tool",
            contents = contents,
            actionVerb = "Run",      -- custom button label
            save_frame = "myToolPos", -- remember window position
        }
        if verb == "cancel" then break end
        -- Process props.inputText, show result, loop back
    end
    prefs.lastInput = props.inputText
end)
```

## Platform-Aware File Opening
```lua
-- LrShell.openFilesInApp(fileList, applicationPath)
-- Signature differs by platform:
if WIN_ENV then
    LrShell.openFilesInApp({""}, targetPath)  -- target as "app" opens with default handler
else
    LrShell.openFilesInApp({targetPath}, "open")  -- macOS "open" command
end
```

## Unicode LINE SEPARATOR Handling
Lightroom uses Unicode LINE SEPARATOR (U+2028) instead of `\n` for multi-line text in metadata fields. Convert between the two formats when interacting with external APIs:

```lua
-- Lightroom uses Unicode LINE SEPARATOR (U+2028) instead of \n for multi-line text
-- Convert before sending to external APIs:
local function encodeForApi(str)
    return string.gsub(str, string.char(0xE2, 0x80, 0xA8), "\n")
end
local function decodeFromApi(str)
    return string.gsub(str, "\n", string.char(0xE2, 0x80, 0xA8))
end
```

## Programmatic Export (LrExportSession constructor)
You can trigger an export programmatically without going through the Export dialog by constructing an `LrExportSession` directly:

```lua
local LrExportSession = import 'LrExportSession'
local session = LrExportSession({
    photosToExport = photos,
    exportSettings = {
        LR_format = "JPEG",
        LR_jpeg_quality = 0.85,
        LR_export_destinationType = "specificFolder",
        LR_export_destinationPathPrefix = "/path/to/output",
        LR_size_doConstrain = true,
        LR_size_maxWidth = 2048,
        LR_size_maxHeight = 2048,
        LR_collisionHandling = "rename",
        LR_minimizeEmbeddedMetadata = false,
    },
})
session:doExportOnCurrentTask()
```

## withWriteAccessDo with asynchronous option
The `asynchronous` option allows write access calls to return immediately without blocking the calling thread if the catalog is busy:

```lua
catalog:withWriteAccessDo("Action", function(context)
    -- write operations
end, { timeout = 5, asynchronous = true })
-- asynchronous = true: does not block calling thread if catalog is busy
```

## io.popen for Shell Command Output
Despite the restricted Lua environment, `io.popen()` IS available in the SDK sandbox (confirmed by real-world plugins). This allows plugins to execute shell commands and read their output:

```lua
-- io.popen IS available in the SDK sandbox
local fh = io.popen("uname -o 2>/dev/null", "r")
local result = fh:read()
fh:close()
```

## LrTasks.execute() External Command Pattern
`LrTasks.execute()` is the SDK-sanctioned replacement for the restricted `os.execute()`. It runs a shell command and returns the exit code. To capture output, redirect to a temporary file:

```lua
-- External command execution (replacement for restricted os.execute)
local tempFile = LrPathUtils.child(LrPathUtils.getStandardFilePath("temp"), "output.txt")
local cmdLine = '"' .. exePath .. '" ' .. args .. ' > "' .. tempFile .. '"'
if WIN_ENV then cmdLine = '"' .. cmdLine .. '"' end  -- Windows needs outer quotes
if LrTasks.execute(cmdLine) == 0 then
    local output = LrFileUtils.readFile(tempFile)
end
```

**Key points:**
- Returns the process exit code (0 = success)
- On Windows, the entire command line needs an extra set of outer quotes when it contains quoted paths
- To capture stdout, redirect to a temp file and read it back with `LrFileUtils.readFile()`

## Bundled Executable Pattern (`_PLUGIN.path`)
Plugins can bundle platform-specific executables inside the plugin folder and reference them via `_PLUGIN.path`:

```lua
local exePath = LrPathUtils.child(_PLUGIN.path, WIN_ENV and "tool.exe" or "tool")
```

This is commonly used with `LrTasks.execute()` to run bundled helper tools (e.g., image hash calculators, metadata extractors).

## Cross-File State Sharing via `_G`
The `_G` global table can be used to share state between different Lua script files within the same plugin. Values set in `LrInitPlugin` are accessible from all other plugin scripts:

```lua
-- In LrInitPlugin script:
_G.logger = LrLogger("myPlugin")
_G.pluginVersion = "1.2.3"

-- In other files (menu items, export providers, etc.):
local logger = _G.logger
```

**Caution:** `_G` state is lost on plugin reload. For persistent state, use `LrPrefs.prefsForPlugin()` instead.
