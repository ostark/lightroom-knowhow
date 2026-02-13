# Plugin Structure

A Lightroom Classic plug-in is a collection of Lua scripts packaged in a specially named folder. The SDK defines a standard architecture that all plug-ins share (except web-engine plug-ins, which use a different architecture). This document covers the folder layout, the manifest file, delivery, lifecycle, and debugging.

---

## Folder Structure

A plug-in is a **folder** whose name ends with one of two recognized extensions:

| Extension | Purpose | macOS Finder behavior |
|---|---|---|
| `.lrplugin` | Production / delivery | Shown as a **bundle** (appears as a single file) |
| `.lrdevplugin` | Development / hot-reload | Shown as a **normal folder** (easy to browse and edit) |

Both extensions are fully recognized by Lightroom Classic. The only functional difference is that `.lrdevplugin` does not trigger the macOS Finder "package" behavior, making it convenient for development.

### Internal layout

The folder must contain at minimum an `Info.lua` manifest file. Beyond that, you can organize your Lua scripts however you like:

```
MyPlugin.lrdevplugin/
    Info.lua                    -- required manifest
    PluginInit.lua              -- initialization script
    PluginInfoProvider.lua      -- Plugin Manager customization
    ExportServiceProvider.lua   -- export service definition
    MetadataDefinition.lua      -- custom metadata fields
    Utils.lua                   -- shared helper functions
    config.lua                  -- optional debugging config
```

You can also use subdirectories for larger plug-ins:

```
MyPlugin.lrdevplugin/
    Info.lua
    src/
        ExportServiceProvider.lua
        PluginInfoProvider.lua
    resources/
        icon.png
    presets/
        default.lrtemplate
```

All Lua files referenced from `Info.lua` use paths relative to the plug-in root folder.

---

## Info.lua -- The Plugin Manifest

Every plug-in must contain a file named `Info.lua` at the root of the plug-in folder. This file returns a Lua table that describes the plug-in to Lightroom Classic. Lightroom reads this file to determine what the plug-in provides, which scripts to execute, and how to display the plug-in in the Plug-in Manager.

### Important: The Loader Environment

`Info.lua` runs in a restricted Lua environment. Compared to the full SDK scripting environment:

- The standard Lua `string` namespace **is** available.
- The `LOC` function **is** available (for localized display strings).
- `WIN_ENV` and `MAC_ENV` Boolean globals **are** available.
- The `_VERSION` variable is available (contains version information).
- You **cannot** use `import`, `require`, or any other Lightroom SDK globals.

### Complete Reference of Info.lua Entries

#### Identification and Version

| Key | Required? | Type | Description |
|---|---|---|---|
| `LrSdkVersion` | **Required** | number | The preferred version of the Lightroom Classic SDK for this plug-in. Should be set to the latest SDK version for the target release (e.g., `5.0`, `10.0`, `14.0`). Older plug-ins may use values like `1.3`, `2.0`, `3.0`. |
| `LrSdkMinimumVersion` | Optional | number | The minimum SDK version that this plug-in can run on. Use this when your plug-in works with older Lightroom versions but provides new features for newer ones. For example, set `LrSdkMinimumVersion = 8.0` and `LrSdkVersion = 11.0` if the plug-in works on 8.0+ but has 11.0-specific features. Defaults to the value of `LrSdkVersion`. |
| `LrToolkitIdentifier` | **Required** | string | A unique identifier for your plug-in, using reverse-domain (Java-style) naming: `"com.mycompany.myplugin"`. Only one plug-in with a given identifier can be enabled at a time. The `com.adobe.*` namespace is reserved for Adobe. |
| `LrPluginName` | Required (SDK 2.0+) | string | The display name of the plug-in, shown in the Plug-in Manager dialog. Supports localization via `LOC`. If omitted on older SDK versions, Lightroom displays the title of the first Export Service Provider, or the base name of the plug-in folder. |
| `VERSION` | Optional | table | A version table for display in the Plug-in Manager. Members: `major` (number), `minor` (number), `revision` (number), `build` (string), `display` (string, optional). The default display format is `major.minor.revision.build`. The `build` value is omitted if zero; both `revision` and `build` are omitted if both are zero. If you prefer a custom format, provide the `display` string (supports `LOC` for localization). Ignored before SDK 2.0. |

