# SDK Sample Plugins & Tutorials

The Lightroom Classic SDK ships with complete sample plugins in `LR_SDK/Sample Plugins/`. These samples demonstrate the full range of plugin types and serve as practical starting points for your own development. This document walks through each sample and the step-by-step tutorials from Chapters 8-11 of the SDK guide.

---

## Chapter 8: SDK Sample Plugin Walkthroughs

### FTP Upload Sample

**Folder:** `ftp_upload.lrdevplugin`

**Purpose:** Export photos directly to an FTP server, demonstrating a complete Export Service Provider that adds a remote upload destination to the Export dialog.

**Key APIs:** `LrExportServiceProvider`, `LrFtp`, `LrDialogs`, `LrBinding`

**Plugin files:**

| File | Role |
|------|------|
| `Info.lua` | Describes the plugin to Lightroom Classic |
| `FtpUploadExportServiceProvider.lua` | The service definition file |
| `FtpUploadExportDialogSections.lua` | Defines initialization routes and Export dialog customizations |
| `FtpUploadTask.lua` | Performs the actual image upload to the FTP server |

**What it demonstrates:**

- **Export service definition:** Registers as an export destination that appears in the Export dialog's destination dropdown. When selected, it loads a custom "FTP Server" section in the dialog.
- **FTP connection setup:** The FTP Server section provides a "Destination" popup with an "Edit" option that opens a configuration dialog for server name, username, password, protocol (default FTP), port (default 21), and server path (with a Browse button for remote filesystem navigation).
- **Preset management:** FTP configurations can be saved as named presets via "Save Current Settings as new Preset" in the configuration dialog.
- **Subfolder support:** A "Put in Subfolder" checkbox enables specifying a subfolder path (default "photos"). Nested paths like `myphotos/myotherfolder/` are supported. Missing folders are created automatically on the server.
- **Rendition iteration and upload:** `FtpUploadTask.lua` implements `processRenderedPhotos` to iterate through each rendered photo and upload it via FTP. The full destination path is displayed at the bottom of the FTP Server section.
- **Progress reporting:** A progress indicator appears in the upper-left corner of the Lightroom catalog window during export, allowing users to monitor upload progress.

---

### Flickr Sample Plugin

**Folder:** `flickr.lrdevplugin`

**Purpose:** Publish photos to Flickr. This is described in the SDK guide as "more than a sample" -- it is most of the source code for Lightroom Classic's built-in Flickr support.

**Key APIs:** `LrPublishServiceProvider`, `LrHttp`, `LrXml`, `LrDialogs`, `LrBinding`

**Plugin files:**

| File | Role |
|------|------|
| `Info.lua` | Describes the plugin to Lightroom Classic |
| `FlickrExportServiceProvider.lua` | The service definition file |
| `FlickrExportDialogSections.lua` | Defines initialization routes and Export/Publishing Manager dialog customizations |
| `FlickrPublishSupport.lua` | Defines the publishing operations for publication to Flickr |
| `FlickrAPI.lua` | Handles Flickr API requests and responses |
| `FlickrUser.lua` | Manages the Flickr user account and authentication |

**What it demonstrates:**

- **Complete publish service workflow:** Unlike a plain export service, a publish service maintains an ongoing relationship between Lightroom and the remote service. Photos move through states: "New Photos to Publish" -> "Published Photos" -> "Modified Photos to Re-Publish."
- **Authentication flow:** The "Flickr Account" section in the Publishing Manager has a "Log In" button. Clicking it triggers an authorization dialog (defined in `FlickrAPI.lua`), which opens the default browser to the Flickr login page. After the user authorizes access, the button changes to "Switch User."
- **Collection management:** A default "Photostream" collection is created when the publish service is established. Users drag photos into it and click "Publish" to trigger rendering and upload.
- **Publish-specific callbacks:**
  - `getCollectionBehaviorInfo` -- controls collection creation and behavior
  - `metadataThatTriggersRepublish` -- defines which metadata changes cause a photo to enter the "Modified" state
  - `deletePhotosFromPublishedCollection` -- handles removal of photos from the remote service
- **Remote photo ID tracking:** After upload, the plugin stores a remote photo ID so Lightroom can track the relationship between local and remote copies. This enables re-publishing modified photos (replacing the existing remote version) and deletion.
- **Comments and ratings:** The plugin retrieves viewer feedback from Flickr and displays it in Lightroom's Comments panel via a "Refresh" button. Ratings correspond to the number of times other users have marked a photo as a favorite.
- **Preset fields and user presets:** Demonstrates creating plugin-defined preset fields and binding settings values to UI components.
- **Localization:** Shows use of ZStrings for localizing display strings.

**Flickr API integration:** The plugin uses the Flickr services API, including authentication endpoints (frob-based auth flow), upload methods, and metadata retrieval. See `http://www.flickr.com/services/api` for the Flickr API reference.

---

### Custom Metadata Sample

**Folder:** `custommetadatasample.lrdevplugin`

**Purpose:** Define custom metadata fields and tagsets for use within Lightroom Classic.

