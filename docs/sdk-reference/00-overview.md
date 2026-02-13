# SDK Overview

## What is the Lightroom Classic SDK

The Adobe Photoshop Lightroom Classic Software Development Kit (SDK) is a **Lua-based scripting environment** for extending and customizing Lightroom Classic functionality. You write plug-ins in Lua that hook into well-defined extension points in the application.

The SDK is available for download from:
https://www.adobe.io/apis/creativecloud/lightroomclassic.html

The SDK package contains:
- **Programmer's Guide** (`LrC_SDK/Manual/Lightroom Classic SDK Guide.pdf`)
- **API Reference** (`LrC_SDK/API Reference/index.html`) -- complete HTML reference
- **Sample Plugins** (`LrC_SDK/Sample Plugins/`) -- working examples

### SDK Version

The guide's sample code uses `LrSdkVersion = 5.0`. The `LrSdkVersion` field in `Info.lua` should be set to the latest SDK version matching the current Lightroom Classic release. Historical values include 1.3, 1.4, 2.0, 3.0, 4.0, 5.0, and higher. You can also set `LrSdkMinimumVersion` to allow your plug-in to load in older Lightroom versions while still using features from a newer SDK.

### Types of Plug-ins You Can Create

1. **Export Service Providers** -- Customize Lightroom's Export dialog and export processing; send images to custom destinations (FTP servers, web services, etc.)
2. **Publish Service Providers** -- Like export services, but with ongoing synchronization through the Publishing Manager
3. **Export Filter Providers (Post-Process Actions)** -- Intercept the export pipeline after rendering to apply additional processing or filtering before images reach their destination
4. **Metadata Providers** -- Define custom public or private metadata fields associated with photos, and custom metadata tagsets for the Library module's Metadata panel
5. **Menu Items** -- Add items to the File menu (`LrExportMenuItems`), Library menu (`LrLibraryMenuItems`), or Help menu (`LrHelpMenuItems`)
6. **Web-Engine Plug-ins** -- Define new HTML photo gallery types that appear in the Web module's Gallery panel (these use a slightly different architecture with `.lrwebengine` folders)

Standard plug-ins use `.lrdevplugin` (development) or `.lrplugin` (release) folder extensions. Web-engine plug-ins use `.lrwebengine`.

---

## Lua Environment

### Lua Version

Lightroom Classic uses **Lua 5.1.5**. Features introduced in Lua 5.2 and later are not available.

For Lua language reference, see http://www.lua.org/ and "Programming in Lua, second edition" by Roberto Ierusalimschy.

### The `import()` Function

The SDK provides a custom built-in function called `import()` for loading SDK namespaces and classes. This is **not** the standard Lua `require()` -- it is specific to Lightroom.

```lua
-- import() loads an SDK namespace (returns a table of functions)
-- or an SDK class (returns a constructor function)
local LrMD5 = import 'LrMD5'
local LrLogger = import 'LrLogger'
```

The pattern `local LrXxx = import 'LrXxx'` is the standard convention. The parentheses around the string argument can be omitted because Lua allows this when calling a function with a single string literal.

When `import()` loads a **namespace**, it returns a table of static functions accessed via dot notation:

```lua
local LrMD5 = import 'LrMD5'
local digest = LrMD5.digest( 'some string' )
```

When `import()` loads a **class**, it returns a constructor function. Call the constructor to create an instance, then use colon notation for method calls:

```lua
local LrLogger = import 'LrLogger'
local logger = LrLogger( 'myPlugin' )    -- constructor call, returns an instance
logger:enable( 'print' )                  -- method call on the instance
logger:warn( 'something bad happened' )
```

### The `require()` Function

Lightroom defines its own `require()` function for loading your own Lua files from within the same plug-in directory. It works similarly to standard Lua `require()` but is more narrowly scoped:

- Takes a single parameter: the filename of another `.lua` file in the same plug-in
- On first call, loads and executes the file; caches the return value
- On subsequent calls, returns the cached value (unless the plug-in has been garbage collected)

```lua
-- SomeFile.lua
SomeFile = {}

function SomeFile.doSomething( arg )
    return tostring( arg )
end
```

```lua
-- AnotherFile.lua
require 'SomeFile.lua'
SomeFile.doSomething( 42 )
```