#### Lifecycle Scripts

| Key | Required? | Type | Description |
|---|---|---|---|
| `LrInitPlugin` | Optional | string | Name of a Lua script that runs when the plug-in is loaded or reloaded. Use this to initialize values in the plug-in's global function environment. When the plug-in is reloaded, a new environment is created, all previous values are discarded, and this script runs again. Ignored if `LrSdkVersion` < 2.0. |
| `LrForceInitPlugin` | Optional | boolean | When `true`, forces `LrInitPlugin` to run at application startup, even for plug-ins that do not provide export/publish services or custom metadata, as long as the plug-in contributes at least a menu item. Otherwise the init script does not run until first use. Ignored before SDK 4.0. |
| `LrShutdownPlugin` | Optional | string | Name of a Lua script that runs when the user unloads the plug-in. Only executes if the plug-in was loaded or reloaded through the Plug-in Manager during the current session. Ignored before SDK 3.0. |
| `LrShutdownApp` | Optional | string | Name of a Lua script that runs when Lightroom Classic is shutting down. The script must return a table containing an `LrShutdownFunction` member (see "Application Termination Script" below). Ignored if `LrSdkVersion` < 4.0. |
| `LrEnablePlugin` | Optional | string | Name of a Lua script that runs when the user enables the plug-in in the Plug-in Manager. Ignored before SDK 3.0. |
| `LrDisablePlugin` | Optional | string | Name of a Lua script that runs when the user disables the plug-in in the Plug-in Manager. Ignored before SDK 3.0. |

#### Plugin Manager Customization

| Key | Required? | Type | Description |
|---|---|---|---|
| `LrPluginInfoProvider` | Optional | string | Name of a Lua script that customizes the Plug-in Manager dialog when the plug-in is selected. The script can return `startDialog`, `endDialog`, `sectionsForTopOfDialog`, and `sectionsForBottomOfDialog` functions. Ignored before SDK 2.0. |
| `LrPluginInfoUrl` | Optional | string | URL of your website or a page with plug-in information. Displayed in the Status section of the Plug-in Manager when the plug-in is selected, and in error messages if the plug-in fails to load. Ignored before SDK 2.0. |

#### Menu Items

| Key | Required? | Type | Description |
|---|---|---|---|
| `LrExportMenuItems` | Optional | table of tables | Adds menu items to **File > Plug-in Extras**. Each entry is a table with `title` (string), `file` (string), and optionally `enabledWhen` (string: `"photosAvailable"`, `"photosSelected"`, `"videosSelected"`, or `"anythingSelected"`). |
| `LrLibraryMenuItems` | Optional | table of tables | Adds menu items to **Library > Plug-in Extras**. Same structure as `LrExportMenuItems`. |
| `LrHelpMenuItems` | Optional | table of tables | Adds menu items to **Help > Plug-in Extras**. Same structure as `LrExportMenuItems`. |

**Single-item shorthand:** `LrExportMenuItems`, `LrLibraryMenuItems`, and `LrHelpMenuItems` normally take an array of tables. When there is only one menu item, you can pass a single table (not wrapped in an array):

```lua
-- Array form (multiple items):
LrLibraryMenuItems = {
    { title = "Action 1", file = "Action1.lua" },
    { title = "Action 2", file = "Action2.lua" },
}
-- Shorthand form (single item):
LrLibraryMenuItems = {
    title = "My Action",
    file = "MyAction.lua",
}
```

#### Service Providers

| Key | Required? | Type | Description |
|---|---|---|---|
| `LrExportServiceProvider` | Optional | table of tables | Defines one or more export/publish destinations. Each entry: `title` (string, required), `file` (string, required -- the service definition script), `builtInPresetsDir` (string, optional -- subfolder name for preset `.lrtemplate` files), `id` (string, optional -- unique identifier; defaults to consecutive numbers). |
| `LrExportFilterProvider` | Optional | table of tables | Defines one or more export filters (post-process actions applied after rendering, before final destination). Each entry: `title` (string), `file` (string -- filter definition script), `id` (string -- unique identifier), `requiresFilter` (string, optional -- ID of another filter this one depends on). Ignored before SDK 2.0. |

