# Lightroom Classic SDK 11.4 -- Additional Namespace API Reference

Namespace modules from `sdk-source/API Reference/modules/` not covered in `Namespaces.md`.

## Table of Contents

- [LrApplicationView](#lrapplicationview)
- [LrBinding](#lrbinding)
- [LrColor](#lrcolor)
- [LrErrors](#lrerrors)
- [LrExportSettings](#lrexportsettings)
- [LrFtp](#lrftp)
- [LrLocalization](#lrlocalization)
- [LrMD5](#lrmd5)
- [LrMath](#lrmath)
- [LrPasswords](#lrpasswords)
- [LrPhotoInfo](#lrphotoinfo)
- [LrPrefs](#lrprefs)
- [LrProgressScope](#lrprogressscope)
- [LrRecursionGuard](#lrrecursionguard)
- [LrSelection](#lrselection)
- [LrShell](#lrshell)
- [LrSlideshow](#lrslideshow)
- [LrSocket](#lrsocket)
- [LrSounds](#lrsounds)
- [LrStringUtils](#lrstringutils)
- [LrSystemInfo](#lrsysteminfo)
- [LrTether](#lrtether)
- [LrUndo](#lrundo)
- [LrXml](#lrxml)

## LrApplicationView

This namespace provides access to the application's view state, including the active module, main view mode, secondary view mode, and zoom level. Access the functions directly from the imported namespace.

Source: `sdk-source/API Reference/modules/LrApplicationView.html`

### Methods

| Method | Returns | SDK | Description |
|---|---|---|---|
| `LrApplicationView.cycleLoupeViewInfo()` | - | 7.4 | Changes the Loupe View Info style. Only works in Library and Develop modules. First supported in version 7.4 of the Lightroom SDK. |
| `LrApplicationView.fullscreenHidePanels()` | - | 7.4 | Changes the screen mode to Full Screen and Hide Panels. First supported in version 7.4 of the Lightroom SDK. |
| `LrApplicationView.fullscreenPreview()` | - | 7.4 | Changes the screen mode to Full Screen Preview. First supported in version 7.4 of the Lightroom SDK. |
| `LrApplicationView.getCurrentModuleName()` | moduleName (string) The name of the current module, one of: "library", "develop", "map", "book", "slideshow", "print", "web". | 6.0 | Returns the name of the currently active module. First supported in version 6.0 of the Lightroom SDK. |
| `LrApplicationView.getSecondaryViewName()` | viewName (string) The name of the secondary view being shown, one of: "loupe", "live_loupe", "locked_loupe", "grid", "compare", "survey", "slideshow", or nil. | 6.0 | Returns the name of the view currently showing on the secondary screen, or nil of the secondary display is not on. First supported in version 6.0 of the Lightroom SDK. |
| `LrApplicationView.gridView()` | - | 7.4 | Opens Grid View. First supported in version 7.4 of the Lightroom SDK. |
| `LrApplicationView.gridViewStyle()` | - | 7.4 | Changes the Grid View Style. First supported in version 7.4 of the Lightroom SDK. |
| `LrApplicationView.isSecondaryDisplayOn()` | - | 6.0 | Returns true if the secondary window is currently on. First supported in version 6.0 of the Lightroom SDK. |
| `LrApplicationView.nextScreenMode()` | - | 7.4 | Changes the Screen Mode. First supported in version 7.4 of the Lightroom SDK. |
| `LrApplicationView.showSecondaryView( viewName )` | - | 6.0 | Shows a view on the secondary screen, or hides the secondary screen if the given view was previously being shown. First supported in version 6.0 of the Lightroom SDK. |
| `LrApplicationView.showView( viewName )` | - | 6.0 | Switches the app's view mode. First supported in version 6.0 of the Lightroom SDK. |
| `LrApplicationView.switchToModule( moduleName )` | - | 6.0 | Switches between modules. First supported in version 6.0 of the Lightroom SDK. |
| `LrApplicationView.toggleLoupe()` | - | 7.4 | Toggle Loupe View while in Library. First supported in version 7.4 of the Lightroom SDK. Must be used with in Library. |
| `LrApplicationView.toggleSecondaryDisplay()` | - | 6.0 | Toggles the the secondary window on/off. First supported in version 6.0 of the Lightroom SDK. |
| `LrApplicationView.toggleSecondaryDisplayFullscreen()` | - | 6.0 | Toggles fullscreen mode for the secondary window. First supported in version 6.0 of the Lightroom SDK. |
| `LrApplicationView.toggleZoom()` | - | 6.0 | Zooms toggles between zoomed in and zoomed out. Only works in Library and Develop modules. First supported in version 6.0 of the Lightroom SDK. |
| `LrApplicationView.zoomIn()` | - | 6.0 | Zooms in to next level. Only works in Library and Develop modules. First supported in version 6.0 of the Lightroom SDK. |
| `LrApplicationView.zoomInSome()` | - | 6.0 | Zooms in one small step. Only works in Library and Develop modules. First supported in version 6.0 of the Lightroom SDK. Deprecated API - included for avoiding breakage of plugins |
| `LrApplicationView.zoomOut()` | - | 6.0 | Zooms out to next level. Only works in Library and Develop modules. First supported in version 6.0 of the Lightroom SDK. |
| `LrApplicationView.zoomOutSome()` | - | 6.0 | Zooms out one small step. Only works in Library and Develop modules. First supported in version 6.0 of the Lightroom SDK. Deprecated API - included for avoiding breakage of plugins |
| `LrApplicationView.zoomToOneToOne()` | - | 10.0 | Zooms to 100%. Only works in Library and Develop modules. First supported in version 10.0 of the Lightroom SDK. |

### Method Details

#### `LrApplicationView.cycleLoupeViewInfo()`

Changes the Loupe View Info style. Only works in Library and Develop modules. First supported in version 7.4 of the Lightroom SDK.

SDK: 7.4

#### `LrApplicationView.fullscreenHidePanels()`

Changes the screen mode to Full Screen and Hide Panels. First supported in version 7.4 of the Lightroom SDK.

SDK: 7.4

#### `LrApplicationView.fullscreenPreview()`

Changes the screen mode to Full Screen Preview. First supported in version 7.4 of the Lightroom SDK.

SDK: 7.4

#### `LrApplicationView.getCurrentModuleName()`

Returns the name of the currently active module. First supported in version 6.0 of the Lightroom SDK.

Returns: moduleName (string) The name of the current module, one of: "library", "develop", "map", "book", "slideshow", "print", "web".

SDK: 6.0

#### `LrApplicationView.getSecondaryViewName()`

Returns the name of the view currently showing on the secondary screen, or nil of the secondary display is not on. First supported in version 6.0 of the Lightroom SDK.

Returns: viewName (string) The name of the secondary view being shown, one of: "loupe", "live_loupe", "locked_loupe", "grid", "compare", "survey", "slideshow", or nil.

SDK: 6.0

#### `LrApplicationView.gridView()`

Opens Grid View. First supported in version 7.4 of the Lightroom SDK.

SDK: 7.4

#### `LrApplicationView.gridViewStyle()`

Changes the Grid View Style. First supported in version 7.4 of the Lightroom SDK.

SDK: 7.4

#### `LrApplicationView.isSecondaryDisplayOn()`

Returns true if the secondary window is currently on. First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

#### `LrApplicationView.nextScreenMode()`

Changes the Screen Mode. First supported in version 7.4 of the Lightroom SDK.

SDK: 7.4

#### `LrApplicationView.showSecondaryView( viewName )`

Shows a view on the secondary screen, or hides the secondary screen if the given view was previously being shown. First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

#### `LrApplicationView.showView( viewName )`

Switches the app's view mode. First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

#### `LrApplicationView.switchToModule( moduleName )`

Switches between modules. First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

#### `LrApplicationView.toggleLoupe()`

Toggle Loupe View while in Library. First supported in version 7.4 of the Lightroom SDK. Must be used with in Library.

SDK: 7.4

#### `LrApplicationView.toggleSecondaryDisplay()`

Toggles the the secondary window on/off. First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

#### `LrApplicationView.toggleSecondaryDisplayFullscreen()`

Toggles fullscreen mode for the secondary window. First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

#### `LrApplicationView.toggleZoom()`

Zooms toggles between zoomed in and zoomed out. Only works in Library and Develop modules. First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

#### `LrApplicationView.zoomIn()`

Zooms in to next level. Only works in Library and Develop modules. First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

#### `LrApplicationView.zoomInSome()`

Zooms in one small step. Only works in Library and Develop modules. First supported in version 6.0 of the Lightroom SDK. Deprecated API - included for avoiding breakage of plugins

SDK: 6.0

#### `LrApplicationView.zoomOut()`

Zooms out to next level. Only works in Library and Develop modules. First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

#### `LrApplicationView.zoomOutSome()`

Zooms out one small step. Only works in Library and Develop modules. First supported in version 6.0 of the Lightroom SDK. Deprecated API - included for avoiding breakage of plugins

SDK: 6.0

#### `LrApplicationView.zoomToOneToOne()`

Zooms to 100%. Only works in Library and Develop modules. First supported in version 10.0 of the Lightroom SDK.

SDK: 10.0

## LrBinding

This namespace allows you to create observable properties tables, and to define common relationships between UI elements and data property values. Access these functions directly from the imported namespace. The `makePropertyTable()` function creates an observable table, in which you can store program data that you can associate with dynamic values in your UI. Use the transformation functions as the `value` argument to LrView.bind(). These functions perform very common transformations between the source value of a binding (that is, the value whose change triggered a notification, typically an export-settings value in a property table) and the destination value (the other end of the binding, typically a view property such as "visible" or "enabled"). Bindings can work in both directions; that is, a change in the bound table affects the value of the view property, and changing the view property affects the table's key value. However, these functions (except as noted) create one-way bindings. They only change the bound view property when a bound table's key value changes, not the reverse. For example, this creates a binding that hides the control when the value of "mySetting" becomes true: `binding = { visible = LrBinding.negativeOfKey( "mySetting" ) }`

Source: `sdk-source/API Reference/modules/LrBinding.html`

### Methods

| Method | Returns | SDK | Description |
|---|---|---|---|
| `LrBinding.andAllKeys( optObject, keys )` | - | 1.3 | Creates a binding that determines if the values of all the source keys evaluate to true. The return value is placed in the bound view property, which must be Boolean. First supported in version 1.3 of the Lightroom SDK. |
| `LrBinding.keyEquals( key, compareValue, optObject )` | - | 1.3 | Creates a binding that determines if the source value is equal to a comparison value. The return value is placed in the bound view property, which must be Boolean. First supported in version 1.3 of the Lightroom SDK. |
| `LrBinding.keyIsNil( key, optObject )` | - | 1.3 | Creates a binding that determines if the source value is not present. The return value is placed in the bound view property, which must be Boolean. First supported in version 1.3 of the Lightroom SDK. |
| `LrBinding.keyIsNot( key, compareValue, optObject )` | - | 1.3 | Creates a binding that determines if the source value is not equal to a comparison value. The return value is placed in the bound view property, which must be Boolean. First supported in version 1.3 of the Lightroom SDK. |
| `LrBinding.keyIsNotNil( key, optObject )` | - | 1.3 | Creates a binding that determines if the source value is present. The return value is placed in the bound view property, which must be Boolean. First supported in version 1.3 of the Lightroom SDK. |
| `LrBinding.makePropertyTable( functionContext )` | - | 1.3 | Creates a table that automatically sends notifications whenever values in the table are changed. You can set this as the bound table for an `LrView` object, or pass it as the `optObject` to any of the `LrBinding` functions. You can also call addObserver() on this table to register any object for notification when values in this table are changed. You must call this function with a function context, so that Lightroom can remove notifications when the table is no longer needed. First supported in version 1.3 of the Lightroom SDK. |
| `LrBinding.negativeOfKey( key, optObject )` | - | 1.3 | Creates a binding that negates the source value, if it is Boolean or numeric. For a value of any other type, the transformation returns nil. This is a two-way binding; changes in the view property also place the negated value in the bound table key. First supported in version 1.3 of the Lightroom SDK. |
| `LrBinding.orAllKeys( optObject, keys )` | - | 1.3 | Creates a binding that determines if the values of any of the source keys evaluate to true. The return value is placed in the bound view property, which must be Boolean. First supported in version 1.3 of the Lightroom SDK. |

### Method Details

#### `LrBinding.andAllKeys( optObject, keys )`

Creates a binding that determines if the values of all the source keys evaluate to true. The return value is placed in the bound view property, which must be Boolean. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `LrBinding.keyEquals( key, compareValue, optObject )`

Creates a binding that determines if the source value is equal to a comparison value. The return value is placed in the bound view property, which must be Boolean. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `LrBinding.keyIsNil( key, optObject )`

Creates a binding that determines if the source value is not present. The return value is placed in the bound view property, which must be Boolean. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `LrBinding.keyIsNot( key, compareValue, optObject )`

Creates a binding that determines if the source value is not equal to a comparison value. The return value is placed in the bound view property, which must be Boolean. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `LrBinding.keyIsNotNil( key, optObject )`

Creates a binding that determines if the source value is present. The return value is placed in the bound view property, which must be Boolean. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `LrBinding.makePropertyTable( functionContext )`

Creates a table that automatically sends notifications whenever values in the table are changed. You can set this as the bound table for an `LrView` object, or pass it as the `optObject` to any of the `LrBinding` functions. You can also call addObserver() on this table to register any object for notification when values in this table are changed. You must call this function with a function context, so that Lightroom can remove notifications when the table is no longer needed. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `LrBinding.negativeOfKey( key, optObject )`

Creates a binding that negates the source value, if it is Boolean or numeric. For a value of any other type, the transformation returns nil. This is a two-way binding; changes in the view property also place the negated value in the bound table key. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `LrBinding.orAllKeys( optObject, keys )`

Creates a binding that determines if the values of any of the source keys evaluate to true. The return value is placed in the bound view property, which must be Boolean. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

### Properties

| Property | Notes | Description |
|---|---|---|
| `LrBinding.kUnsupportedDirection` | (Read-Only) | Your transformation function should return this value to indicate that the current direction is not supported by the transform. Bindings can work in both directions; that is, a change in the bound table affects the value of the view property,and changing the view property affects the table's key value. When writing your own transformation functions, you can choose to support only one direction. First supported in version 1.3 of the Lightroom SDK. |

## LrColor

This class encapsulates color values, specified using RGB or grayscale values, or by name. Use the imported namespace as a constructor; access the functions through the created objects.

Source: `sdk-source/API Reference/modules/LrColor.html`

### Methods

| Method | Returns | SDK | Description |
|---|---|---|---|
| `LrColor( ... )` | - | 1.3 | Creates an `LrColor` object. Set the color values using a number in the range [0..1]. For red, green, and blue, 1 is saturation. For alpha (transparency), 0 is fully transparent and 1 is fully opaque. For a grayscale value, 0 is white and 1 is black. You can also specify a color by name. First supported in version 1.3 of the Lightroom SDK. |
| `color:alpha()` | (number) The alpha value in the range [0.0..1.0] | 1.3 | Retrieves the alpha (transparency) value of this color. First supported in version 1.3 of the Lightroom SDK. |
| `color:blue()` | (number) The blue value in the range [0.0..1.0] | 1.3 | Retrieves the blue value of this color. First supported in version 1.3 of the Lightroom SDK. |
| `color:green()` | (number) The green value in the range [0.0..1.0] | 1.3 | Retrieves the green value of this color. First supported in version 1.3 of the Lightroom SDK. |
| `color:red()` | (number) The red value in the range [0.0..1.0] | 1.3 | Retrieves the red value of this color. First supported in version 1.3 of the Lightroom SDK. |
| `color:type()` | (string) 'LrColor'. | 4.1 | Reports the type of this object. First supported in version 4.1 of the Lightroom SDK. |

### Method Details

#### `LrColor( ... )`

Creates an `LrColor` object. Set the color values using a number in the range [0..1]. For red, green, and blue, 1 is saturation. For alpha (transparency), 0 is fully transparent and 1 is fully opaque. For a grayscale value, 0 is white and 1 is black. You can also specify a color by name. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `color:alpha()`

Retrieves the alpha (transparency) value of this color. First supported in version 1.3 of the Lightroom SDK.

Returns: (number) The alpha value in the range [0.0..1.0]

SDK: 1.3

#### `color:blue()`

Retrieves the blue value of this color. First supported in version 1.3 of the Lightroom SDK.

Returns: (number) The blue value in the range [0.0..1.0]

SDK: 1.3

#### `color:green()`

Retrieves the green value of this color. First supported in version 1.3 of the Lightroom SDK.

Returns: (number) The green value in the range [0.0..1.0]

SDK: 1.3

#### `color:red()`

Retrieves the red value of this color. First supported in version 1.3 of the Lightroom SDK.

Returns: (number) The red value in the range [0.0..1.0]

SDK: 1.3

#### `color:type()`

Reports the type of this object. First supported in version 4.1 of the Lightroom SDK.

Returns: (string) 'LrColor'.

SDK: 4.1

## LrErrors

This namespace allows you to format Lua error strings that can be used in error dialogs. The built-in Lua `error()` function is also available in the Lightroom Lua environment. Access the functions directly from the imported namespace.

Source: `sdk-source/API Reference/modules/LrErrors.html`

### Methods

| Method | Returns | SDK | Description |
|---|---|---|---|
| `LrErrors.isCanceledError( errorString )` | - | 1.3 | Reports whether an error string returned from a protected call (pcall) represents a user cancellation. First supported in version 1.3 of the Lightroom SDK. |
| `LrErrors.throwCanceled()` | - | 1.3 | Throws an error indicating that a task was canceled by the user. First supported in version 1.3 of the Lightroom SDK. |
| `LrErrors.throwUserError( text )` | - | 1.3 | Throws an error with a given message. Use the function `LrDialogs.attachErrorDialogToFunctionContext()` to show a standard error dialog that displays this text. First supported in version 1.3 of the Lightroom SDK. |

### Method Details

#### `LrErrors.isCanceledError( errorString )`

Reports whether an error string returned from a protected call (pcall) represents a user cancellation. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `LrErrors.throwCanceled()`

Throws an error indicating that a task was canceled by the user. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `LrErrors.throwUserError( text )`

Throws an error with a given message. Use the function `LrDialogs.attachErrorDialogToFunctionContext()` to show a standard error dialog that displays this text. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

## LrExportSettings

This namespace allows you to check or set an image file format for an export operation, and (as of Lightroom 4.0) it also provides access to `LrVideoExportPreset` objects which represent the presets available for video export. These objects, in turn, can be used to access the names of the video export presets, as shown in the Export Dialog, as well as the strings used to represent each preset in export settings (`export_videoPreset` property). Access the functions directly from the imported namespace.

Source: `sdk-source/API Reference/modules/LrExportSettings.html`

### Methods

| Method | Returns | SDK | Description |
|---|---|---|---|
| `LrExportSettings.addVideoExportPresets( definition, pluginObject )` | - | - | Adds to the available presets for video export in the export/publish dialog in the form of additional entries in the 'Format' and 'Quality' popup menus in the Video section. The video export preset file (.epr) is required to be generated with Adobe Media Encoder. First supported in vesion 4.0 of the Lightroom SDK. |
| `LrExportSettings.applyVideoExportPreset( exportSettings, preset )` | - | 4.0 | Applies the specified video export preset to the 'exportSettings' property table. Typically used while constructing properties for an LrExportSession instantiation. First supported in version 4.0 of the Lightroom SDK. |
| `LrExportSettings.extensionForFormat( format )` | - | 1.3 | Retrieves the proper file extension to use for a file format. First supported in version 1.3 of the Lightroom SDK. |
| `LrExportSettings.removeVideoExportPreset( presetObject, pluginObject )` | - | 4.0 | Removes a custom video export preset previously added by this plug-in via addVideoEXportPresets. This call will return true if successful, false otherwise. Only presets added by this plug-in can be removed. First supported in version 4.0 of the Lightroom SDK. |
| `LrExportSettings.supportableVideoExportFormats()` | (table) Array of tables. Each table contains extension: (string) The file extension any video exported using this format will receive. formatName: (string) The name of this format. Use this when adding video export presets in your plug-in. | 4.0 | Retrieves an array of tables, each of which describes a format supportable for video export. First supported in version 4.0 of the Lightroom SDK. |
| `LrExportSettings.videoExportPresets()` | (table) Array of `LrVideoExportPreset` | 4.0 | Retrieves the `LrVideoExportPreset` objects associated with the available presets for video export. First supported in version 4.0 of the Lightroom SDK. |
| `LrExportSettings.videoExportPresetsForPlugin( pluginObject )` | - | 4.0 | Returns a list of custom video export presets previously added by this plug-in via addVideoEXportPresets. First supported in version 4.0 of the Lightroom SDK. |

### Method Details

#### `LrExportSettings.addVideoExportPresets( definition, pluginObject )`

Adds to the available presets for video export in the export/publish dialog in the form of additional entries in the 'Format' and 'Quality' popup menus in the Video section. The video export preset file (.epr) is required to be generated with Adobe Media Encoder. First supported in vesion 4.0 of the Lightroom SDK.

#### `LrExportSettings.applyVideoExportPreset( exportSettings, preset )`

Applies the specified video export preset to the 'exportSettings' property table. Typically used while constructing properties for an LrExportSession instantiation. First supported in version 4.0 of the Lightroom SDK.

SDK: 4.0

#### `LrExportSettings.extensionForFormat( format )`

Retrieves the proper file extension to use for a file format. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `LrExportSettings.removeVideoExportPreset( presetObject, pluginObject )`

Removes a custom video export preset previously added by this plug-in via addVideoEXportPresets. This call will return true if successful, false otherwise. Only presets added by this plug-in can be removed. First supported in version 4.0 of the Lightroom SDK.

SDK: 4.0

#### `LrExportSettings.supportableVideoExportFormats()`

Retrieves an array of tables, each of which describes a format supportable for video export. First supported in version 4.0 of the Lightroom SDK.

Returns: (table) Array of tables. Each table contains extension: (string) The file extension any video exported using this format will receive. formatName: (string) The name of this format. Use this when adding video export presets in your plug-in.

SDK: 4.0

#### `LrExportSettings.videoExportPresets()`

Retrieves the `LrVideoExportPreset` objects associated with the available presets for video export. First supported in version 4.0 of the Lightroom SDK.

Returns: (table) Array of `LrVideoExportPreset`

SDK: 4.0

#### `LrExportSettings.videoExportPresetsForPlugin( pluginObject )`

Returns a list of custom video export presets previously added by this plug-in via addVideoEXportPresets. First supported in version 4.0 of the Lightroom SDK.

SDK: 4.0

## LrFtp

This namespace and class allows you to send and receive data using FTP. The namespace contains a factory function, `LrFtp.create()`, for creating an `ftpConnection` object. Use this object to connect to remote FTP servers, check for directories and files on the remote system, and upload files. All of these methods block during the network interaction, and must be called from within an asynchronous task started by `LrTasks`. Functions to access FTP settings and work with FTP paths are called directly from the imported namespace.

Source: `sdk-source/API Reference/modules/LrFtp.html`

### Methods

| Method | Returns | SDK | Description |
|---|---|---|---|
| `LrFtp.appendFtpPaths( root, child )` | - | 1.3 | Appends two paths together for use in FTP. Often an FTP preset contains a parent directory in which the user wants to put multiple subdirectories. Use this function to generate the final destination directory for upload by combining the parent directory with the child directory. The function ensures that a single directory separator is inserted between the two path parts. If the child path starts with a '/' then the root path is not used. It ensures the result ends in a trailing '/', unless the result is the empty string. It does not resolve relative paths using '..' or '.'. First supported in version 1.3 of the Lightroom SDK. |
| `LrFtp.create( params, autoNegotiate )` | - | 1.3 | Creates and return an FTP connection object (`ftpConnection`). This method must be called from within within an asynchronous task started by `LrTasks`. First supported in version 1.3 of the Lightroom SDK. |
| `LrFtp.ftpPathValidator( view, inValue )` | - | 1.3 | A validator function for use in `LrView` UI control definitions. Backslashes are converted to forward slashes, and a notice is presented to the user. If the value contains a new-line character, everything after and including the new-line is removed. First supported in version 1.3 of the Lightroom SDK. |
| `LrFtp.makeFtpPresetPopup( params )` | - | 1.3 | Creates and returns a pop-up menu view object for accessing FTP presets. First supported in version 1.3 of the Lightroom SDK. |
| `LrFtp.queryForPasswordIfNeeded( ftpSettings )` | - | 2.0 | Prompts the user for a password, but only if the preset was created with 'store password' unchecked. First supported in version 2.0 of the Lightroom SDK. |
| `ftpConnection:disconnect()` | - | 1.3 | Disconnects this connection from the server. Once disconnected, this connection cannot be reused. This method must be called from within an asynchronous task started by `LrTasks`. Throws an exception in the event of an error. First supported in version 1.3 of the Lightroom SDK. |
| `ftpConnection:exists( filename )` | - | 1.3 | Tests for the existance of a file or directory on the remote system. at the current `ftpConnection.path`. This method must be called from within an asynchronous task started by `LrTasks`. First supported in version 1.3 of the Lightroom SDK. |
| `ftpConnection:getContents( remoteFileName )` | - | 1.3 | Retrieves the contents of a file or directory on the remote server and returns it as a string. If the remote name is a path separator character ('/'), a file listing for the current `ftpConnection.path` will be returned. This method must be called from within an asynchronous task started by `LrTasks`. Throws an exception in the event of an error. First supported in version 1.3 of the Lightroom SDK. |
| `ftpConnection:makeDirectory( directoryName )` | - | 1.3 | Creates a directory on the remote server. The current `ftpConnection.path` must exist on the server as a directory. There must not exist any file or directory of this name at the destination location. This method must be called from within an asynchronous task started by `LrTasks`. Throws an exception in the event of an error. First supported in version 1.3 of the Lightroom SDK. |
| `ftpConnection:pRemoveDirectory( directoryName )` | - | 1.3 | Removes a directory on the remote server. The same as `removeDirectory()`, except that it returns success or failure rather than throwing an exception. First supported in version 1.3 of the Lightroom SDK. |
| `ftpConnection:pRemoveFile( filename )` | - | 1.3 | Removes a file on the remote server. The same as `removeFile()`, except that it returns success or failure rather than throwing an exception. First supported in version 1.3 of the Lightroom SDK. |
| `ftpConnection:putFile( theLocalFilePath, destFileName )` | - | 1.3 | Sends a file from the local filesystem to the remote server. To specify an upload destination, set the connection to a given directory by setting the path property. The upload destination must already exist as a directory. This method must be called from within an asynchronous task started by `LrTasks`. Throws an exception in the event of an error. First supported in version 1.3 of the Lightroom SDK. |
| `ftpConnection:removeDirectory( directoryName )` | - | 1.3 | Removes a directory on the remote server. The current `ftpConnection.path` must exist on the server as a directory. There must exist an empty directory with this name at the destination location. This method must be called from within an asynchronous task started by `LrTasks`. Throws an exception on error. First supported in version 1.3 of the Lightroom SDK. |
| `ftpConnection:removeFile( filename )` | - | 1.3 | Removes a file on the remote server. The current `ftpConnection.path` must exist on the server as a directory. There must exist a file with this name at the destination location. This method must be called from within an asynchronous task started by `LrTasks`. Throws an exception in the event of an error. First supported in version 1.3 of the Lightroom SDK. |
| `ftpConnection:toTable()` | (table) A table of entries for all the properties on this connection. | 1.3 | Converts the properties of this FTP connection back into a Lua table, the same as the one passed to `LrFtp.create()` to create the object. First supported in version 1.3 of the Lightroom SDK. |

### Method Details

#### `LrFtp.appendFtpPaths( root, child )`

Appends two paths together for use in FTP. Often an FTP preset contains a parent directory in which the user wants to put multiple subdirectories. Use this function to generate the final destination directory for upload by combining the parent directory with the child directory. The function ensures that a single directory separator is inserted between the two path parts. If the child path starts with a '/' then the root path is not used. It ensures the result ends in a trailing '/', unless the result is the empty string. It does not resolve relative paths using '..' or '.'. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `LrFtp.create( params, autoNegotiate )`

Creates and return an FTP connection object (`ftpConnection`). This method must be called from within within an asynchronous task started by `LrTasks`. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `LrFtp.ftpPathValidator( view, inValue )`

A validator function for use in `LrView` UI control definitions. Backslashes are converted to forward slashes, and a notice is presented to the user. If the value contains a new-line character, everything after and including the new-line is removed. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `LrFtp.makeFtpPresetPopup( params )`

Creates and returns a pop-up menu view object for accessing FTP presets. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `LrFtp.queryForPasswordIfNeeded( ftpSettings )`

Prompts the user for a password, but only if the preset was created with 'store password' unchecked. First supported in version 2.0 of the Lightroom SDK.

SDK: 2.0

#### `ftpConnection:disconnect()`

Disconnects this connection from the server. Once disconnected, this connection cannot be reused. This method must be called from within an asynchronous task started by `LrTasks`. Throws an exception in the event of an error. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `ftpConnection:exists( filename )`

Tests for the existance of a file or directory on the remote system. at the current `ftpConnection.path`. This method must be called from within an asynchronous task started by `LrTasks`. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `ftpConnection:getContents( remoteFileName )`

Retrieves the contents of a file or directory on the remote server and returns it as a string. If the remote name is a path separator character ('/'), a file listing for the current `ftpConnection.path` will be returned. This method must be called from within an asynchronous task started by `LrTasks`. Throws an exception in the event of an error. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `ftpConnection:makeDirectory( directoryName )`

Creates a directory on the remote server. The current `ftpConnection.path` must exist on the server as a directory. There must not exist any file or directory of this name at the destination location. This method must be called from within an asynchronous task started by `LrTasks`. Throws an exception in the event of an error. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `ftpConnection:pRemoveDirectory( directoryName )`

Removes a directory on the remote server. The same as `removeDirectory()`, except that it returns success or failure rather than throwing an exception. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `ftpConnection:pRemoveFile( filename )`

Removes a file on the remote server. The same as `removeFile()`, except that it returns success or failure rather than throwing an exception. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `ftpConnection:putFile( theLocalFilePath, destFileName )`

Sends a file from the local filesystem to the remote server. To specify an upload destination, set the connection to a given directory by setting the path property. The upload destination must already exist as a directory. This method must be called from within an asynchronous task started by `LrTasks`. Throws an exception in the event of an error. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `ftpConnection:removeDirectory( directoryName )`

Removes a directory on the remote server. The current `ftpConnection.path` must exist on the server as a directory. There must exist an empty directory with this name at the destination location. This method must be called from within an asynchronous task started by `LrTasks`. Throws an exception on error. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `ftpConnection:removeFile( filename )`

Removes a file on the remote server. The current `ftpConnection.path` must exist on the server as a directory. There must exist a file with this name at the destination location. This method must be called from within an asynchronous task started by `LrTasks`. Throws an exception in the event of an error. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `ftpConnection:toTable()`

Converts the properties of this FTP connection back into a Lua table, the same as the one passed to `LrFtp.create()` to create the object. First supported in version 1.3 of the Lightroom SDK.

Returns: (table) A table of entries for all the properties on this connection.

SDK: 1.3

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

## LrLocalization

This namespace allows you to localize your plug-in for use in multiple languages, using the Adobe ZString mechanism. A ZString uniquely identifies a string usage within an application, allowing you to provide different language versions of the string, depending on the locale. A ZString has this format: `"$$$/ZStringPath/StringKey=This is the English text value"` The ZString mechanism searches a string dictionary for the current locale, matching the path and identifier, then displays the language-specific text. You must supply translation dictionaries for supported languages as part of your plug-in. See the SDK Programmer's Guide for information on how to create translation dictionaries. ZStrings in code should consist entirely of low-ASCII characters. The key should only contain characters in the set "a-ZA-Z0-9/". The value can contain any low-ASCII character. ZStrings allow some common non-low-ASCII characters to be substituted for escape sequences in the strings. For example, the sequence `^C` includes the copyright symbol in that location in the resulting string. The escape character followed by a number (`^1`) is a replacement point, that allows the sequence to be replaced by some other string supplied as an additional argument to `LOC()`. The following escape sequences are available: `^r`: carriage return `^n`: line feed `^B`: bullet `^C`: copyright `^D`: degree `^I`: increment `^R`: registered trademark `^S`: n-ary summation `^T`: trademark `^!`: logical not `^{`: left single quote `^}`: right single quote `^[`: left double quote `^]`: right double quote `^'`: apostrophe `^.`: ellipsis ("...") `^E`: Latin small e with acute accent `^e`: Latin small e with circumflex `^d`: Greek capital delta `^L`: backslash (\) `^V`: vertical bar (|) `^#`: command key (in Mac OS only) `^``: accent grave ("`") `^^`: circumflex ("^") `^0 - ^9`: Replacement point for string arguments. `^U+1234`: Encodes any arbitrary Unicode character by its code point (represented here by "1234"). The code point must always be expressed as four hexadecimal digits.

Source: `sdk-source/API Reference/modules/LrLocalization.html`

### Methods

| Method | Returns | SDK | Description |
|---|---|---|---|
| `LOC( string, ... )` | - | 1.3 | Finds a localized string by looking up the key in the dictionary for the current locale. This function is an alias for `LrLocalization.translateForPlugin()`, which automatically provides the toolkit ID for the current plug-in. First supported in version 1.3 of the Lightroom SDK. |
| `LrLocalization.currentLanguage()` | (string) The two-letter ISO code for the language currently in use. (such as 'en' for English, 'fr' for French). | 3.0 | Retrieves the language that is currently in use for translation. First supported in version 3.0 of the Lightroom SDK. |
| `LrLocalization.encodeUtf8Character( ch )` | - | 1.3 | Converts a Unicode code point value into a UTF-8 string. First supported in version 1.3 of the Lightroom SDK. |
| `LrLocalization.translateForPlugin( pluginId, string, ... )` | - | 1.3 | Finds a localized string by looking up the key in the plug-in's dictionary for the current locale. First supported in version 1.3 of the Lightroom SDK. |

### Method Details

#### `LOC( string, ... )`

Finds a localized string by looking up the key in the dictionary for the current locale. This function is an alias for `LrLocalization.translateForPlugin()`, which automatically provides the toolkit ID for the current plug-in. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `LrLocalization.currentLanguage()`

Retrieves the language that is currently in use for translation. First supported in version 3.0 of the Lightroom SDK.

Returns: (string) The two-letter ISO code for the language currently in use. (such as 'en' for English, 'fr' for French).

SDK: 3.0

#### `LrLocalization.encodeUtf8Character( ch )`

Converts a Unicode code point value into a UTF-8 string. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `LrLocalization.translateForPlugin( pluginId, string, ... )`

Finds a localized string by looking up the key in the plug-in's dictionary for the current locale. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

## LrMD5

This namespace provides MD5 digest services. Access the functions directly from the imported namespace.

Source: `sdk-source/API Reference/modules/LrMD5.html`

### Methods

| Method | Returns | SDK | Description |
|---|---|---|---|
| `LrMD5.digest( data )` | - | 1.3 | Creates an MD5 digest from a string. First supported in version 1.3 of the Lightroom SDK. |

### Method Details

#### `LrMD5.digest( data )`

Creates an MD5 digest from a string. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

## LrMath

This namespace provides additional basic math operations not otherwise available in the Lua language. Access the functions directly from the imported namespace.

Source: `sdk-source/API Reference/modules/LrMath.html`

### Methods

| Method | Returns | SDK | Description |
|---|---|---|---|
| `LrMath.bitAnd( a, b )` | - | 3.0 | Performs a bitwise AND on two integers. First supported in version 3.0 of the Lightroom SDK. The values a and b must be numeric and are treated as positive 32-bit integers. The function's behavior when passed non-integer numbers or numbers that fall outside the 32-bit space is undefined. |
| `LrMath.bitOr( a, b )` | - | 3.0 | Performs a bitwise OR on two integers. First supported in version 3.0 of the Lightroom SDK. The values a and b must be numeric and are treated as positive 32-bit integers. The function's behavior when passed non-integer numbers or numbers that fall outside the 32-bit space is undefined. |
| `LrMath.bitXor( a, b )` | - | 3.0 | Performs a bitwise exclusive OR on two integers. First supported in version 3.0 of the Lightroom SDK. The values a and b must be numeric and are treated as positive 32-bit integers. The function's behavior when passed non-integer numbers or numbers that fall outside the 32-bit space is undefined. |

### Method Details

#### `LrMath.bitAnd( a, b )`

Performs a bitwise AND on two integers. First supported in version 3.0 of the Lightroom SDK. The values a and b must be numeric and are treated as positive 32-bit integers. The function's behavior when passed non-integer numbers or numbers that fall outside the 32-bit space is undefined.

SDK: 3.0

#### `LrMath.bitOr( a, b )`

Performs a bitwise OR on two integers. First supported in version 3.0 of the Lightroom SDK. The values a and b must be numeric and are treated as positive 32-bit integers. The function's behavior when passed non-integer numbers or numbers that fall outside the 32-bit space is undefined.

SDK: 3.0

#### `LrMath.bitXor( a, b )`

Performs a bitwise exclusive OR on two integers. First supported in version 3.0 of the Lightroom SDK. The values a and b must be numeric and are treated as positive 32-bit integers. The function's behavior when passed non-integer numbers or numbers that fall outside the 32-bit space is undefined.

SDK: 3.0

## LrPasswords

This namespace provides a mechanism to store passwords in a secure fashion, using services provided by each operating system. The password API allows a plug-in author to associate an encrypted string with a key string. Lightroom scopes the key strings by plug-in ID so that a plug-in cannot access the passwords stored by another plug-in. Access the functions directly from the imported namespace.

Source: `sdk-source/API Reference/modules/LrPasswords.html`

### Methods

| Method | Returns | SDK | Description |
|---|---|---|---|
| `LrPasswords.retrieve( keystring, salt, pluginId )` | - | 3.0 | Retrieves a plain-text password from the encrypted password storage. First supported in version 3.0 of the Lightroom SDK. |
| `LrPasswords.store( keystring, myPassword, salt, pluginId )` | - | 3.0 | Stores an encrypted password. First supported in version 3.0 of the Lightroom SDK. |

### Method Details

#### `LrPasswords.retrieve( keystring, salt, pluginId )`

Retrieves a plain-text password from the encrypted password storage. First supported in version 3.0 of the Lightroom SDK.

SDK: 3.0

#### `LrPasswords.store( keystring, myPassword, salt, pluginId )`

Stores an encrypted password. First supported in version 3.0 of the Lightroom SDK.

SDK: 3.0

## LrPhotoInfo

This namespace allows you to get information about individual photo files. These files need not be part of a Lightroom catalog.

Source: `sdk-source/API Reference/modules/LrPhotoInfo.html`

### Methods

| Method | Returns | SDK | Description |
|---|---|---|---|
| `LrPhotoInfo.fileAttributes( path )` | - | 2.0 | Retrieves the file attributes that describe a photo file at a given path. First supported in version 2.0 of the Lightroom SDK. |

### Method Details

#### `LrPhotoInfo.fileAttributes( path )`

Retrieves the file attributes that describe a photo file at a given path. First supported in version 2.0 of the Lightroom SDK.

SDK: 2.0

## LrPrefs

This namespace allows you to access a table of preferences that you define and store for your own plug-in. For example: `local prefs = import 'LrPrefs'.prefsForPlugin() prefs.userName = 'John Smith'` Each plug-in has its own namespace for preferences; your preference names do not conflict with other plug-ins or with application preferences. (Except: Plug-ins can potentially share preferences by using a common "plugin ID" on the call to LrPrefs.prefsForPlugin.) Plug-ins do not have access to Lightroom's global preferences. Access the functions directly from the imported namespace.

Source: `sdk-source/API Reference/modules/LrPrefs.html`

### Methods

| Method | Returns | SDK | Description |
|---|---|---|---|
| `LrPrefs.prefsForPlugin( pluginId )` | - | 1.3 | Retrieves the preferences table for a plug-in. You can store any Boolean, number, or string value as either a key or a value in this table. You can also store tables containing these types. Note: Lightroom may not notice assignments deep in table structures. You may need to reassign a table to ensure that it is stored properly. For example: `prefs.mySetting = {}`: Saved to prefs. `prefs.mySetting[ 44 ] = 'my value'`: May not be saved to prefs unless you trigger changes. `prefs.mySetting = prefs.mySetting`: Causes all earlier changes to be saved. First supported in version 1.3 of the Lightroom SDK. Note: You must use `prefs:pairs()` (where `prefs` is the table returned by this function) to iterate this table. The built-in Lua function `pairs` will not work. |

### Method Details

#### `LrPrefs.prefsForPlugin( pluginId )`

Retrieves the preferences table for a plug-in. You can store any Boolean, number, or string value as either a key or a value in this table. You can also store tables containing these types. Note: Lightroom may not notice assignments deep in table structures. You may need to reassign a table to ensure that it is stored properly. For example: `prefs.mySetting = {}`: Saved to prefs. `prefs.mySetting[ 44 ] = 'my value'`: May not be saved to prefs unless you trigger changes. `prefs.mySetting = prefs.mySetting`: Causes all earlier changes to be saved. First supported in version 1.3 of the Lightroom SDK. Note: You must use `prefs:pairs()` (where `prefs` is the table returned by this function) to iterate this table. The built-in Lua function `pairs` will not work.

SDK: 1.3

## LrProgressScope

This class allows you to provide feedback to the user about the progress of a long-running task. An entry in Lightroom's progress area at the top-left of the catalog window is created for each active progress scope. Scopes can be nested; that is, the UI can show progress in a subsidiary task (such as uploading a single photo) that advances the parent task (such as an upload operation for a set of photos) by a given amount. The parent task is identified by a title above the progress bar, and the current task is identified by a caption below it. Use the imported namespace as a constructor; access the functions through the created objects.

Source: `sdk-source/API Reference/modules/LrProgressScope.html`

### Methods

| Method | Returns | SDK | Description |
|---|---|---|---|
| `LrProgressScope( params )` | - | 1.3 | Creates a progress scope object. First supported in version 1.3 of the Lightroom SDK. |
| `progressScope:attachToFunctionContext( context )` | - | 1.3 | Attaches this progress scope to a function context so that it can be cleared when the function ends, regardless of how the function is terminated. First supported in version 1.3 of the Lightroom SDK. |
| `progressScope:cancel()` | - | 1.3 | Signals that this operation should be canceled. Called when the user clicks the X at the right end of the progress bar in the catalog window. This does not immediately cancel the operation; that happens when the task polls :isCanceled() and stops the operation in response to a true result. First supported in version 1.3 of the Lightroom SDK. |
| `progressScope:done()` | - | 1.3 | Marks this progress scope as complete. First supported in version 1.3 of the Lightroom SDK. |
| `progressScope:getParentScope()` | - | 4.0 | Returns the parent progress scope, if any. First supported in version 4.0 of the Lightroom SDK. |
| `progressScope:getPortionComplete()` | (number) The proportion of the work that has been done, in the range [0..totalAmount]. | 1.3 | Retrieves the portion of this task that has been marked as completed. First supported in version 1.3 of the Lightroom SDK. |
| `progressScope:isCancelable()` | (Boolean) True if scope can be canceled. | 1.3 | Reports whether this progress scope can be canceled. First supported in version 1.3 of the Lightroom SDK. |
| `progressScope:isCanceled()` | (Boolean) True if `progressScope:cancel()` has been called. | 1.3 | Reports whether this operation been canceled by the user. First supported in version 1.3 of the Lightroom SDK. |
| `progressScope:isDone()` | (Boolean) True if `done()` has been called | 1.3 | Reports whether this progress scope has been completed. First supported in version 1.3 of the Lightroom SDK. |
| `progressScope:isIndeterminate()` | (Boolean) True if `setIndeterminate()` has been called, false otherwise. | 1.3 | Reports whether this progress scope is indeterminate. When a scope is indeterminate, you cannot determine how much of the task remains to be completed. The function `progressScope:getPortionComplete()` returns -1. First supported in version 1.3 of the Lightroom SDK. |
| `progressScope:isLowUiPriority()` | (Boolean) True if scope has low ui priority. | 8.4 | Reports whether this progress scope has low ui priority. First supported in version 8.4 of the Lightroom SDK. |
| `progressScope:isPausable()` | (Boolean) True if scope can be paused. | 7.5 | Reports whether this progress scope can be paused. First supported in version 7.5 of the Lightroom SDK. |
| `progressScope:isPaused()` | (Boolean) True if `progressScope:pause()` has been called. | 7.5 | Reports whether this operation been paused by the user. First supported in version 7.5 of the Lightroom SDK. |
| `progressScope:pause()` | - | 7.5 | Signals that this operation should be paused. Called when the user clicks the \|\| at the right end of the progress bar in the catalog window. This does not immediately pause the operation; that happens when the task polls :isPaused() and pauses the operation in response to a true result. First supported in version 7.5 of the Lightroom SDK. |
| `progressScope:setCancelable( cancelable )` | - | 1.3 | Allows or disallows user cancellation of this progress scope. First supported in version 1.3 of the Lightroom SDK. |
| `progressScope:setCaption( caption )` | - | 1.3 | Changes the caption that identifies this child task. First supported in version 1.3 of the Lightroom SDK. |
| `progressScope:setIndeterminate()` | - | 1.3 | Makes this progress scope indeterminate. When a scope is indeterminate, you cannot determine how much of the task remains to be completed. The function `progressScope:getPortionComplete()` returns -1. Indeterminate progress scopes are only useful in the context of `LrDialogs:showModalProgressDialog()`; they do not display properly in the Lightroom catalog window. First supported in version 1.3 of the Lightroom SDK. |
| `progressScope:setLowUiPriority( inPrior )` | - | 8.4 | Allows or disallows capability of user to change ui priority of this progress scope. First supported in version 8.4 of the Lightroom SDK. |
| `progressScope:setPausable( pausable, cancelable )` | - | 7.5 | Allows or disallows capability of user to pause this progress scope. First supported in version 7.5 of the Lightroom SDK. |
| `progressScope:setPortionComplete( amountDone, totalAmount )` | - | 1.3 | Sets the portion of this task that has been completed. First supported in version 1.3 of the Lightroom SDK. |
| `progressScope:type()` | (string) 'LrProgressScope'. | 4.1 | Reports the type of this object. First supported in version 4.1 of the Lightroom SDK. |

### Method Details

#### `LrProgressScope( params )`

Creates a progress scope object. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `progressScope:attachToFunctionContext( context )`

Attaches this progress scope to a function context so that it can be cleared when the function ends, regardless of how the function is terminated. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `progressScope:cancel()`

Signals that this operation should be canceled. Called when the user clicks the X at the right end of the progress bar in the catalog window. This does not immediately cancel the operation; that happens when the task polls :isCanceled() and stops the operation in response to a true result. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `progressScope:done()`

Marks this progress scope as complete. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `progressScope:getParentScope()`

Returns the parent progress scope, if any. First supported in version 4.0 of the Lightroom SDK.

SDK: 4.0

#### `progressScope:getPortionComplete()`

Retrieves the portion of this task that has been marked as completed. First supported in version 1.3 of the Lightroom SDK.

Returns: (number) The proportion of the work that has been done, in the range [0..totalAmount].

SDK: 1.3

#### `progressScope:isCancelable()`

Reports whether this progress scope can be canceled. First supported in version 1.3 of the Lightroom SDK.

Returns: (Boolean) True if scope can be canceled.

SDK: 1.3

#### `progressScope:isCanceled()`

Reports whether this operation been canceled by the user. First supported in version 1.3 of the Lightroom SDK.

Returns: (Boolean) True if `progressScope:cancel()` has been called.

SDK: 1.3

#### `progressScope:isDone()`

Reports whether this progress scope has been completed. First supported in version 1.3 of the Lightroom SDK.

Returns: (Boolean) True if `done()` has been called

SDK: 1.3

#### `progressScope:isIndeterminate()`

Reports whether this progress scope is indeterminate. When a scope is indeterminate, you cannot determine how much of the task remains to be completed. The function `progressScope:getPortionComplete()` returns -1. First supported in version 1.3 of the Lightroom SDK.

Returns: (Boolean) True if `setIndeterminate()` has been called, false otherwise.

SDK: 1.3

#### `progressScope:isLowUiPriority()`

Reports whether this progress scope has low ui priority. First supported in version 8.4 of the Lightroom SDK.

Returns: (Boolean) True if scope has low ui priority.

SDK: 8.4

#### `progressScope:isPausable()`

Reports whether this progress scope can be paused. First supported in version 7.5 of the Lightroom SDK.

Returns: (Boolean) True if scope can be paused.

SDK: 7.5

#### `progressScope:isPaused()`

Reports whether this operation been paused by the user. First supported in version 7.5 of the Lightroom SDK.

Returns: (Boolean) True if `progressScope:pause()` has been called.

SDK: 7.5

#### `progressScope:pause()`

Signals that this operation should be paused. Called when the user clicks the || at the right end of the progress bar in the catalog window. This does not immediately pause the operation; that happens when the task polls :isPaused() and pauses the operation in response to a true result. First supported in version 7.5 of the Lightroom SDK.

SDK: 7.5

#### `progressScope:setCancelable( cancelable )`

Allows or disallows user cancellation of this progress scope. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `progressScope:setCaption( caption )`

Changes the caption that identifies this child task. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `progressScope:setIndeterminate()`

Makes this progress scope indeterminate. When a scope is indeterminate, you cannot determine how much of the task remains to be completed. The function `progressScope:getPortionComplete()` returns -1. Indeterminate progress scopes are only useful in the context of `LrDialogs:showModalProgressDialog()`; they do not display properly in the Lightroom catalog window. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `progressScope:setLowUiPriority( inPrior )`

Allows or disallows capability of user to change ui priority of this progress scope. First supported in version 8.4 of the Lightroom SDK.

SDK: 8.4

#### `progressScope:setPausable( pausable, cancelable )`

Allows or disallows capability of user to pause this progress scope. First supported in version 7.5 of the Lightroom SDK.

SDK: 7.5

#### `progressScope:setPortionComplete( amountDone, totalAmount )`

Sets the portion of this task that has been completed. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `progressScope:type()`

Reports the type of this object. First supported in version 4.1 of the Lightroom SDK.

Returns: (string) 'LrProgressScope'.

SDK: 4.1

## LrRecursionGuard

This namespace and class provides a simple recursion guard for function execution. The typical case for using this is to prevent a chain of observation handlers from triggering infinite recursion. Use the imported namespace as a constructor; access the functions through the created objects.

Source: `sdk-source/API Reference/modules/LrRecursionGuard.html`

### Methods

| Method | Returns | SDK | Description |
|---|---|---|---|
| `LrRecursionGuard( name )` | - | 2.0 | Creates a new recursion guard. First supported in version 2.0 of the Lightroom SDK. |
| `recursionGuard:performWithGuard( func, ... )` | - | 2.0 | Calls a function, but only if we are not already inside a call that has been guarded by this guard. If `recursionGuard.active == true`, does nothing. First supported in version 2.0 of the Lightroom SDK. |

### Method Details

#### `LrRecursionGuard( name )`

Creates a new recursion guard. First supported in version 2.0 of the Lightroom SDK.

SDK: 2.0

#### `recursionGuard:performWithGuard( func, ... )`

Calls a function, but only if we are not already inside a call that has been guarded by this guard. If `recursionGuard.active == true`, does nothing. First supported in version 2.0 of the Lightroom SDK.

SDK: 2.0

### Properties

| Property | Notes | Description |
|---|---|---|
| `recursionGuard.active` | (Read-Only) | (Boolean) True if this recursion guard is currently active; that is, currently inside a call to `recursionGuard:performWithGuard()`. First supported in version 2.0 of the Lightroom SDK. |

## LrSelection

This namespace provides access to the selection-based commands. Commands in this namespace that modify photos in the "selection" behave just like the main menu commands: if the grid view is currently visible then they apply to all selected photos, otherwise they only apply to the active photo. Access the functions directly from the imported namespace.

Source: `sdk-source/API Reference/modules/LrSelection.html`

### Methods

| Method | Returns | SDK | Description |
|---|---|---|---|
| `LrSelection.clearLabels()` | - | 6.0 | Clears all color labels from the selection. First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.decreaseRating()` | - | 6.0 | Decreases the rating of the selection. First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.deselectActive()` | - | 6.0 | Removes the active photo from the selection. First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.deselectOthers()` | - | 6.0 | Deselects all photos except for the active photo. First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.extendSelection( direction, amount )` | - | 6.0 | Extends the existing selection, selecting more photos to its beginning or end. Behaves exactly like the Shift+Left/Right Arrow keys in Library grid. First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.flagAsPick()` | - | 6.0 | Sets the flag state of the selction to pick. First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.flagAsReject()` | - | 6.0 | Sets the flag state of the selection to reject. First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.getColorLabel()` | (string) The current color label, one of: "red", "yellow", "green", "blue", "purple", "other", or "none". | 6.0 | Returns the color label assigned to the active photo, one of: "red", "yellow", "green", "blue", "purple", "other", or "none". The underlying metadata values that these names map to will depend on the current Color Label Set. The default label set maps these names to "Red", "Yellow", "Green", "Blue", and "Purple". The return value "other" indicates that the photo has a label that does not match any values in the current set. First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.getFlag()` | - | 6.0 | Returns the pick flag state of the active photo as a number (-1 = reject, 0 = none, 1 = pick). First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.getRating()` | - | 6.0 | Returns the rating of the selection as a number (0-5). First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.increaseRating()` | - | 6.0 | Increases the rating of the selection. First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.nextPhoto()` | - | 6.0 | Advances the selection to the next photo in the filmstrip. First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.previousPhoto()` | - | 6.0 | Advances the selection to the previous photo in the filmstrip. First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.removeFlag()` | - | 6.0 | Clears the flag state of the selection. First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.selectAll()` | - | 6.0 | Selects all photos in the filmstrip. First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.selectFirstPhoto()` | - | 6.0 | Selects the first photo in the selection, or in the entire filmstrip if there is no selection. Only available in the Library module. First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.selectInverse()` | - | 6.0 | Inverts the selection in the filmstrip. First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.selectLastPhoto()` | - | 6.0 | Selects the last photo in the selection, or in the entire filmstrip if there is no selection. Only available in the Library module. First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.selectNone()` | - | 6.0 | Deselects all photos in the filmstrip. First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.setColorLabel( label )` | - | 6.0 | Sets the color label of the selection, one of: "red", "yellow", "green", "blue", "purple", or "none". The underlying metadata values that these names map to will depend on the current Color Label Set. The default label set maps these names to "Red", "Yellow", "Green", "Blue", and "Purple". First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.setRating( rating )` | - | 6.0 | Sets the rating of the selection. First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.toggleBlueLabel()` | - | 6.0 | Toggles the state of the Blue color label of the selection. First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.toggleGreenLabel()` | - | 6.0 | Toggles the state of the Green color label of the selection. First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.togglePurpleLabel()` | - | 6.0 | Toggles the state of the Purple color label of the selection. First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.toggleRedLabel()` | - | 6.0 | Toggles the state of the Red color label of the selection. First supported in version 6.0 of the Lightroom SDK. |
| `LrSelection.toggleYellowLabel()` | - | 6.0 | Toggles the state of the Yellow color label of the selection. First supported in version 6.0 of the Lightroom SDK. |

### Method Details

#### `LrSelection.clearLabels()`

Clears all color labels from the selection. First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

#### `LrSelection.decreaseRating()`

Decreases the rating of the selection. First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

#### `LrSelection.deselectActive()`

Removes the active photo from the selection. First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

#### `LrSelection.deselectOthers()`

Deselects all photos except for the active photo. First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

#### `LrSelection.extendSelection( direction, amount )`

Extends the existing selection, selecting more photos to its beginning or end. Behaves exactly like the Shift+Left/Right Arrow keys in Library grid. First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

#### `LrSelection.flagAsPick()`

Sets the flag state of the selction to pick. First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

#### `LrSelection.flagAsReject()`

Sets the flag state of the selection to reject. First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

#### `LrSelection.getColorLabel()`

Returns the color label assigned to the active photo, one of: "red", "yellow", "green", "blue", "purple", "other", or "none". The underlying metadata values that these names map to will depend on the current Color Label Set. The default label set maps these names to "Red", "Yellow", "Green", "Blue", and "Purple". The return value "other" indicates that the photo has a label that does not match any values in the current set. First supported in version 6.0 of the Lightroom SDK.

Returns: (string) The current color label, one of: "red", "yellow", "green", "blue", "purple", "other", or "none".

SDK: 6.0

#### `LrSelection.getFlag()`

Returns the pick flag state of the active photo as a number (-1 = reject, 0 = none, 1 = pick). First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

#### `LrSelection.getRating()`

Returns the rating of the selection as a number (0-5). First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

#### `LrSelection.increaseRating()`

Increases the rating of the selection. First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

#### `LrSelection.nextPhoto()`

Advances the selection to the next photo in the filmstrip. First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

#### `LrSelection.previousPhoto()`

Advances the selection to the previous photo in the filmstrip. First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

#### `LrSelection.removeFlag()`

Clears the flag state of the selection. First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

#### `LrSelection.selectAll()`

Selects all photos in the filmstrip. First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

#### `LrSelection.selectFirstPhoto()`

Selects the first photo in the selection, or in the entire filmstrip if there is no selection. Only available in the Library module. First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

#### `LrSelection.selectInverse()`

Inverts the selection in the filmstrip. First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

#### `LrSelection.selectLastPhoto()`

Selects the last photo in the selection, or in the entire filmstrip if there is no selection. Only available in the Library module. First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

#### `LrSelection.selectNone()`

Deselects all photos in the filmstrip. First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

#### `LrSelection.setColorLabel( label )`

Sets the color label of the selection, one of: "red", "yellow", "green", "blue", "purple", or "none". The underlying metadata values that these names map to will depend on the current Color Label Set. The default label set maps these names to "Red", "Yellow", "Green", "Blue", and "Purple". First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

#### `LrSelection.setRating( rating )`

Sets the rating of the selection. First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

#### `LrSelection.toggleBlueLabel()`

Toggles the state of the Blue color label of the selection. First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

#### `LrSelection.toggleGreenLabel()`

Toggles the state of the Green color label of the selection. First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

#### `LrSelection.togglePurpleLabel()`

Toggles the state of the Purple color label of the selection. First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

#### `LrSelection.toggleRedLabel()`

Toggles the state of the Red color label of the selection. First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

#### `LrSelection.toggleYellowLabel()`

Toggles the state of the Yellow color label of the selection. First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

## LrShell

This namespace provides access to some operating-system shell functions (Finder in Mac OS, Windows Explorer in Windows). All paths must be provided in platform-specific syntax.

Source: `sdk-source/API Reference/modules/LrShell.html`

### Methods

| Method | Returns | SDK | Description |
|---|---|---|---|
| `LrShell.openFilesInApp( files, appPath )` | - | 1.3 | Opens one or more files in another application. For example: `LrShell.openFilesInApp( { "/Users/example/myLightroomPlugin.lrplugin/Info.lua" }, "/Applications/TextEdit.app" )` NOTE: Windows has a maximum limit on the length of any command line it can process. In order to avoid this limit, Lightroom may have to split up large batches of files and make multiple calls to your command-line process. Windows documentation suggests that this limit is 8000 characters, but practical testing shows it to be much lower. Lightroom splits command lines that exceed 1500 characters (total length of command-line application name, extra arguments, and file names after escaping). There appears to be no such limit in Mac OS, so this function always causes one and only one invocation of the command-line process. First supported in version 1.3 of the Lightroom SDK. |
| `LrShell.openPathsViaCommandLine( files, appPath, extraArgs )` | - | 3.0 | Opens one or more files via a command-line process. For example: `LrShell.openFilesInCommandLineProcess( { "/Users/example/myLightroomPlugin.lrplugin/Info.lua" }, "/usr/bin/edit", "-w" )` NOTE: Windows has a maximum limit on the length of any command line it can process. In order to avoid this limit, Lightroom may have to split up large batches of files and make multiple calls to your command-line process. Windows documentation suggests that this limit is 8000 characters, but practical testing shows it to be much lower. Lightroom splits command lines that exceed 1500 characters (total length of command-line application name, extra arguments, and file names after escaping). There appears to be no such limit in Mac OS, so this function always causes one and only one invocation of the command-line process. Note: Due to the implementation of `fork()` in Mac OS, multiple calls to this function are executed sequentially, even if run from separate tasks. First supported in version 3.0 of the Lightroom SDK. |
| `LrShell.revealInShell( path )` | - | 1.3 | Brings the Finder or Explorer to the foreground and highlights a file. First supported in version 1.3 of the Lightroom SDK. |

### Method Details

#### `LrShell.openFilesInApp( files, appPath )`

Opens one or more files in another application. For example: `LrShell.openFilesInApp( { "/Users/example/myLightroomPlugin.lrplugin/Info.lua" }, "/Applications/TextEdit.app" )` NOTE: Windows has a maximum limit on the length of any command line it can process. In order to avoid this limit, Lightroom may have to split up large batches of files and make multiple calls to your command-line process. Windows documentation suggests that this limit is 8000 characters, but practical testing shows it to be much lower. Lightroom splits command lines that exceed 1500 characters (total length of command-line application name, extra arguments, and file names after escaping). There appears to be no such limit in Mac OS, so this function always causes one and only one invocation of the command-line process. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `LrShell.openPathsViaCommandLine( files, appPath, extraArgs )`

Opens one or more files via a command-line process. For example: `LrShell.openFilesInCommandLineProcess( { "/Users/example/myLightroomPlugin.lrplugin/Info.lua" }, "/usr/bin/edit", "-w" )` NOTE: Windows has a maximum limit on the length of any command line it can process. In order to avoid this limit, Lightroom may have to split up large batches of files and make multiple calls to your command-line process. Windows documentation suggests that this limit is 8000 characters, but practical testing shows it to be much lower. Lightroom splits command lines that exceed 1500 characters (total length of command-line application name, extra arguments, and file names after escaping). There appears to be no such limit in Mac OS, so this function always causes one and only one invocation of the command-line process. Note: Due to the implementation of `fork()` in Mac OS, multiple calls to this function are executed sequentially, even if run from separate tasks. First supported in version 3.0 of the Lightroom SDK.

SDK: 3.0

#### `LrShell.revealInShell( path )`

Brings the Finder or Explorer to the foreground and highlights a file. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

## LrSlideshow

This namespace provides access to Slideshow commands. Access the functions directly from the imported namespace.

Source: `sdk-source/API Reference/modules/LrSlideshow.html`

### Methods

| Method | Returns | SDK | Description |
|---|---|---|---|
| `LrSlideshow.startSlideshow()` | - | 6.0 | Begins an impromptu slideshow using the photos currently in the filmstrip. First supported in version 6.0 of the Lightroom SDK. |
| `LrSlideshow.stopSlideshow()` | - | 6.0 | Stops a running slideshow. First supported in version 6.0 of the Lightroom SDK. |

### Method Details

#### `LrSlideshow.startSlideshow()`

Begins an impromptu slideshow using the photos currently in the filmstrip. First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

#### `LrSlideshow.stopSlideshow()`

Stops a running slideshow. First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

## LrSocket

This namespace is used to send and receive data from other processes using sockets. Example usage: `local LrSocket = import "LrSocket" local LrTasks = import "LrTasks" import "LrTasks".startAsyncTask( function() LrFunctionContext.callWithContext( 'socket_remote', function( context ) local running = true local sender = LrSocket.bind { functionContext = context, port = 0, -- (let the OS assign the port) mode = "send", onConnecting = function( socket, port ) -- TODO end, onConnected = function( socket, port ) -- TODO end, onMessage = function( socket, message ) -- nothing, we don't expect to get any messages back from a send port end, onClosed = function( socket ) running = false end, onError = function( socket, err ) if err == "timeout" then socket:reconnect() end end, } sender:send( "Hello world" ) while running do LrTasks.sleep( 1/2 ) -- seconds end sender:close() end ) end )`

Source: `sdk-source/API Reference/modules/LrSocket.html`

### Methods

| Method | Returns | SDK | Description |
|---|---|---|---|
| `LrSocket.bind( params )` | - | 6.0 | Opens a socket connection (on localhost) for either reading or writing operations. First supported in version 6.0 of the Lightroom SDK. The socket is automatically closed if the plug-in is disabled or removed by the user. |
| `socket:close()` | - | 6.0 | Closes a socket connection. First supported in version 6.0 of the Lightroom SDK. |
| `socket:reconnect()` | - | 6.0 | Asks a socket to restablish its connection. First supported in version 6.0 of the Lightroom SDK. |
| `socket:send( message )` | - | 6.0 | Sends a message via a "send" mode socket. First supported in version 6.0 of the Lightroom SDK. |
| `socket:type()` | (string) 'LrSocket'. | 6.0 | Reports the type of this object. First supported in version 6.0 of the Lightroom SDK. |

### Method Details

#### `LrSocket.bind( params )`

Opens a socket connection (on localhost) for either reading or writing operations. First supported in version 6.0 of the Lightroom SDK. The socket is automatically closed if the plug-in is disabled or removed by the user.

SDK: 6.0

#### `socket:close()`

Closes a socket connection. First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

#### `socket:reconnect()`

Asks a socket to restablish its connection. First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

#### `socket:send( message )`

Sends a message via a "send" mode socket. First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

#### `socket:type()`

Reports the type of this object. First supported in version 6.0 of the Lightroom SDK.

Returns: (string) 'LrSocket'.

SDK: 6.0

## LrSounds

This namespace provides functions for playing sounds. Access the functions directly from the imported namespace.

Source: `sdk-source/API Reference/modules/LrSounds.html`

### Methods

| Method | Returns | SDK | Description |
|---|---|---|---|
| `LrSounds.getSystemSounds()` | (table) Array of sounds. | 6.0 | Returns an array of system sounds that can be played via playSystemSound. Each element in the array has a "title" attribute to identify it. The list of available sounds is platform-specific. This function must be called from within an asynchronous task started using `LrTasks`. First supported in version 6.0 of the Lightroom SDK. |
| `LrSounds.playSystemSound( systemSound )` | - | 6.0 | Plays a system sound. This function must be called from within an asynchronous task started using `LrTasks`. First supported in version 6.0 of the Lightroom SDK. |

### Method Details

#### `LrSounds.getSystemSounds()`

Returns an array of system sounds that can be played via playSystemSound. Each element in the array has a "title" attribute to identify it. The list of available sounds is platform-specific. This function must be called from within an asynchronous task started using `LrTasks`. First supported in version 6.0 of the Lightroom SDK.

Returns: (table) Array of sounds.

SDK: 6.0

#### `LrSounds.playSystemSound( systemSound )`

Plays a system sound. This function must be called from within an asynchronous task started using `LrTasks`. First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

## LrStringUtils

This namespace provides utility functions for string manipulation. All of these functions assume UTF-8 encoding for strings, unless a different encoding is specifically mentioned in the documentation. Access the functions directly from the imported namespace.

Source: `sdk-source/API Reference/modules/LrStringUtils.html`

### Methods

| Method | Returns | SDK | Description |
|---|---|---|---|
| `LrStringUtils.byteString( number, precision )` | - | 1.3 | Converts a number into a string representation suitable for displaying byte values. The function transforms the number appropriately and adds an indicator for bytes, kilobytes, megabytes, and so on. For example, a number n between 1 and 1024 results in the string "n bytes". A number between 1024 and 1024^2 results in the string "n KB", and so on. The byte indicators are "bytes", "KB", "MB", "GB", "TB", and "PB" First supported in version 1.3 of the Lightroom SDK. |
| `LrStringUtils.compareStrings( string1, string2, treatNumberAsString )` | - | 1.3 | Compares two strings using the operating system's localized string comparison. This is a wrapper for Lua's `table.sort` function, with this function as the comparator. Optional parameter treatNumberAsString decides whether to treat numbers is strings as numbers or normal string. For example, `LrStringUtils.compareStrings("ab10c", "ab7c")` returns false because 10 > 7 `LrStringUtils.compareStrings("ab10c", "ab7c", true)` returns true because 1 < 7 First supported in version 1.3 of the Lightroom SDK. |
| `LrStringUtils.decodeBase64( string )` | - | 1.3 | Decodes a string from base-64 encoding. First supported in version 1.3 of the Lightroom SDK. |
| `LrStringUtils.encodeBase64( string )` | - | 1.3 | Encodes a string in base-64 encoding. First supported in version 1.3 of the Lightroom SDK. |
| `LrStringUtils.isOnlyAscii( string )` | - | 1.3 | Reports whether a string contains only 7-bit ASCII characters. First supported in version 1.3 of the Lightroom SDK. |
| `LrStringUtils.localizedStringSort( strings )` | - | 1.3 | Sorts an array of strings in-place, using the operating system's localized string comparison. First supported in version 1.3 of the Lightroom SDK. |
| `LrStringUtils.lower( string )` | - | 1.3 | Converts a string to lowercase using the operating system's localized case conversion. Unlike the Lua `string.lower` function, this function properly converts characters outside the 7-bit ASCII space. First supported in version 1.3 of the Lightroom SDK. |
| `LrStringUtils.numberToString( number, precision )` | - | 1.3 | Formats a number as a string with an optional limit on precision. Does not insert separators for thousands. For example, `LrStringUtils.numberToString( 43500, 2 )` returns "43500.00", not "43,500.00"). First supported in version 1.3 of the Lightroom SDK. |
| `LrStringUtils.numberToStringWithSeparators( number, precision )` | - | - | Formats a number as a string with thousands separators with an optional limit on precision. Insert thousands separators with the correct grouping according to user locale. For example, `LrStringUtils.numberToString( 43500, 2 )` returns "43,500.00", not "43500.00"). |
| `LrStringUtils.trimWhitespace( string )` | - | 1.3 | Removes whitespace from the beginning and end of a string. First supported in version 1.3 of the Lightroom SDK. |
| `LrStringUtils.truncate( string, maxBytes )` | - | 1.3 | Truncates a string to a maximum number of bytes, preserving the validity of the UTF-8 encoding. First supported in version 1.3 of the Lightroom SDK. |
| `LrStringUtils.upper( string )` | - | 1.3 | Converts a string to uppercase using the operating system's localized case conversion. Unlike the Lua `string.upper` function, this function properly converts characters outside the 7-bit ASCII space. First supported in version 1.3 of the Lightroom SDK. |

### Method Details

#### `LrStringUtils.byteString( number, precision )`

Converts a number into a string representation suitable for displaying byte values. The function transforms the number appropriately and adds an indicator for bytes, kilobytes, megabytes, and so on. For example, a number n between 1 and 1024 results in the string "n bytes". A number between 1024 and 1024^2 results in the string "n KB", and so on. The byte indicators are "bytes", "KB", "MB", "GB", "TB", and "PB" First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `LrStringUtils.compareStrings( string1, string2, treatNumberAsString )`

Compares two strings using the operating system's localized string comparison. This is a wrapper for Lua's `table.sort` function, with this function as the comparator. Optional parameter treatNumberAsString decides whether to treat numbers is strings as numbers or normal string. For example, `LrStringUtils.compareStrings("ab10c", "ab7c")` returns false because 10 > 7 `LrStringUtils.compareStrings("ab10c", "ab7c", true)` returns true because 1 < 7 First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `LrStringUtils.decodeBase64( string )`

Decodes a string from base-64 encoding. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `LrStringUtils.encodeBase64( string )`

Encodes a string in base-64 encoding. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `LrStringUtils.isOnlyAscii( string )`

Reports whether a string contains only 7-bit ASCII characters. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `LrStringUtils.localizedStringSort( strings )`

Sorts an array of strings in-place, using the operating system's localized string comparison. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `LrStringUtils.lower( string )`

Converts a string to lowercase using the operating system's localized case conversion. Unlike the Lua `string.lower` function, this function properly converts characters outside the 7-bit ASCII space. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `LrStringUtils.numberToString( number, precision )`

Formats a number as a string with an optional limit on precision. Does not insert separators for thousands. For example, `LrStringUtils.numberToString( 43500, 2 )` returns "43500.00", not "43,500.00"). First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `LrStringUtils.numberToStringWithSeparators( number, precision )`

Formats a number as a string with thousands separators with an optional limit on precision. Insert thousands separators with the correct grouping according to user locale. For example, `LrStringUtils.numberToString( 43500, 2 )` returns "43,500.00", not "43500.00").

#### `LrStringUtils.trimWhitespace( string )`

Removes whitespace from the beginning and end of a string. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `LrStringUtils.truncate( string, maxBytes )`

Truncates a string to a maximum number of bytes, preserving the validity of the UTF-8 encoding. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `LrStringUtils.upper( string )`

Converts a string to uppercase using the operating system's localized case conversion. Unlike the Lua `string.upper` function, this function properly converts characters outside the 7-bit ASCII space. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

## LrSystemInfo

This namespace allows you to gather information about the user's computer and operating system. Access the functions directly from the imported namespace.

Source: `sdk-source/API Reference/modules/LrSystemInfo.html`

### Methods

| Method | Returns | SDK | Description |
|---|---|---|---|
| `LrSystemInfo.appWindowSize()` | - | - | Reports the size of the main Lightroom application window. Return values (number) Width of Lightroom's main application window, in pixels (number) Height of Lightroom's main application window, in pixels |
| `LrSystemInfo.architecture()` | (string) System architecture, one of 'x86', 'x64', 'ppc', or 'ppc64'. | - | Reports the CPU architecture of the host computer. |
| `LrSystemInfo.displayInfo()` | (table) An array of tables, one per display, each with these entries: width (number) Width of the display in pixels. height (number) Height of the display in pixels. isMain (Boolean) True if the display is the main system display. hasAppMain (Boolean) True if the main Lightroom window is currently hosted on the display. | - | Reports information about the displays available to the system. |
| `LrSystemInfo.ipAddress()` | (string) The IP address. | 6.0 | Retrieves the IP address of the system running Lightroom. First supported in version 6.0 of the Lightroom SDK. |
| `LrSystemInfo.is64Bit()` | (Boolean) True if on 64-bit OS; false otherwise | - | Reports whether the host is running a 64-bit operating system. |
| `LrSystemInfo.isGCOptimizationEnabled()` | (Boolean) True if GC Optimization is enabled; false if GC Optimization is disabled. | - | Reports whether GC Optimization is enabled or not. |
| `LrSystemInfo.isSyncEnabled()` | (Boolean) True if sync is enabled; false if sync is disabled or paused. | - | Reports whether Sync is enabeld or not. |
| `LrSystemInfo.memSize()` | (number) Size of physical memory in bytes. | - | Reports the amount of physical RAM installed on the host computer. |
| `LrSystemInfo.numCPUs()` | (number) Number of CPUs or CPU cores. | - | Reports the number of CPUs on the host computer system. Typically counts each core on a multi-core system. |
| `LrSystemInfo.osVersion()` | (string) A string description of the OS version, such as "Microsoft Windows XP Professional Service Pack 3 (Build 2600)". | - | Reports the version of the current operating system. Use only for reporting purposes. Do not attempt to parse this string. |
| `LrSystemInfo.summaryString()` | (string) A string description of the system information, such as "Microsoft Windows XP Professional Service Pack 3 (Build 2600) (x86)". | - | Returns a summary of system information. Use only for reporting purposes. Do not attempt to parse this string. |

### Method Details

#### `LrSystemInfo.appWindowSize()`

Reports the size of the main Lightroom application window. Return values (number) Width of Lightroom's main application window, in pixels (number) Height of Lightroom's main application window, in pixels

#### `LrSystemInfo.architecture()`

Reports the CPU architecture of the host computer.

Returns: (string) System architecture, one of 'x86', 'x64', 'ppc', or 'ppc64'.

#### `LrSystemInfo.displayInfo()`

Reports information about the displays available to the system.

Returns: (table) An array of tables, one per display, each with these entries: width (number) Width of the display in pixels. height (number) Height of the display in pixels. isMain (Boolean) True if the display is the main system display. hasAppMain (Boolean) True if the main Lightroom window is currently hosted on the display.

#### `LrSystemInfo.ipAddress()`

Retrieves the IP address of the system running Lightroom. First supported in version 6.0 of the Lightroom SDK.

Returns: (string) The IP address.

SDK: 6.0

#### `LrSystemInfo.is64Bit()`

Reports whether the host is running a 64-bit operating system.

Returns: (Boolean) True if on 64-bit OS; false otherwise

#### `LrSystemInfo.isGCOptimizationEnabled()`

Reports whether GC Optimization is enabled or not.

Returns: (Boolean) True if GC Optimization is enabled; false if GC Optimization is disabled.

#### `LrSystemInfo.isSyncEnabled()`

Reports whether Sync is enabeld or not.

Returns: (Boolean) True if sync is enabled; false if sync is disabled or paused.

#### `LrSystemInfo.memSize()`

Reports the amount of physical RAM installed on the host computer.

Returns: (number) Size of physical memory in bytes.

#### `LrSystemInfo.numCPUs()`

Reports the number of CPUs on the host computer system. Typically counts each core on a multi-core system.

Returns: (number) Number of CPUs or CPU cores.

#### `LrSystemInfo.osVersion()`

Reports the version of the current operating system. Use only for reporting purposes. Do not attempt to parse this string.

Returns: (string) A string description of the OS version, such as "Microsoft Windows XP Professional Service Pack 3 (Build 2600)".

#### `LrSystemInfo.summaryString()`

Returns a summary of system information. Use only for reporting purposes. Do not attempt to parse this string.

Returns: (string) A string description of the system information, such as "Microsoft Windows XP Professional Service Pack 3 (Build 2600) (x86)".

## LrTether

This namespace provides control over tethered shooting. Access the functions directly from the imported namespace.

Source: `sdk-source/API Reference/modules/LrTether.html`

### Methods

| Method | Returns | SDK | Description |
|---|---|---|---|
| `LrTether.getAdvanceSelectionOnTetheredCapture()` | (boolean) The advance selection preference. | 6.0 | Returns boolean indicating whether or not each new tethered capture photo is selected. First supported in version 6.0 of the Lightroom SDK. |
| `LrTether.isTetherActive()` | (boolean) True if tethered capture is active. | 6.0 | Returns boolean indicating if a tethered capture session is running. First supported in version 6.0 of the Lightroom SDK. |
| `LrTether.numDownloadsPending()` | (number) The number of photos currently being downloaded from a tethered capture. | 6.0 | Returns the number of photos currently being downloaded from the tethered camera. First supported in version 6.0 of the Lightroom SDK. |
| `LrTether.setAdvanceSelectionOnTetheredCapture( advance )` | - | 6.0 | Sets the preference controlling whether or not each new tethered capture photo is selected. First supported in version 6.0 of the Lightroom SDK. |
| `LrTether.startTether()` | - | 6.0 | Starts a tethered capture session. First supported in version 6.0 of the Lightroom SDK. |
| `LrTether.stopTether()` | - | 6.1 | Stops a tethered capture session. First supported in version 6.1 of the Lightroom SDK. |
| `LrTether.triggerCapture()` | - | 6.0 | Triggers a tethered capture. Does nothing if a tether session is not active. First supported in version 6.0 of the Lightroom SDK. |
| `LrTether.triggerCaptureBlocking()` | (boolean) True if capture was successful, false if a problem occurred. | 6.0 | Triggers a tethered capture, blocking until finished. This function must be called from within an asynchronous task started using `LrTasks`. First supported in version 6.0 of the Lightroom SDK. |

### Method Details

#### `LrTether.getAdvanceSelectionOnTetheredCapture()`

Returns boolean indicating whether or not each new tethered capture photo is selected. First supported in version 6.0 of the Lightroom SDK.

Returns: (boolean) The advance selection preference.

SDK: 6.0

#### `LrTether.isTetherActive()`

Returns boolean indicating if a tethered capture session is running. First supported in version 6.0 of the Lightroom SDK.

Returns: (boolean) True if tethered capture is active.

SDK: 6.0

#### `LrTether.numDownloadsPending()`

Returns the number of photos currently being downloaded from the tethered camera. First supported in version 6.0 of the Lightroom SDK.

Returns: (number) The number of photos currently being downloaded from a tethered capture.

SDK: 6.0

#### `LrTether.setAdvanceSelectionOnTetheredCapture( advance )`

Sets the preference controlling whether or not each new tethered capture photo is selected. First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

#### `LrTether.startTether()`

Starts a tethered capture session. First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

#### `LrTether.stopTether()`

Stops a tethered capture session. First supported in version 6.1 of the Lightroom SDK.

SDK: 6.1

#### `LrTether.triggerCapture()`

Triggers a tethered capture. Does nothing if a tether session is not active. First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

#### `LrTether.triggerCaptureBlocking()`

Triggers a tethered capture, blocking until finished. This function must be called from within an asynchronous task started using `LrTasks`. First supported in version 6.0 of the Lightroom SDK.

Returns: (boolean) True if capture was successful, false if a problem occurred.

SDK: 6.0

## LrUndo

This namespace provides access to undo/redo commands. Access the functions directly from the imported namespace.

Source: `sdk-source/API Reference/modules/LrUndo.html`

### Methods

| Method | Returns | SDK | Description |
|---|---|---|---|
| `LrUndo.canRedo()` | - | 6.0 | Returns true of the redo command is currently enabled. First supported in version 6.0 of the Lightroom SDK. |
| `LrUndo.canUndo()` | - | 6.0 | Returns true of the undo command is currently enabled. First supported in version 6.0 of the Lightroom SDK. |
| `LrUndo.redo()` | - | 6.0 | Redoes the last undone history state. First supported in version 6.0 of the Lightroom SDK. |
| `LrUndo.undo()` | - | 6.0 | Undoes the last history state. First supported in version 6.0 of the Lightroom SDK. |

### Method Details

#### `LrUndo.canRedo()`

Returns true of the redo command is currently enabled. First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

#### `LrUndo.canUndo()`

Returns true of the undo command is currently enabled. First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

#### `LrUndo.redo()`

Redoes the last undone history state. First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

#### `LrUndo.undo()`

Undoes the last history state. First supported in version 6.0 of the Lightroom SDK.

SDK: 6.0

## LrXml

This namespace and class allows you create and examine XML documents. The namespace functions allow you to create an XML builder object, and to parse existing XML documents into read-only XML DOM objects. The XML builder object (`builderInstance`) allows you to create and manipulate XML documents. The XML DOM object (`xmlDomInstance`) is read-only, and allows you to examine an existing XML document. Text values added to or retrieved from the XML document will automatically be entity encoded and decoded, where required by the XML 1.1 recommendation. Please refer to the recommendation (especially sections 2.4 and 4.6) for definitions of the entities supported and when their use is required.

Source: `sdk-source/API Reference/modules/LrXml.html`

### Methods

| Method | Returns | SDK | Description |
|---|---|---|---|
| `LrXml.createXmlBuilder( omitDeclaration )` | - | 1.3 | Creates an XML builder object (`builderInstance`) for constructing an XML document. Use the methods of the resulting object to create the document contents, and to serialize the resulting XML into a string. First supported in version 1.3 of the Lightroom SDK. |
| `LrXml.parseXml( xmlString )` | - | 1.3 | Parses a string containing valid XML to create and return a read-only XML DOM object (`xmlDomInstance`) which you can use to examine the XML content. The returned DOM object is the root of a tree of DOM objects for the XML nodes in the document. Use the `xmlDomInstance` functions to traverse the node tree. The DOM object is an interface to a platform-specific XML parser. There can be variation in how whitespace, XML processing instructions, and other subtle aspects of XML are handled. Use caution when parsing XML. Do not assume elements are at a particular index. Instead, iterate child nodes and test by name and type to find a particular node. For example one parser might return a text node for the whitespace separating two elements, while another removes the whitespace; or one might skip comments while another includes them. First supported in version 1.3 of the Lightroom SDK. |
| `builderInstance:append( otherXmlBuilder )` | - | 1.3 | Appends all the XML in another `builderInstance` to this one at the current point.The other object must not have any unclosed blocks. First supported in version 1.3 of the Lightroom SDK. |
| `builderInstance:beginBlock( name, attributes )` | - | 1.3 | Adds an XML opening tag to this XML document. This must be closed later by a call to `endBlock()`. First supported in version 1.3 of the Lightroom SDK. |
| `builderInstance:comment( contents )` | - | 1.3 | Appends an XML comment to this XML document. First supported in version 1.3 of the Lightroom SDK. |
| `builderInstance:endBlock()` | - | 1.3 | Adds an XML closing tag to this XML document. This must be balance a preceding call to `beginBlock()`. First supported in version 1.3 of the Lightroom SDK. |
| `builderInstance:serialize()` | (string) The serialized XML document. | 1.3 | Retrieves the complete XML document as a string. First supported in version 1.3 of the Lightroom SDK. |
| `builderInstance:tag( name, value, attributes )` | - | 1.3 | Adds a single tag to this XML document, with an optional text child node. First supported in version 1.3 of the Lightroom SDK. |
| `builderInstance:text( value )` | - | 1.3 | Adds a text node to this XML document. First supported in version 1.3 of the Lightroom SDK. |
| `xmlDomInstance:attributes()` | (table) The attributes as a table, keyed by attribute name. Each entry is itself a table containing keys for "value", "namespace", and "name". If this is not an element node, returns nil. | 1.3 | Retrieves the attributes of this element node. First supported in version 1.3 of the Lightroom SDK. |
| `xmlDomInstance:childAtIndex( index )` | - | 1.3 | Retrieves a child of this element node by index. First supported in version 1.3 of the Lightroom SDK. |
| `xmlDomInstance:childCount()` | (number) The number of children, or nil if this node is not an element node. | 1.3 | Reports the number of children of this element node. First supported in version 1.3 of the Lightroom SDK. |
| `xmlDomInstance:name()` | - | 1.3 | Retrieves the name of the `xml` node from this XML document. First supported in version 1.3 of the Lightroom SDK. Return values (string) The name of the `xml` node. (string) The namespace of the `xml` node. |
| `xmlDomInstance:serialize()` | (string) The XML as a string. | 1.3 | Converts the XML encapsulated by this object into its string representation. The result does not include an XML declaration. First supported in version 1.3 of the Lightroom SDK. |
| `xmlDomInstance:text()` | (string) The text of the `xml` node. | 3.0 | Retrieves the text of the `xml` node from this XML document. First supported in version 3.0 of the Lightroom SDK. |
| `xmlDomInstance:transform( xsltString )` | - | 1.3 | Transforms this XML into string output by applying an XSLT transformation. Depending on the operating system, the result of the transform can contain different amounts and/or kinds of whitespace. To normalize the result, apply a substitution pattern such as this: `string.gsub( result, "[\r\n ]+", " " )` This must be called on the root node. Note: The error messages from this function can be misleading. If you see the message "out of memory", you may want to review the application or OS console for other messages that may be more helpful. First supported in version 1.3 of the Lightroom SDK. |
| `xmlDomInstance:type()` | (string) The node type, one of "element", "text", "comment", "processinginstruction" | 1.3 | Retrieves the type of the `xml` node from this XML document. First supported in version 1.3 of the Lightroom SDK. |

### Method Details

#### `LrXml.createXmlBuilder( omitDeclaration )`

Creates an XML builder object (`builderInstance`) for constructing an XML document. Use the methods of the resulting object to create the document contents, and to serialize the resulting XML into a string. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `LrXml.parseXml( xmlString )`

Parses a string containing valid XML to create and return a read-only XML DOM object (`xmlDomInstance`) which you can use to examine the XML content. The returned DOM object is the root of a tree of DOM objects for the XML nodes in the document. Use the `xmlDomInstance` functions to traverse the node tree. The DOM object is an interface to a platform-specific XML parser. There can be variation in how whitespace, XML processing instructions, and other subtle aspects of XML are handled. Use caution when parsing XML. Do not assume elements are at a particular index. Instead, iterate child nodes and test by name and type to find a particular node. For example one parser might return a text node for the whitespace separating two elements, while another removes the whitespace; or one might skip comments while another includes them. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `builderInstance:append( otherXmlBuilder )`

Appends all the XML in another `builderInstance` to this one at the current point.The other object must not have any unclosed blocks. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `builderInstance:beginBlock( name, attributes )`

Adds an XML opening tag to this XML document. This must be closed later by a call to `endBlock()`. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `builderInstance:comment( contents )`

Appends an XML comment to this XML document. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `builderInstance:endBlock()`

Adds an XML closing tag to this XML document. This must be balance a preceding call to `beginBlock()`. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `builderInstance:serialize()`

Retrieves the complete XML document as a string. First supported in version 1.3 of the Lightroom SDK.

Returns: (string) The serialized XML document.

SDK: 1.3

#### `builderInstance:tag( name, value, attributes )`

Adds a single tag to this XML document, with an optional text child node. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `builderInstance:text( value )`

Adds a text node to this XML document. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `xmlDomInstance:attributes()`

Retrieves the attributes of this element node. First supported in version 1.3 of the Lightroom SDK.

Returns: (table) The attributes as a table, keyed by attribute name. Each entry is itself a table containing keys for "value", "namespace", and "name". If this is not an element node, returns nil.

SDK: 1.3

#### `xmlDomInstance:childAtIndex( index )`

Retrieves a child of this element node by index. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `xmlDomInstance:childCount()`

Reports the number of children of this element node. First supported in version 1.3 of the Lightroom SDK.

Returns: (number) The number of children, or nil if this node is not an element node.

SDK: 1.3

#### `xmlDomInstance:name()`

Retrieves the name of the `xml` node from this XML document. First supported in version 1.3 of the Lightroom SDK. Return values (string) The name of the `xml` node. (string) The namespace of the `xml` node.

SDK: 1.3

#### `xmlDomInstance:serialize()`

Converts the XML encapsulated by this object into its string representation. The result does not include an XML declaration. First supported in version 1.3 of the Lightroom SDK.

Returns: (string) The XML as a string.

SDK: 1.3

#### `xmlDomInstance:text()`

Retrieves the text of the `xml` node from this XML document. First supported in version 3.0 of the Lightroom SDK.

Returns: (string) The text of the `xml` node.

SDK: 3.0

#### `xmlDomInstance:transform( xsltString )`

Transforms this XML into string output by applying an XSLT transformation. Depending on the operating system, the result of the transform can contain different amounts and/or kinds of whitespace. To normalize the result, apply a substitution pattern such as this: `string.gsub( result, "[\r\n ]+", " " )` This must be called on the root node. Note: The error messages from this function can be misleading. If you see the message "out of memory", you may want to review the application or OS console for other messages that may be more helpful. First supported in version 1.3 of the Lightroom SDK.

SDK: 1.3

#### `xmlDomInstance:type()`

Retrieves the type of the `xml` node from this XML document. First supported in version 1.3 of the Lightroom SDK.

Returns: (string) The node type, one of "element", "text", "comment", "processinginstruction"

SDK: 1.3