Note that globals defined via `require` live in a special per-plug-in function environment and do not affect Lightroom as a whole. Avoid names starting with `Lr` to prevent conflicts with future SDK versions.

### Key Difference: `import` vs `require`

| Aspect | `import 'LrXxx'` | `require 'MyModule.lua'` |
|--------|-------------------|--------------------------|
| Purpose | Load SDK namespaces/classes | Load your own plug-in modules |
| Source | Built into Lightroom SDK | Your plug-in's folder |
| Returns | Namespace table or class constructor | Whatever the loaded file returns/defines |
| Caching | Always available | Cached per plug-in lifecycle |

### Typical File Header

A typical Lightroom plug-in script starts with SDK imports at the top:

```lua
-- Standard SDK imports
local LrApplication = import 'LrApplication'
local LrDialogs = import 'LrDialogs'
local LrErrors = import 'LrErrors'
local LrFunctionContext = import 'LrFunctionContext'
local LrLogger = import 'LrLogger'
local LrTasks = import 'LrTasks'
local LrView = import 'LrView'

-- Your own modules
require 'Utils.lua'
```

### Available Standard Lua Features

**Global functions available in Lightroom Classic:**

`assert()`, `dofile()`, `error()`, `getmetatable()`, `ipairs()`, `load()`, `loadfile()`, `loadstring()`, `next()`, `pairs()`, `pcall()`, `rawequal()`, `rawget()`, `rawset()`, `select()`, `setmetatable()`, `tonumber()`, `tostring()`, `type()`, `unpack()`

**Note on `loadstring()`:** Functions compiled via `loadstring()` inherit the full SDK global scope, including the `import()` function. This means dynamically loaded code has the same privilege level as the plugin itself and can access all SDK namespaces.

**Global functions NOT available:**

`collectgarbage()`, `gcinfo()`, `getfenv()`, `module()`, `newproxy()`, `package()`, `setfenv()`

### Standard Lua Namespaces

**Fully available:**

| Namespace | Notes |
|-----------|-------|
| `io` | Available. Notably, `io.popen()` is also available (confirmed by real plugins), allowing plugins to execute shell commands and read their output. |
| `math` | Available |
| `string` | Available |

**Not available:**

| Namespace | Notes |
|-----------|-------|
| `package` | Not available; Lightroom does not use Lua 5.1's module system |

**Partially available:**

| Namespace | What is available |
|-----------|-------------------|
| `os` | Only `clock()`, `date()`, `time()`, `tmpname()`. All other functions removed. Use `LrFileUtils`, `LrDate`, and `LrTasks` for SDK-native operations; note `io` remains available in plugin runtime. |
| `table` | All functions **except** `getn()`, `setn()`, and `maxn()` (deprecated in Lua 5.1). So `concat`, `insert`, `remove`, `sort` are all available. |
| `coroutine` | Only `canYield()` and `running()`. No `create`, `resume`, `wrap`, or `yield`. |
| `debug` | Only `getInfo()`. |

### Platform Detection

Lightroom Classic defines two Boolean globals for platform detection:

```lua
if WIN_ENV then
    -- Running on Windows
end

if MAC_ENV then
    -- Running on macOS
end
```

The `LrSystemInfo` namespace (available since SDK version 3.0) provides additional platform information, including 32-bit vs. 64-bit architecture.

There is also a `_VERSION` variable containing version information otherwise available through `LrApplication.versionTable()`.

### Other Global Variables

- **`_PLUGIN`** -- An `LrPlugin` object providing access to your plug-in's configuration, path, and resources.

---

## SDK Architecture

The Lightroom Classic SDK is organized into **namespaces** (static utility function tables) and **classes** (constructors that produce object instances with methods and properties).