#### Metadata

| Key | Required? | Type | Description |
|---|---|---|---|
| `LrMetadataProvider` | Optional | string | Name of a Lua script that defines custom metadata fields. Only one metadata provider per plug-in. The script defines fields available in the Library module. Can be combined with export services and filters. Ignored before SDK 2.0. |
| `LrMetadataTagsetFactory` | Optional | string or table of strings | Defines custom metadata tagsets that appear in the Metadata panel's tagset menu. Can be a single script name or a table of script names. Ignored before SDK 2.0. |

#### Miscellaneous

| Key | Required? | Type | Description |
|---|---|---|---|
| `LrAlsoUseBuiltInTranslations` | Optional | boolean | When `true`, strings not found in the plug-in's translation file are checked against Lightroom's built-in translation file for the current language. Note: string keys are not guaranteed to remain stable across version releases. Ignored before SDK 3.0. |
| `LrLimitNumberOfTempRenditions` | Optional | boolean | When `true`, Lightroom throttles the number of temporary image files on disk during export, protecting against high disk space usage. The plug-in is expected to remove temporary rendition files when done. Ignored before SDK 5.0. |
| `URLHandler` | Optional | string | Name of a file that provides custom URL handling. The file must return a table with a `URLHandler` entry (a function that takes a URL as parameter). Lightroom is the registered receiver of `lightroom://` URLs and routes them to matching plug-in handlers based on the toolkit identifier (e.g., `lightroom://com.mycompany.myplugin/action`). Ignored before SDK 4.0. |

---

## Complete Info.lua Example

Below is a realistic, comprehensive `Info.lua` file demonstrating most entries:

```lua
return {

    -- SDK version targeting
    LrSdkVersion = 13.0,
    LrSdkMinimumVersion = 6.0,

    -- Identification
    LrToolkitIdentifier = "com.picdrop.lightroom.uploader",
    LrPluginName = LOC "$$$/Picdrop/PluginName=picdrop Uploader",
    LrPluginInfoUrl = "https://www.picdrop.com/help/lightroom-plugin",

    -- Version
    VERSION = {
        major = 2,
        minor = 1,
        revision = 0,
        build = "20260115-abc123",
    },

    -- Lifecycle scripts
    LrInitPlugin = "PluginInit.lua",
    LrForceInitPlugin = true,
    LrShutdownPlugin = "PluginShutdown.lua",
    LrShutdownApp = "AppShutdown.lua",
    LrEnablePlugin = "PluginEnable.lua",
    LrDisablePlugin = "PluginDisable.lua",

    -- Plugin Manager customization
    LrPluginInfoProvider = "PluginInfoProvider.lua",

    -- Menu items (File > Plug-in Extras)
    LrExportMenuItems = {
        {
            title = LOC "$$$/Picdrop/ExportMenu=Upload to picdrop",
            file = "ExportMenuItem.lua",
            enabledWhen = "photosSelected",
        },
    },

    -- Menu items (Library > Plug-in Extras)
    LrLibraryMenuItems = {
        {
            title = LOC "$$$/Picdrop/LibraryMenu/Sync=Sync with picdrop",
            file = "SyncMenuItem.lua",
            enabledWhen = "anythingSelected",
        },
        {
            title = LOC "$$$/Picdrop/LibraryMenu/Settings=picdrop Settings",
            file = "SettingsMenuItem.lua",
        },
    },

    -- Help menu
    LrHelpMenuItems = {
        {
            title = LOC "$$$/Picdrop/HelpMenu=picdrop Help",
            file = "HelpMenuItem.lua",
        },
    },

    -- Export service
    LrExportServiceProvider = {
        title = LOC "$$$/Picdrop/ServiceName=picdrop",
        file = "PicdropExportServiceProvider.lua",
        builtInPresetsDir = "presets",
    },

    -- Export filter
    LrExportFilterProvider = {
        {
            title = LOC "$$$/Picdrop/Filter/Watermark=picdrop Watermark",
            file = "WatermarkFilterProvider.lua",
            id = "com.picdrop.filter.watermark",
        },
    },

    -- Custom metadata
    LrMetadataProvider = "PicdropMetadataDefinition.lua",
    LrMetadataTagsetFactory = "PicdropTagset.lua",

    -- URL handler (lightroom://com.picdrop.lightroom.uploader/...)
    URLHandler = "URLHandler.lua",

    -- Miscellaneous
    LrAlsoUseBuiltInTranslations = true,
    LrLimitNumberOfTempRenditions = true,
}
```