**Key APIs:** `LrMetadataProvider`, `metadataFieldsForPhotos`, `LrMetadataTagsetFactory`

**Plugin files:**

| File | Role |
|------|------|
| `Info.lua` | Plugin description |
| `CustomMetadataDefinition.lua` | Defines custom metadata fields |
| `CustomMetadataTagset.lua` | Custom tagset for the Metadata panel |
| `AllMetadataTagset.lua` | Tagset that includes all metadata |
| `DisplayMetadata.lua` | Dialog to display custom metadata values |
| `PluginInfoProvider.lua` | Customizes the Plug-in Manager dialog |
| `PluginInit.lua` | Plugin initialization and global variables |
| `strings/en/TranslatedString.txt` | English localization dictionary |

**What it demonstrates:**

- **Defining string and enum fields:** Custom fields appear in the Metadata panel under "Custom Metadata" when selected from the panel's dropdown menu.
- **Making fields searchable/browsable:** Setting `searchable = true` allows fields to be used in smart collection criteria.
- **Schema versioning:** The `schemaVersion` property provides version control for field migration -- incrementing it notifies users of changes to the plugin.
- **Plug-in Manager customization:** Adds a custom section to the Plug-in Manager dialog via `LrPluginInfoProvider`, showing global variables and a button that opens URLs via `LrHttp.openUrlInBrowser()`.
- **Plugin initialization:** Uses `LrInitPlugin` to define global variables (prefixed with `_G.`) available throughout the plugin.
- **Localization:** Includes a string dictionary file for translated display strings.
- **Custom dialog via menu item:** Adds a "Custom Metadata Dialog" item under Library > Plug-in Extras that displays a plugin-defined dialog showing metadata values for selected photos.

---

### Metadata Export Filter Sample

**Folder:** `metaexportfilter.lrdevplugin`

**Purpose:** Demonstrate an Export Filter Provider that filters photos based on metadata values during export.

**Key APIs:** `LrExportFilterProvider`, `shouldRenderPhoto()`

**Plugin files:**

| File | Role |
|------|------|
| `Info.lua` | Plugin description |
| `Metadata.lua` | Metadata definitions |
| `MetadataExportFilterProvider` | Export filter logic |

**What it demonstrates:**

- **Export Filter Provider basics:** Appears as "Metadata Post Process" in the Post-Process Actions panel of the Export dialog. Users insert it into the export pipeline by selecting and clicking Insert (or double-clicking).
- **Custom filter dialog section:** When inserted, a dialog section appears allowing users to choose a metadata field (e.g., Title) from a dropdown and enter a value to match against.
- **`shouldRenderPhoto()` usage:** Only photos whose metadata matches the user's choice are exported; all others are removed from the export operation. This makes use of the custom metadata fields defined in the Custom Metadata Sample above.
- **Mixing built-in and custom fields:** The filter operates on both standard Lightroom metadata and plugin-defined custom metadata.

---

### Post-Processing Samples

**Folders:** `creatorfilter.lrdevplugin` and `languagefilter.lrdevplugin`

**Purpose:** Demonstrate Export Filter Providers that use external applications to modify XMP metadata during export.

**Key APIs:** `LrExportFilterProvider`, `postProcessRenderedPhotos`

**Plugin files for `creatorfilter.lrdevplugin`:**

| File | Role |
|------|------|
| `Info.lua` | Plugin description |
| `CreatorExternalToolFilterProvider.lua` | Export Filter Provider definition |
| `win\LightroomCreatorXMP.exe` | Windows XMP processing tool |
| `mac/LightroomCreatorXMP` | macOS XMP processing tool |

**Plugin files for `languagefilter.lrdevplugin`:**

| File | Role |
|------|------|
| `Info.lua` | Plugin description |
| `LanguageExternalToolFilterProvider.lua` | Export Filter Provider definition |
| `win\LightroomLanguageXMP.exe` | Windows XMP processing tool |
| `mac/LightroomLanguageXMP` | macOS XMP processing tool |

**What they demonstrate:**

- **External application integration:** Both plugins invoke platform-specific command-line tools to write XMP metadata to exported files.
- **Creator External Tool:** Allows users to add or modify the creator-name XMP property. Also includes the metadata filter logic from the Metadata Export Filter sample, combining exclusion filtering with XMP writing.
- **Language External Tool:** Allows users to update a localized value for the Title property in XMP metadata, selecting a language and entering a new translation value.
- **Combining multiple post-processing actions:** Users can insert one, both, or neither action into the export pipeline. Actions can be reordered using up/down arrows in the dialog sections, or removed via the X icon, double-click, or Remove button.
- **Filter pipeline behavior:** When both are inserted, they execute in the order shown. Each adds its own dialog section to the Export dialog. The user can verify results by examining XMP metadata in exported photos.

---

### Web Engine Sample

**Folder:** `websample.lrwebengine`

**Purpose:** Demonstrate a web-engine plugin by creating a simple HTML gallery with a filmstrip of small images and a larger selected image.

**Key APIs:** `galleryInfo.lrweb`, `manifest.lrweb`, LuaPages, tagsets

**Plugin files:**

