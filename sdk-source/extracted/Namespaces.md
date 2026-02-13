# Lightroom Classic SDK 11.4 -- Namespace API Reference

Extracted from the official Adobe Lightroom Classic SDK 11.4 API Reference HTML documentation.
Covers 10 key namespaces with every method, full signatures, parameters, return types, and descriptions.

---

## Table of Contents

1. [LrApplication](#lrapplication)
2. [LrDate](#lrdate)
3. [LrDialogs](#lrdialogs)
4. [LrFileUtils](#lrfileutils)
5. [LrFunctionContext](#lrfunctioncontext)
6. [LrHttp](#lrhttp)
7. [LrLogger](#lrlogger)
8. [LrPathUtils](#lrpathutils)
9. [LrTasks](#lrtasks)
10. [LrView](#lrview)

---

## LrApplication

**Type:** Namespace

Provides access to the active catalog and application-wide information, such as version information. Access the functions directly from the imported namespace.

### LrApplication.activeCatalog()

Retrieves the catalog that is currently open in Lightroom.

- **Parameters:** None
- **Return value:** (`LrCatalog`) The catalog object.
- **Since:** SDK 1.3

---

### LrApplication.addDevelopPresetForPlugin( plugin, presetName, presetValue )

Adds a preset hidden within a plug-in. These presets are stored in a special folder called "Plugin Develop Presets." They do not appear in the presets panel in the Develop module, and cannot be retrieved by ID. To apply the preset, use `LrPhoto:applyDevelopPresetFromPlugin`. To retrieve, use `LrApplication:getDevelopPresetsForPlugin()`.

- **Parameters:**
  - `plugin` (`_PLUGIN`) -- Your plug-in object.
  - `presetName` (string) -- The preset's name.
  - `presetValue` (table) -- The setting values for the preset. For allowed values, see `LrDevelopPreset:getSetting`.
- **Return value:** (`LrDevelopPreset`) The preset object.
- **Since:** SDK 3.0

---

### LrApplication.appStoreReceiptHash()

Retrieves a unique identifier that is keyed to the Mac App Store receipt. Intended to aid in plug-in registrations for app store builds of Lightroom, where there is no serial number available.

- **Parameters:** None
- **Return value:** (string) The unique ID, or nil if the running version of Lightroom is not from the Mac App Store.
- **Since:** SDK 4.1

---

### LrApplication.backupAtNextShutdown( pluginId )

Requests a catalog backup to be performed next time Lightroom closes. This does not alter the backup periodicity already in place, other than by affecting the recorded time for last backup, if the user does not choose to skip the backup via the dialog at shutdown time.

- **Parameters:**
  - `pluginId` (string) -- The plugin identifier (`_PLUGIN.id`).
- **Return value:** None
- **Since:** SDK 4.0

---

### LrApplication.developPresetByUuid( uuid )

Retrieves a develop preset from its unique identifier. Does not retrieve presets added using `LrApplication:addDevelopPresetForPlugin`.

- **Parameters:**
  - `uuid` (string) -- The unique identifier, as returned by `LrDevelopPreset:getUuid`.
- **Return value:** (`LrDevelopPreset`) The preset object.
- **Since:** SDK 3.0

---

### LrApplication.developPresetFolders()

Retrieves all defined develop preset folders.

- **Parameters:** None
- **Return value:** (array of `LrDevelopPresetFolder`) The preset folder objects.
- **Since:** SDK 3.0

---

### LrApplication.filenamePresets()

Reports available file-naming presets.

- **Parameters:** None
- **Return value:** (table) A table describing each of the available file-naming presets, or an empty table if no presets exist. Key: the preset name. Value: the UUID or path to the preset's definition.
- **Since:** SDK 3.0

---

### LrApplication.getDevelopPresetsForPlugin( plugin, uuid )

Retrieves a specific develop preset, or all develop presets associated with this plug-in.

- **Parameters:**
  - `plugin` (`_PLUGIN`) -- Your plug-in object.
  - `uuid` (string, optional) -- The unique identifier of a preset. See `LrDevelopPreset:getUuid`.
- **Return value:** (`LrDevelopPreset` or array of `LrDevelopPreset`) The specified preset object, or an array of all associated presets if no unique ID is supplied.
- **Since:** SDK 3.0

---

### LrApplication.macAddressHash()

Retrieves a unique identifier that is keyed to the MAC address of the system running Lightroom. Intended to aid in plug-in registrations for app store builds of Lightroom, where there is no serial number available.

- **Parameters:** None
- **Return value:** (string) The unique ID.
- **Since:** SDK 4.1

---

### LrApplication.metadataPresets()

Reports available metadata presets. The returned table contains the name of each metadata property along with its string ID.

- **Parameters:** None
- **Return value:** (table) A table describing each of the available metadata presets, or an empty table if no presets exist. Key: the preset name. Value: the UUID or path to the preset's definition.
- **Since:** SDK 3.0

---

### LrApplication.purchaseSource()

Returns a string identifying the manner in which the Lightroom instance was obtained. Intended to aid in plug-in registrations for app store builds.

- **Parameters:** None
- **Return value:** (string) `'retail'`, `'MAS'` (Mac App Store), or `'CC'` (Creative Cloud, as of LR 5.6).
- **Since:** SDK 4.1

---

### LrApplication.serialNumberHash()

Retrieves a unique identifier that is keyed to the Lightroom serial number. Can be used to implement plug-in registrations.

- **Parameters:** None
- **Return value:** (string) The unique ID, or `"trial"` if no serial number is installed. Returns empty string for Mac App Store builds (as of LR 4.1) and Creative Cloud builds (as of LR 5.6).
- **Since:** SDK 3.0

---

### LrApplication.versionString()

Retrieves the current version of the application as a user-displayable string (for instance, "2.0").

- **Parameters:** None
- **Return value:** (string) Lightroom version.
- **Since:** SDK 2.0

---

### LrApplication.versionTable()

Retrieves the current version of the application as a table that can be parsed.

- **Parameters:** None
- **Return value:** (table) Lightroom version table containing:
  - `major` (number) -- Major version number.
  - `minor` (number) -- Minor version number.
  - `revision` (number) -- Revision number.
  - `build` (number, deprecated) -- Build number in the form YYYYMMDDHHmm.
  - `build_version` (string) -- Build version as a string (available from 8.3.0).
  - `publicBeta` (number or Boolean, deprecated) -- Public beta number, or false for final release.
- **Since:** SDK 2.0

---

### LrApplication.viewFilterPresets()

Reports available view-filter presets.

- **Parameters:** None
- **Return values:**
  1. (table) A table describing each of the available view-filter presets, or an empty table if none exist. Key: the preset name. Value: the UUID or path to the preset's definition.
  2. (string) If a named filter is currently invoked, the name of that filter.
- **Since:** SDK 3.0

---

## LrDate

**Type:** Namespace

Allows you to create and manipulate date and time values in various formats. Access the functions directly from the imported namespace.

### LrDate.currentTime()

Retrieves the current date and time as a Cocoa date stamp; that is, a number of seconds since midnight UTC on January 1, 2001.

- **Parameters:** None
- **Return value:** (number) The current date and time as a Cocoa date stamp value.
- **Since:** SDK 1.3

---

### LrDate.formatLongDate( time )

Converts a timestamp to the user's preferred long date format. The exact format varies with user preferences and language settings, but is something like "December 31, 2009".

- **Parameters:**
  - `time` (number) -- The Cocoa date stamp (seconds since midnight UTC, January 1, 2001).
- **Return value:** (string) Date in long-date format.
- **Since:** SDK 3.0

---

### LrDate.formatMediumDate( time )

Converts a timestamp to the user's preferred medium date format. Something like "Dec 31, 2009".

- **Parameters:**
  - `time` (number) -- The Cocoa date stamp.
- **Return value:** (string) Date in medium-date format.
- **Since:** SDK 3.0

---

### LrDate.formatMediumTime( time )

Converts a timestamp to the user's preferred medium time format. Something like "9:12:34 PM".

- **Parameters:**
  - `time` (number) -- The Cocoa date stamp.
- **Return value:** (string) Time in medium-time format.
- **Since:** SDK 3.0

---

### LrDate.formatShortDate( time )

Converts a timestamp to the user's preferred short date format. Something like "12/31/09".

- **Parameters:**
  - `time` (number) -- The Cocoa date stamp.
- **Return value:** (string) Date in short-date format.
- **Since:** SDK 3.0

---

### LrDate.formatShortTime( time )

Converts a timestamp to the user's preferred short time format. Something like "9:12 PM".

- **Parameters:**
  - `time` (number) -- The Cocoa date stamp.
- **Return value:** (string) Time in short-time format.
- **Since:** SDK 3.0

---

### LrDate.timeFromComponents( year, month, day, hour, minute, second, timeZone )

Composes a time stamp from the component values.

- **Parameters:**
  - `year` (number) -- The 4-digit year.
  - `month` (number) -- The month, in the range [1..12].
  - `day` (number) -- The day, in the range [1..31].
  - `hour` (number) -- The hour, in the range [0..23].
  - `minute` (number) -- The minute, in the range [0..59].
  - `second` (number) -- The second, in the range [0..59].
  - `timeZone` (number, string, or Boolean) -- The string `"local"` or `true` to use the local time zone, or an explicit time zone expressed as the difference in seconds from UTC. For example, U.S. Pacific Standard Time is -28800. **Warning:** The 1.3 SDK documentation incorrectly stated this was expressed in hours relative to UTC.
- **Return value:** (number) The time as a Cocoa date stamp (seconds since midnight UTC, January 1, 2001).
- **Since:** SDK 1.3

---

### LrDate.timeFromPosixDate( time )

Converts a Unix/Posix-style date timestamp to a Mac-style timestamp.

- **Parameters:**
  - `time` (number) -- The Unix/Posix date stamp (seconds since midnight UTC, January 1, 1970).
- **Return value:** (number) The Cocoa date stamp (seconds since midnight UTC, January 1, 2001).
- **Since:** SDK 3.0

---

### LrDate.timeToIsoDate( time )

Converts a timestamp to an ISO formatted date (not including the time).

- **Parameters:**
  - `time` (number) -- The Cocoa date stamp.
- **Return value:** (string) An ISO formatted date string (such as "2007-10-06").
- **Since:** SDK 1.3

---

### LrDate.timeToPosixDate( time )

Converts a Mac-style timestamp to a Unix/Posix-style date timestamp.

- **Parameters:**
  - `time` (number) -- The Cocoa date stamp.
- **Return value:** (number) The Unix/Posix date stamp (seconds since midnight UTC, January 1, 1970).
- **Since:** SDK 3.0

---

### LrDate.timeToUserFormat( time, format, isGMT )

Converts a timestamp to a specified date-time format. The result is produced with the current user's locale, which cannot be changed. By default the result applies the local timezone.

- **Parameters:**
  - `time` (number) -- The Cocoa date stamp.
  - `format` (string) -- The date-time format string. Special tokens:
    - `%B` -- Full name of month
    - `%b` -- 3-letter name of month
    - `%m` -- 2-digit month number
    - `%d` -- Day number with leading zero
    - `%e` -- Day number without leading zero
    - `%j` -- Julian day of the year with leading zero
    - `%a` -- Day name abbreviation
    - `%A` -- Day name
    - `%y` -- 2-digit year number
    - `%Y` -- 4-digit year number
    - `%H` -- Hour with leading zero (24-hour clock)
    - `%1H` -- Hour without leading zero (24-hour clock)
    - `%I` -- Hour with leading zero (12-hour clock)
    - `%1I` -- Hour without leading zero (12-hour clock)
    - `%M` -- Minute with leading zero
    - `%S` -- Second with leading zero
    - `%p` -- AM/PM designation
    - `%P` -- AM/PM designation (with white space trimming)
    - `%%` -- Literal % symbol
  - `isGMT` (boolean) -- If true, use GMT rather than the local timezone.
- **Return value:** (string) The formatted date-time string.
- **Since:** SDK 1.3

---

### LrDate.timeToW3CDate( time )

Converts a timestamp to a W3C formatted date and time.

- **Parameters:**
  - `time` (number) -- The Cocoa date stamp.
- **Return value:** (string) A W3C formatted date-time string (such as "2007-10-06T12:54:39-07:00").
- **Since:** SDK 1.3

---

### LrDate.timeZone()

Retrieves the current time zone and reports whether that zone is currently observing daylight savings time.

- **Parameters:** None
- **Return values:**
  1. (number) The offset from UTC in seconds. For example, U.S. Pacific Standard Time (PST) is -28800.
  2. (Boolean) True if daylight savings time is in effect.
- **Since:** SDK 2.0

---

### LrDate.timestampToComponents( time, optTimeZone )

Converts a Cocoa date stamp to its components (individual values for year, month, day, and so on).

- **Parameters:**
  - `time` (number) -- The date and time as a Cocoa date stamp value.
  - `optTimeZone` (number, optional) -- An optional time zone bias expressed as seconds relative to UTC (e.g., US Central Standard Time = -21600). Defaults to local time zone if not supplied.
- **Return values:**
  1. (number) year
  2. (number) month (1-12)
  3. (number) day (1-31)
  4. (number) hour (0-23)
  5. (number) minute (0-59)
  6. (number) second (0-59); fractional seconds may be discarded
  7. (number) day of week (1-7, Sunday = 1, Saturday = 7)
- **Since:** SDK 2.0

---

## LrDialogs

**Type:** Namespace

Allows you to invoke and manipulate predefined or custom dialog boxes. Predefined dialogs allow you to display informational text, error messages and prompts to users. You can also define and invoke a custom modal dialog using an LrView hierarchy of UI elements. All dialogs are modal. Access the functions directly from the imported namespace.

### LrDialogs.attachErrorDialogToFunctionContext( context )

Invokes an error dialog if an error results from the execution of a function in a given context.

- **Parameters:**
  - `context` (`LrFunctionContext`) -- The function-context object for the function.
- **Return value:** None
- **Since:** SDK 1.3

---

### LrDialogs.confirm( message, info, actionVerb, cancelVerb, otherVerb )

Invokes a modal dialog for confirmation. Displays a message, with an action button, a cancel button, and optionally one other button.

- **Parameters:**
  - `message` (string) -- The main alert message string, the title of the dialog.
  - `info` (string, optional) -- A secondary message string, shown in a smaller font below the main message. Can be nil.
  - `actionVerb` (string, optional) -- The label string for the action button. Default is "OK".
  - `cancelVerb` (string, optional) -- The label string for the cancel button. Default is "Cancel".
  - `otherVerb` (string, optional) -- A label string for an optional third button. If not supplied, no third button is shown.
- **Return value:** (string) The button used to dismiss the dialog, one of `"ok"`, `"cancel"`, or `"other"`.
- **Since:** SDK 1.3

---

### LrDialogs.message( message, info, style )

Invokes a modal dialog to display a message, with a single "OK" button that dismisses the dialog.

- **Parameters:**
  - `message` (string) -- The main message to display.
  - `info` (string, optional) -- A secondary message to display, shown in a smaller font below the main message. Can be nil.
  - `style` (string, optional) -- The visual style of the dialog, one of: `"warning"` (the default), `"info"`, or `"critical"`. In Mac OS, this affects the style of the icon.
- **Return value:** None
- **Since:** SDK 1.3

---

### LrDialogs.messageWithDoNotShow( args )

Invokes a message dialog that prompts for an action, and includes a "Do not show" checkbox. If the user has seen this dialog before and selected "Do not show," returns without showing the dialog.

- **Parameters:**
  - `args` (table) -- A table with these fields:
    - `message` (string) -- The main message.
    - `info` (string, optional) -- A secondary message shown in smaller text.
    - `actionPrefKey` (string) -- A key in which the chosen action is stored if do-not-show is checked. This key is added to your plug-in's list of settings.
- **Return value:** None
- **Since:** SDK 1.3

---

### LrDialogs.presentFloatingDialog( plugin, args )

Invokes a custom dialog box as a floating dialog. The contents are defined by an `LrView` hierarchy of containers and controls.

- **Parameters:**
  - `plugin` (`_PLUGIN`) -- Your plug-in object.
  - `args` (table) -- A table with these fields:
    - `title` (string) -- The title of the dialog.
    - `contents` (`LrView`) -- The topmost container of an LrView hierarchy.
    - `blockTask` (Boolean, optional) -- True to make the call blocking. If true, the call must be enclosed in an asynchronous task. Default is false.
    - `save_frame` (string, optional) -- A unique key to automatically save the position of the dialog.
    - `onShow` (function, optional) -- Called when the dialog first appears. Receives a table with `toFront` and `close` functions.
    - `windowWillClose` (function, optional) -- Called when the floating dialog is about to close.
    - `selectionChangeObserver` (function, optional) -- Called when selected photos/videos change.
    - `sourceChangeObserver` (function, optional) -- Called when active source(s) change.
- **Return value:** None
- **Since:** SDK 5.0

---

### LrDialogs.presentModalDialog( args )

Invokes a custom dialog box as a modal dialog. The contents are defined by an `LrView` hierarchy. The bottom shows OK and Cancel buttons, and optionally a third button or custom accessory view.

- **Parameters:**
  - `args` (table) -- A table with these fields:
    - `title` (string) -- The title of the dialog.
    - `resizable` (Boolean or string) -- `"vertically"` or `"horizontally"` for one direction, `true` for both, `false` to prevent resizing.
    - `contents` (`LrView`) -- The topmost container of an LrView hierarchy.
    - `accessoryView` (`LrView`, optional) -- Alternative selection mechanism in place of the third button. Mutually exclusive with `otherVerb`.
    - `actionVerb` (string, optional) -- The localizable label of the action button; default `"OK"`.
    - `actionBinding` (table, optional) -- Binding(s) applicable to the action button. Example: `actionBinding = { enabled = { bind_to_object = props, key = 'actionEnabled' } }`.
    - `cancelVerb` (string, optional) -- The localizable label of the cancel button; default `"Cancel"`. Use `"< exclude >"` to hide the cancel button.
    - `otherVerb` (string, optional) -- Label for a third button. Return value: `"other"`. Mutually exclusive with `accessoryView`.
    - `save_frame` (string, optional) -- A unique key to automatically save the position of the dialog.
- **Return value:** (string) The unique return value of the button used to dismiss the dialog (`"ok"`, `"cancel"`, or `"other"`).
- **Since:** SDK 1.3

---

### LrDialogs.promptForActionWithDoNotShow( args )

Invokes a dialog that prompts for an action, and includes a "Do not show" checkbox. If the user has previously selected "Do not show," returns the previously selected action without showing the dialog.

- **Parameters:**
  - `args` (table) -- A table with these fields:
    - `message` (string) -- The main message.
    - `info` (string, optional) -- A secondary message shown in smaller text.
    - `actionPrefKey` (string) -- A key in which the chosen action is stored.
    - `verbBtns` (table) -- An array of action buttons. Each entry is a table with:
      - `label` (string) -- A localizable label for the button.
      - `verb` (string) -- A unique identifier for the action.
- **Return value:** (string) The selected action identifier, or nil if the user cancels.
- **Since:** SDK 1.3

---

### LrDialogs.resetDoNotShowFlag( actionPrefKey )

Resets one or both "Do not show" flags, as previously set by calls to `messageWithDoNotShow()` or `promptForActionWithDoNotShow()`.

- **Parameters:**
  - `actionPrefKey` (string, optional) -- Name of the key supplied to the do-not-show method call. If supplied, that specific dialog is reset. If nil, all keys for this plug-in are reset.
- **Return value:** None
- **Since:** SDK 3.0

---

### LrDialogs.runOpenPanel( args )

Invokes the platform Open File dialog.

- **Parameters:**
  - `args` (table) -- A table with these fields:
    - `title` (string) -- The title of the dialog.
    - `prompt` (string) -- The label of the default button (replaces "Open").
    - `canChooseFiles` (Boolean) -- True to allow files to be selected.
    - `canChooseDirectories` (Boolean) -- True to allow directories to be selected.
    - `canCreateDirectories` (Boolean) -- True to include a button to create directories.
    - `allowsMultipleSelection` (Boolean) -- True to allow multiple files to be selected.
    - `fileTypes` (string or table) -- The file types that can be selected.
    - `accessoryView` (`LrView`) -- A custom view to be included in the dialog.
    - `initialDirectory` (string, optional) -- Path to directory that should be initially opened.
- **Return value:** (table) An array of path names, or nil if the dialog was cancelled.
- **Since:** SDK 1.3

---

### LrDialogs.runSavePanel( args )

Invokes the platform Save File dialog.

- **Parameters:**
  - `args` (table) -- A table with these fields:
    - `title` (string) -- The title of the dialog.
    - `prompt` (string) -- The label of the default button (replaces "Save").
    - `requiredFileType` (string) -- The file extension of the file to be saved.
    - `canCreateDirectories` (Boolean) -- True to include a button to create directories.
    - `accessoryView` (`LrView`) -- A custom view to be included in the dialog.
- **Return value:** (string) The path of the file that was saved, or nil if the dialog was cancelled.
- **Since:** SDK 1.3

---

### LrDialogs.showBezel( message, fadeDelay )

Shows a message in a window that quickly fades away. Only one bezel is visible at any given time; the latest call overrides any existing bezel.

- **Parameters:**
  - `message` (string) -- The message to display.
  - `fadeDelay` (number, optional) -- The number of seconds to show the message. Default is 1.2 seconds.
- **Return value:** None
- **Since:** SDK 5.0

---

### LrDialogs.showError( errorString )

Invokes a modal dialog that displays an error message.

- **Parameters:**
  - `errorString` (string) -- The error string to display. If this string is a valid error string (i.e., from LrErrors) then that error will be displayed. If not, a generic error message is displayed and the string is used as secondary information.
- **Return value:** None
- **Since:** SDK 1.3

---

### LrDialogs.showModalProgressDialog( params )

Shows a modal progress dialog. This dialog remains visible (and blocks all other LR UI elements) until the progress scope is marked completed or canceled.

- **Parameters:**
  - `params` (table) -- A table with these fields:
    - `title` (string) -- Title of the dialog, representing the entire task. Cannot be changed once operation begins.
    - `caption` (string, optional) -- Subtitle, representing a subtask. Can be changed while operation is in progress.
    - `width` (number, optional) -- Width of the progress bar, in pixels.
    - `cannotCancel` (Boolean, optional) -- If true, the cancel button is dimmed.
    - `functionContext` (`LrFunctionContext`) -- A function context to attach to this progress dialog. The dialog terminates when the function scope completes.
- **Return value:** (`LrProgressScope`) A progress scope object. Use this object to signal the portion complete.
- **Since:** SDK 2.0

---

### LrDialogs.stopModalWithResult( dialog, result )

Dismisses a modal dialog that is currently displayed. Can be used to simulate the user clicking a button.

- **Parameters:**
  - `dialog` (`LrView`) -- The dialog to dismiss, or any element of that dialog.
  - `result` (string) -- The value to return from the invocation function; typically one of `"ok"`, `"cancel"`, or `"other"`.
- **Return value:** None
- **Since:** SDK 1.3

---

## LrFileUtils

**Type:** Namespace

Allows you to manipulate files and directories on the file system in a platform-independent manner. Path syntax is platform-specific. If possible, use these functions only within an asynchronous task started by LrTasks. (As of Lightroom 2.0, it is permitted to use these functions in other contexts.) Access the functions directly from the imported namespace.

### LrFileUtils.chooseUniqueFileName( path )

Creates a path string that (if written to) would not overwrite any existing file. If the given path does not refer to an existing file, it is returned unchanged. Otherwise, the last component is altered (e.g., `"/MyDir/MyFile.jpg"` might become `"/MyDir/MyFile-2.jpg"`).

- **Parameters:**
  - `path` (string) -- The initial path.
- **Return value:** (string) The unique path name derived from the given path.
- **Since:** SDK 1.3

---

### LrFileUtils.copy( srcPath, destPath )

Copies a file from one location to another. The parent directory at the destination must already exist. Fails if a file with the same name already exists at the destination.

- **Parameters:**
  - `srcPath` (string) -- The path to the existing source file.
  - `destPath` (string) -- The path to a location for the copy.
- **Return value:** (Boolean) True on success. On failure, can return a second parameter indicating the reason.
- **Since:** SDK 1.3

---

### LrFileUtils.createAllDirectories( path )

Creates a directory at a given path, recursively creating any parent directories that do not already exist.

- **Parameters:**
  - `path` (string) -- The path of the new directory.
- **Return value:** (Boolean) True if any parent directory was created; false if all parents already existed.
- **Since:** SDK 1.3

---

### LrFileUtils.createDirectory( path )

Creates a directory at a given path. The parent directory must already exist.

- **Parameters:**
  - `path` (string) -- The path of the new directory.
- **Return value:** None
- **Since:** SDK 1.3

---

### LrFileUtils.delete( path )

Immediately deletes the file or directory at a given path. If the path refers to a directory, all of the contents are deleted. Use with care; in most cases, `moveToTrash()` is preferred.

- **Parameters:**
  - `path` (string) -- The path.
- **Return value:** (Boolean) True on success. On failure, can return a second parameter indicating the reason.
- **Since:** SDK 1.3

---

### LrFileUtils.directoryEntries( pathToFolder )

Iterates through the files and folders that are immediate children of the folder. Use in a for loop:

```lua
for filePath in LrFileUtils.directoryEntries( pathToFolder ) do ... end
```

Includes folders but does not recurse into them. A file handle remains open until the loop completes normally. Do not use `break` to exit this for loop.

- **Parameters:**
  - `pathToFolder` (string) -- The folder to examine.
- **Return value:** Iterator function.
- **Since:** SDK 2.0

---

### LrFileUtils.exists( path )

Reports whether a given path indicates an existing file or directory.

- **Parameters:**
  - `path` (string) -- The path.
- **Return value:** (string or Boolean) The string `'file'` or `'directory'` if the path corresponds to an existing entity on disk, `false` if not.
- **Since:** SDK 1.3

---

### LrFileUtils.fileAttributes( path )

Retrieves the file attributes for the file or directory at a given path.

- **Parameters:**
  - `path` (string) -- The path.
- **Return value:** (table) A set of file attributes, or an empty table if the file does not exist. Attributes include:
  - `fileSize` -- File size in bytes.
  - `fileCreationDate` -- The creation date (seconds since midnight GMT, January 1, 2001).
  - `fileModificationDate` -- The modification date (seconds since midnight GMT, January 1, 2001).
- **Since:** SDK 1.3

---

### LrFileUtils.files( pathToFolder )

Iterates through the files that are immediate children of the folder. Skips any folders inside this folder. Use in a for loop:

```lua
for filePath in LrFileUtils.files( pathToFolder ) do ... end
```

Do not use `break` to exit this for loop.

- **Parameters:**
  - `pathToFolder` (string) -- The folder to examine.
- **Return value:** Iterator function.
- **Since:** SDK 2.0

---

### LrFileUtils.hasNoVisibleFiles( path )

Reports whether a given path refers to a directory that contains no visible files. The definition of "visible" differs between Mac OS and Windows.

- **Parameters:**
  - `path` (string) -- The directory path.
- **Return value:** (Boolean) True if the directory contains no visible files; false otherwise.
- **Since:** SDK 1.3

---

### LrFileUtils.isDeletable( path )

Reports whether a file or directory can be deleted.

- **Parameters:**
  - `path` (string) -- The path.
- **Return value:** (Boolean) True if there is a file that can be deleted at this path; false if not.
- **Since:** SDK 1.3

---

### LrFileUtils.isEmptyDirectory( path )

Reports whether a given path refers to a directory that contains no files.

- **Parameters:**
  - `path` (string) -- The directory path.
- **Return value:** (Boolean) True if the directory contains no files; false otherwise.
- **Since:** SDK 1.3

---

### LrFileUtils.isReadable( path )

Reports whether a path indicates a readable disk file.

- **Parameters:**
  - `path` (string) -- The path.
- **Return value:** (Boolean) True if there is a file that can be read at this path; false if not.
- **Since:** SDK 1.3

---

### LrFileUtils.isWritable( path )

Reports whether a path indicates a writable disk file.

- **Parameters:**
  - `path` (string) -- The path.
- **Return value:** (Boolean) True if there is a file that can be written to at this path; false if not.
- **Since:** SDK 1.3

---

### LrFileUtils.makeFileWritable( path )

Makes a file writeable, if possible.

- **Parameters:**
  - `path` (string) -- The path.
- **Return value:** (Boolean) True if the file is writeable after the call, false if not.
- **Since:** SDK 1.3

---

### LrFileUtils.move( srcPath, destPath )

Moves a file from one location to another. The parent directory at the destination must already exist. Fails if a file with the same name already exists at the destination.

- **Parameters:**
  - `srcPath` (string) -- The path to the existing source file.
  - `destPath` (string) -- The path to a new location for the file.
- **Return value:** (Boolean) True on success. On failure, can return a second parameter indicating the reason.
- **Since:** SDK 1.3

---

### LrFileUtils.moveToTrash( path )

Moves a file or directory to the system trash or recycle bin.

- **Parameters:**
  - `path` (string) -- The path.
- **Return value:** (Boolean) True on success. If false, the function returns a second parameter indicating the reason.
- **Since:** SDK 1.3

---

### LrFileUtils.pathsAreOnSameVolume( path1, path2 )

Reports whether two paths are on the same volume (meaning you could move from one path to the other without copying).

- **Parameters:**
  - `path1` (string) -- The first path.
  - `path2` (string) -- The second path.
- **Return value:** (Boolean) True if the two paths are on the same volume, false otherwise.
- **Since:** SDK 1.3

---

### LrFileUtils.readFile( path )

Reads the contents of a file into memory. Use this in preference to the built-in Lua `io` namespace if the path might contain non-ASCII characters.

- **Parameters:**
  - `path` (string) -- The file to read.
- **Return value:** (string) The contents of the file.
- **Since:** SDK 2.2

---

### LrFileUtils.recursiveDirectoryEntries( pathToFolder )

Iterates through all files and folders that are anywhere inside the folder (recursive). Use in a for loop:

```lua
for filePath in LrFileUtils.recursiveDirectoryEntries( pathToFolder ) do ... end
```

Do not use `break` to exit this for loop.

- **Parameters:**
  - `pathToFolder` (string) -- The folder to examine.
- **Return value:** Iterator function.
- **Since:** SDK 2.0

---

### LrFileUtils.recursiveFiles( pathToFolder )

Iterates through all files that are anywhere inside the folder (recursive). Looks inside all sub-folders but does not return folder entries themselves.

```lua
for filePath in LrFileUtils.recursiveFiles( pathToFolder ) do ... end
```

Do not use `break` to exit this for loop.

- **Parameters:**
  - `pathToFolder` (string) -- The folder to examine.
- **Return value:** Iterator function.
- **Since:** SDK 2.0

---

### LrFileUtils.resolveAlias( path )

Resolves an alias (Mac OS) or shortcut (Windows).

- **Parameters:**
  - `path` (string) -- Path to examine.
- **Return value:** (string) If the path points to an alias or shortcut, returns the path pointed to. Otherwise, returns the path unchanged.
- **Since:** SDK 1.3

---

### LrFileUtils.resolveAllAliases( path )

Resolves all aliases and shortcuts in this path and returns the resulting path (the actual file location). Resolves aliases at any location in the path string. Can be time consuming.

- **Parameters:**
  - `path` (string) -- The path.
- **Return value:** (string) The fully resolved path.
- **Since:** SDK 1.3

---

### LrFileUtils.volumeAttributes( path )

Retrieves information about the disk volume containing a given path.

- **Parameters:**
  - `path` (string) -- The path.
- **Return value:** (table) A table containing:
  - `fileSystemSize` -- The total number of bytes on the disk.
  - `fileSystemFreeSize` -- The number of available bytes on the disk.
- **Since:** SDK 1.3

---

## LrFunctionContext

**Type:** Namespace and Class

Helps you clean up resources following the execution of a function. You can register any number of cleanup handlers to respond to the success or failure of a function. You must create property tables within a function context, so that Lightroom can remove notifications when the table is no longer needed.

Access the calling functions (e.g., `callWithContext()`) directly from the imported namespace. You do not create instances of `LrFunctionContext` directly. They are created by the calling functions and exist only for the lifetime of the function call or task. A `functionContext` object is passed as the first parameter of the call.

### LrFunctionContext.callWithContext( name, func, ... )

Calls the main function, then calls all of the cleanup handlers before returning control. If called from within an asynchronous task, uses `LrTasks.pcall()` to make a yield-safe call. If an error is thrown, it is rethrown after the cleanup handlers are called.

- **Parameters:**
  - `name` (string) -- A name for this context (used only for debugging).
  - `func` (function) -- The main function to call.
  - `...` -- Other parameters passed directly to the main function. The function-context instance is inserted in front of these parameters.
- **Return value:** (any) The call results; whatever is returned from the main function.
- **Since:** SDK 1.3

---

### LrFunctionContext.callWithContext_noyield( name, func, ... )

Same as `callWithContext`, but calls the function in a fashion that disables `LrTasks.yield` from working. Use if you need to ensure that the called function is completed as an atomic unit.

- **Parameters:**
  - `name` (string) -- A name for this context (debugging only).
  - `func` (function) -- The main function to call.
  - `...` -- Other parameters passed directly to the main function.
- **Return value:** (any) The call results.
- **Since:** SDK 2.0

---

### LrFunctionContext.callWithEmptyEnvironment( func, ... )

Runs the main function in a known-safe function environment. Equivalent to `setfenv( func, {} ); return func( ... )`. The function is subjected to `string.dump` for safety; variables from the calling scope (including imported namespaces) do not carry through.

- **Parameters:**
  - `func` (function) -- The main function to call, with an empty environment.
  - `...` (any) -- Further arguments passed through to the function.
- **Return value:** (any) The call results.
- **Since:** SDK 3.0

---

### LrFunctionContext.callWithEnvironment( func, env, ... )

Runs the main function in a caller-provided function environment. Equivalent to `setfenv( func, env ); return func( ... )`. The function is subjected to `string.dump` for safety.

- **Parameters:**
  - `func` (function) -- The main function to call.
  - `env` (table) -- The function environment to use.
  - `...` (any) -- Further arguments passed through to the function.
- **Return value:** (any) The call results.
- **Since:** SDK 3.0

---

### LrFunctionContext.pcallWithContext( name, func, ... )

Makes a protected call, like Lua's standard `pcall`, but calls all of the cleanup handlers before returning control. If called within an asynchronous task, uses `LrTasks.pcall()`. Cleanup handlers are deferred until the coroutine runs to completion or failure (not called when yielding).

- **Parameters:**
  - `name` (string) -- A name for this context (debugging only).
  - `func` (function) -- The main function to call.
  - `...` -- Other parameters passed directly to the main function.
- **Return value:** (any) The pcall results; a success/failure value followed by any other return values.
- **Since:** SDK 1.3

---

### LrFunctionContext.pcallWithContext_noyield( name, func, ... )

Same as `pcallWithContext`, but disables `LrTasks.yield`. Use to ensure the called function is completed atomically.

- **Parameters:**
  - `name` (string) -- A name for this context (debugging only).
  - `func` (function) -- The main function to call.
  - `...` -- Other parameters passed directly to the main function.
- **Return value:** (any) The pcall results.
- **Since:** SDK 2.0

---

### LrFunctionContext.pcallWithEmptyEnvironment( func, ... )

Runs the main function in a known-safe function environment, catching any exceptions. Equivalent to `setfenv( func, {} ); return pcall( func, ... )`.

- **Parameters:**
  - `func` (function) -- The main function to call, with an empty environment.
  - `...` (any) -- Further arguments passed through to the function.
- **Return values:**
  1. (Boolean) True if the call succeeded, false if an error occurred.
  2. (any) The call results.
- **Since:** SDK 3.0

---

### LrFunctionContext.pcallWithEnvironment( func, env, ... )

Runs the main function in a caller-provided function environment, catching any exceptions. Equivalent to `setfenv( func, env ); return pcall( func, ... )`.

- **Parameters:**
  - `func` (function) -- The main function to call.
  - `env` (table) -- The function environment to use.
  - `...` (any) -- Further arguments passed through to the function.
- **Return values:**
  1. (Boolean) True if the call succeeded, false if an error occurred.
  2. (any) The call results.
- **Since:** SDK 3.0

---

### LrFunctionContext.postAsyncTaskWithContext( name, func )

Runs the main function in an asynchronous/cooperative task, then calls any cleanup handlers.

- **Parameters:**
  - `name` (string) -- A name for this context (debugging only).
  - `func` (function) -- The main function to run asynchronously. Receives the `LrFunctionContext` object as its one and only parameter.
- **Return value:** None
- **Since:** SDK 1.3

---

### functionContext:addCleanupHandler( func )

Registers a cleanup handler in an instance. This function is called when the main function finishes or throws an error. Cleanup handlers are called in reverse order of registration (last registered is called first).

- **Parameters:**
  - `func` (function) -- The function to call upon completion of the main function. Parameters are the results from `pcall()`: a success/failure value, followed by other results or the failure message.
- **Return value:** None
- **Since:** SDK 1.3

---

### functionContext:addFailureHandler( func )

Registers a failure handler in an instance. This function is called only if the main function fails (throws an error). This is a convenience function that wraps your function so it is only called on failure.

- **Parameters:**
  - `func` (function) -- The function to call if the main function fails. Parameters are the results from `pcall()`: `false` (failure) followed by the failure message.
- **Return value:** None
- **Since:** SDK 1.3

---

### functionContext:addOperationTitleForError( title )

Attaches a string to this function context to be shown in any error dialog triggered by `LrDialogs.attachErrorDialogToFunctionContext`. This string acts as a title to the actual error message. Use the form "Unable to perform operation."

- **Parameters:**
  - `title` (string) -- The descriptive string to be shown on error.
- **Return value:** None
- **Since:** SDK 3.0

---

## LrHttp

**Type:** Namespace

Allows you to send and receive data using HTTP. The functions can only be called within an asynchronous task (the implicit task that Lightroom starts for your `processRenderedPhotos` function, or one started using LrTasks).

In the event of network error, all LrHttp GET and POST methods return nil plus an info object. The info object is the headers (if any data were received). It also contains an `"error"` entry which is a table with keys:
- `errorCode` (string) -- One of: `"cancelled"`, `"badURL"`, `"timedOut"`, `"cannotFindHost"`, `"cannotConnectToHost"`, `"resourceUnavailable"`, `"networkConnectionLost"`, `"redirectError"`, `"badServerResponse"`, `"authenticationError"`, `"securityError"`, `"serverCertificateHasBadDate"`, `"serverCertificateHasUnknownRoot"`.
- `name` (string) -- Localized description of the error.
- `nativeCode` -- Error code from the operating system.

The info object may also contain `"partial_data"` for any data returned before the error occurred.

### LrHttp.get( url, headers, timeout )

Retrieves data over the network using HTTP or HTTPS GET.

- **Parameters:**
  - `url` (string) -- The URL to get.
  - `headers` (table, optional) -- A table of tables, one for each header. Each header table has a `field` and a `value` entry. Unless you specify a `Content-Type` header, Lightroom will add one with value `'text/plain'`. To force omission, specify `Content-Type` with value `'skip'`.
  - `timeout` (number) -- Seconds to wait during each phase of the connection before canceling. Ignored by LR 1.3 and 1.4.
- **Return values:**
  1. (string) The body of the HTTP response.
  2. (table) Response headers. Each header table has a `field` and `value` entry. The table contains the key `"status"` whose value is the HTTP status (integer). Cookies are stored in `Set-Cookie` headers.
- **Since:** SDK 1.3

---

### LrHttp.openUrlInBrowser( url )

Opens a URL in the user's preferred web browser.

- **Parameters:**
  - `url` (string) -- The URL to open.
- **Return value:** None
- **Since:** SDK 1.3

---

### LrHttp.parseCookie( cookie, decodeUrlEncoding )

Converts a received "Set-Cookie" field into a Lua table. Each field is a separate table key, with the field's value as the table value. For fields without an explicit value (such as `secure`), the value is set to `true`.

- **Parameters:**
  - `cookie` (string) -- The received cookie value from a `Set-Cookie` HTTP header.
  - `decodeUrlEncoding` (Boolean, optional) -- True to decode URL-encoded content. Default is true.
- **Return value:** (table) The parsed cookie fields.
- **Since:** SDK 1.3

---

### LrHttp.post( url, postBody, headers, method, timeout, totalSize )

Sends or retrieves data using HTTP or HTTPS POST. Limited to a single chunk of post data. Must be called from within `LrFunctionContext.postAsyncTaskWithContext()`.

- **Parameters:**
  - `url` (string) -- The URL to post to.
  - `postBody` (string or function) -- The data to send. As of LR 4.1, may also be a callback function to provide data chunks. Return nil when all data has been provided.
  - `headers` (table, optional) -- A table of tables, one for each header. Each has `field` and `value`. Unless you specify `Content-Type`, LR adds `'text/plain'`. Use `'skip'` to omit.
  - `method` (string, optional) -- The HTTP method to use. Default is `"POST"`.
  - `timeout` (number) -- Seconds to wait per phase. Ignored by LR 1.3 and 1.4.
  - `totalSize` (number) -- Total size of the post body when `postBody` is a function (LR 4.1+).
- **Return values:**
  1. (string) The body of the HTTP response.
  2. (table) Response headers (same format as `get`).
- **Since:** SDK 1.3

---

### LrHttp.postMultipart( url, content, headers, timeout, callbackFn, suppressFormData )

Sends or retrieves MIME-Multipart data using HTTP or HTTPS POST. Assumes content consists of `form-data` and inserts a `Content-Disposition` header into each MIME part (behavior can be suppressed as of LR 5.0).

- **Parameters:**
  - `url` (string) -- The URL to post to.
  - `content` (table) -- An array of content chunks. Each entry should contain:
    - `name` (string, optional) -- The name of the multipart chunk.
    - `fileName` (string, optional) -- The name of a file to pass in the MIME header.
    - `filePath` (string, optional) -- The path to the file.
    - `value` (string or function, optional) -- The data for the chunk. As of LR 4.0, may be a callback function. If using a function, the content table may only contain one entry. Return nil when done. Required if no file is specified.
    - `totalSize` (number, optional) -- Required if `value` is a function (LR 4.0+). Total size of data from the provider function.
    - `contentType` (string, optional) -- The content MIME type.
  - `headers` (table, optional) -- Response headers. A `Content-Length` header is added automatically if not specified.
  - `timeout` (number) -- Seconds to wait per phase. Ignored by LR 1.3 and 1.4.
  - `callbackFn` (function, optional) -- Called with a number between 0 and 1 indicating upload progress percentage.
  - `suppressFormData` (Boolean, optional) -- If true, `Content-Disposition` header is not added to each MIME chunk.
- **Return values:**
  1. (string) The body of the HTTP response.
  2. (table) Response headers (same format as `get`).
- **Since:** SDK 1.3

---

## LrLogger

**Type:** Class and Namespace

Provides a mechanism for writing debug output that can be viewed with an external log viewer application (such as Console on Mac OS, DebugView or WinDBG on Windows).

Use the imported namespace as a constructor; access the functions through the created objects.

Configure loggers using the `config.lua` file:
- Create an entry for each logger: `loggers.<loggerName> = {...}`
- Arguments include `logLevel` as a string: `"fatal"`, `"error"`, `"warn"`, `"info"`, `"debug"`, or `"trace"`.
- For each valid log level, add an entry to modify behavior (e.g., `trace = 'logfile'`).
- Use `action = 'logfile'` for all log levels.

### LrLogger( name )

Creates a new logger or finds and returns an existing one. Loggers are silent until configured with `logger:enable()`.

- **Parameters:**
  - `name` (string, optional) -- A name for this logger.
- **Return value:** (`LrLogger`) An `LrLogger` object.
  - If `name` matches an existing logger, returns that object.
  - If `name` does not match, returns a new named object.
  - If `name` is nil, returns an application-wide "default" object.
- **Since:** SDK 1.3

---

### logger:enable( actions )

Enables specific log output from this logger.

- **Parameters:**
  - `actions` (string, function, or table) -- What action to take for each log action type. For each action type, this must be either a function that takes a string (the log message), or one of:
    - `"print"` -- Print to console log.
    - `"traceback"` -- Print to console log with stack traceback.
    - `"logfile"` -- Print to a log file named for the logger (written to `~/Documents` on Mac OS, `My Documents` on Windows).
  - As a shortcut, pass a single string or function to apply to all output.
- **Return value:** None
- **Since:** SDK 1.3

---

### logger:disable()

Disables all log output from this logger. Equivalent to `logger:enable( false )`.

- **Parameters:** None
- **Return value:** None
- **Since:** SDK 1.3

---

### logger:trace( ... )

Feeds log output through the action function defined for 'trace' messages.

- **Parameters:**
  - `...` -- Data to be printed, of any type; `tostring()` is called on all values.
- **Return value:** None
- **Since:** SDK 1.3

---

### logger:tracef( format, ... )

Feeds log output through the action function defined for 'trace' messages, using `string.format` to prepare the output.

- **Parameters:**
  - `format` (string) -- Formatting instructions (see Lua's `string.format`).
  - `...` -- Arguments required by the format string.
- **Return value:** None
- **Since:** SDK 2.0

---

### logger:debug( ... )

Feeds log output through the action function defined for 'debug' messages.

- **Parameters:**
  - `...` -- Data to be printed, of any type; `tostring()` is called on all values.
- **Return value:** None
- **Since:** SDK 1.3

---

### logger:debugf( format, ... )

Feeds log output through the action function defined for 'debug' messages, using `string.format`.

- **Parameters:**
  - `format` (string) -- Formatting instructions.
  - `...` -- Arguments required by the format string.
- **Return value:** None
- **Since:** SDK 2.0

---

### logger:info( ... )

Feeds log output through the action function defined for 'info' messages.

- **Parameters:**
  - `...` -- Data to be printed, of any type; `tostring()` is called on all values.
- **Return value:** None
- **Since:** SDK 1.3

---

### logger:infof( format, ... )

Feeds log output through the action function defined for 'info' messages, using `string.format`.

- **Parameters:**
  - `format` (string) -- Formatting instructions.
  - `...` -- Arguments required by the format string.
- **Return value:** None
- **Since:** SDK 2.0

---

### logger:warn( ... )

Feeds log output through the action function defined for 'warn' messages.

- **Parameters:**
  - `...` -- Data to be printed, of any type; `tostring()` is called on all values.
- **Return value:** None
- **Since:** SDK 1.3

---

### logger:warnf( format, ... )

Feeds log output through the action function defined for 'warn' messages, using `string.format`.

- **Parameters:**
  - `format` (string) -- Formatting instructions.
  - `...` -- Arguments required by the format string.
- **Return value:** None
- **Since:** SDK 2.0

---

### logger:error( ... )

Feeds log output through the action function defined for 'error' messages.

- **Parameters:**
  - `...` -- Data to be printed, of any type; `tostring()` is called on all values.
- **Return value:** None
- **Since:** SDK 1.3

---

### logger:errorf( format, ... )

Feeds log output through the action function defined for 'error' messages, using `string.format`.

- **Parameters:**
  - `format` (string) -- Formatting instructions.
  - `...` -- Arguments required by the format string.
- **Return value:** None
- **Since:** SDK 2.0

---

### logger:fatal( ... )

Feeds log output through the action function defined for 'fatal' messages.

- **Parameters:**
  - `...` -- Data to be printed, of any type; `tostring()` is called on all values.
- **Return value:** None
- **Since:** SDK 1.3

---

### logger:fatalf( format, ... )

Feeds log output through the action function defined for 'fatal' messages, using `string.format`.

- **Parameters:**
  - `format` (string) -- Formatting instructions.
  - `...` -- Arguments required by the format string.
- **Return value:** None
- **Since:** SDK 2.0

---

### logger:quick( ... )

Creates optimized versions of specified log functions for use in tight loops. Avoids method lookup overhead and becomes a no-op when logging is disabled.

```lua
local warn, info = logger:quick( 'warn', 'info' )
warn( 'something bad happened' )
```

- **Parameters:**
  - `...` (one or more strings) -- The names of log functions to optimize.
- **Return value:** (one or more functions) The optimized functions.
- **Since:** SDK 1.3

---

### logger:quickf( ... )

Creates optimized versions of specified log functions for use in tight loops. Unlike `logger:quick`, these functions take `string.format` instructions.

```lua
local warnf, infof = logger:quickf( 'warn', 'info' )
warnf( 'something %s happened', 'bad' )
```

- **Parameters:**
  - `...` (one or more strings) -- The names of log functions to optimize.
- **Return value:** (one or more functions) The optimized functions.
- **Since:** SDK 2.0

---

### logger:type()

Reports the type of this object.

- **Parameters:** None
- **Return value:** (string) `'LrLogger'`.
- **Since:** SDK 4.1

---

## LrPathUtils

**Type:** Namespace

Allows you to manipulate file-system path strings in a platform-appropriate way. All paths are specified in platform-specific syntax. Access the functions directly from the imported namespace.

### LrPathUtils.addExtension( path, extension )

Adds a new filename extension to a path. Appends the new extension after any existing extension.

- **Parameters:**
  - `path` (string) -- The path.
  - `extension` (string) -- The new extension to append.
- **Return value:** (string) The path with the new extension appended.
- **Since:** SDK 1.3

---

### LrPathUtils.child( path, child )

Combines path elements into a single path.

- **Parameters:**
  - `path` (string) -- The base path (e.g., `'C:\MyDir\'`).
  - `child` (string) -- A child directory or filename to append (e.g., `'MyFile'`).
- **Return value:** (string) The combined path (e.g., `'C:\MyDir\MyFile'`).
- **Since:** SDK 1.3

---

### LrPathUtils.extension( path )

Retrieves the filename extension (if any) from the path.

- **Parameters:**
  - `path` (string) -- The path.
- **Return value:** (string) The extension, or an empty string if there is no extension.
- **Since:** SDK 1.3

---

### LrPathUtils.getStandardFilePath( which )

Retrieves the path to a standard directory, as defined for the platform.

Note: the `"appPrefs"` selector returns the root of Lightroom's application preferences folder, not the overall user preferences folder tree.

- **Parameters:**
  - `which` (string) -- The desired path. One of: `'home'`, `'temp'`, `'desktop'`, `'appPrefs'`, `'pictures'`, `'documents'`, `'appData'`.
- **Return value:** (string) The full path to the specified standard directory.
- **Since:** SDK 1.3

---

### LrPathUtils.isAbsolute( path )

Reports whether a path is absolute or relative. Converse of `LrPathUtils.isRelative()`.

- **Parameters:**
  - `path` (string) -- The path.
- **Return value:** (Boolean) True if it is an absolute path, false if relative.
- **Since:** SDK 1.3

---

### LrPathUtils.isRelative( path )

Reports whether a path is absolute or relative. Converse of `LrPathUtils.isAbsolute()`.

- **Parameters:**
  - `path` (string) -- The path.
- **Return value:** (Boolean) True if it is a relative path, false if absolute.
- **Since:** SDK 1.3

---

### LrPathUtils.leafName( path )

Retrieves the leaf name from a path.

- **Parameters:**
  - `path` (string) -- The path.
- **Return value:** (string) The final path component.
- **Since:** SDK 1.3

---

### LrPathUtils.makeAbsolute( path, base )

Converts a relative path to an absolute path if possible.

- **Parameters:**
  - `path` (string) -- The relative path.
  - `base` (string) -- The base path. Must be supplied and must be an absolute path.
- **Return value:** (string) The absolute path, or a path relative to the new base location.
- **Since:** SDK 1.3

---

### LrPathUtils.makeRelative( path, base )

Converts an absolute path to a relative path if possible.

- **Parameters:**
  - `path` (string) -- The path.
  - `base` (string) -- The base location, from which to make the path relative.
- **Return value:** (string) The path, modified to be relative to the new base location.
- **Since:** SDK 1.3

---

### LrPathUtils.maxPathLength()

Reports the maximum permissible path length for the current platform.

- **Parameters:** None
- **Return value:** (number) The maximum path length in characters.
- **Since:** SDK 1.3

---

### LrPathUtils.parent( path )

Retrieves the parent directory of a path.

Note: As of LR 2.0, calling this on a file system root (`"/"` on Mac or `"C:\\"` on Windows) returns nil on both platforms.

- **Parameters:**
  - `path` (string) -- The file path.
- **Return value:** (string) The path to the parent directory.
- **Since:** SDK 1.3

---

### LrPathUtils.removeExtension( path )

Removes the filename extension from a path, if it has one.

- **Parameters:**
  - `path` (string) -- The path.
- **Return value:** (string) The path without any extension.
- **Since:** SDK 1.3

---

### LrPathUtils.replaceExtension( path, extension )

Changes the filename extension of a path, replacing any existing extension.

- **Parameters:**
  - `path` (string) -- The path.
  - `extension` (string) -- The new extension.
- **Return value:** (string) The path with the new extension.
- **Since:** SDK 1.3

---

### LrPathUtils.standardizePath( path )

Standardizes a path, resolving links and shortcuts such as `..` (dot dot) and `~` (home).

- **Parameters:**
  - `path` (string) -- The path.
- **Return value:** (string) The path in canonical form.
- **Since:** SDK 1.3

---

## LrTasks

**Type:** Namespace

Allows you to start and manage tasks that run cooperatively on Lightroom's main (user interface) thread. These are expressed in Lua as coroutines and are similar to lightweight threads.

### LrTasks.canYield()

Reports whether a cooperative task is currently running (a task started with `LrTasks.startAsyncTask()` or similar). If so, you can call `LrTasks.yield()`.

- **Parameters:** None
- **Return value:** (Boolean) True if `LrTasks.yield()` can be called.
- **Since:** SDK 1.3

---

### LrTasks.execute( cmd )

Similar to Lua's built-in `os.execute()` function, but blocks only the task that calls it, instead of blocking the entire application.

Note: If Lightroom is running in an application sandbox environment (Mac App Store version, LR 5.0+), other sandboxed applications' binaries cannot be invoked directly, as that violates sandbox restrictions. Consult Apple's documentation for details.

- **Parameters:**
  - `cmd` (string) -- A command to pass to the command line of the OS shell.
- **Return value:** (number) The exit status of the OS shell.
- **Since:** SDK 1.3

---

### LrTasks.pcall( func, ... )

Simulates Lua's standard `pcall()`, but in a way that allows a call to `LrTasks.yield()` to occur inside it.

- **Parameters:**
  - `func` (function) -- The function to call.
  - `...` -- Parameters passed through to the function.
- **Return value:** (Boolean + ...) Success (`true`) or failure (`false`) + the return value from the function (same as Lua's `pcall()`).
- **Since:** SDK 1.3

---

### LrTasks.sleep( delay )

Temporarily stops this task and allows other tasks on Lightroom's main UI thread to proceed. This task resumes no earlier than the given number of seconds later.

- **Parameters:**
  - `delay` (number) -- The number of seconds to delay. Fractional values are allowed.
- **Return value:** None
- **Since:** SDK 2.0

---

### LrTasks.startAsyncTask( func, optName )

Starts a function that will run as a cooperative task on Lightroom's main thread. If an error is thrown while this task is executing, shows a standard error dialog.

- **Parameters:**
  - `func` (function) -- The function to start.
  - `optName` (string, optional) -- A name to assign to the task, for debugging only.
- **Return value:** None
- **Since:** SDK 1.3

---

### LrTasks.startAsyncTaskWithoutErrorHandler( func, optName )

Starts a function that will run as a cooperative task on Lightroom's main thread. This version does NOT automatically show an error dialog on failure.

- **Parameters:**
  - `func` (function) -- The function to start.
  - `optName` (string, optional) -- A name to assign to the task, for debugging only.
- **Return value:** None
- **Since:** SDK 1.3

---

### LrTasks.yield()

Temporarily stops this task and allows other tasks on Lightroom's main UI thread to proceed. This task will resume at an unspecified time in the relatively near future (usually well under a second).

- **Parameters:** None
- **Return value:** None
- **Since:** SDK 1.3

---

## LrView

**Type:** Namespace and Class

Allows you to define user interface elements for your plug-in. Use `LrView.osFactory()` to obtain a factory object, which you then use to construct dialog box elements. These elements are views (containers) and controls of various types, arranged in a node hierarchy.

A view hierarchy returned by any factory creation function can only be used in one place in the user interface at any given time.

Shared property sets:
- **View properties** -- Shared by all containers and controls except layout containers (`row`, `column`, `spacer`).
- **Control properties** -- Shared by all control types.
- **Text properties** and **Editable text properties** -- Shared by controls containing text or editable text.
- **Child layout properties** and **Node layout properties** -- Used by containers to control sizing/placement of children.

### Namespace Functions

#### LrView.bind( binding )

Declares a binding to a data value in a property table.

- **Parameters:**
  - `binding` (string or table) -- The data property. As a string: the name of a key in the default bound table. As a table (single property): `{ key = "...", bind_to_object = ..., transform = function(value, fromModel) ... end }`. As a table (multiple properties): `{ keys = {...}, bind_to_object = ..., operation = function(binder, value, fromModel) ... end, transform = function(value, fromModel) ... end }`.
- **Return value:** (table) An internal table that defines the binding. Do not modify.
- **Since:** SDK 1.3

---

#### LrView.conditionalItem( condition, view )

Allows you to define a view that is added to the layout only if a specific condition is true. The condition is evaluated once when the view description is generated (not a binding).

- **Parameters:**
  - `condition` (any type) -- If not nil or false, the view is included in the layout.
  - `view` (view description) -- The view to include if condition is true.
- **Return value:** Either the view description or `kIgnoredView`, depending on the value of `condition`.
- **Since:** SDK 2.0

---

#### LrView.osFactory()

Produces a factory object that can be used to create views and controls.

- **Parameters:** None
- **Return value:** (object) The factory object.
- **Since:** SDK 1.3

---

#### LrView.share( name )

Declares the sharing of an attribute value with other views. Typically used with a size value (width or height), in which case the greatest of the shared values is used for all objects that share the value.

- **Parameters:**
  - `name` (string) -- The name to be used to share this attribute with other views.
- **Return value:** (table) An internal table that defines the sharing. Do not modify.
- **Since:** SDK 1.3

---

### Namespace Constants

#### kIgnoredView (Read-Only)

An object that can be inserted in a view description that will be ignored when the views are created.

---

### Factory Methods (viewFactory:...)

#### viewFactory:catalog_photo( args )

Creates a view containing a photo from the catalog.

- **Parameters:**
  - `args` (table) -- View properties plus:
    - `photo` (LrPhoto) -- The photo.
    - `width` (number, default: height if specified) -- Width of the photo box in pixels.
    - `height` (number, default: width if specified) -- Height of the photo box in pixels. Both default to 200 if neither specified.
    - `frame_width` (number, default: 0) -- Thickness of frame around the photo box.
    - `frame_color` (LrColor, default: black) -- Color of the frame.
    - `background_color` (LrColor, default: black) -- Color for unfilled areas of the photo box.
    - `mouse_down` (function, optional) -- Callback; receives the view object that was clicked.
- **Since:** SDK 4.0

---

#### viewFactory:checkbox( args )

Creates a checkbox control. Checked when `value` equals `checked_value`, unchecked when `value` equals `unchecked_value`, mixed state otherwise.

- **Parameters:**
  - `args` (table) -- View properties, Control properties, Text properties, plus:
    - `title` (string, default: nil) -- The display text.
    - `value` (any, default: nil) -- The current value.
    - `checked_value` (any, default: true) -- Value indicating checked state.
    - `unchecked_value` (any, default: false) -- Value indicating unchecked state.
- **Since:** SDK 1.3

---

#### viewFactory:color_well( args )

Creates a color well control. Displays the current color; when clicked, shows a color picker UI.

- **Parameters:**
  - `args` (table) -- View properties, Control properties, plus:
    - `value` (`LrColor`, default: nil) -- The current color to display.
- **Since:** SDK 1.3

---

#### viewFactory:column( args )

Creates a column container, laying out its children vertically. Has no non-layout properties of its own.

- **Parameters:**
  - `args` (table) -- Child layout properties, Node layout properties.
- **Since:** SDK 1.3

---

#### viewFactory:combo_box( args )

Creates a combo box control with an editable text field and a pop-up menu of predefined text values.

- **Parameters:**
  - `args` (table) -- View properties, Control properties, Text properties, Editable text properties, plus:
    - `items` (table, default: nil) -- An array of simple values for the menu. Cannot be localized in place.
- **Since:** SDK 1.3

---

#### viewFactory:control_spacing()

Retrieves a spacing value suitable for a group of controls.

- **Parameters:** None
- **Return value:** (number) The spacing value in pixels.
- **Since:** SDK 1.3

---

#### viewFactory:dialog_spacing()

Retrieves a spacing value suitable for the top level of a dialog.

- **Parameters:** None
- **Return value:** (number) The spacing value in pixels.
- **Since:** SDK 1.3

---

#### viewFactory:edit_field( args )

Creates an edit-field control that accepts keyboard input when focused. Input is committed with every keystroke if `immediate` is true; otherwise when focus is lost.

- **Parameters:**
  - `args` (table) -- View properties, Control properties, Text properties, Editable text properties.
- **Since:** SDK 1.3

---

#### viewFactory:group_box( args )

Creates a group box container, a visible containment frame for a set of controls. Can have a localizable title.

- **Parameters:**
  - `args` (table) -- View properties, Child layout properties, Node layout properties, plus:
    - `font` (any, default: nil, inherited) -- See Control properties.
    - `title` (string, default: nil) -- The display text.
    - `show_title` (Boolean, default: true) -- True to show the title.
- **Since:** SDK 1.3

---

#### viewFactory:label_spacing()

Retrieves a spacing value suitable for a label-and-control group.

- **Parameters:** None
- **Return value:** (number) The spacing value in pixels.
- **Since:** SDK 1.3

---

#### viewFactory:password_field( args )

Creates a password field control (editable text that displays bullet characters).

- **Parameters:**
  - `args` (table) -- View properties, Control properties, Text properties, Editable text properties.
- **Since:** SDK 1.3

---

#### viewFactory:picture( args )

Creates a picture control displaying a static image or icon.

- **Parameters:**
  - `args` (table) -- View properties, Control properties, plus:
    - `value` (string, default: nil) -- Name of the file or resource. Obtain with `_PLUGIN:resourceId( "myLogo.png" )`.
    - `frame_width` (number, default: nil) -- Width of the frame around the image.
    - `frame_color` (`LrColor`, default: black) -- Color of the frame.
- **Since:** SDK 1.3

---

#### viewFactory:popup_menu( args )

Creates a pop-up menu control with choices, each having a title and value.

- **Parameters:**
  - `args` (table) -- View properties, Control properties, Text properties, plus:
    - `value` (any, default: nil) -- The current control value.
    - `items` (table, default: nil) -- Table of items. Each entry has a localizable `title` and a `value`.
    - `value_equal` (function, default: nil) -- A function `myValueEqual( value1, value2 )` to compare control value to each item's value for selection determination.
- **Since:** SDK 1.3

---

#### viewFactory:push_button( args )

Creates a push button control that responds to a click with an action.

- **Parameters:**
  - `args` (table) -- View properties, Control properties, Text properties, plus:
    - `title` (string, default: nil) -- The display text.
    - `action` (function, default: nil) -- Action function in the form `myAction( button )`.
- **Since:** SDK 1.3

---

#### viewFactory:radio_button( args )

Creates a radio button control. Checked when `value` equals `checked_value`, unchecked for any other value (except nil, which shows mixed state).

Note (SDK 6.0+): On Mac, radio buttons with the same parent view are automatically linked. Use `osFactory:view` with `place = "horizontal"` or `"vertical"` instead of `osFactory:row`/`column` if you need more than two radio buttons.

- **Parameters:**
  - `args` (table) -- View properties, Control properties, Text properties, plus:
    - `title` (string, default: nil) -- The display text.
    - `value` (any, default: nil) -- Current value.
    - `checked_value` (any) -- Value indicating checked state.
- **Since:** SDK 1.3

---

#### viewFactory:row( args )

Creates a row container, laying out its children horizontally. Has no non-layout properties of its own.

- **Parameters:**
  - `args` (table) -- Child layout properties, Node layout properties.
- **Since:** SDK 1.3

---

#### viewFactory:scrolled_view( args )

Creates a container view with horizontal and vertical scroll bars.

- **Parameters:**
  - `args` (table) -- View properties, Child layout properties, plus:
    - `width` (number, default: 450) -- Width in pixels.
    - `background_color` (LrColor, default: white) -- Background color. Dynamic updates via binding only work on Mac.
    - `height` (number, default: 150) -- Height in pixels (minimum 80).
    - `horizontal_scroller` (Boolean, optional, default: true) -- Whether horizontal scroll bar is present.
    - `vertical_scroller` (Boolean, optional, default: true) -- Whether vertical scroll bar is present.
- **Since:** SDK 4.0

---

#### viewFactory:separator( args )

Creates a separator that draws a line (2 pixels wide) in its container.

- **Parameters:**
  - `args` (table) -- A table with:
    - `fill_horizontal` (number, default: nil) -- Width of horizontal line as percentage [0..1] of parent's width.
    - `fill_vertical` (number, default: nil) -- Height of vertical line as percentage [0..1] of parent's height.
    If both specified, the larger value determines direction.
- **Since:** SDK 1.3

---

#### viewFactory:simple_list( args )

Creates a simple scrolling list control similar to `popup_menu` but displayed as a scrollable list.

- **Parameters:**
  - `args` (table) -- View properties, Control properties (except `font`), plus:
    - `width` (number, default: 450) -- Width in pixels.
    - `height` (number, default: 150) -- Height in pixels (minimum 80).
    - `value` (table, default: nil) -- Array of values of selected items.
    - `items` (table, default: nil) -- Table of items. Each entry has a `title` and `value`.
    - `allows_multiple_selection` (Boolean) -- True for multi-selection.
    - `value_equal` (function, default: nil) -- Comparison function `myValueEqual( value1, value2 )`.
- **Since:** SDK 4.0

---

#### viewFactory:slider( args )

Creates a slider control with a draggable indicator.

- **Parameters:**
  - `args` (table) -- View properties, Control properties, plus:
    - `value` (number, default: nil) -- Value to display.
    - `min` (number, default: nil) -- Low end of range.
    - `max` (number, default: nil) -- High end of range.
    - `integral` (Boolean, default: false) -- True for integer increments.
- **Since:** SDK 1.3

---

#### viewFactory:spacer( args )

Creates a view to consume space for layout purposes. An empty row affecting the layout of siblings. Typically shares size with sibling rows using `LrView.share()`.

- **Parameters:**
  - `args` (table) -- A table with:
    - `width` (number, default: nil) -- Horizontal size in pixels.
    - `height` (number, default: nil) -- Vertical size in pixels.
- **Since:** SDK 1.3

---

#### viewFactory:static_text( args )

Creates a static text control (typically a label or instructions; does not respond to user input).

- **Parameters:**
  - `args` (table) -- View properties, Control properties, Text properties, plus:
    - `title` (string, default: nil) -- The display text.
    - `truncation` (string, default: nil) -- Where to truncate: `'head'`, `'middle'`, `'tail'`.
    - `selectable` (Boolean, default: false) -- True to make text selectable (Mac OS only).
    - `alignment` (string, default: `'left'`) -- Text alignment: `'left'`, `'center'`, `'right'`.
    - `text_color` (`LrColor`, default: black) -- Color of the text.
    - `mouse_down` (function, optional) -- Callback; receives the view object that was clicked.
- **Since:** SDK 1.3

---

#### viewFactory:tab_view( args )

Creates a container of tabbed pages. Draws frames for `tab_view_item` children but has no title itself.

- **Parameters:**
  - `args` (table) -- View properties, Child layout properties, Node layout properties, plus:
    - `font` (any, default: nil) -- Font used in tab titles.
    - `size` (string, default: `'regular'`, inherited) -- Font size of tab titles.
    - `value` (any, default: nil) -- Identifier of the currently selected tab.
- **Since:** SDK 1.3

---

#### viewFactory:tab_view_item( args )

Creates a tabbed page container in a tab view container.

- **Parameters:**
  - `args` (table) -- View properties, Child layout properties, Node layout properties, plus:
    - `title` (string, default: nil) -- The display text in the tab.
    - `identifier` (string, required) -- A unique identifier for this page. Must be a string.
- **Since:** SDK 1.3

---

#### viewFactory:view( args )

Creates a basic containment frame for a set of controls, with no visual representation.

- **Parameters:**
  - `args` (table) -- View properties, Child layout properties, Node layout properties.
- **Since:** SDK 1.3

---

## Method Count Summary

| Namespace | Methods |
|---|---|
| LrApplication | 15 |
| LrDate | 14 |
| LrDialogs | 14 |
| LrFileUtils | 24 |
| LrFunctionContext | 12 |
| LrHttp | 5 |
| LrLogger | 19 |
| LrPathUtils | 14 |
| LrTasks | 7 |
| LrView | 4 namespace functions + 1 constant + 27 factory methods = 32 |
| **Total** | **156** |