---

## Plugin Delivery

### Development: `.lrdevplugin`

During development, name your plug-in folder with the `.lrdevplugin` extension:

```
picdrop-uploader.lrdevplugin/
```

This extension gives you two advantages:
1. On macOS, the Finder shows it as a regular folder (not a bundle), so you can browse and edit files normally.
2. Lightroom Classic can reload the plug-in via the Plug-in Author Tools section in the Plug-in Manager (click "Reload Plug-in"), or automatically after each export/publish operation if the checkbox is enabled.

### Production: `.lrplugin`

For delivery to users, rename the extension to `.lrplugin`:

```
picdrop-uploader.lrplugin/
```

On macOS this causes the Finder to treat the folder as a package (single-file appearance), giving a cleaner user experience.

### Installation

Users install plug-ins through:

1. **File > Plug-in Manager** -- opens the Plug-in Manager dialog.
2. Click **Add** and browse to the `.lrplugin` folder.
3. The plug-in appears in the list. Users can **enable**, **disable**, or **remove** it.

### Automatic Loading

Lightroom also auto-loads plug-ins from the standard Modules folder:

| Platform | Path |
|---|---|
| macOS (current user) | `~/Library/Application Support/Adobe/Lightroom/Modules` |
| macOS (all users) | `/Library/Application Support/Adobe/Lightroom/Modules` |
| Windows 7/8/10/11 | `C:\Users\<username>\AppData\Roaming\Adobe\Lightroom\Modules` |

Plug-ins in the Modules folder are automatically listed in the Plug-in Manager. They can be enabled or disabled, but the Remove button is dimmed -- they cannot be removed through the dialog.

### Plugin Manager Status Indicators

The Plug-in Manager dialog shows status for each plug-in:

- **Installed and running** -- plug-in is active and functioning.
- **Installed but disabled** -- user has disabled the plug-in.
- **Error loading** -- plug-in failed to load (check `LrPluginInfoUrl` in error messages).
- **Not installed** -- plug-in was previously registered but can no longer be found at its path.

---

## Plugin Lifecycle

### Initialization Sequence

When Lightroom starts or a plug-in is loaded through the Plug-in Manager:

```
LrInitPlugin      -->  Runs the initialization script.
                       Initializes the plug-in's global function environment.
                       (A new environment is created on each reload.)

LrEnablePlugin     -->  Runs when the plug-in is enabled.

(plug-in active)   -->  Menu items, export services, metadata, etc. are available.
```

If `LrForceInitPlugin` is `true`, `LrInitPlugin` runs at application startup even if the plug-in would normally be lazily initialized (i.e., not started until first use).

### Shutdown Sequence

When the user disables or removes the plug-in:

```
LrDisablePlugin    -->  Runs when the plug-in is disabled in the Plug-in Manager.

LrShutdownPlugin   -->  Runs when the plug-in is unloaded.
                        Only executes if the plug-in was loaded/reloaded through
                        the Plug-in Manager during the current session.
```

### Application Quit

When Lightroom Classic is closing:

```
LrShutdownApp      -->  Runs the application shutdown script.
```

The `LrShutdownApp` script must return a table with an `LrShutdownFunction`:

```lua
-- AppShutdown.lua
return {
    LrShutdownFunction = function( doneFunction, progressFunction )

        -- Perform cleanup tasks...
        -- Report progress: progressFunction( percentComplete, message )
        --   percentComplete: number between 0 and 1
        --   message: string for the progress dialog
        --   returns: true if the user clicked Cancel

        local canceled = progressFunction( 0.5, "Cleaning up picdrop cache..." )
        if canceled then
            doneFunction()
            return
        end

        -- ... finish cleanup ...

        -- Signal completion (required -- allows shutdown to proceed)
        doneFunction()
    end,
}
```