- Plug-ins **cannot** define new namespaces or classes; they can only use what the SDK provides.
- Lightroom does not use Lua 5.1's module system. Namespaces are loaded via `import()`.
- The object model follows the pattern described in Chapter 16 of "Programming in Lua" (http://www.lua.org/pil/16.html).

### Namespaces

Namespaces are tables of static functions. Access them with dot notation after importing.

| Namespace | Description |
|-----------|-------------|
| `LrApplication` | Application-wide information; access to the active catalog |
| `LrBinding` | Define data relationships between UI elements and other objects |
| `LrColor` | Access color values (RGB, grayscale, or by name). Also a class. |
| `LrDate` | Create and manipulate date-time values |
| `LrDialogs` | Show messages in predefined modal dialogs |
| `LrErrors` | Format Lua error strings for error dialogs |
| `LrExportSettings` | Check or set image file format for export operations |
| `LrFileUtils` | Platform-independent file and folder manipulation |
| `LrFtp` | Work with FTP paths and settings. Also a class. |
| `LrFunctionContext` | Function calls with cleanup-handler registration. Also a class. |
| `LrHttp` | Send and receive data via HTTP. Must be used within a task. |
| `LrLocalization` | Localize your plug-in for multiple languages |
| `LrLogger` | Logging capability. Also a class. |
| `LrMath` | Additional basic math operations |
| `LrMD5` | MD5 digest services |
| `LrPasswords` | Store passwords securely |
| `LrPathUtils` | Manipulate file-system path strings in a platform-appropriate way |
| `LrPhotoInfo` | Get information about individual photo files (e.g., dimensions) |
| `LrPrefs` | Define persistent preferences for your plug-in |
| `LrProgressScope` | Provide progress feedback for long-running tasks. Also a class. |
| `LrRecursionGuard` | Simple recursion guard for function execution. Also a class. |
| `LrShell` | Access platform file browser shell functions (Explorer / Finder) |
| `LrStringUtils` | String manipulation utilities |
| `LrSystemInfo` | Information about the runtime environment (platform, architecture) |
| `LrTasks` | Start and manage cooperative tasks on Lightroom's main UI thread |
| `LrView` | Construct dialog box elements; obtain factory objects and create bindings. Also a class. |
| `LrXml` | Create XML builder objects and parse XML into read-only DOM objects. Also a class. |

### Classes

Classes are loaded via `import()` which returns a constructor function. Some classes are only obtained through other objects (e.g., `LrCatalog` from `LrApplication.activeCatalog()`).

| Class | Description | How to obtain |
|-------|-------------|---------------|
| `LrCatalog` | Access a Lightroom Classic catalog | `LrApplication.activeCatalog()` |
| `LrCollection` | Access a photo collection | Returned by `LrCatalog:createCollection()`, `LrCatalog:getChildCollections()`, etc. |
| `LrCollectionSet` | Access a photo collection set | Returned by `LrCatalog:createCollectionSet()`, etc. |
| `LrColor` | Encapsulates a color | Import constructor: `local LrColor = import 'LrColor'` |
| `LrDevelopPreset` | Access a develop preset | Returned by `LrDevelopPresetFolder:getDevelopPresets()` |
| `LrDevelopPresetFolder` | Access a develop-preset folder | Returned by `LrApplication.developPresetFolders()` |
| `LrExportContext` | Encapsulates an export context | Passed to your `processRenderedPhotos()` function |
| `LrExportRendition` | A single photo rendition during export | Returned by `LrExportSession:renditions()` |
| `LrExportSession` | Access export photo list and renditions | Import constructor, or via `exportContext.exportSession` |
| `LrFilterContext` | Access user choices and photo list during export filtering | Passed to your `postProcessRenderedPhotos` function |
| `LrFolder` | Access a file-system folder containing photos | Returned by `LrCatalog:getFolders()`, etc. |
| `LrFtp` | An FTP connection | `LrFtp.create()` factory function |
| `LrFunctionContext` | Cleanup handler registration for function execution | Passed to functions called via `LrFunctionContext.callWithContext()` etc. |
| `LrKeyword` | Encapsulates a keyword | Returned by `LrCatalog:createKeyword()`, `LrCatalog:getKeywords()`, etc. |
| `LrLogger` | Debug output mechanism | Import constructor: `local LrLogger = import 'LrLogger'` |
| `LrObservableTable` | Observable properties table (for data binding) | Created by `LrBinding.makePropertyTable()` |
| `LrPhoto` | A single photo or virtual copy in the active catalog | Returned by many functions of `LrCatalog`, `LrCollection`, etc. |
| `LrPlugin` | Access plug-in configuration, path, and resources | Global variable `_PLUGIN` |
| `LrProgressScope` | Progress feedback for long-running tasks | Import constructor |
| `LrPublishedCollection` | Access a published-photo collection | Parallel to `LrCollection` access functions |
| `LrPublishedCollectionSet` | Access a published-photo collection set | Parallel to `LrCollectionSet` access functions |
| `LrPublishedPhoto` | Publishing info for a photo in a published collection | Returned by `LrPublishedCollection:getPublishedPhotos()` |
| `LrPublishService` | Access a named publishing service | Returned by `LrCatalog:getPublishServices()` |
| `LrRecursionGuard` | Simple recursion guard | Import constructor |
| `LrVideoExportPreset` | A single video export preset | Returned by `LrExportSettings.videoExportPresets` |
| `LrView` | Construct dialog box elements | Import namespace, then `LrView.osFactory()` or passed to `sectionsForTopOfDialog()` |
| `LrWebViewFactory` | Construct elements for Web module panels | Passed to the `views` function in `galleryInfo.lrweb`. Only available in web-engine plug-ins. |
| `LrXml` | XML builder and DOM objects | `LrXml.createXmlBuilder()` or `LrXml.parseXml()` |

Note: Several items (`LrColor`, `LrFtp`, `LrFunctionContext`, `LrLogger`, `LrProgressScope`, `LrRecursionGuard`, `LrView`, `LrXml`) act as **both** namespace and class -- they have static functions accessible via dot notation on the imported table, and also produce object instances with methods accessible via colon notation.

---

## Import System

### `import 'LrXxx'` -- SDK Namespaces and Classes

The `import()` function is the gateway to the entire Lightroom Classic SDK. It accepts a single string argument (the name of an SDK namespace or class) and returns either:

- A **table of functions** (for namespaces), or
- A **constructor function** (for classes)

```lua
-- Namespace: returns a table
local LrDialogs = import 'LrDialogs'
LrDialogs.message( "Hello", "World" )           -- dot notation

-- Class: returns a constructor
local LrLogger = import 'LrLogger'
local log = LrLogger( 'myPlugin' )               -- call constructor
log:enable( 'print' )                             -- colon notation for methods
```

### `require 'MyModule'` -- Your Own Plugin Modules

The `require()` function loads `.lua` files from your plug-in's directory:

```lua
require 'MyModule.lua'
-- MyModule (the global table defined in that file) is now accessible
MyModule.someFunction()
```

Key behaviors:
- The file is executed once and the result is cached for the plug-in's lifetime
- The loaded file typically defines a global table matching the filename
- The global lives in a per-plug-in environment (does not leak into Lightroom globals)
- You cannot use `require()` to load SDK namespaces, and you cannot use `import()` to load your own files

### Example: Complete File with Both import and require

```lua
-- MyExportService.lua

-- SDK imports (using import)
local LrApplication = import 'LrApplication'
local LrDialogs = import 'LrDialogs'
local LrFunctionContext = import 'LrFunctionContext'
local LrLogger = import 'LrLogger'
local LrTasks = import 'LrTasks'

-- Own modules (using require)
require 'MyUploadUtils.lua'
require 'MyConfig.lua'

-- Create a logger
local logger = LrLogger( 'MyExportPlugin' )
logger:enable( 'logfile' )

-- Use SDK namespace
local catalog = LrApplication.activeCatalog()

-- Use own module
MyUploadUtils.uploadPhoto( photo, destination )
```

### Function Context Pattern

Many operations in Lightroom require wrapping in a function context for proper error handling and resource cleanup:

```lua
local LrFunctionContext = import 'LrFunctionContext'
local LrDialogs = import 'LrDialogs'
local LrErrors = import 'LrErrors'

LrFunctionContext.callWithContext( 'myOperation', function( context )
    -- Attach standard error dialog
    LrDialogs.attachErrorDialogToFunctionContext( context )

    -- Your code here
    -- Errors are caught and displayed to the user
end )
```

For background tasks (required for operations like HTTP requests):

```lua
local LrTasks = import 'LrTasks'

LrTasks.startAsyncTask( function()
    -- This runs cooperatively on Lightroom's main UI thread
    -- LrHttp functions can only be called from within a task
end )
```