| File | Role |
|------|------|
| `manifest.lrweb` | Maps LuaPage source and template files to output HTML using commands for different page types and resources |
| `galleryInfo.lrweb` | Defines the data model and UI for the gallery |
| `grid.html` | Template LuaPage with HTML and embedded Lua/JavaScript |
| `header.html` | Common HTML header template |
| `footer.html` | Common HTML footer template |
| `readme.txt` | Explanation of how the sample works |

**What it demonstrates:**

- **Web engine architecture:** Web engines use a different plugin structure from standard plugins. They are installed in `LR_Root/shared/webengines` and appear in the Web module's Engine list.
- **Complete web engine structure:** The manifest maps templates to output pages. The galleryInfo defines the data model. HTML templates use LuaPages syntax for dynamic content.
- **Template syntax:** LuaPages embed Lua code in HTML using `<% %>` for code blocks and `<%= %>` for output expressions.
- **Gallery preview:** Shows a filmstrip of small images on one side and a larger version of the selected image on the right.

---

## Chapter 9: Hello World Export Plugin Tutorial

This tutorial walks through creating a plugin that adds menu items to the File and Library menus, displays predefined and custom dialogs, demonstrates data binding with transforms and observers, and sets up debugging with LrLogger.

### Step 1: Create Plugin Folder

Create a folder named `helloworld.lrdevplugin`. For development, use the `.lrdevplugin` suffix; for delivery, use `.lrplugin`.

### Step 2: Create Info.lua

The `Info.lua` file describes your plugin to Lightroom Classic. It must return a table with the SDK version, a unique toolkit identifier, and entries for the features your plugin provides.

```lua
return {
    LrSdkVersion = 5.0,
    LrToolkitIdentifier = 'com.adobe.lightroom.sdk.helloworld',

    -- Adds "Hello World Dialog" to File > Plug-in Extras
    LrExportMenuItems = {
        title = "Hello World Dialog",
        file = "ExportMenuItem.lua",
    },

    -- Adds "Hello World Custom Dialog" to Library > Plug-in Extras
    LrLibraryMenuItems = {
        title = "Hello World Custom Dialog",
        file = "LibraryMenuItem.lua",
    },
}
```

Note: A single table for `LrExportMenuItems` defines one menu item. For multiple items, use a table of tables.

### Step 3: ExportMenuItem.lua -- Displaying a Predefined Dialog

This script demonstrates importing the `LrDialogs` namespace and using its `message()` function:

```lua
local LrDialogs = import 'LrDialogs'

MyHWExportItem = {}

function MyHWExportItem.showModalDialog()
    LrDialogs.message( "ExportMenuItem Selected", "Hello World!", "info" )
end

MyHWExportItem.showModalDialog()
```

The three arguments to `LrDialogs.message()` are: title, message text, and style ("info", "warning", or "critical").

### Step 4: LibraryMenuItem.lua -- Displaying a Custom Dialog

This is where the tutorial gets progressively more sophisticated. The script demonstrates:
- Importing multiple namespaces: `LrFunctionContext`, `LrBinding`, `LrDialogs`, `LrView`, `LrColor`
- Creating an observable property table
- Building a view hierarchy with the view factory
- Binding UI controls to data

```lua
local LrFunctionContext = import 'LrFunctionContext'
local LrBinding = import 'LrBinding'
local LrDialogs = import 'LrDialogs'
local LrView = import 'LrView'
local LrColor = import 'LrColor'

MyHWLibraryItem = {}

function MyHWLibraryItem.showCustomDialog()
    LrFunctionContext.callWithContext( "showCustomDialog", function( context )
        -- Create an observable property table (requires function context
        -- for automatic cleanup if anything goes wrong)
        local props = LrBinding.makePropertyTable( context )
        props.isChecked = false

        local f = LrView.osFactory()
        local c = f:row {
            bind_to_object = props,   -- all child controls inherit this binding
            f:checkbox {
                title = "Enable",
                value = LrView.bind( "isChecked" ),  -- bound to data key
            },
            f:edit_field {
                value = "Some Text",
                enabled = LrView.bind( "isChecked" ), -- enabled only when checked
            },
        }

        local result = LrDialogs.presentModalDialog {
            title = "Custom Dialog",
            contents = c,
        }
    end)
end

MyHWLibraryItem.showCustomDialog()
```

**Key pattern:** `LrFunctionContext.callWithContext()` wraps your code in a context that handles cleanup. The second argument is your main function, which receives the context object needed to create observable tables.

### Step 5: Adding Transforms -- Data Transformation in Bindings

Transforms allow you to convert a data value before displaying it. This example binds two radio buttons and a static text field to the same key, with a transform on the text:

