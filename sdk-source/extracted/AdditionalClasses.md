# Lightroom Classic SDK 11.4 -- Additional Class API Reference

Class-bearing modules from `sdk-source/API Reference/modules/` not yet covered by `Classes.md`, `LrPhoto.md`, `LrCatalog.md`, or `LrDevelopController.md`.

## Table of Contents

- [LrColor](#lrcolor)
- [LrDevelopPreset](#lrdeveloppreset)
- [LrDevelopPresetFolder](#lrdeveloppresetfolder)
- [LrFilterContext](#lrfiltercontext)
- [LrFtp](#lrftp)
- [LrFunctionContext](#lrfunctioncontext)
- [LrLogger](#lrlogger)
- [LrObservableTable](#lrobservabletable)
- [LrPlugin](#lrplugin)
- [LrRecursionGuard](#lrrecursionguard)
- [LrVideoExportPreset](#lrvideoexportpreset)
- [LrView](#lrview)
- [LrWebViewFactory](#lrwebviewfactory)
- [LrXml](#lrxml)

## LrColor

Heading: `Class and Namespace LrColor`

This class encapsulates color values, specified using RGB or grayscale values, or by name. Use the imported namespace as a constructor; access the functions through the created objects.

Source: `sdk-source/API Reference/modules/LrColor.html`

### Methods

| Method | Returns | Description |
|---|---|---|
| `LrColor( ... )` | - | Creates an `LrColor` object. Set the color values using a number in the range [0..1]. For red, green, and blue, 1 is saturation. For alpha (transparency), 0 is fully transparent and 1 is fully opaque. For a grayscale value, 0 is white and 1 is black. You can also specify a color by name. First supported in version 1.3 of the Lightroom SDK. |
| `color:alpha()` | (number) The alpha value in the range [0.0..1.0] | Retrieves the alpha (transparency) value of this color. First supported in version 1.3 of the Lightroom SDK. |
| `color:blue()` | (number) The blue value in the range [0.0..1.0] | Retrieves the blue value of this color. First supported in version 1.3 of the Lightroom SDK. |
| `color:green()` | (number) The green value in the range [0.0..1.0] | Retrieves the green value of this color. First supported in version 1.3 of the Lightroom SDK. |
| `color:red()` | (number) The red value in the range [0.0..1.0] | Retrieves the red value of this color. First supported in version 1.3 of the Lightroom SDK. |
| `color:type()` | (string) 'LrColor'. | Reports the type of this object. First supported in version 4.1 of the Lightroom SDK. |

## LrDevelopPreset

Heading: `Class LrDevelopPreset`

This class provides access to a develop preset, which stores persistent develop settings. Access the functions and properties from the object. Retrieve the objects for all the presets at the root of the hierarchy by calling LrApplication.developPresetFolders(). Retrieve objects from the parent folder using LrDevelopPresetFolder.getDevelopPresets().

Source: `sdk-source/API Reference/modules/LrDevelopPreset.html`

### Methods

| Method | Returns | Description |
|---|---|---|
| `preset:getFile()` | (string) The path. | Retrieves the file path of this preset. First supported in version 3.0 of the Lightroom SDK. |
| `preset:getName()` | (string) The name. | Retrieves the name of this preset. First supported in version 3.0 of the Lightroom SDK. |
| `preset:getParent()` | (`LrDevelopPresetFolder`) The parent preset folder object. | Retrieves the parent folder of this preset. First supported in version 3.0 of the Lightroom SDK. |
| `preset:getSetting()` | (table) The develop settings table. Contains these members: AutoBrightness: (Boolean) AutoContrast: (Boolean) AutoExposure: (Boolean) AutoGrayscaleWeights: (Boolean) AutoShadows: (Boolean) AutoTonality: (Boolean) BlueHue: (number) BlueSaturation: (number) Brightness: (number) ChromaticAberrationB: (number) ChromaticAberrationR: (number) ColorNoiseReduction: (number) Contrast: (number) ConvertToGrayscale: (Boolean) Dehaze: (number) Exposure: (number) FillLight: (number) GrainAmount: (number) GrainFrequency: (number) GrainSize: (number) GrayMixerBlues: (number) GrayMixerCyans: (number) GrayMixerGreens: (number) GrayMixerMagentas: (number) GrayMixerReds: (number) GrayMixerYellows: (number) GreenHue: (number) GreenSaturation: (number) HighlightRecovery: (number) HueAdjustmentBlues: (number) HueAdjustmentCyans: (number) HueAdjustmentGreens: (number) HueAdjustmentMagenhas: (number) HueAdjustmentReds: (number) HueAdjustmentYellows: (number) LuminanceAdjustmentBlues: (number) LuminanceAdjustmentCyans: (number) LuminanceAdjustmentGreens: (number) LuminanceAdjustmentMagentas: (number) LuminanceAdjustmentReds: (number) LuminanceAdjustmentYellows: (number) LuminanceSmoothing: (number) RedHue: (number) RedSaturation: (number) Saturation: (number) SaturationAdjustmentBlues: (number) SaturationAdjustmentCyans: (number) SaturationAdjustmentGreens: (number) SaturationAdjustmentMagentas: (number) SaturationAdjustmentReds: (number) SaturationAdjustmentYellows: (number) ShadowTint: (number) Shadows: (number) Sharpness: (number) SplitToningHighlightHue: (number) SplitToningHighlightSaturation: (number) SplitToningShadowHue: (number) SplitToningShadowSaturation: (number) Temperature: (number) Tint: (number) ToneCurve: (table) ToneDarks: (number) ToneHighlightSplit: (number) ToneHighlights: (number) ToneLights: (number) ToneMidtoneSplit: (number) ToneShadowSplit: (number) ToneShadows: (number) Vibrance: (number) VignetteAmount: (number) VignetteMidpoint: (number) WhiteBalance: (string) | Retrieves the settings for this preset. First supported in version 3.0 of the Lightroom SDK. WARNING:The develop settings APIs are experimental. The contents of the settings table are not guaranteed to remain compatible in future versions of Lightroom.The definitive list is the one shown in the UI. |
| `preset:getUuid()` | (string) The unique ID. | Retrieves the unique identifier of this preset. First supported in version 3.0 of the Lightroom SDK. |
| `preset:type()` | (string) 'LrDevelopPreset'. | Reports the type of this object. First supported in version 4.1 of the Lightroom SDK. |

## LrDevelopPresetFolder

Heading: `Class LrDevelopPresetFolder`

This class provides access to a develop-preset folder, and to the LrDevelopPreset objects for the contained presets. Access the functions and properties from the object. Retrieve the objects for all the folders by calling LrApplication.getDevelopPresetFolders().

Source: `sdk-source/API Reference/modules/LrDevelopPresetFolder.html`

### Methods

| Method | Returns | Description |
|---|---|---|
| `folder:getDevelopPresets()` | (array of `LrDevelopPreset`) The develop-preset objects. | Retrieves the develop-preset children of this folder. First supported in version 3.0 of the Lightroom SDK. |
| `folder:getName()` | (string) The name. | Retrieves the name of this folder. First supported in version 3.0 of the Lightroom SDK. |
| `folder:getPath()` | (string) The path. | Retrieves the path of this folder. First supported in version 3.0 of the Lightroom SDK. |
| `folder:type()` | (string) 'LrDevelopPresetFolder'. | Reports the type of this object. First supported in version 4.1 of the Lightroom SDK. |

## LrFilterContext

Heading: `Class LrFilterContext`

Provides access to the choices a user has made in the Export dialog, and the list of photos to be exported. An `LrFilterContext` object is passed to your plug-in as a parameter to your service script's `postProcessRenderedPhotos` function. You cannot import the namespace or access the properties and functions in any other way.

Source: `sdk-source/API Reference/modules/LrFilterContext.html`

### Methods

| Method | Returns | Description |
|---|---|---|
| `filterContext:renditions( params )` | - | Alias for filterContext.sourceExportSession:renditionsForFilter. (The `plugin` and `renditionsToSatisfy`arguments are provided automatically by this version of the function.) Creates an iterator with which to walk an export filter's renditions-to-satisfy list. The iterator generates a rendition from this export session (that is, before the application of this filter) and matches it with the corresponding rendition to be satisfied by the filter. First supported in version 2.0 of the Lightroom SDK. For example: `for sourceRendition, renditionToSatisfy in exportSession:renditions( args ) do -- (do something with rendition) end` |

### Properties

| Property | Notes | Description |
|---|---|---|
| `filterContext.propertyTable` | (Read-Only) | (table) The property table containing the Export settings defined for your plug-in, along with any built-in Lightroom Export settings that you have not excluded. The settings have the values chosen by the user in the Export dialog. First supported in version 2.0 of the Lightroom SDK. |
| `filterContext.renditionsToSatisfy` | (Read-Only) | (table) The list of renditions that have been requested by the next filter in the stack (or the final destination plug-in). First supported in version 2.0 of the Lightroom SDK. See also: LrExportSession |
| `filterContext.sourceExportSession` | (Read-Only) | (table) The export session which should be used to as the source of photo renditions for this filter (i.e. the original renditions or the results of the previous filter). First supported in version 2.0 of the Lightroom SDK. See also: LrExportSession |

## LrFtp

Heading: `Namespace and Class LrFtp`

This namespace and class allows you to send and receive data using FTP. The namespace contains a factory function, `LrFtp.create()`, for creating an `ftpConnection` object. Use this object to connect to remote FTP servers, check for directories and files on the remote system, and upload files. All of these methods block during the network interaction, and must be called from within an asynchronous task started by `LrTasks`. Functions to access FTP settings and work with FTP paths are called directly from the imported namespace.

Source: `sdk-source/API Reference/modules/LrFtp.html`

### Methods

| Method | Returns | Description |
|---|---|---|
| `LrFtp.appendFtpPaths( root, child )` | - | Appends two paths together for use in FTP. Often an FTP preset contains a parent directory in which the user wants to put multiple subdirectories. Use this function to generate the final destination directory for upload by combining the parent directory with the child directory. The function ensures that a single directory separator is inserted between the two path parts. If the child path starts with a '/' then the root path is not used. It ensures the result ends in a trailing '/', unless the result is the empty string. It does not resolve relative paths using '..' or '.'. First supported in version 1.3 of the Lightroom SDK. |
| `LrFtp.create( params, autoNegotiate )` | - | Creates and return an FTP connection object (`ftpConnection`). This method must be called from within within an asynchronous task started by `LrTasks`. First supported in version 1.3 of the Lightroom SDK. |
| `LrFtp.ftpPathValidator( view, inValue )` | - | A validator function for use in `LrView` UI control definitions. Backslashes are converted to forward slashes, and a notice is presented to the user. If the value contains a new-line character, everything after and including the new-line is removed. First supported in version 1.3 of the Lightroom SDK. |
| `LrFtp.makeFtpPresetPopup( params )` | - | Creates and returns a pop-up menu view object for accessing FTP presets. First supported in version 1.3 of the Lightroom SDK. |
| `LrFtp.queryForPasswordIfNeeded( ftpSettings )` | - | Prompts the user for a password, but only if the preset was created with 'store password' unchecked. First supported in version 2.0 of the Lightroom SDK. |
| `ftpConnection:disconnect()` | - | Disconnects this connection from the server. Once disconnected, this connection cannot be reused. This method must be called from within an asynchronous task started by `LrTasks`. Throws an exception in the event of an error. First supported in version 1.3 of the Lightroom SDK. |
| `ftpConnection:exists( filename )` | - | Tests for the existance of a file or directory on the remote system. at the current `ftpConnection.path`. This method must be called from within an asynchronous task started by `LrTasks`. First supported in version 1.3 of the Lightroom SDK. |
| `ftpConnection:getContents( remoteFileName )` | - | Retrieves the contents of a file or directory on the remote server and returns it as a string. If the remote name is a path separator character ('/'), a file listing for the current `ftpConnection.path` will be returned. This method must be called from within an asynchronous task started by `LrTasks`. Throws an exception in the event of an error. First supported in version 1.3 of the Lightroom SDK. |
| `ftpConnection:makeDirectory( directoryName )` | - | Creates a directory on the remote server. The current `ftpConnection.path` must exist on the server as a directory. There must not exist any file or directory of this name at the destination location. This method must be called from within an asynchronous task started by `LrTasks`. Throws an exception in the event of an error. First supported in version 1.3 of the Lightroom SDK. |
| `ftpConnection:pRemoveDirectory( directoryName )` | - | Removes a directory on the remote server. The same as `removeDirectory()`, except that it returns success or failure rather than throwing an exception. First supported in version 1.3 of the Lightroom SDK. |
| `ftpConnection:pRemoveFile( filename )` | - | Removes a file on the remote server. The same as `removeFile()`, except that it returns success or failure rather than throwing an exception. First supported in version 1.3 of the Lightroom SDK. |
| `ftpConnection:putFile( theLocalFilePath, destFileName )` | - | Sends a file from the local filesystem to the remote server. To specify an upload destination, set the connection to a given directory by setting the path property. The upload destination must already exist as a directory. This method must be called from within an asynchronous task started by `LrTasks`. Throws an exception in the event of an error. First supported in version 1.3 of the Lightroom SDK. |
| `ftpConnection:removeDirectory( directoryName )` | - | Removes a directory on the remote server. The current `ftpConnection.path` must exist on the server as a directory. There must exist an empty directory with this name at the destination location. This method must be called from within an asynchronous task started by `LrTasks`. Throws an exception on error. First supported in version 1.3 of the Lightroom SDK. |
| `ftpConnection:removeFile( filename )` | - | Removes a file on the remote server. The current `ftpConnection.path` must exist on the server as a directory. There must exist a file with this name at the destination location. This method must be called from within an asynchronous task started by `LrTasks`. Throws an exception in the event of an error. First supported in version 1.3 of the Lightroom SDK. |
| `ftpConnection:toTable()` | (table) A table of entries for all the properties on this connection. | Converts the properties of this FTP connection back into a Lua table, the same as the one passed to `LrFtp.create()` to create the object. First supported in version 1.3 of the Lightroom SDK. |

### Properties

| Property | Notes | Description |
|---|---|---|
| `ftpConnection.connected` | (Read-Only) | (Boolean) True if a connection exists. Even if the connection exists, it could time out or experience network problems at any time, so the fact of connection does not guarantee the success of subsequent operations. First supported in version 1.3 of the Lightroom SDK. |
| `ftpConnection.passive` | (Read-Only) | (string) When protocol is "ftp", the kind of passive connection to attempt. One of "none", "normal", or "enhanced". When protocol is "sftp", this is not used. First supported in version 1.3 of the Lightroom SDK. |
| `ftpConnection.password` | (Read-Only) | (string) The password to accompany the username in authentication. First supported in version 1.3 of the Lightroom SDK. |
| `ftpConnection.path` | (Read/Write) | (string) The remote path to use when sending or receiving files from the server. First supported in version 1.3 of the Lightroom SDK. |
| `ftpConnection.port` | (Read-Only) | (integer) The network port the server is using to host the FTP service. First supported in version 1.3 of the Lightroom SDK. |
| `ftpConnection.protocol` | (Read-Only) | (string) The type of FTP connection to use, one of "ftp" or "sftp". First supported in version 1.3 of the Lightroom SDK. |
| `ftpConnection.server` | (Read-Only) | (string) The server name or IP address for this FTP connection. First supported in version 1.3 of the Lightroom SDK. |
| `ftpConnection.username` | (Read-Only) | (string) The username to authenticate the connection. First supported in version 1.3 of the Lightroom SDK. |

## LrFunctionContext

Heading: `Namespace and Class LrFunctionContext`

This namespace and class helps you clean up resources following the execution of a function. You can register any number of cleanup handlers to respond to the success or failure of a function. You must create property tables within a function context, so that Lightroom can remove notifications when the table is no longer needed. See LrBinding.makePropertyTable(). Access the calling functions, such as `LrFunctionContext.callWithContext()`, directly from the imported namespace. You do not create instances of `LrFunctionContext` directly. They are created by the calling functions, and exist only for the lifetime of the function call or task. A `functionContext` object is passed as the first parameter of the call, followed by any other parameters you provide. Use the passed object to provide the cleanup handlers for the called function execution.

Source: `sdk-source/API Reference/modules/LrFunctionContext.html`

### Methods

| Method | Returns | Description |
|---|---|---|
| `LrFunctionContext.callWithContext( name, func, ... )` | - | Calls the main function, then calls all of the cleanup handlers before returning control. Call this function directly from the imported namespace. If this is called from within an asynchronous task (that is, a task started from `LrTasks.startAsyncTask()`), it uses `LrTasks.pcall()` to make a yield-safe call. If an error is thrown by the main function, that error is rethrown after the cleanup handlers are called. First supported in version 1.3 of the Lightroom SDK. |
| `LrFunctionContext.callWithContext_noyield( name, func, ... )` | - | Same as callWithContext, but calls the function in a fashion that disables LrTasks.yield from working. Use if you need to ensure that the called function is completed as an atomic unit. Call this function directly from the imported namespace. If this is called from within an asynchronous task (that is, a task started from `LrTasks.startAsyncTask()`), it uses `LrTasks.pcall()` to make a yield-safe call. If an error is thrown by the main function, that error is rethrown after the cleanup handlers are called. First supported in version 2.0 of the Lightroom SDK. |
| `LrFunctionContext.callWithEmptyEnvironment( func, ... )` | - | Runs the main function in a known-safe function environment. Equivalent to `setfenv( func, {} ); return func( ... )`. The passed-in function is subjected to string.dump for safety reasons, so any variables declared in the scope of the calling function are not automatically passed through to the inner function. In particular, imported namespaces and classes do not carry through. First supported in version 3.0 of the Lightroom SDK. |
| `LrFunctionContext.callWithEnvironment( func, env, ... )` | - | Runs the main function in a caller-provided function environment. Equivalent to `setfenv( func, env ); return func( ... )`. The passed-in function is subjected to string.dump for safety reasons, so any variables declared in the scope of the calling function are not automatically passed through to the inner function. In particular, imported namespaces and classes do not carry through. First supported in version 3.0 of the Lightroom SDK. |
| `LrFunctionContext.pcallWithContext( name, func, ... )` | - | Makes a protected call, like Lua's standard `pcall`, but calls all of the cleanup handlers before returning control. Call this function directly from the imported namespace. If this is called from within an asynchronous task (that is, a task started from `LrTasks.startAsyncTask()`), it uses `LrTasks.pcall()` to make a yield-safe call. The cleanup handlers are deferred until the coroutine runs to completion or failure. They are not called when yielding. First supported in version 1.3 of the Lightroom SDK. |
| `LrFunctionContext.pcallWithContext_noyield( name, func, ... )` | - | Same as `pcallWithContext`, but calls the function in a fashion that disables `LrTasks.yield` from working. Use if you need to ensure that the called function is completed as an atomic unit. First supported in version 2.0 of the Lightroom SDK. |
| `LrFunctionContext.pcallWithEmptyEnvironment( func, ... )` | - | Runs the main function in a known-safe function environment, catching any exceptions that occur. Equivalent to `setfenv( func, {} ); return pcall( func, ... )`. The passed-in function is subjected to string.dump for safety reasons, so any variables declared in the scope of the calling function are not automatically passed through to the inner function. In particular, imported namespaces and classes do not carry through. First supported in version 3.0 of the Lightroom SDK. |
| `LrFunctionContext.pcallWithEnvironment( func, env, ... )` | - | Runs the main function in a caller-provided function environment, catching any exceptions that occur. Equivalent to `setfenv( func, {} ); return pcall( func, ... )`. Variables declared in the scope of the calling function are NOT automatically passed through to the inner function. In particular, imported namespaces and classes do not carry through. First supported in version 3.0 of the Lightroom SDK. |
| `LrFunctionContext.postAsyncTaskWithContext( name, func )` | - | Runs the main function in an asynchronous/cooperative task, then calls any cleanup handlers. Call this function directly from the imported namespace. First supported in version 1.3 of the Lightroom SDK. |
| `functionContext:addCleanupHandler( func )` | - | Registers a cleanup handler in an instance. This function is called when the main function finishes or throws an error. Cleanup handlers are called in reverse order of registration; that is, the last cleanup handler registered is called first. First supported in version 1.3 of the Lightroom SDK. |
| `functionContext:addFailureHandler( func )` | - | Registers a failure handler in an instance. This function is called only if the main function fails; that is, throws an error. This is a convenience function. It calls your registered cleanup handler with a wrapper around your function that calls through in the event of a failure. First supported in version 1.3 of the Lightroom SDK. |
| `functionContext:addOperationTitleForError( title )` | - | Attaches a string to this function context to be shown in any error dialog triggered by `LrDialogs.attachErrorDialogToFunctionContext`. This string acts as a title to the actual error message, which is shown in smaller text below this message. Use the form "Unable to perform operation." First supported in version 3.0 of the Lightroom SDK. |

## LrLogger

Heading: `Class and Namespace LrLogger`

This class provides a mechanism for writing debug output that can be viewed with an external log viewer application. Use the imported namespace as a constructor; access the functions through the created objects. Common applications for viewing debug output are: DebugView (available for download from Microsoft) WinDBG (available for download from Microsoft) Microsoft Developer Studio Console (built-in application on Mac OS: look in /Applications/Utilities) Xcode Configure loggers using the config.lua file as follows: Create an entry for each logger of interest by specifying loggers.loggerName = {...} Arguments in the table include `logLevel` and a string "fatal", "error", "warn", "info", "debug", or "trace". For each valid log level, you can add an entry to modify the behavior of log messages for that level. For example, to log to a file, add the entry `trace = 'logfile',` To specify an action for all log levels, add the entry `action = 'logfile',`

Source: `sdk-source/API Reference/modules/LrLogger.html`

### Methods

| Method | Returns | Description |
|---|---|---|
| `LrLogger( name )` | - | Creates a new logger or finds and returns an existing one. Loggers are silent until configured with `LrLogger:enable()`. First supported in version 1.3 of the Lightroom SDK. |
| `logger:debug( ... )` | - | Feeds log output through the action function defined for 'debug' messages. First supported in version 1.3 of the Lightroom SDK. |
| `logger:debugf( format, ... )` | - | Feeds log output through the action function defined for 'debug' messages, using string.format to prepare the output. First supported in version 2.0 of the Lightroom SDK. |
| `logger:disable()` | - | Disables all log output from this logger. Equivalent to `logger:enable( false )`. First supported in version 1.3 of the Lightroom SDK. |
| `logger:enable( actions )` | - | Enables specific log output from this logger. First supported in version 1.3 of the Lightroom SDK. |
| `logger:error( ... )` | - | Feeds log output through the action function defined for 'error' messages. First supported in version 1.3 of the Lightroom SDK. |
| `logger:errorf( format, ... )` | - | Feeds log output through the action function defined for 'error' messages, using string.format to prepare the output. First supported in version 2.0 of the Lightroom SDK. |
| `logger:fatal( ... )` | - | Feeds log output through the action function defined for 'fatal' messages. First supported in version 1.3 of the Lightroom SDK. |
| `logger:fatalf( format, ... )` | - | Feeds log output through the action function defined for 'fatal' messages, using string.format to prepare the output. First supported in version 2.0 of the Lightroom SDK. |
| `logger:info( ... )` | - | Feeds log output through the action function defined for 'info' messages. First supported in version 1.3 of the Lightroom SDK. |
| `logger:infof( format, ... )` | - | Feeds log output through the action function defined for 'info' messages, using string.format to prepare the output. First supported in version 2.0 of the Lightroom SDK. |
| `logger:quick( ... )` | - | Creates optimized versions of specified log functions for use in tight loops. This version avoids the overhead of the method lookup, and is reduced to a no-op function when logging is disabled. For example: `local warn, info = logger:quick( 'warn', 'info' ) warn( 'something bad happened' )` First supported in version 1.3 of the Lightroom SDK. |
| `logger:quickf( ... )` | - | Creates optimized versions of specified log functions for use in tight loops. This version avoids the overhead of the method lookup, and is reduced to a no-op function when logging is disabled. Unlike the functions returned by `logger:quick`, these functions take `string.format` instructions. For example: `local warnf, infof = logger:quickf( 'warn', 'info' ) warnf( 'something %s happened', 'bad' )` First supported in version 2.0 of the Lightroom SDK. |
| `logger:trace( ... )` | - | Feeds log output through the action function defined for 'trace' messages. First supported in version 1.3 of the Lightroom SDK. |
| `logger:tracef( format, ... )` | - | Feeds log output through the action function defined for 'trace' messages, using string.format to prepare the output. First supported in version 2.0 of the Lightroom SDK. |
| `logger:type()` | (string) 'LrLogger'. | Reports the type of this object. First supported in version 4.1 of the Lightroom SDK. |
| `logger:warn( ... )` | - | Feeds log output through the action function defined for 'warn' messages. First supported in version 1.3 of the Lightroom SDK. |
| `logger:warnf( format, ... )` | - | Feeds log output through the action function defined for 'warn' messages, using string.format to prepare the output. First supported in version 2.0 of the Lightroom SDK. |

## LrObservableTable

Heading: `Class LrObservableTable`

This class implements an observable properties table. You can register interest in changes to values in this table via the `addObserver` method, and discontinue interest via the `removeObserver` method. You can create an observable table by calling `LrBinding.makePropertyTable()`. Some other API functions may create observable tables for you.

Source: `sdk-source/API Reference/modules/LrObservableTable.html`

### Methods

| Method | Returns | Description |
|---|---|---|
| `observableTable:addObserver( condition, table, func )` | - | Registers an observer for a property table. The observer is notified when a specified value in the observed table changes, and responds by invoking a handler function. There are two forms of this function: One simply registers a callback function; the other associates that callback function with a table (any arbitrary table) so that the observer can later be removed via `removeObserver`. First supported in version 1.3 of the Lightroom SDK. For example (simple form): `local propertyTable = LrBinding.makePropertyTable( functionContext ) local function colorSpaceChanged( propertyTable, key, value ) -- do something with new value end propertyTable:addObserver( 'colorSpace', colorSpaceChanged )` For example (longer form, with removeObserver): `local propertyTable = LrBinding.makePropertyTable( functionContext ) local myTable = {} local function colorSpaceChanged( myTable, propertyTable, key, value ) -- do something with new value -- note that myTable becomes first parameter in this usage end propertyTable:addObserver( 'colorSpace', myTable, colorSpaceChanged ) -- (later ...) propertyTable:removeObserver( 'colorSpace', myTable )` |
| `observableTable:pairs()` | (function) an iterator that can be used in a `for` loop | Iterate the contents of this table. Like Lua's built-in `pairs` function, except that it actually works on the observable table. First supported in version 1.3 of the Lightroom SDK. |
| `observableTable:removeObserver( condition, table )` | - | Unregisters an existing observer on a property table. The observer is no longer notified when the specified value in the observed table changes. Important: This form can only be used if a table was provided to the `addObserver` function. (See second example code under `addObserver`.) First supported in version 1.3 of the Lightroom SDK. |

## LrPlugin

Heading: `Class LrPlugin`

This class represents a Lightroom plug-in, and the object provides access to configuration information, such as the path and resources. All resources must exist within the plug-in folder. A reference to the active plug-in is stored in the global environment as `_PLUGIN`. There is currently no way to access other plug-ins.

Source: `sdk-source/API Reference/modules/LrPlugin.html`

### Methods

| Method | Returns | Description |
|---|---|---|
| `plugin:hasResource( name )` | - | Reports whether a resource exists in this plug-in. Typically this is a file in the plug-in folder. First supported in version 1.3 of the Lightroom SDK. |
| `plugin:resourceId( name )` | - | Retrieves a reference to a resource in this plug-in. Typically this is a file in the plug-in folder. First supported in version 1.3 of the Lightroom SDK. |
| `plugin:type()` | (string) 'LrPlugin'. | Reports the type of this object. First supported in version 4.1 of the Lightroom SDK. |

### Properties

| Property | Notes | Description |
|---|---|---|
| `plugin.enabled` | (Read-Only) | Reports whether the plug-in is enabled. First supported in version 3.0 of the Lightroom SDK. |
| `plugin.id` | (Read-Only) | Retrieves the unique identifier of this plug-in. First supported in version 1.3 of the Lightroom SDK. |
| `plugin.path` | (Read-Only) | Retrieves the absolute path of the plug-in folder or package. First supported in version 1.3 of the Lightroom SDK. |

## LrRecursionGuard

Heading: `Namespace and Class LrRecursionGuard`

This namespace and class provides a simple recursion guard for function execution. The typical case for using this is to prevent a chain of observation handlers from triggering infinite recursion. Use the imported namespace as a constructor; access the functions through the created objects.

Source: `sdk-source/API Reference/modules/LrRecursionGuard.html`

### Methods

| Method | Returns | Description |
|---|---|---|
| `LrRecursionGuard( name )` | - | Creates a new recursion guard. First supported in version 2.0 of the Lightroom SDK. |
| `recursionGuard:performWithGuard( func, ... )` | - | Calls a function, but only if we are not already inside a call that has been guarded by this guard. If `recursionGuard.active == true`, does nothing. First supported in version 2.0 of the Lightroom SDK. |

### Properties

| Property | Notes | Description |
|---|---|---|
| `recursionGuard.active` | (Read-Only) | (Boolean) True if this recursion guard is currently active; that is, currently inside a call to `recursionGuard:performWithGuard()`. First supported in version 2.0 of the Lightroom SDK. |

## LrVideoExportPreset

Heading: `Class LrVideoExportPreset`

An object of this class represents a single video export preset. Use such instances to identify names of video export presets, as well as the string used to represent each video export preset in export settings (`export_videoPreset` property). Objects of this type are returned by LrExportSettings.videoExportPresets

Source: `sdk-source/API Reference/modules/LrVideoExportPreset.html`

### Methods

| Method | Returns | Description |
|---|---|---|
| `videoExportPreset:extension()` | (string) The extension. | This function returns the target extension for the video format associated with this video export preset. First supported in version 4.0 of the Lightroom SDK. |
| `videoExportPreset:formatID()` | (string) The identifier of the video format this video export preset represents. | This function returns the identifier of the format corresponding to this video export preset. First supported in version 4.0 of the Lightroom SDK. |
| `videoExportPreset:name()` | (string) The name of the video export preset. | This function returns the name of the video export preset. First supported in version 4.0 of the Lightroom SDK. |
| `videoExportPreset:presetPath()` | (string) The preset path. | For a preset provided by a plug-in, this function returns the path to the preset file associated with this video export preset. For any of the default presets, this function will return nil. First supported in version 4.0 of the Lightroom SDK. |
| `videoExportPreset:targetInfo()` | (string) The target information for this preset. | This function returns the string which appears in the 'Target' information of the Video section in the Export Dialog when this video export preset is selected. In the case of custom video export preset, this is the string supplied for 'targetInfo' when the preset was added via the LrExportSettings.addVideoExportPresets API. Note that for some of the default (built-in) presets, the target info is generated dynamically based on certain properties of the source video. For such presets, this function returns nil. First supported in version 4.0 of the Lightroom SDK. |
| `videoExportPreset:type()` | (string) 'LrVideoExportPreset'. | Reports the type of this object. First supported in version 4.1 of the Lightroom SDK. |

## LrView

Heading: `Namespace and Class LrView`

This namespace and class allows you to define user interface elements for your plug-in. Use the namespace function `LrView.osFactory()` to obtain a factory object, which you then use to construct dialog box elements to be displayed in Lightroom's export dialog or custom dialogs of your own design. These elements are views, or containers, and controls of various types, arranged in a node hierarchy. The factory object has creation functions for each type of node. The arguments to a creation function allow you to set the initial property values, for properties that are appropriate to the container or control type. You can create a dynamic value for a property by setting its value to the result of the `LrView.bind()` namespace function, or to the result of one of the `LrBindings` functions. Note that a view (or a hierachy of such views) returned by any of the factory creation functions can only be used in one place in the user interface at any given time. Different sets of properties are appropriate to different types of containers and controls, and the sets overlap. In additions to the properties that affect only a specific type of container or control, these sets of properties are shared among certain broad categories: View properties are shared by all containers and controls except the layout containers (`row`, `column`, `spacer`) Control properties are shared by all control types. Text properties and Editable text properties are shared by the types of controls that contain text or editable text. Containers have layout properties that control the sizing and placement of their children in the node hierarchy. These are of two types: Child layout properties Node layout properties

Source: `sdk-source/API Reference/modules/LrView.html`

### Methods

| Method | Returns | Description |
|---|---|---|
| `LrView.bind( binding )` | - | This namespace function declares a binding to a data value in a property table. First supported in version 1.3 of the Lightroom SDK. |
| `LrView.conditionalItem( condition, view )` | - | This namespace function allows you to define a view that is added to the layout only if a specific condition is true. If the condition is false, the view is ignored. (Note that this is not a binding; the condition is evaluated once when the view description is generated.) First supported in version 2.0 of the Lightroom SDK. |
| `LrView.osFactory()` | (object) The factory object. | This namespace function produces a factory object that can be used to create views and controls. First supported in version 1.3 of the Lightroom SDK. |
| `LrView.share( name )` | - | This namespace function declares the sharing of an attribute value with other views. Typically used with a size value (width or height), in which case the greatest of the shared values is used for all objects that share the value. First supported in version 1.3 of the Lightroom SDK. |
| `viewFactory:catalog_photo( args )` | - | Creates a view containing a photo from the catalog. First supported in version 4.0 of the Lightroom SDK. |
| `viewFactory:checkbox( args )` | - | Creates a checkbox control, which displays the title text with a platform-style checkbox button. A checkbox is checked (selected) when its `value` is equal to its `checked_value`, and unchecked (deselected) when its `value` is equal to its `unchecked_value`. If its `value` has any other value, the button shows a mixed state. First supported in version 1.3 of the Lightroom SDK. |
| `viewFactory:color_well( args )` | - | Creates a color well control, which displays the current color, and when clicked shows a UI that lets the user choose a different color. First supported in version 1.3 of the Lightroom SDK. |
| `viewFactory:column( args )` | - | Creates a column container, which lays out its children vertically. This view is affected by property values in its parent (such as `visible`), but has no non-layout properties of its own. First supported in version 1.3 of the Lightroom SDK. |
| `viewFactory:combo_box( args )` | - | Creates a combo box control, with an editable text field and a pop-up menu of predefined text values. The user can enter any text, or select from the menu. When an item is selected from the menu, its value becomes the control value, and is displayed in the text field. First supported in version 1.3 of the Lightroom SDK. |
| `viewFactory:control_spacing()` | (number) The spacing value in pixels. | Retrieves a spacing value suitable for assignment to the spacing property of a group of controls. First supported in version 1.3 of the Lightroom SDK. |
| `viewFactory:dialog_spacing()` | (number) The spacing value in pixels. | Retrieves a spacing value suitable for assignment to the spacing property of a group of items at the top level of a dialog. First supported in version 1.3 of the Lightroom SDK. |
| `viewFactory:edit_field( args )` | - | Creates an edit-field control, which accepts keyboard input when it has the input focus. User input is committed (that is, the `value` is updated) with every keystroke if `immediate` is true. If `immediate` is false, input is committed when the control loses focus. There is a platform difference in the focus behavior: First supported in version 1.3 of the Lightroom SDK. In Windows, the control loses focus when the user clicks outside it. In Mac OS, it loses focus when the user uses Tab to shift the focus, not when the user clicks outside the control. |
| `viewFactory:group_box( args )` | - | Creates a group box container, a visible containment frame for a set of controls. Can have a localizable title, which is displayed near the top left corner of the frame. First supported in version 1.3 of the Lightroom SDK. |
| `viewFactory:label_spacing()` | (number) The spacing value in pixels. | Retrieves a spacing value suitable for assignment to the spacing property of a group of items where the items are closely related and one of the items serves as a label for the other items. First supported in version 1.3 of the Lightroom SDK. |
| `viewFactory:password_field( args )` | - | Creates a password field control, an editable text field that obscures the entered text, displaying only bullet characters. First supported in version 1.3 of the Lightroom SDK. |
| `viewFactory:picture( args )` | - | Creates a picture control, which displays a static image or icon. First supported in version 1.3 of the Lightroom SDK. |
| `viewFactory:popup_menu( args )` | - | Creates a pop-up menu control, which offers a pop-up menu of choices, each with a title and value. When the user pops up the menu and makes a choice, the selected item's title and value become those of the control. The current title text is displayed in the control when the menu is not open. First supported in version 1.3 of the Lightroom SDK. |
| `viewFactory:push_button( args )` | - | Creates a push button control, which responds to a click with an action. Drawn in platform-standard style with a rounded appearance. First supported in version 1.3 of the Lightroom SDK. |
| `viewFactory:radio_button( args )` | - | Creates a radio button control. The button is checked (selected) when the control `value` is equal to its `checked_value`, and unchecked (deselected) when `value` has any other value, except nil. When `value` is nil, the button shows a mixed state. Within a container, only one of a set of radio buttons should be selected. Selecting one button should deselect all others in the set. You must enforce this in the way you bind the button values; it is not automatic. First supported in version 1.3 of the Lightroom SDK. As of version 6.0 of the Lightroom SDK, on Mac only, radio buttons with the same parent view will be automatically 'linked', i.e. checking one will clear all the others, as a result of a change in the underlying OS provided API. This should only be noticeable in a view construct where radio buttons are declared via the `osFactory:row` or `osFactory:column` method within the same parent view. If you wish to have more than two radio buttons in a row or column, use the `osFactory:view` method instead, with a `place` attribute of `horizontal` or `vertical`. Do not attempt to take advantage of OS X's automatic behavior, as the automatically changed radio button states will not necessarily be reflected in the property table to which the radio buttons' values are bound. |
| `viewFactory:row( args )` | - | Creates a row container, which lays out its children horizontally. This view is affected by property values in its parent (such as `visible`), but has no non-layout properties of its own. First supported in version 1.3 of the Lightroom SDK. |
| `viewFactory:scrolled_view( args )` | - | Creates a container view with horizontal and vertical scroll bars. First supported in version 4.0 of the Lightroom SDK. On Mac OS, the scroll bars will automatically be hidden if the content of the scroll view does not require vertical and/or horizontal scrolling ability. On Windows, the scroll bar(s) will be grayed out in such a case. |
| `viewFactory:separator( args )` | - | Creates a separator, which draws a line 2 pixels in width in its container, but has no other behavior. First supported in version 1.3 of the Lightroom SDK. |
| `viewFactory:simple_list( args )` | - | Creates a simple scrolling list control, which is similar to popup_menu in that it offers a simple non-hierarchical list of choices, each with a title and value. When the user clicks on an item in the list, that selected item's value becomes the value of the control. First supported in version 4.0 of the Lightroom SDK. |
| `viewFactory:slider( args )` | - | Creates a slider control, which has a draggable indicator that changes an associated numeric value. First supported in version 1.3 of the Lightroom SDK. |
| `viewFactory:spacer( args )` | - | Creates a view to consume space for the purposes of layout.This is an empty row, which affects the layout of other children of its parent. It has no properties of its own except for size; these are typically shared with its sibling rows, using the `LrView.share()` function. First supported in version 1.3 of the Lightroom SDK. |
| `viewFactory:static_text( args )` | - | Creates a static text control that does not respond to user input, typically a label or instructions. First supported in version 1.3 of the Lightroom SDK. |
| `viewFactory:tab_view( args )` | - | Creates a container of tabbed pages. The containing tab view draws the frames for its `tab_view_item` children, but has no title. The `font` value is the default for the tab text of the children. First supported in version 1.3 of the Lightroom SDK. |
| `viewFactory:tab_view_item( args )` | - | Creates a tabbed page container in a tab view container. The localizable title text is displayed in the tab. First supported in version 1.3 of the Lightroom SDK. |
| `viewFactory:view( args )` | - | Creates a basic containment frame for a set of controls, with no visual representation. First supported in version 1.3 of the Lightroom SDK. |

### Properties

| Property | Notes | Description |
|---|---|---|
| `kIgnoredView` | (Read-Only) | This namespace constant defines an object that can be inserted in a view description that will be ignored when the views are created. |

## LrWebViewFactory

Heading: `Class LrWebViewFactory`

This class specializes the view factory for use with web-engine plug-ins. An instance is provided to a web engine's `views()` function. You cannot create an instance in any other context. The `LrWebViewFactory` object is only available in web engines.

Source: `sdk-source/API Reference/modules/LrWebViewFactory.html`

### Methods

| Method | Returns | Description |
|---|---|---|
| `webViewFactory:checkbox_and_color_row( args )` | - | Creates a row containing a check box, a label, and a color well, within a section in a Web-module panel. First supported in version 2.0 of the Lightroom SDK. |
| `webViewFactory:checkbox_row( args )` | - | Creates a row containing a label and a checkbox, within a column container in a section in a Web-module panel. First supported in version 2.0 of the Lightroom SDK. |
| `webViewFactory:color_content_column( args )` | - | Creates a container for color swatches within a section in a Web-module panel. Has a column layout(that is, `place='vertical'`) and appropriate spacing and margins for properly positioning `label_and_color_row` elements. First supported in version 2.0 of the Lightroom SDK. |
| `webViewFactory:content_column( args )` | - | Creates a general-purpose container within a section in a Web-module panel. Has a column layout and appropriate spacing and margins for properly positioning labels, checkboxes, and so on. First supported in version 2.0 of the Lightroom SDK. |
| `webViewFactory:content_section( args )` | - | Creates a generic column-layout container within a section in a Web-module panel. This can contain checkboxes or other labels that do not require any additional indentation. First supported in version 2.0 of the Lightroom SDK. |
| `webViewFactory:header_section( args )` | - | Creates a generic row-layout container within a header section in a Web-module panel. This can contain checkboxes or other labels that do not require any additional indentation, used as the first element of a section. |
| `webViewFactory:header_section_label( args )` | - | Creates a label with an appropriate color, font, size and margins to be used as a section header. Must be the immediate child of a `subdivided_sections` view. First supported in version 2.0 of the Lightroom SDK. |
| `webViewFactory:identity_plate( args )` | - | Creates an identity plate control. Must be the immediate child of a `subdivided_sections` container within a Web-module panel. First supported in version 2.0 of the Lightroom SDK. |
| `webViewFactory:label_and_color_row( args )` | - | Creates a row containing a label and a color well, within a `color_content_column` in a section in a Web-module panel. First supported in version 2.0 of the Lightroom SDK. |
| `webViewFactory:labeled_text_input( args )` | - | Creates a row containing a label and an edit text, with optional most-recently-used (MRU) menu. First supported in version 2.0 of the Lightroom SDK. |
| `webViewFactory:metadataModeControl( args )` | - | Creates a row containing a pop-up menu with metadata mode choices, within a section in a Web-module panel. |
| `webViewFactory:panel_content( args )` | - | Creates a top-level Web-module panel. Use only at the top level of containment; immediate children are created with `subdivided_sections()`. Each child section within this container is separated by a heavy black divider line. First supported in version 2.0 of the Lightroom SDK. |
| `webViewFactory:popup_row( args )` | - | Creates a row container for `popup_menu` controls. First supported in version 2.0 of the Lightroom SDK. |
| `webViewFactory:row( args )` | - | Creates a generic row-layout container within a section in a Web-module panel, with correct spacing and horizontal fill. First supported in version 2.0 of the Lightroom SDK. |
| `webViewFactory:row_column_picker( args )` | - | Creates a control for selecting the number of rows and columns in a grid. First supported in version 2.0 of the Lightroom SDK. |
| `webViewFactory:slider_content_column( args )` | - | Creates a container for `slider_row` views within a section in a Web-module panel. Has a column layout(that is, `place='vertical'`) and appropriate spacing and margins for properly positioning `slider_row` controls. First supported in version 2.0 of the Lightroom SDK. |
| `webViewFactory:slider_row( args )` | - | Creates a row containing a label, a slider, and an edit text, within a `slider_content_column` in a section in a Web-module panel. First supported in version 2.0 of the Lightroom SDK. |
| `webViewFactory:subdivided_sections( args )` | - | Creates a section within a Web-module panel created by `panel_content()`. Each child view within this container is separated by a light gray divider line. This container sets appropriate margins for aligning headers and checkboxes. Its children are row, column, and heading containers. First supported in version 2.0 of the Lightroom SDK. |
| `webViewFactory:warning_icon( args )` | - | Creates a small symbol that appears to warn the user about a specific property value. |

## LrXml

Heading: `Namespace and Class LrXml`

This namespace and class allows you create and examine XML documents. The namespace functions allow you to create an XML builder object, and to parse existing XML documents into read-only XML DOM objects. The XML builder object (`builderInstance`) allows you to create and manipulate XML documents. The XML DOM object (`xmlDomInstance`) is read-only, and allows you to examine an existing XML document. Text values added to or retrieved from the XML document will automatically be entity encoded and decoded, where required by the XML 1.1 recommendation. Please refer to the recommendation (especially sections 2.4 and 4.6) for definitions of the entities supported and when their use is required.

Source: `sdk-source/API Reference/modules/LrXml.html`

### Methods

| Method | Returns | Description |
|---|---|---|
| `LrXml.createXmlBuilder( omitDeclaration )` | - | Creates an XML builder object (`builderInstance`) for constructing an XML document. Use the methods of the resulting object to create the document contents, and to serialize the resulting XML into a string. First supported in version 1.3 of the Lightroom SDK. |
| `LrXml.parseXml( xmlString )` | - | Parses a string containing valid XML to create and return a read-only XML DOM object (`xmlDomInstance`) which you can use to examine the XML content. The returned DOM object is the root of a tree of DOM objects for the XML nodes in the document. Use the `xmlDomInstance` functions to traverse the node tree. The DOM object is an interface to a platform-specific XML parser. There can be variation in how whitespace, XML processing instructions, and other subtle aspects of XML are handled. Use caution when parsing XML. Do not assume elements are at a particular index. Instead, iterate child nodes and test by name and type to find a particular node. For example one parser might return a text node for the whitespace separating two elements, while another removes the whitespace; or one might skip comments while another includes them. First supported in version 1.3 of the Lightroom SDK. |
| `builderInstance:append( otherXmlBuilder )` | - | Appends all the XML in another `builderInstance` to this one at the current point.The other object must not have any unclosed blocks. First supported in version 1.3 of the Lightroom SDK. |
| `builderInstance:beginBlock( name, attributes )` | - | Adds an XML opening tag to this XML document. This must be closed later by a call to `endBlock()`. First supported in version 1.3 of the Lightroom SDK. |
| `builderInstance:comment( contents )` | - | Appends an XML comment to this XML document. First supported in version 1.3 of the Lightroom SDK. |
| `builderInstance:endBlock()` | - | Adds an XML closing tag to this XML document. This must be balance a preceding call to `beginBlock()`. First supported in version 1.3 of the Lightroom SDK. |
| `builderInstance:serialize()` | (string) The serialized XML document. | Retrieves the complete XML document as a string. First supported in version 1.3 of the Lightroom SDK. |
| `builderInstance:tag( name, value, attributes )` | - | Adds a single tag to this XML document, with an optional text child node. First supported in version 1.3 of the Lightroom SDK. |
| `builderInstance:text( value )` | - | Adds a text node to this XML document. First supported in version 1.3 of the Lightroom SDK. |
| `xmlDomInstance:attributes()` | (table) The attributes as a table, keyed by attribute name. Each entry is itself a table containing keys for "value", "namespace", and "name". If this is not an element node, returns nil. | Retrieves the attributes of this element node. First supported in version 1.3 of the Lightroom SDK. |
| `xmlDomInstance:childAtIndex( index )` | - | Retrieves a child of this element node by index. First supported in version 1.3 of the Lightroom SDK. |
| `xmlDomInstance:childCount()` | (number) The number of children, or nil if this node is not an element node. | Reports the number of children of this element node. First supported in version 1.3 of the Lightroom SDK. |
| `xmlDomInstance:name()` | - | Retrieves the name of the `xml` node from this XML document. First supported in version 1.3 of the Lightroom SDK. Return values (string) The name of the `xml` node. (string) The namespace of the `xml` node. |
| `xmlDomInstance:serialize()` | (string) The XML as a string. | Converts the XML encapsulated by this object into its string representation. The result does not include an XML declaration. First supported in version 1.3 of the Lightroom SDK. |
| `xmlDomInstance:text()` | (string) The text of the `xml` node. | Retrieves the text of the `xml` node from this XML document. First supported in version 3.0 of the Lightroom SDK. |
| `xmlDomInstance:transform( xsltString )` | - | Transforms this XML into string output by applying an XSLT transformation. Depending on the operating system, the result of the transform can contain different amounts and/or kinds of whitespace. To normalize the result, apply a substitution pattern such as this: `string.gsub( result, "[\r\n ]+", " " )` This must be called on the root node. Note: The error messages from this function can be misleading. If you see the message "out of memory", you may want to review the application or OS console for other messages that may be more helpful. First supported in version 1.3 of the Lightroom SDK. |
| `xmlDomInstance:type()` | (string) The node type, one of "element", "text", "comment", "processinginstruction" | Retrieves the type of the `xml` node from this XML document. First supported in version 1.3 of the Lightroom SDK. |