Important notes about `LrShutdownFunction`:
- `doneFunction()` must be called when cleanup is complete (this allows asynchronous tasks).
- If 10 seconds pass without a call to `progressFunction`, Lightroom assumes the task is hung and proceeds with shutdown.
- The `LrDialogs` namespace is **not** available during the shutdown task.

---

## Debugging

### LrLogger -- Trace Logging

The primary debugging tool in the SDK is the `LrLogger` namespace/class. It lets you write trace output to either a platform console or a log file.

#### Setting Up a Logger

```lua
local LrLogger = import 'LrLogger'

-- Create a named logger instance
local logger = LrLogger( 'picdropPlugin' )

-- Choose output destination:
logger:enable( "print" )    -- output to platform console (stdout)
-- OR
logger:enable( "logfile" )  -- write to a log file on disk
```

#### Writing Log Messages

`LrLogger` provides methods at different severity levels:

```lua
logger:trace( "Detailed step-by-step info" )
logger:debug( "Debugging details" )
logger:info( "General information" )
logger:warn( "Something unexpected happened" )
logger:error( "Something went wrong" )
logger:fatal( "Critical failure" )
```

#### Practical Example

```lua
-- At the top of any script file:
local LrLogger = import 'LrLogger'
local LrTasks = import 'LrTasks'

local logger = LrLogger( 'picdropPlugin' )
logger:enable( "logfile" )

local function outputToLog( message )
    logger:trace( message )
end

-- Use throughout your code:
outputToLog( "Starting export process..." )
outputToLog( "Processing photo: " .. photo:getFormattedMetadata( "fileName" ) )
```

### Viewing Log Output

#### "logfile" Action -- Log Files

When using `logger:enable( "logfile" )`, log output is written to:

| Platform | Path |
|---|---|
| macOS | `~/Documents/LrClassicLogs/<loggerName>.txt` |
| Windows | `<user_home>\Documents\LrClassicLogs\<loggerName>.txt` |

For the example above (`LrLogger('picdropPlugin')`), the file would be:
- macOS: `~/Documents/LrClassicLogs/picdropPlugin.txt`

You can watch the log file in real-time from the terminal:

```bash
tail -f ~/Documents/LrClassicLogs/picdropPlugin.txt
```

#### "print" Action -- Platform Console

When using `logger:enable( "print" )`, output goes to stdout, which you view with:

- **macOS**: Console.app (`/Applications/Utilities/Console.app`) or Xcode
- **Windows**: WinDbg (attach to `lightroom.exe` process) or Microsoft Developer Studio

### Finding Deprecated API Calls

You can add a debugging flag to `config.lua` in your plug-in folder to detect calls to deprecated SDK functionality:

```lua
-- config.lua (in the plug-in root folder)

-- Option 1: Throw an exception on each deprecated call
sdkDeprecation.action = "throw"

-- Option 2: Log deprecated calls to a file
sdkDeprecation.action = "log"
```

When using the `"log"` action, you must also configure the deprecation logger in `config.lua`:

```lua
-- config.lua
sdkDeprecation.action = "log"

loggers.AgSdkDeprecation = {
    logLevel = "info",
    action = "logfile",
}
```

The deprecation log is written to:
- **macOS**: `~/Documents/AgSdkDeprecation.log`
- **Windows**: `<user_home>\My Documents\AgSdkDeprecation.log`

### Development Workflow Summary

1. Name your plug-in folder with `.lrdevplugin` for rapid iteration.
2. Add it to Lightroom via **File > Plug-in Manager > Add**.
3. Set up `LrLogger` with `"logfile"` action and `tail -f` the log.
4. Enable `sdkDeprecation` in `config.lua` to catch deprecated calls early.
5. Use the **Plug-in Author Tools** section in the Plug-in Manager to reload after code changes, or enable the auto-reload-on-export checkbox.
6. When ready for delivery, rename the extension from `.lrdevplugin` to `.lrplugin`.

> **Note**: Reloading a plug-in (interactively or automatically after export) does **not** reload localization dictionaries. Translation files are read only when the plug-in is first loaded or Lightroom is restarted.