```lua
function MyHWLibraryItem.showCustomDialogWithTransform()
    LrFunctionContext.callWithContext( "showCustomDialogWithTransform",
        function( context )
            local props = LrBinding.makePropertyTable( context )
            props.selectedButton = "one"

            local f = LrView.osFactory()
            local c = f:column {
                bind_to_object = props,
                spacing = f:control_spacing(),
                f:row {
                    spacing = f:control_spacing(),
                    f:column {
                        f:radio_button {
                            title = "Button one",
                            checked_value = "one",
                            value = LrView.bind( "selectedButton" ),
                        },
                        f:radio_button {
                            title = "Button two",
                            checked_value = "two",
                            value = LrView.bind( "selectedButton" ),
                        },
                    },
                },
                f:row {
                    f:static_text {
                        text_color = LrColor( 1, 0, 0 ),
                        title = LrView.bind {
                            key = "selectedButton",
                            transform = function( value, fromTable )
                                if value == "one" then
                                    return "Button one selected"
                                else
                                    return "Button two selected"
                                end
                            end,
                        },
                    },
                },
            }

            LrDialogs.presentModalDialog {
                title = "Custom Dialog Transform",
                contents = c,
            }
        end )
end
```

**How radio buttons work:** Each radio button has a `checked_value`. When the user selects a button, the bound key is set to that button's `checked_value`. Because both buttons are bound to the same key, selecting one automatically deselects the other. The transform function on the static text converts "one"/"two" into a display string.

### Step 6: Binding to Multiple Keys in Multiple Tables

This demonstrates sliders bound to keys in two separate property tables, plus a computed field that combines values from both:

```lua
function MyHWLibraryItem.showCustomDialogWithMultipleBind()
    LrFunctionContext.callWithContext( "showCustomDialogWithMultipleBind",
        function( context )
            local tableOne = LrBinding.makePropertyTable( context )
            local tableTwo = LrBinding.makePropertyTable( context )
            tableOne.sliderOne = 0
            tableTwo.sliderTwo = 50

            local f = LrView.osFactory()
            local c = f:column {
                bind_to_object = tableOne,  -- default table for this hierarchy
                spacing = f:control_spacing(),
                f:row {
                    f:group_box {
                        title = "Slider One",
                        font = "<system>",
                        f:slider {
                            value = LrView.bind( "sliderOne" ),
                            min = 0, max = 100,
                            width = LrView.share( "slider_width" ),
                        },
                        f:edit_field {
                            place_horizontal = 0.5,
                            value = LrView.bind( "sliderOne" ),
                            width_in_digits = 7,
                        },
                    },
                    f:group_box {
                        title = "Slider Two",
                        font = "<system>",
                        f:slider {
                            bind_to_object = tableTwo,  -- override default table
                            value = LrView.bind( "sliderTwo" ),
                            min = 0, max = 100,
                            width = LrView.share( "slider_width" ),
                        },
                        f:edit_field {
                            place_horizontal = 0.5,
                            bind_to_object = tableTwo,  -- override default table
                            value = LrView.bind( "sliderTwo" ),
                            width_in_digits = 7,
                        },
                    },
                },
                f:group_box {
                    fill_horizontal = 1,
                    title = "Both Values",
                    font = "<system>",
                    f:edit_field {
                        place_horizontal = 0.5,
                        value = LrView.bind {
                            keys = {
                                { key = "sliderOne" },              -- from default table
                                { key = "sliderTwo",
                                  bind_to_object = tableTwo },      -- from other table
                            },
                            operation = function( _, values, _ )
                                return values.sliderTwo + values.sliderOne
                            end,
                        },
                        width_in_digits = 7,
                    },
                },
            }

            LrDialogs.presentModalDialog {
                title = "Custom Dialog Multiple Bind",
                contents = c,
            }
        end )
end
```

**Key concepts:**
- `bind_to_object` on a control overrides the default table inherited from the parent container.
- `LrView.bind` with a `keys` table and `operation` function binds to multiple keys across multiple tables. The `operation` is called whenever any bound key changes, and its return value becomes the control's displayed value.
- `LrView.share( "slider_width" )` makes multiple controls share the same computed width.

### Step 7: Adding a Data Observer

Observers provide the most flexible way to respond to data changes. Unlike transforms (which only change how a value is displayed), observers can take arbitrary actions:

```lua
function MyHWLibraryItem.showCustomDialogWithObserver()
    LrFunctionContext.callWithContext( "showCustomDialogWithObserver",
        function( context )
            local props = LrBinding.makePropertyTable( context )
            props.myObservedString = "This is a string"

            local f = LrView.osFactory()

            -- Static text showing the current value (NOT dynamically bound)
            local showValue_st = f:static_text {
                title = props.myObservedString,     -- static assignment, not binding
                text_color = LrColor( 1, 0, 0 ),
            }

            -- Edit field with immediate keystroke updates
            local updateField = f:edit_field {
                value = "Enter some text",
                immediate = true,  -- update value with every keystroke
            }

            -- Observer callback: fires when myObservedString changes
            local myCalledFunction = function()
                showValue_st.title = updateField.value
                showValue_st.text_color = LrColor( 1, 0, 0 )  -- turn red
            end

            props:addObserver( "myObservedString", myCalledFunction )

            local c = f:column {
                f:row {
                    fill_horizontal = 1,
                    f:static_text {
                        alignment = "right",
                        width = LrView.share "label_width",
                        title = "Bound value: ",
                    },
                    showValue_st,
                },
                f:row {
                    f:static_text {
                        alignment = "right",
                        width = LrView.share "label_width",
                        title = "New value: ",
                    },
                    updateField,
                    f:push_button {
                        title = "Update",
                        action = function()
                            showValue_st.text_color = LrColor( 0, 0, 0 )  -- black
                            props.myObservedString = updateField.value
                            -- Setting this property triggers the observer,
                            -- which turns the text red again
                        end,
                    },
                },
            }

            LrDialogs.presentModalDialog {
                title = "Custom Dialog",
                contents = c,
            }
        end )
end
```

**Observer behavior:** The observer fires only when the observed value *changes*. Clicking "Update" sets the text to black, then sets `myObservedString` to the edit field's value. If the value actually changed, the observer fires and turns it red. If you click Update again without changing the text, the value does not change, so the observer does not fire, and the text stays black.

### Step 8: Debugging with LrLogger

The SDK does not provide a built-in debugger. You write trace output using `LrLogger`:

```lua
local LrLogger = import 'LrLogger'
local myLogger = LrLogger( 'libraryLogger' )
myLogger:enable( "print" )   -- output to system console
-- OR
myLogger:enable( "logfile" )  -- output to a text file

function MyHWLibraryItem.outputToLog( message )
    myLogger:trace( message )
end
```

**Log file location:** When using `"logfile"` mode, the output file is named after the logger with a `.txt` extension (e.g., `libraryLogger.txt`) and is located in `~/Documents/LrClassicLogs/` on both macOS and Windows.

**Viewing logs:**
- **macOS logfile:** Use `tail -f ~/Documents/LrClassicLogs/libraryLogger.txt` in Terminal
- **macOS console (print mode):** Use the built-in Console app in `/Applications/Utilities`
- **Windows console (print mode):** Use WinDbg -- attach to the `lightroom.exe` process, then choose Debug > Go to resume Lightroom and view trace output

### Key Lessons from the Tutorial

1. **Always wrap async code in `LrFunctionContext.callWithContext()`** to get proper cleanup of observable tables and observers.
2. **Use `LrView.bind()` for reactive UI** -- controls automatically update when their bound data changes.
3. **Export preset fields define the data model** -- they declare the keys and default values your plugin works with.
4. **`processRenderedPhotos` is where the real work happens** -- this is the callback that receives rendered files.
5. **`rendition:waitForRender()` blocks until the file is ready** -- it returns a success boolean and either the file path or an error message.
6. **Transforms and operations** compute display values from one or more bound keys without changing the underlying data.
7. **Observers** are the most flexible binding mechanism, allowing arbitrary side effects when data changes.

---

## Chapter 10: Metadata Plugin Tutorial

This tutorial walks through building a plugin that defines custom metadata fields, creates tagsets to display them, and customizes the Plug-in Manager.

### Step 1: Create the Plugin Framework

Create `myMetadata.lrplugin/` with three files:

**Info.lua:**
```lua
return {
    LrSdkVersion = 5.0,
    LrToolkitIdentifier = 'sample.metadata.mymetadatasample',
    LrPluginName = LOC "$$$/MyMetadataSample/PluginName=My Metadata Sample",
    LrMetadataProvider = 'MyMetadataDefinitionFile.lua',
    LrMetadataTagsetFactory = 'MyMetadataTagset.lua',
}
```

### Step 2: Define Metadata Fields

**MyMetadataDefinitionFile.lua:**
```lua
return {
    metadataFieldsForPhotos = {
        {
            id = 'siteId',
            -- No title or dataType: this is a private/internal field.
            -- Other plugins can read it but cannot write to it.
        },
        {
            id = 'myString',
            title = LOC "$$$/MyMetadataSample/Fields/MyString=My String",
            dataType = 'string',       -- shown as editable text field
            searchable = true,         -- usable in smart collection criteria
        },
        {
            id = 'myboolean',
            title = LOC "$$$/MyMetadataSample/Fields/Display=My Boolean",
            dataType = 'enum',         -- shown as popup menu of valid values
            values = {
                {
                    value = 'true',
                    title = LOC "$$$/MyMetadataSample/Fields/Display/True=True",
                },
                {
                    value = 'false',
                    title = LOC "$$$/MyMetadataSample/Fields/Display/False=False",
                },
            },
        },
    },
    schemaVersion = 1,
}
```

**Field visibility rules:**
- A field with only an `id` is private/internal -- invisible in the Metadata panel, but accessible programmatically.
- Adding a `title` makes the field visible in the Metadata panel.
- Adding `dataType` tells the panel how to render the editing control (`'string'` = text field, `'enum'` = popup menu).
- `dataType = 'string'` is the default, so it can be omitted for string fields.
- `searchable = true` enables the field for smart collection criteria.
- `schemaVersion` provides version control; increment it when changing field definitions to notify users.

### Step 3: Define a Tagset

Tagsets control what appears in the Metadata panel when selected from its dropdown menu.

**MyMetadataTagset.lua:**
```lua
return {
    title = LOC "$$$/MyMetadataSample/Tagset/Title=My Metadata",
    id = 'MyMetadataTagset',
    items = {
        -- Built-in metadata section
        { 'com.adobe.label',
            label = LOC "$$$/Metadata/OrigLabel=Standard Metadata" },
        'com.adobe.filename',
        'com.adobe.folder',
        'com.adobe.separator',

        -- Custom metadata section (wildcard matches all fields from this plugin)
        { 'com.adobe.label',
            label = LOC "$$$/Metadata/CusLabel=My Metadata" },
        'sample.metadata.mymetadatasample.*',
    },
}
```

**Tagset details:**
- `'com.adobe.label'` creates a labeled section header in the panel.
- `'com.adobe.separator'` inserts a visual separator.
- The wildcard `*` at the end of a toolkit identifier matches all fields from that plugin. The wildcard can only appear at the end.
- Custom metadata also appears at the bottom of the "All" tagset automatically.

### Step 4: Read/Write Custom Metadata Programmatically

Custom metadata values are accessed on `LrPhoto` objects:

```lua
-- Reading
local value = photo:getPropertyForPlugin( 'sample.metadata.mymetadatasample', 'siteId' )

-- Writing (only the owning plugin can write)
photo:setPropertyForPlugin( _PLUGIN, 'siteId', 'my-value-here' )
```

### Step 5: Customizing the Plug-in Manager

Add `LrPluginInfoProvider`, `LrInitPlugin`, and optionally `LrPluginInfoUrl` to `Info.lua`:

```lua
return {
    LrSdkVersion = 5.0,
    LrToolkitIdentifier = 'sample.metadata.mymetadatasample',
    LrPluginName = LOC "$$$/MyMetadataSample/PluginName=My Metadata Sample",
    LrInitPlugin = 'PluginInit.lua',
    LrMetadataProvider = 'MyMetadataDefinitionFile.lua',
    LrMetadataTagsetFactory = 'MyMetadataTagset.lua',
    LrPluginInfoProvider = 'PluginInfoProvider.lua',
    LrPluginInfoUrl = "http://www.mycompany.com",
}
```

**PluginInit.lua** -- defines global variables:
```lua
_G.currentDisplayImage = "no"
_G.pluginID = "com.adobe.lightroom.sdk.metadata.custommetadatasample"
_G.URL = "http://www.mycompany.com"
```

**PluginInfoProvider.lua** -- references the manager section definition:
```lua
require 'PluginManager'
return {
    sectionsForTopOfDialog = PluginManager.sectionsForTopOfDialog,
}
```

**PluginManager.lua** -- builds the custom UI section:
```lua
local LrView = import "LrView"
local LrHttp = import "LrHttp"

PluginManager = {}

function PluginManager.sectionsForTopOfDialog( f, p )
    return {
        {
            title = "Custom Metadata Sample",
            f:row {
                spacing = f:control_spacing(),
                f:static_text {
                    title = 'Click the button to find out more about Adobe',
                    alignment = 'left',
                    fill_horizontal = 1,
                },
                f:push_button {
                    width = 150,
                    title = 'Connect to Adobe',
                    enabled = true,
                    action = function()
                        LrHttp.openUrlInBrowser( _G.URL )
                    end,
                },
            },
            f:row {
                f:static_text {
                    title = 'Global default value for displayImage: ',
                    alignment = 'left',
                },
                f:static_text {
                    title = _G.currentDisplayImage,
                    fill_horizontal = 1,
                },
            },
        },
    }
end
```

The custom section appears above the standard Lightroom sections in the Plug-in Manager. The `LrPluginInfoUrl` value is shown in the standard Status section.

---

## Chapter 11: Web Gallery Tutorial

This tutorial builds a simple HTML gallery with a thumbnail grid, large-image detail pages, pagination, user-editable titles with Live Update, and custom tagsets.

### Step 1: Create the Plugin Folder

Web gallery plugins use the `.lrwebengine` suffix and must be placed in a specific location:

- **macOS:** `~/Library/Application Support/Adobe/Lightroom/Web Galleries/mySamplePlugin.lrwebengine`
- **Windows:** `LightroomRoot\shared\webengines\mySamplePlugin.lrwebengine`

### Step 2: Create galleryInfo.lrweb

This is the information file that defines the gallery identity and data model:

```lua
return {
    LRSDKVersion = 5.0,
    LrSdkMinimumVersion = 2.0,
    title = "My Sample Plug-in",
    id = "com.adobe.wpg.templates.mysample",
    galleryType = "lua",
    maximumGallerySize = 50000,

    model = {
        -- Image base folder
        ["nonDynamic.imageBase"] = "content",

        -- Thumbnail size definition
        ["photoSizes.thumb.height"] = 150,
        ["photoSizes.thumb.width"] = 150,
        ["photoSizes.thumb.metadataExportMode"] = "copyright",
        ["appearance.thumb.cssID"] = ".thumb",

        -- Large image size definition
        ["photoSizes.large.width"] = 450,
        ["photoSizes.large.height"] = 450,

        -- Site title (editable via Live Update)
        ["metadata.siteTitle.value"] = "MySample",
        ["appearance.siteTitle.cssID"] = "#siteTitle",
    },

    views = function( controller, f )
        local LrView = import "LrView"
        local bind = LrView.bind
        return {
            labels = f:panel_content {
                bind_to_object = controller,
                f:subdivided_sections {
                    f:labeled_text_input {
                        title = "MySample",
                        value = bind "metadata.siteTitle.value",
                    },
                },
            },
        }
    end,
}
```

**Data model keys:**
- `photoSizes.<name>.width/height` -- defines an image size (here "thumb" and "large")
- `appearance.<name>.cssID` -- associates an image size with a CSS selector
- `metadata.<name>.value` -- user-editable metadata value
- `nonDynamic.imageBase` -- the base folder for exported images
- The `views` function returns UI controls for the Web module's control panels. The `labels` key maps to the "Site Info" section.

### Step 3: Create manifest.lrweb

The manifest maps templates to output pages and declares resources:

```lua
importTags( "lr", "com.adobe.lightroom.default" )
importTags( "xmpl", "myExampleTags.lrweb" )

AddCustomCSS {
    filename = 'content/custom.css',
}

AddGridPages {
    template = "grid.html",
    rows = 4,
    columns = 4,
}

AddPhotoPages {
    template = 'large.html',
    variant = '_large',
    destination = "content",
}

AddResources {
    source = "resources",
    destination = "resources",
}
```

**Manifest commands:**
- `importTags()` loads a tagset definition file and assigns it a namespace prefix.
- `AddCustomCSS` specifies the custom stylesheet.
- `AddGridPages` creates paginated thumbnail grid pages from a template.
- `AddPhotoPages` creates one HTML page per photo for the large view. The `variant` suffix is appended to each filename (e.g., `img0731_large.html`).
- `AddResources` copies resource files (JavaScript, CSS, images) to the output.

### Step 4: Create HTML Templates

**header.html** -- common HTML header:
```html
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="generator" content="Adobe Photoshop Lightroom" />
    <title>My Sample Plug-in</title>
    <link rel="stylesheet" type="text/css" media="screen"
        title="Custom Settings" href="$others/custom.css" >
</head>
<body>
<h1 onclick="clickTarget( this, 'metadata.siteTitle.value' );"
    id="metadata.siteTitle.value">$model.metadata.siteTitle.value</h1>
<script type="text/javascript" src="$theRoot/resources/live_update.js"></script>
```

The `<h1>` tag displays the site title from the data model. The `onclick` handler enables in-place editing -- clicking the title in the preview lets the user edit it directly. The `live_update.js` script (part of the SDK) handles the Live Update callbacks.

**footer.html** -- closes the HTML:
```html
</body>
</html>
```

**grid.html** -- thumbnail grid template:
```html
<%
--[[ Define local variables for resource paths ]]
local mySize = "thumb"
local others = "content"
local theRoot = "."
%>

<%@ include file="header.html" %>

<lr:ThumbnailGrid>
    <lr:GridPhotoCell>
        <a href="$others/<%= image.exportFilename %>_large.html">
            <img src="$others/bin/images/thumb/<%= image.exportFilename %>.jpg"
                 id="<%= image.imageID %>" class="thumb" />
        </a>
    </lr:GridPhotoCell>
</lr:ThumbnailGrid>

<% if numGridPages > 1 then %>
<div class="pagination">
    <ul>
        <lr:Pagination>
            <lr:CurrentPage>
                <li>$page</li>
            </lr:CurrentPage>
            <lr:OtherPages>
                <li><a href="$link">$page</a></li>
            </lr:OtherPages>
            <lr:PreviousEnabled>
                <li><a href="$link">Previous</a></li>
            </lr:PreviousEnabled>
            <lr:PreviousDisabled>
                <li>Previous</li>
            </lr:PreviousDisabled>
            <lr:NextEnabled>
                <li><a href="$link">Next</a></li>
            </lr:NextEnabled>
            <lr:NextDisabled>
                <li>Next</li>
            </lr:NextDisabled>
        </lr:Pagination>
    </ul>
</div>
<% end %>

<%@ include file="footer.html" %>
```

**LuaPages syntax in templates:**
- `<% ... %>` -- Lua code block (control flow, variable definitions)
- `<%= ... %>` -- Lua expression output (inserts the value into HTML)
- `<%@ include file="..." %>` -- includes another template file
- `<lr:TagName>` -- built-in Lightroom tags from the imported "lr" namespace
- `$model.key.path` -- accesses a value from the data model
- `$others`, `$theRoot`, `$link`, `$page` -- template variables

**large.html** -- detail page for each photo:
```html
<%
local image = getImage( index )
local theRoot = ".."
local others = "."
local mySize = "large"
%>

<%@ include file="header.html" %>

<div>
    <ul>
        <lr:Pagination>
            <lr:PreviousEnabled>
                <li><a href="$link">Previous</a></li>
            </lr:PreviousEnabled>
            <lr:PreviousDisabled>
                <li>Previous</li>
            </lr:PreviousDisabled>
            <li><a href="$gridPageLink">Index</a></li>
            <lr:NextEnabled>
                <li><a href="$link">Next</a></li>
            </lr:NextEnabled>
            <lr:NextDisabled>
                <li>Next</li>
            </lr:NextDisabled>
        </lr:Pagination>
    </ul>
</div>

<a href="$gridPageLink">
    <img src="bin/images/large/<%= image.exportFilename %>.jpg" />
</a>

<%@ include file="footer.html" %>
```

Note the `$gridPageLink` variable, which navigates back to the thumbnail grid.

### Step 5: Custom Tagsets for Web Galleries

Web gallery tagsets are external files with macro-like tag definitions that templates can use:

**myExampleTags.lrweb:**
```lua
local sayings = {
    "A dish fit for the gods - Julius Caesar, Shakespeare",
    "Oh, that way madness lies - King Lear, Shakespeare",
    "A multitude of sins - James 5:20",
    "A knight in shining armour - The Ancient Ballad of Prince Baldwin",
    "Blood is thicker than water - Guy Mannering, Sir Walter Scott",
}

local randomSayingCount = 0

globals = {
    randomSaying = function()
        randomSayingCount = math.mod( randomSayingCount + 1, #sayings )
        return sayings[ randomSayingCount ]
    end,
}

tags = {
    saying = {
        startTag = "write( 'Here is a saying: ' ) write( randomSaying() )",
        endTag = "write( [[And that's all.]] )",
    },
    aQuote = {
        startTag = 'write( [[<blockquote style="margin: 0 0 0 30px; '
                .. 'padding: 10px 0 0 20px; font-size: 88%; '
                .. 'line-height: 1.5em; color: #666;">]] )',
        endTag = 'write( [[</blockquote>]] )',
    },
}
```

**Using custom tags in templates:**
```html
<xmpl:aQuote>You know what they say:<br>
    <xmpl:saying> <br />....how interesting!<br /></xmpl:saying>
</xmpl:aQuote>
```

The prefix `xmpl` comes from `importTags( "xmpl", "myExampleTags.lrweb" )` in the manifest. Each tag has `startTag` and `endTag` code that executes before and after the tag's content. The `globals` table defines functions accessible from templates.

### Folder Structure

The complete web gallery plugin has this structure:
```
mySamplePlugin.lrwebengine/
    galleryInfo.lrweb
    manifest.lrweb
    myExampleTags.lrweb
    grid.html
    large.html
    header.html
    footer.html
    resources/
        live_update.js       (copy from the SDK)
    css/
    js/
    strings/
        en/
```

---

## Common Patterns Across Samples

1. **LrLogger for debugging:** All samples use or can easily adopt `LrLogger` for trace output. Enable with `"logfile"` for file output to `~/Documents/LrClassicLogs/` or `"print"` for console output.

2. **Rendition iteration pattern:** Export and publish samples all follow the same core loop:
   ```lua
   for i, rendition in exportContext:renditions { stopIfCanceled = true } do
       local success, pathOrMessage = rendition:waitForRender()
       if success then
           -- process the file at pathOrMessage
       end
   end
   ```

3. **Publish extends export with remote ID tracking:** A publish service stores a remote photo ID after upload (`rendition:recordPublishedPhotoId( remoteId )`), enabling Lightroom to detect modifications and handle re-publishing or deletion.

4. **LrView factory pattern for all UI:** Every dialog and panel uses `LrView.osFactory()` to obtain a factory, then builds a hierarchy of containers (columns, rows, group boxes) with controls (sliders, checkboxes, text fields, buttons).

5. **Error handling with LrFunctionContext:** All interactive code runs within `LrFunctionContext.callWithContext()` or `LrFunctionContext.postAsyncTaskWithContext()`, providing automatic cleanup and failure handling.

6. **Data binding with LrBinding:** Observable property tables created via `LrBinding.makePropertyTable( context )` serve as the reactive data model. Controls bound via `LrView.bind()` update automatically.

---

## Using Samples as Starting Points

| If you need... | Start with... | Why |
|----------------|---------------|-----|
| Simple file export | FTP Upload sample | Cleanest export service pattern, minimal dependencies |
| Publish service (ongoing sync) | Flickr sample | Complete publish lifecycle with auth, collections, comments |
| Custom metadata fields | Custom Metadata sample | Full field definition, tagset, and Plug-in Manager customization |
| Export filtering/post-processing | Metadata Export Filter or Creator Filter samples | Shows shouldRenderPhoto() and external tool integration |
| Web gallery | Web Engine sample | Complete web engine with grid, detail pages, Live Update |

**Steps to adapt a sample:**
1. Copy the most relevant sample folder and rename it with your own `.lrdevplugin` suffix.
2. Change `LrToolkitIdentifier` in `Info.lua` to a unique identifier for your plugin (e.g., `com.yourcompany.yourplugin`).
3. Update `LrPluginName` to your plugin's display name.
4. Adapt the service provider callbacks for your specific use case.
5. Modify or replace the dialog sections to match your UI needs.
6. Add your own logic to `processRenderedPhotos` (for export) or the publish-specific callbacks (for publish services).
