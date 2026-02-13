# Export & Publish Service Providers

## Overview

Export and publish are the two mechanisms Lightroom Classic provides for rendering photos and sending them to a destination. Both are driven by plug-in defined service providers that share much of the same callback API.

- **Export services** extend the `File > Export` dialog. Export is a one-time operation: photos are rendered once and transferred to their destination. Lightroom Classic maintains no further record of the operation. Plug-ins add export destinations (e.g. web services, devices) beyond the built-in hard drive and CD/DVD options.

- **Publish services** extend the Publish Services panel in the Library module. Publish represents an ongoing relationship between the catalog and the destination. Published collections track which photos need to be exported, re-exported, or deleted. The Publishing Manager dialog is largely similar to the Export dialog.

- **Both share the same base callback structure.** A publish service is a superset of an export service. With the exception of export presets, every callback an export service defines is also valid for a publish service, plus additional publish-specific callbacks.

---

## Export Service Provider

### Defining the Service

In `Info.lua`, declare the export service:

```lua
LrExportServiceProvider = {
    title = "Service Name",         -- appears as the Export destination
    file = "MyExportServiceProvider.lua",  -- the service definition script
    builtInPresetsDir = "myPresets", -- optional subfolder for presets
},
```

The `title` and `file` entries are required. You can localize the title using `LOC` and a ZString.

The service definition script (`MyExportServiceProvider.lua`) must return a table containing callbacks, properties, and configuration entries.

Minimal example of the returned table:

```lua
return {
    startDialog = function( propertyTable ) ... end,
    endDialog = function( propertyTable, why ) ... end,
    exportPresetFields = { { key = 'myPluginSetting', default = 'Initial value' } },
    showSections = { 'fileNaming', 'imageSettings' },
    sectionsForBottomOfDialog = function( viewFactory, propertyTable ) ... end,
    processRenderedPhotos = function( functionContext, exportContext ) ... end,
}
```

### Callback Sequence

When a user opens the Export dialog and initiates an export, callbacks fire in this order:

1. **`startDialog(propertyTable)`** -- called when the export dialog opens (or when the user switches to this destination)
2. **`sectionsForTopOfDialog(viewFactory, propertyTable)`** -- define custom UI sections above built-in sections
3. **`sectionsForBottomOfDialog(viewFactory, propertyTable)`** -- define custom UI sections below built-in sections
4. **`updateExportSettings(exportSettings)`** -- force or modify render settings before export begins
5. **`processRenderedPhotos(functionContext, exportContext)`** -- the main export logic; iterate renditions, upload/copy files

When the dialog closes, `endDialog` is called with a reason string.

### Key Callbacks

#### `startDialog(propertyTable)`

Called when the user chooses this export destination, or when the dialog opens and this destination is already selected (remembered from the previous session). The `propertyTable` contains current export settings (both plug-in-defined and Lightroom-defined). Use this to initialize transient state, add observers, or validate credentials.

This is a blocking call. For long-running tasks (network access), create a task via `LrTasks`.

#### `endDialog(propertyTable, why)`

Called when the user deselects this destination or dismisses the dialog. The `why` parameter is a string:

| Value | Meaning |
|---|---|
| `"changedServiceProvider"` | A different export destination was chosen |
| `"ok"` | The user clicked Export (export service) or Save (publish service). For export, Lightroom then begins rendering through `processRenderedPhotos`. For publish, Lightroom creates the service entry in the Publish Services panel. |
| `"cancel"` | The user clicked Cancel; no operation is initiated |

#### `sectionsForTopOfDialog(viewFactory, propertyTable)`

Returns a table of section definition tables to be displayed **above** Lightroom's built-in sections. Each section has a `title`, optional `synopsis` (shown when collapsed), and child `LrView` elements built from the `viewFactory`.

```lua
sectionsForTopOfDialog = function( viewFactory, propertyTable )
    return {
        {
            title = "My Plugin Settings",
            synopsis = LrView.bind { key = 'myField', object = propertyTable },
            viewFactory:row {
                viewFactory:static_text { title = "Label:" },
                viewFactory:edit_field { value = LrView.bind 'myField' },
            },
        },
    }
end,
```

#### `sectionsForBottomOfDialog(viewFactory, propertyTable)`

Same as `sectionsForTopOfDialog`, but sections appear **below** the built-in sections.

#### `processRenderedPhotos(functionContext, exportContext)`

The main workhorse. This callback is responsible for transferring each rendered image to its final destination. It runs inside a cooperative task that Lightroom provides -- you do not need to create your own task.

Parameters:
- `functionContext` (`LrFunctionContext`) -- use to define cleanup handlers
- `exportContext` (`LrExportContext`) -- provides access to `exportContext.propertyTable` (settings) and the list of renditions

Available `exportContext` properties in `processRenderedPhotos`:
- `exportContext.propertyTable` -- the export settings table
- `exportContext.exportSession` -- the `LrExportSession` object
- `exportContext.publishedCollection` -- the `LrPublishedCollection` object (publish operations only)
- `exportContext.publishedCollectionInfo` -- table with collection info fields including `name` (publish operations only)
- `exportContext.publishService` -- the `LrPublishService` object (publish operations only)

Typical pattern:

```lua
processRenderedPhotos = function( functionContext, exportContext )
    local nPhotos = exportContext.exportSession:countRenditions()

    -- Configure the progress indicator
    local progressScope = exportContext:configureProgress {
        title = nPhotos > 1
            and LOC( "$$$/MyPlugin/Export/Progress=Exporting ^1 photos", nPhotos )
            or  LOC  "$$$/MyPlugin/Export/Progress/One=Exporting one photo",
    }

    for i, rendition in exportContext:renditions() do
        -- Wait for Lightroom to finish rendering this photo
        local success, pathOrMessage = rendition:waitForRender()

        if success then
            -- pathOrMessage is the file path of the rendered image
            local ok, err = myUploadFunction( pathOrMessage )
            if not ok then
                rendition:uploadFailed( err )
            end
        else
            -- pathOrMessage is an error message
            rendition:uploadFailed( pathOrMessage )
        end
    end
end,
```

Key points:
- `exportContext:renditions()` returns an iterator; it automatically updates the progress indicator.
- Lightroom renders in a background thread, so rendering and your upload/copy work overlap.
- Call `rendition:uploadFailed(message)` to report per-photo failures.

#### `canExportToTemporaryLocation`

A Boolean value (not a function). When `true`, an additional choice "Temporary folder (will be discarded upon completion)" appears in the Export To popup. Lightroom writes files to a hidden temporary folder, and deletes them after `processRenderedPhotos` completes. Default is `false`.

If your plug-in hides the Export Location section, temporary-folder behavior happens automatically.

#### `exportPresetFields`

Defines custom persistent properties with default values. These are saved across sessions and included in export presets.

```lua
exportPresetFields = {
    { key = 'privacy',        default = 'public' },
    { key = 'privacy_family', default = false },
    { key = 'privacy_friends',default = false },
    { key = 'safety',         default = 'safe' },
    { key = 'hideFromPublic', default = false },
    { key = 'type',           default = 'photo' },
    { key = 'addTags',        default = '' },
},
```

Access these via `propertyTable` in dialog callbacks and `exportContext.propertyTable` in `processRenderedPhotos`. The default values are used only on first invocation; after that, the user's previous choices are restored.

#### `showSections` / `hideSections`

Control which built-in sections appear in the Export dialog. Provide one or the other, not both. If neither is provided, all default sections are shown.

```lua
-- Positive form: show only these sections
showSections = { 'fileNaming', 'imageSettings' },

-- Negative form: hide these sections, show the rest
hideSections = { 'exportLocation' },
```

Available section identifiers:

| Identifier | Section |
|---|---|
| `exportLocation` | Export Location |
| `fileNaming` | File Naming |
| `fileSettings` | File Settings |
| `imageSettings` | Image Sizing |
| `outputSharpening` | Output Sharpening |
| `metadata` | Metadata |
| `video` | Video |
| `watermarking` | Watermarking |

When you hide a section, its preset values are excluded from any presets the user creates. If you hide `exportLocation`, Lightroom renders photos into a temporary folder and deletes it after processing.

#### `allowFileFormats` / `disallowFileFormats`

Restrict available still-photo file formats. Provide one or the other.

```lua
allowFileFormats = { 'JPEG', 'TIFF' },
-- or
disallowFileFormats = { 'DNG', 'ORIGINAL' },
```

Recognized formats: `JPEG`, `PSD`, `TIFF`, `DNG`, `ORIGINAL`.

#### `allowColorSpaces` / `disallowColorSpaces`

Restrict available color spaces. Provide one or the other.

```lua
allowColorSpaces = { 'sRGB' },
-- or
disallowColorSpaces = { 'ProPhotoRGB' },
```

Recognized color spaces: `sRGB`, `AdobeRGB`, `ProPhotoRGB`.

#### `hidePrintResolution`

A Boolean value. When `true`, the Image Sizing section shows dimensions only in pixel units -- all mention of print units (inches, centimeters, pixels-per-inch) is hidden. Default is `false`.

#### `updateExportSettings(exportSettings)`

Called at the start of the export operation (Stage 1 of the rendering pipeline), before any photos are rendered. Allows the service to force specific render settings. For example:

```lua
updateExportSettings = function( exportSettings )
    exportSettings.LR_size_maxHeight = 400
    exportSettings.LR_size_maxWidth = 400
end,
```

Filters (Export Filter Providers) are not involved at this stage.

#### `postProcessRenderedPhotos(functionContext, filterContext)`

This callback is for **Export Filter Providers**, not the main Export Service Provider. See the Export Filter Provider section below.

---

### Export Preset Fields

Define custom persistent properties:

```lua
exportPresetFields = {
    { key = 'myField', default = 'value' },
    { key = 'myNumber', default = 0 },
    { key = 'myBool', default = false },
}
```

- In dialog callbacks (`startDialog`, `sectionsForTopOfDialog`, etc.): access via `propertyTable.myField`
- In `processRenderedPhotos`: access via `exportContext.propertyTable.myField`
- Default values are used only on first invocation; subsequent invocations restore previous values
- For publish services, these settings are saved with the publish service but cannot be loaded from a preset

---

### Built-in Property Keys

All of the following keys are available in the `propertyTable` passed to callbacks. They correspond to the built-in sections of the Export dialog.

#### Destination (Export Location)

| Key | Type | Description |
|---|---|---|
| `LR_export_destinationType` | String | Export To popup. Values: `chooseLater`, `desktop`, `documents`, `home`, `pictures`, `sourceFolder`, `specificFolder`, `tempFolder` |
| `LR_export_destinationPathPrefix` | String | Destination folder path |
| `LR_export_destinationPathSuffix` | String | Subfolder name (valid only when `LR_export_useSubfolder` is true) |
| `LR_export_useSubfolder` | Boolean | True when "Put in Subfolder" is checked. Cannot be used with `tempFolder` |
| `LR_reimportExportedPhoto` | Boolean | True when "Add to This Catalog" is checked. Cannot be used with `tempFolder` |
| `LR_reimport_stackWithOriginal` | Boolean | True when "Stack With Original" is checked. Only meaningful when destination is `sourceFolder` and use-subfolder is false |
| `LR_collisionHandling` | String | Existing Files popup. Values: `ask`, `rename`, `overwrite`, `skip` |

#### File Naming

| Key | Type | Description |
|---|---|---|
| `LR_tokens` | String | File-naming pattern. Can contain tokens in double curly braces, e.g. `{{image_name}}` |
| `LR_tokenCustomString` | String | Custom text naming template for use with `{{custom_token}}` |
| `LR_initialSequenceNumber` | Number | Initial value for sequence number renaming |
| `LR_extensionCase` | String | File extension case: `uppercase` or `lowercase` |
| `LR_renamingTokensOn` | Boolean | True when files are renamed on export |

**Token patterns** (used within `LR_tokens` in double curly braces):

Image Name: `image_name`, `image_filename_number_suffix`, `image_folder`, `image_originalName`, `image_originalName_number_suffix`, `copy_name`, `custom_token`

Sequence: `naming_sequenceNumber_1Digit` through `_5Digits`, `naming_operationSequence_1Digit` through `_5Digits`, `naming_sequenceTotal_1Digit` through `_5Digits`

Date: `date_LocalEncoding`, `date_YYYYMMDD`, `date_YYMMDD`, `date_YYYY`, `date_YY`, `date_Month`, `date_Mon`, `date_MM`, `date_DD`, `date_Julian`, `date_Hour`, `date_Minute`, `date_Second`

Metadata: `com.adobe.title`, `com.adobe.caption`, `com.adobe.copyright`, `com.adobe.keywords`, `com.adobe.creator`, `com.adobe.headline`, `com.adobe.city`, `com.adobe.state`, `com.adobe.country`, and many more IPTC/EXIF fields.

#### File Settings

| Key | Type | Description |
|---|---|---|
| `LR_format` | String | Still-photo file format: `JPEG`, `PSD`, `TIFF`, `DNG`, `ORIGINAL` |
| `LR_export_colorSpace` | String | Color space: `sRGB`, `AdobeRGB`, `ProPhotoRGB` |
| `LR_export_bitDepth` | Number | Bit depth for TIFF/PSD: `8` or `16`. Ignored for other formats |

**JPEG-specific:**

| Key | Type | Description |
|---|---|---|
| `LR_jpeg_quality` | Number | JPEG quality `[0..1]` where 1 is best quality |
| `LR_jpeg_useLimitSize` | Boolean | True when "Limit File Size To:" is checked |
| `LR_jpeg_limitSize` | Number | Target file size in kilobytes (when limit is enabled) |

**TIFF-specific:**

| Key | Type | Description |
|---|---|---|
| `LR_tiff_compressionMethod` | String | `compressionMethod_None`, `compressionMethod_LZW`, `compressionMethod_ZIP` |

**DNG-specific:**

| Key | Type | Description |
|---|---|---|
| `LR_DNG_previewSize` | String | JPEG preview size: `none`, `medium`, `large` |
| `LR_DNG_compatability` | Number | Oldest compatible ACR version: `33816576` (ACR 2.4), `67174400` (ACR 4.1), `67502080` (ACR 4.6), `84148224` (ACR 5.4) |
| `LR_DNG_conversionMethod` | String | `preserveRAW` or `convertToLinear` |
| `LR_DNG_embedRAW` | Boolean | True to embed original raw file |

#### Image Sizing

| Key | Type | Description |
|---|---|---|
| `LR_size_doConstrain` | Boolean | True to constrain maximum size |
| `LR_size_doNotEnlarge` | Boolean | True to prevent enlargement |
| `LR_size_maxHeight` | Number | Height constraint in units specified by `LR_size_units` |
| `LR_size_maxWidth` | Number | Width constraint in units specified by `LR_size_units` |
| `LR_size_megapixels` | Number | Target megapixels (when resize type is `megapixels`) |
| `LR_size_resizeType` | String | Resize method: `wh` (width and height), `dimensions`, `longEdge`, `shortEdge`, `megapixels`. For `longEdge`/`shortEdge`, the value is constrained by `LR_size_maxHeight` |
| `LR_size_resolution` | Number | Resolution in units specified by `LR_size_resolutionUnits` |
| `LR_size_resolutionUnits` | String | Resolution units: `inch` or `cm` |
| `LR_size_units` | String | Size constraint units: `inch`, `cm`, `pixels` |

#### Output Sharpening

| Key | Type | Description |
|---|---|---|
| `LR_outputSharpeningOn` | Boolean | True when "Sharpen For" is checked |
| `LR_outputSharpeningLevel` | Number | Sharpening amount: `1` (low), `2` (medium), `3` (high) |
| `LR_outputSharpeningMedia` | String | Destination media: `screen`, `matte`, `glossy` |

#### Metadata

| Key | Type | Description |
|---|---|---|
| `LR_metadata_keywordOptions` | String | `lightroomHierarchical` (hierarchy checked) or `flat` (unchecked). Ignored when minimize metadata is true |
| `LR_embeddedMetadataOption` | String | Include popup: `copyrightOnly`, `copyrightAndContactOnly`, `allExceptCameraInfo`, `all` |
| `LR_minimizeEmbeddedMetadata` | Boolean | True when "Minimize Embedded Metadata" is checked. Superseded by `LR_embeddedMetadataOption` |
| `LR_removeLocationMetadata` | Boolean | True when "Remove Location Info" is checked. Strips all GPS location metadata |

#### Video

| Key | Type | Description |
|---|---|---|
| `LR_includeVideoFiles` | Boolean | True when "Include Video Files" is checked. Only considered when the plug-in sets `canExportVideo = true` |

Use `LrExportSettings.applyVideoExportPreset()` to dynamically set video format and preset.

#### Watermarking

| Key | Type | Description |
|---|---|---|
| `LR_useWatermark` | Boolean | True to enable watermarking on export |
| `LR_watermarking_id` | String | Unique identifier of the watermark preset to use. Assigned by Lightroom when the user creates the preset; cannot be set programmatically |

#### Post-Processing Filter

| Key | Type | Description |
|---|---|---|
| `LR_exportFiltersFromThisPlugin` | Table | Keys are filter IDs, values are the index in the filter stack. E.g. `LR_exportFiltersFromThisPlugin.myFirstFilter = 1` |

#### General Export

| Key | Type | Description |
|---|---|---|
| `LR_cantExportBecause` | String or nil | When present, disables the Export/Save button and displays the string as an explanation. Set to `nil` to re-enable the button |

#### Publish Service Properties

Available in the property table when the service is used as a publish service provider:

| Key | Type | Description |
|---|---|---|
| `LR_publish_connectionName` | String | Descriptive name of the connection, as assigned by the user |
| `LR_isExportForPublish` | Boolean (read-only) | True when the current operation is part of a publish service |
| `LR_editingExistingPublishConnection` | Boolean | True when the user is editing an existing publish service |
| `LR_publishService` | LrPublishService | When editing an existing publish service, the service object |

---

## Publish Service Provider

A publish service is declared identically to an export service in `Info.lua` but uses the `LrExportServiceProvider` key:

```lua
LrExportServiceProvider = {
    title = "Service Name",                    -- appears in Publish Services panel
    file = "MyPublishServiceProvider.lua",     -- the service definition script
},
```

Note: a publish service does **not** provide a `builtInPresetsDir` entry. Publish services cannot use presets to control settings, although they can provide defaults and modify settings via `startDialog`.

### Publish vs. Export Differences

A publish service differs from an export service in these ways:

- **Ongoing relationship**: Tracks what has been published, allowing re-export of only new or changed images
- **Location tracking**: Keeps track of where items were published and can access those locations
- **Collection management**: Can manage collections and folders on the remote destination from within the catalog
- **Feedback retrieval**: Can retrieve comment and rating information added after publication

### Published Photo States

Within a publish collection, photos exist in one of these states:

| State | Meaning |
|---|---|
| **New Photos to Publish** | Photos added to the collection but not yet published |
| **Modified Photos to Republish** | Previously published photos that have been changed (develop edits, metadata changes, etc.) |
| **Deleted Photos to Remove** | Photos that the user has removed from the collection locally but still exist at the destination |
| **Published Photos** | Photos that are up to date between the catalog and the destination |

When the user clicks Publish, Lightroom synchronizes the collection by:
1. Exporting new photos
2. Re-exporting modified photos (updating rendering or metadata)
3. Deleting removed photos from the destination
4. Updating the sort sequence (if applicable)
5. Downloading comments and ratings (if applicable)

### Additional Publish Callbacks

Beyond all the export callbacks, publish services can define these additional callbacks. For full details of each, see the Lightroom Classic SDK API Reference and the Flickr sample plug-in.

#### `getCollectionBehaviorInfo(publishSettings)`

Returns a table describing how the publish service handles collections. Controls whether collections support sorting, comments, ratings, and other behaviors.

#### `metadataThatTriggersRepublish(publishSettings)`

Returns a table of metadata fields that, when changed, should cause a published photo to move from "Published" to "Modified Photos to Republish" state. This lets the service define which metadata changes are significant enough to warrant republishing.

#### `deletePhotosFromPublishedCollection(publishSettings, arrayOfPhotoIds, deletedCallback, localCollectionId)`

Called when the user publishes and there are photos in the "Deleted Photos to Remove" state. The plug-in should delete these photos from the remote service and call the `deletedCallback` for each successfully deleted photo.

**Important:** `arrayOfPhotoIds` contains remote ID **strings** (NOT `LrPhoto` objects). These are the IDs previously assigned via `rendition:recordPublishedPhotoId()`. For each photo successfully deleted from the remote service, the plug-in must call `deletedCallback(remotePhotoId)` to inform Lightroom that the deletion succeeded.

```lua
deletePhotosFromPublishedCollection = function(publishSettings, arrayOfPhotoIds, deletedCallback, localCollectionId)
    for _, remoteId in ipairs(arrayOfPhotoIds) do
        local success = myRemoteDeleteFunction(remoteId)
        if success then
            deletedCallback(remoteId)
        end
    end
end,
```

#### `renamePublishedCollection(publishSettings, info)`

Called when the user renames a published collection. The plug-in can mirror this change on the remote service (e.g. rename a remote album/set).

#### `addPhotosToPublishedCollection(publishSettings, arrayOfPhotos, publishedCollectionInfo)`

Called when photos are added to a published collection. Allows the service to respond to additions.

#### `removePhotosFromPublishedCollection(publishSettings, arrayOfPhotos, publishedCollectionInfo)`

Called when photos are removed from a published collection locally.

#### `getCommentsFromPublishedCollection(publishSettings, arrayOfPhotoInfo, commentCallback)`

Retrieves comments from the remote service for the given photos. The plug-in calls `commentCallback` with the comment data, which is then displayed in Lightroom's Comments panel.

#### `shouldReverseSequenceForPublishedCollection(publishSettings, collectionInfo)`

Controls the sort order of photos in the published collection.

#### `didCreateNewPublishService(publishSettings, info)`

Called after creating a publish service. Allows the plug-in to perform initialization (e.g. create default collections on the remote service).

#### `didUpdatePublishService(publishSettings, info)`

Called after the user updates publish service settings via the Publishing Manager.

#### `goToPublishedCollection(publishSettings, info)`

Open the published collection in the user's browser on the remote service.

#### `goToPublishedPhoto(publishSettings, info)`

Open a specific published photo in the user's browser on the remote service.

#### `reparentPublishedCollection(publishSettings, info)`

Called when the user moves a published collection to a different parent collection set.

The `info` table contains:
- `info.remoteId` -- the remote ID of the collection being moved
- `info.name` -- the name of the collection
- `info.publishedCollection` -- the `LrPublishedCollection` object
- `info.publishService` -- the `LrPublishService` object
- `info.parents` -- array of parent info tables, each containing:
  - `remoteCollectionId` -- remote ID of the parent collection set
  - `name` -- name of the parent collection set
  - `localCollectionId` -- local identifier of the parent collection set

#### `viewForCollectionSetSettings(f, publishSettings, info)`

Returns custom UI for collection set settings dialog. The `f` parameter is a view factory.

#### `updateCollectionSetSettings(publishSettings, info)`

Called to save collection set settings when the user confirms the dialog.

#### `shouldDeletePublishedCollection(publishSettings, info)`

Called to confirm collection deletion. Return `true` to allow deletion.

#### `willDeletePublishService(publishSettings, info)`

Called before a publish service is deleted. Allows the plug-in to clean up remote resources.

#### `deletePublishedCollection(publishSettings, info)`

Called when a published collection is deleted. The plug-in should remove the corresponding resource on the remote service.

#### `canAddCommentsToService`

A Boolean value (not a function). When `true`, enables the Comments panel for photos in this publish service.

### UI Customization Properties

These string or Boolean properties on the publish service provider table customize the labels and behavior shown in the Publish Services panel:

| Property | Description |
|---|---|
| `titleForPublishedCollection` | Custom label for collections (default: "Collection") |
| `titleForPublishedCollection_standalone` | Standalone form of the collection label |
| `titleForPublishedCollectionSet` | Custom label for collection sets |
| `titleForPublishedCollectionSet_standalone` | Standalone form of the collection set label |
| `titleForPublishedSmartCollection` | Custom label for smart collections |
| `titleForPublishedSmartCollection_standalone` | Standalone form of the smart collection label |
| `titleForGoToPublishedCollection` | Menu item text for "Go to Collection". Set to the string `"disable"` to hide the menu item entirely. |
| `titleForGoToPublishedPhoto` | Menu item text for "Go to Photo" |
| `disableRenamePublishedCollection` | Boolean. Prevent the user from renaming collections |
| `disableRenamePublishedCollectionSet` | Boolean. Prevent the user from renaming collection sets |
| `publish_fallbackNameBinding` | Property key to use as publish service name fallback |
| `small_icon` | Icon for the publish service panel (e.g., `"small_icon.png"`) |

### Additional Publish Property Keys

Available in the property table during publish service dialogs:

| Key | Type | Description |
|---|---|---|
| `LR_cantExportBecause` | String or nil | Set to a string to disable export with that message; set to `nil` to enable the Export/Publish button |
| `LR_editingExistingPublishConnection` | Boolean | True when editing an existing publish connection vs. creating a new one |
| `LR_publishService` | LrPublishService | Reference to the publish service object in the property table |
| `supportsIncrementalPublish` | Boolean | When `true`, enables publish tracking so Lightroom maintains published/modified/new states for photos in published collections. This is the key boolean that activates the incremental publish workflow. |

### Advanced Publish Callbacks and Patterns

These callbacks and patterns were discovered through analysis of real-world publish plugins (500px Publisher, pixid).

#### OAuth via URLHandler

The `URLHandler` entry in Info.lua can serve as an OAuth callback receiver. When a URL is opened with the plugin's custom scheme, the handler function is invoked:

```lua
-- In Info.lua:
URLHandler = '500pxURLHandler.lua',

-- In 500pxURLHandler.lua:
return {
    URLHandler = function(url)
        -- Parse OAuth tokens from the redirect URL
        local token = url:match("oauth_token=([^&]+)")
        local verifier = url:match("oauth_verifier=([^&]+)")
    end
}
```

#### LrDialogs.stopModalWithResult

Can programmatically dismiss a modal dialog from an external callback (e.g. when an OAuth redirect arrives while a "waiting for authorization" dialog is open):

```lua
LrDialogs.stopModalWithResult(contentsView, "ok")
-- First arg is the view contents (not a dialog handle)
```

#### Composite Remote ID Pattern

Encode both photo ID and collection ID into a single remoteId for multi-collection tracking:

```lua
rendition:recordPublishedPhotoId(string.format("%s-%s", photoId, collectionId))
-- Parse back: local photoId, collectionId = string.match(remoteId, "([^-]+)-([^-]+)")
```

#### addPhotoByRemoteId for Cross-Collection Sync

```lua
publishedCollection:addPhotoByRemoteId(photo, remoteId, remoteUrl, alreadyPublished)
-- alreadyPublished (boolean): when true, photo is marked as up-to-date
```

#### metadataThatTriggersRepublish with Plugin Metadata

```lua
function provider.metadataThatTriggersRepublish(publishSettings)
    return {
        default = false,  -- IMPORTANT: only listed fields trigger republish
        title = true,
        caption = true,
        ["com.myplugin.myField"] = true,  -- plugin metadata keys work too
    }
end
```

#### shouldDeletePhotosFromServiceOnDeleteFromCatalog

Return `nil` to suppress the deletion dialog entirely (neither delete nor prompt).

#### shouldDeletePublishedCollection

Can return `"cancel"` to prevent collection deletion (not just `true`/`false`).

#### validatePublishedCollectionName(newName)

Called when user renames a collection. Return `true` to accept.

#### LR_canSaveCollection

Set `info.collectionSettings.LR_canSaveCollection = false` in `viewForCollectionSettings` to make a collection read-only.

### Publish Collections

#### Managed vs. Unmanaged Collections

- **Managed collections**: Created and controlled by the plug-in (e.g. a "Photostream" collection auto-created when the service is set up)
- **Unmanaged collections**: Created by the user, who adds photos manually

#### Collection Sets for Hierarchy

Published collections can be organized into collection sets, providing a hierarchical folder-like structure. Collection sets can contain both collections and nested collection sets.

#### Smart Collections within Publish Services

Users can create smart published collections within a publish service. These automatically populate based on metadata criteria, just like regular smart collections in the Library module.

---

## Export Filter Provider

Export Filter Providers define post-process actions that modify renditions after Lightroom's initial rendering but before they reach the Export Service Provider.

### Declaring in Info.lua

```lua
LrExportFilterProvider = {
    title = "Filter Name",                -- display name in the dialog
    file = "MyExportFilterProvider.lua",  -- action definition script
    id = "myFilter",                      -- unique identifier within this plug-in
    requiresFilter = "mainFilter",        -- optional: ID of the main processing filter
    supportsVideo = true,                 -- optional: default is false
},
```

Multiple filters can be declared as a table of tables:

```lua
LrExportFilterProvider = {
    {
        title = "MyAction",
        file = "myAction.lua",
        id = "main",
    },
    {
        title = "Color",
        file = "colorAction.lua",
        id = "color",
        requiresFilter = "main",
    },
    {
        title = "Lines",
        file = "lineAction.lua",
        id = "lines",
        requiresFilter = "main",
    },
},
```

### Action Definition Script

The script returns a table with optional entries:

| Entry | Description |
|---|---|
| `postProcessRenderedPhotos(functionContext, filterContext)` | Defines how the action processes rendered photos. Typically only the main action defines this |
| `shouldRenderPhoto(exportSettings, photo)` | Return `true` to keep the photo, `false` to remove it from the export list |
| `startDialog` / `endDialog` | Same as for export services |
| `exportPresetFields` | Custom persistent settings for this filter |
| `sectionForFilterInDialog(viewFactory, propertyTable)` | Returns a **single** section definition (not an array) shown when the action is selected |

### Filter Processing Pattern

```lua
function MyFilter.postProcessRenderedPhotos( functionContext, filterContext )
    for sourceRendition, renditionToSatisfy in filterContext:renditions() do
        -- Wait for the upstream task to finish rendering this photo
        local success, pathOrMessage = sourceRendition:waitForRender()

        if success then
            -- Process the rendered photo (e.g. invoke external tool)
            local status = LrTasks.execute( 'mytool "' .. pathOrMessage .. '"' )

            if status ~= 0 then
                renditionToSatisfy:renditionIsDone( false, "Processing failed" )
            end
            -- If successful, renditionIsDone is called automatically by the iterator
        end
    end
end
```

### Removing Photos from Export

Use `shouldRenderPhoto` to filter photos based on criteria:

```lua
function MyFilter.shouldRenderPhoto( exportSettings, photo )
    local minRating = exportSettings.min_rating or 1
    local rating = photo:getRawMetadata( 'rating' )
    return rating and rating >= minRating
end
```

For publish operations, returning `false` keeps the photo in "New Photos to Publish" state rather than removing it.

### Filter Chaining

- A single export session has exactly one Export Service Provider but can have any number of post-process actions.
- Actions execute in the order they appear in the dialog.
- Each filter runs in its own `LrTask`, so operations overlap (run in parallel).
- A filter must produce output conforming exactly to the specifications expected by its downstream consumer (correct format, correct path).
- Use `renditionToSatisfy:renditionIsDone(false, message)` to report failures with a meaningful message.

### Advanced: Overriding Render Settings per Filter

A filter can request a different file format from its upstream provider:

```lua
local renditionOptions = {
    filterSettings = function( renditionToSatisfy, exportSettings )
        exportSettings.LR_format = 'TIFF'
        return os.tmpname()  -- override the filename for the input
    end,
}
for sourceRendition, renditionToSatisfy in filterContext:renditions( renditionOptions ) do
    -- ...
end
```

When doing this, the filter is responsible for producing the originally requested format and placing it at the path expected by `renditionToSatisfy`.

---

## Rendering Pipeline (5 Stages)

The complete export operation proceeds through five stages. Each provider (export service, filters, Lightroom's render engine) runs in its own task, so stages overlap for different photos.

### Stage 1: Determine Render Settings

If the service defines `updateExportSettings(exportSettings)`, it is called to force or override render settings. Filters are not involved at this stage.

```lua
updateExportSettings = function( exportSettings )
    exportSettings.LR_size_maxHeight = 400
    exportSettings.LR_size_maxWidth = 400
end,
```

### Stage 2: Decide Which Photos to Render

Filters are invoked top-to-bottom. For each filter, if `shouldRenderPhoto(exportSettings, photo)` is defined, it is called for each photo. Returning `false` removes the photo from the export list. If the function is not defined, all photos pass through.

### Stage 3: Request Renditions

1. The `LrExportSession` generates `LrExportRendition` request objects for every photo that survived Stage 2 (no actual rendering yet).
2. The service's `processRenderedPhotos(functionContext, exportContext)` is called.
3. `processRenderedPhotos` calls `exportContext:renditions()` and waits for each rendition via `rendition:waitForRender()`.
4. The service's rendition requests are sent upstream to the bottom-most filter (or directly to Lightroom's render engine if no filters are present).
5. For each filter with `postProcessRenderedPhotos` defined, it enters its own `filterContext:renditions()` loop, generating new rendition requests upstream.
6. After all filters have intercepted requests, they reach Lightroom's built-in rendering engine.

Each provider runs in its own `LrTask`, so multiple photos can be in process simultaneously by different providers. This parallelism makes the overall export much faster.

### Stage 4: Process Rendered Photos

As Lightroom completes each rendition, `waitForRender()` calls complete in top-to-bottom sequence:

1. The upstream `waitForRender()` completes -- a valid file is now available at the specified path.
2. The filter processes the file (typically invoking an external tool via `LrTasks.execute()`).
3. The filter calls `renditionToSatisfy:renditionIsDone(success, message)` (or lets the iterator do so automatically).
4. This allows the downstream consumer's `waitForRender()` to complete.
5. The process continues for the next rendition.
6. Once all filters finish, the service's `processRenderedPhotos` loop completes its work (upload, copy, etc.).
7. If "Add to this Catalog" was selected, Lightroom adds the new photo to the catalog.

### Stage 5: Error Reporting and Clean Up

After the service's `processRenderedPhotos` loop completes:

- If photos were rendered into a temporary folder, Lightroom deletes it.
- If the export was triggered through the Export dialog:
  - Plays the export completion sound (if configured)
  - Shows an error dialog summarizing any failures
  - Creates a temporary "Previous Export" collection with the source photos

These behaviors are not available when export is initiated programmatically via `LrExportSession`.

---

## Complete Export Service Provider Example

```lua
-- MyExportServiceProvider.lua
local LrView = import "LrView"
local LrDialogs = import "LrDialogs"
local LrFileUtils = import "LrFileUtils"
local LrPathUtils = import "LrPathUtils"
local LrTasks = import "LrTasks"

local bind = LrView.bind

local exportServiceProvider = {}

-- Custom persistent settings
exportServiceProvider.exportPresetFields = {
    { key = 'serverUrl',  default = 'https://example.com/upload' },
    { key = 'apiToken',   default = '' },
    { key = 'albumName',  default = '' },
}

-- Hide sections we don't need for a web upload
exportServiceProvider.hideSections = { 'exportLocation' }

-- Restrict to web-friendly formats
exportServiceProvider.allowFileFormats = { 'JPEG' }
exportServiceProvider.allowColorSpaces = { 'sRGB' }

-- Hide print resolution (pixels only)
exportServiceProvider.hidePrintResolution = true

-- Can use temporary location (automatic since we hide exportLocation)
exportServiceProvider.canExportToTemporaryLocation = true

-- Dialog initialization
function exportServiceProvider.startDialog( propertyTable )
    -- Validate that we have an API token
    if propertyTable.apiToken == '' then
        propertyTable.LR_cantExportBecause = "Please enter an API token."
    else
        propertyTable.LR_cantExportBecause = nil
    end
end

function exportServiceProvider.endDialog( propertyTable, why )
    -- Clean up if needed
end

-- Custom section at top of dialog
function exportServiceProvider.sectionsForTopOfDialog( viewFactory, propertyTable )
    return {
        {
            title = "My Service Settings",
            synopsis = bind 'serverUrl',
            viewFactory:column {
                spacing = viewFactory:control_spacing(),
                viewFactory:row {
                    viewFactory:static_text {
                        title = "Server URL:",
                        alignment = 'right',
                        width = LrView.share 'label_width',
                    },
                    viewFactory:edit_field {
                        value = bind 'serverUrl',
                        width_in_chars = 40,
                    },
                },
                viewFactory:row {
                    viewFactory:static_text {
                        title = "API Token:",
                        alignment = 'right',
                        width = LrView.share 'label_width',
                    },
                    viewFactory:password_field {
                        value = bind 'apiToken',
                        width_in_chars = 40,
                    },
                },
                viewFactory:row {
                    viewFactory:static_text {
                        title = "Album:",
                        alignment = 'right',
                        width = LrView.share 'label_width',
                    },
                    viewFactory:edit_field {
                        value = bind 'albumName',
                        width_in_chars = 30,
                    },
                },
            },
        },
    }
end

-- Force specific export settings
function exportServiceProvider.updateExportSettings( exportSettings )
    exportSettings.LR_jpeg_quality = 0.85
    exportSettings.LR_size_doConstrain = true
    exportSettings.LR_size_maxWidth = 2048
    exportSettings.LR_size_maxHeight = 2048
    exportSettings.LR_size_resizeType = 'longEdge'
end

-- Main export processing
function exportServiceProvider.processRenderedPhotos( functionContext, exportContext )
    local exportSession = exportContext.exportSession
    local exportSettings = exportContext.propertyTable
    local nPhotos = exportSession:countRenditions()

    -- Set up the progress display
    local progressScope = exportContext:configureProgress {
        title = nPhotos > 1
            and string.format( "Uploading %d photos to My Service", nPhotos )
            or  "Uploading one photo to My Service",
    }

    -- Iterate through the renditions
    for i, rendition in exportContext:renditions() do
        -- Check for user cancellation
        if progressScope:isCanceled() then break end

        -- Wait for Lightroom to finish rendering
        local success, pathOrMessage = rendition:waitForRender()

        if success then
            local filePath = pathOrMessage

            -- Upload the rendered file
            -- (Replace with your actual upload implementation)
            local uploadSuccess, uploadError = myUploadToService(
                filePath,
                exportSettings.serverUrl,
                exportSettings.apiToken,
                exportSettings.albumName
            )

            if uploadSuccess then
                -- Optionally store a remote ID for publish services
                rendition:recordPublishedPhotoId( remotePhotoId )
                rendition:recordPublishedPhotoUrl( remotePhotoUrl )
            else
                rendition:uploadFailed( uploadError )
            end

            -- Clean up the temporary file
            LrFileUtils.delete( filePath )
        else
            -- Render failed
            rendition:uploadFailed( pathOrMessage )
        end
    end
end

return exportServiceProvider
```

---

<!-- BEGIN OFFICIAL_EXPORT_PUBLISH -->
## Official Export/Publish Callback & Property Reference (SDK 11.4)

# Lightroom Classic SDK 11.4 -- Export & Publish Service Provider API Reference

Extracted from the official Adobe Lightroom Classic SDK 11.4 API Reference HTML documentation.

Both Export and Publish service providers are defined via a service definition script that returns a table of callbacks and properties. The script is identified in `Info.lua` via the `LrExportServiceProvider` entry.

Unless otherwise noted, all Export service provider hooks are also available to Publish service providers. Publish service providers have additional publish-specific callbacks and properties documented in Part 2.

---

# Part 1: Export Service Provider

The service definition script for an export service provider defines the hooks that your plug-in uses to extend the behavior of Lightroom's Export features. The returned table contains:
- A pair of functions that initialize and terminate your export service.
- Settings that you define for your export service.
- One or more items that define desired customizations for the Export dialog.
- A function that defines the export operation to be performed on rendered photos (required).

---

## Export Service Provider -- Callbacks (Functions)

### startDialog
- **Signature:** `function exportServiceProvider.startDialog(propertyTable)`
- **Parameters:**
  - `propertyTable` (table): An observable table that contains the most recent settings for your export or publish plug-in, including both settings that you have defined and Lightroom-defined export settings.
- **Returns:** Nothing.
- **Required:** No (optional)
- **Notes:** Called when the user chooses this export service provider in the Export or Publish dialog, or when the destination is already selected when the dialog is invoked (remembered from the previous export operation). This is a blocking call. If you need to start a long-running task (such as network access), create a task using `LrTasks`. First supported in version 1.3 of the Lightroom SDK.

---

### endDialog
- **Signature:** `function exportServiceProvider.endDialog(propertyTable, why)`
- **Parameters:**
  - `propertyTable` (table): An observable table that contains the most recent settings for your export or publish plug-in, including both settings that you have defined and Lightroom-defined export settings.
  - `why` (string): The reason this function was called. One of `'ok'`, `'cancel'`, or `'changedServiceProvider'`.
- **Returns:** Nothing.
- **Required:** No (optional)
- **Notes:** Called when the user chooses a different export service provider in the Export or Publish dialog or closes the dialog. This is a blocking call. If you need to start a long-running task, create a task using `LrTasks`. First supported in version 1.3 of the Lightroom SDK.

---

### sectionsForTopOfDialog
- **Signature:** `function exportServiceProvider.sectionsForTopOfDialog(f, propertyTable)`
- **Parameters:**
  - `f` (`LrView.osFactory` object): A view factory object.
  - `propertyTable` (table): An observable table that contains the most recent settings for your export or publish plug-in, including both settings that you have defined and Lightroom-defined export settings.
- **Returns:** (table) An array of dialog sections (see example code for details).
- **Required:** No (optional)
- **Notes:** Called when the user chooses this export service provider in the Export or Publish dialog. Creates new sections that appear above all of the built-in sections in the dialog (except for the Publish Service section in the Publish dialog, which always appears at the very top). Your plug-in's `startDialog` function, if any, is called before this function. This is a blocking call. First supported in version 1.3 of the Lightroom SDK.

---

### sectionsForBottomOfDialog
- **Signature:** `function exportServiceProvider.sectionsForBottomOfDialog(f, propertyTable)`
- **Parameters:**
  - `f` (`LrView.osFactory` object): A view factory object.
  - `propertyTable` (table): An observable table that contains the most recent settings for your export or publish plug-in, including both settings that you have defined and Lightroom-defined export settings.
- **Returns:** (table) An array of dialog sections (see example code for details).
- **Required:** No (optional)
- **Notes:** Called when the user chooses this export service provider in the Export or Publish dialog. Creates new sections that appear below all of the built-in sections in the dialog. Your plug-in's `startDialog` function, if any, is called before this function. This is a blocking call. First supported in version 1.3 of the Lightroom SDK.

---

### updateExportSettings
- **Signature:** `function exportServiceProvider.updateExportSettings(exportSettings)`
- **Parameters:**
  - `exportSettings` (table): The current export settings.
- **Returns:** Nothing.
- **Required:** No (optional)
- **Notes:** Called at the beginning of each export and publish session before the rendition objects are generated. Provides an opportunity for your plug-in to modify the export settings. First supported in version 2.0 of the Lightroom SDK.

---

### processRenderedPhotos
- **Signature:** `function exportServiceProvider.processRenderedPhotos(functionContext, exportContext)`
- **Parameters:**
  - `functionContext` (`LrFunctionContext`): Function context that you can use to attach clean-up behaviors to this process; this function context terminates as soon as your function exits.
  - `exportContext` (`LrExportContext`): Information about your export settings and the photos to be published.
- **Returns:** Nothing.
- **Required:** No (optional, but effectively required for any useful export/publish operation)
- **Notes:** Called for each exported photo after it is rendered by Lightroom and after all post-process actions have been applied to it. This function is responsible for transferring the image file to its destination, as defined by your plug-in. The function is launched within a cooperative task that Lightroom provides. You do not need to start your own task. First supported in version 1.3 of the Lightroom SDK.

---

## Export Service Provider -- Properties

### exportPresetFields
- **Type:** table (array of `{key, default}` items)
- **Required:** No (optional)
- **Notes:** Declares which fields in your property table should be saved as part of an export preset or a publish service connection. Each entry has a `key` (string matching the UI control value name) and a `default` (value used the first time the plug-in is selected). On subsequent activations, user-chosen values from the previous session are used. First supported in version 1.3 of the Lightroom SDK.

### allowFileFormats
- **Type:** table (array of strings)
- **Required:** No (optional)
- **Notes:** Restricts available file format choices in the Export or Publish dialogs. Cannot be used together with `disallowFileFormats`. Valid strings: `"JPEG"`, `"PSD"`, `"TIFF"`, `"DNG"`, `"ORIGINAL"`. Affects still photo files only. First supported in version 1.3.

### disallowFileFormats
- **Type:** table (array of strings)
- **Required:** No (optional)
- **Notes:** Suppresses named file formats from the list. Cannot be used together with `allowFileFormats`. Same valid strings as `allowFileFormats`. Affects still photo files only. First supported in version 1.3.

### allowColorSpaces
- **Type:** table (array of strings)
- **Required:** No (optional)
- **Notes:** Restricts available color space choices. Cannot be used together with `disallowColorSpaces`. Valid strings: `"sRGB"`, `"AdobeRGB"`, `"ProPhotoRGB"`. Affects still photo files only. First supported in version 1.3.

### disallowColorSpaces
- **Type:** table (array of strings)
- **Required:** No (optional)
- **Notes:** Suppresses named color spaces from the list. Cannot be used together with `allowColorSpaces`. Same valid strings as `allowColorSpaces`. Affects still photo files only. First supported in version 1.3.

### allowVideoExportPresets
- **Type:** table (array of tables with `formatID` and optional `presetName`)
- **Required:** No (optional)
- **Notes:** Restricts available video export preset choices. Cannot be used together with `disallowVideoExportPresets`. Each sub-table must contain a `formatID` string. Special `formatID` value `"original"` allows the "Original" entry in the Video Format popup. Use `LrExportSettings.videoExportPresets` to obtain available presets. Affects video files only. First supported in version 4.0.

### disallowVideoExportPresets
- **Type:** table (array of tables with `formatID` and optional `presetName`)
- **Required:** No (optional)
- **Notes:** Suppresses named video export preset choices. Cannot be used together with `allowVideoExportPresets`. Affects video files only. First supported in version 4.0.

### hideSections
- **Type:** table (array of strings)
- **Required:** No (optional)
- **Notes:** Suppresses the display of named sections in the Export or Publish dialogs. Cannot be used together with `showSections`. Valid strings: `"exportLocation"`, `"fileNaming"`, `"fileSettings"`, `"imageSettings"`, `"outputSharpening"`, `"metadata"`, `"watermarking"`, `"video"`. Cannot suppress "Connection Name" in Publish Manager. If `"exportLocation"` is suppressed, files render to a temporary folder deleted after export completes. First supported in version 1.3.

### showSections
- **Type:** table (array of strings)
- **Required:** No (optional)
- **Notes:** Restricts the display of sections to those named. Cannot be used together with `hideSections`. Same valid strings as `hideSections`. First supported in version 1.3.

### hidePrintResolution
- **Type:** Boolean
- **Required:** No (optional)
- **Notes:** When true, hides print resolution controls in the Image Sizing section of the Export or Publish dialog. Recommended when uploading to most web services. First supported in version 1.3.

### canExportVideo
- **Type:** Boolean or string
- **Required:** No (optional)
- **Notes:** When `true`, both video and still photos can be exported. When `false` or not present, video files cannot be exported. When set to the string `"only"`, video files can be exported but not still photos. First supported in version 3.0.

### canExportToTemporaryLocation
- **Type:** Boolean
- **Required:** No (optional)
- **Notes:** If your plug-in allows the display of the `exportLocation` section, this controls whether "Temporary folder" is available. If the user selects this option, files are rendered into a temporary location deleted when export finishes. If the `exportLocation` section is hidden, temporary location behavior is always used.

### supportsIncrementalPublish
- **Type:** Boolean or string
- **Required:** No (optional)
- **Notes:** Declares whether this plug-in supports the Lightroom publish feature. If not present, the plug-in is available in Export only. When `true`, available for both Export and Publish. When set to the string `"only"`, visible only in Publish.

---

# Part 2: Publish Service Provider

The publish service provider extends the export service provider with additional callbacks and properties specific to Lightroom's Publish feature. Because much of the functionality is the same as an export service, all Export callbacks above also apply to Publish.

Publish services, unlike export services, cannot create presets. The settings tables passed to callbacks contain only Lightroom-defined settings and settings explicitly declared in `exportPresetFields`. Callback functions defined for a publish service cannot make any changes to the settings table passed to them.

---

## Publish Service Provider -- Callbacks (Functions)

### addCommentToPublishedPhoto
- **Signature:** `function publishServiceProvider.addCommentToPublishedPhoto(publishSettings, remotePhotoId, commentText)`
- **Parameters:**
  - `publishSettings` (table): The settings for this publish service, as specified by the user in the Publish Manager dialog. Changes do not persist beyond this function call.
  - `remotePhotoId` (string or number): The remote ID of the photo as previously assigned via `exportRendition:recordRemotePhotoId()`.
  - `commentText` (string): The text of the new comment.
- **Returns:** (Boolean) `true` if the comment was successfully added to the service.
- **Required:** No (optional)
- **Notes:** Called when the user adds a new comment to a published photo in the Library module's Comments panel. Your implementation should publish the comment to the service. Non-blocking call (runs within an LrTasks task). First supported in version 3.0.

---

### canAddCommentsToService
- **Signature:** `function publishServiceProvider.canAddCommentsToService(publishSettings)`
- **Parameters:**
  - `publishSettings` (table): The settings for this publish service. Changes do not persist beyond this function call.
- **Returns:** (Boolean) `true` if comments can be added at this time.
- **Required:** No (optional)
- **Notes:** Called whenever a published photo is selected in the Library module. Return `true` if there is a viable connection to the publish service and comments can be added. If not implemented, the new comment section of the Comments panel is left enabled at all times. Allows you to disable the Comments panel temporarily (e.g., if server is down). Non-blocking call. First supported in version 3.0.

---

### deleteFirstOnPublish
- **Signature:** `function publishServiceProvider.deleteFirstOnPublish()`
- **Parameters:** None.
- **Returns:** (Boolean) `true` to delete before publishing, `false` to delete after (default behavior).
- **Required:** No (optional)
- **Notes:** Called when publishing has been initiated. Controls whether deletion of photos from the service takes place before publishing new images / updating previously published images. Default behavior is to delete as the last step. First supported in version 4.0.

---

### deletePhotosFromPublishedCollection
- **Signature:** `function publishServiceProvider.deletePhotosFromPublishedCollection(publishSettings, arrayOfPhotoIds, deletedCallback, localCollectionId)`
- **Parameters:**
  - `publishSettings` (table): The settings for this publish service. Changes do not persist beyond this function call.
  - `arrayOfPhotoIds` (table): The remote photo IDs that were declared by this plug-in when they were published.
  - `deletedCallback` (function): Must be called for each photo ID as soon as the deletion is confirmed by the remote service. Takes a single argument: the photo ID from `arrayOfPhotoIds`.
  - `localCollectionId` (number): The local identifier for the collection from which photos are being removed.
- **Returns:** Nothing.
- **Required:** Yes (required for publish services that support deletion)
- **Notes:** Called when one or more photos have been removed from a published collection and need to be removed from the service. As each photo is deleted, call `deletedCallback` to inform Lightroom. This causes Lightroom to remove the photo from the "Delete Photos to Remove" group. Non-blocking call. First supported in version 3.0.

---

### deletePublishedCollection
- **Signature:** `function publishServiceProvider.deletePublishedCollection(publishSettings, info)`
- **Parameters:**
  - `publishSettings` (table): The settings for this publish service. Changes do not persist beyond this function call.
  - `info` (table): A table with these fields:
    - `isDefaultCollection` (Boolean): True if this is the default collection.
    - `name` (string): The name of this collection.
    - `parents` (table): Array of parent information, each containing:
      - `localCollectionId` (number)
      - `name` (string)
      - `remoteCollectionId` (number or string)
    - `publishService` (`LrPublishService`): The publish service object.
    - `publishedCollection` (`LrPublishedCollection` or `LrPublishedCollectionSet`): The collection object being deleted.
    - `remoteId` (string or number): The ID stored via `exportSession:recordRemoteCollectionId`.
    - `remoteUrl` (optional, string): The URL stored via `exportSession:recordRemoteCollectionUrl`.
- **Returns:** Nothing. Throw a Lua error via `error()` if unable to update the remote service.
- **Required:** Yes (for publish services)
- **Notes:** Called when the user has deleted a published collection via the Publish Services panel UI. Only invoked when the user clicks "Delete" in the confirmation dialog (not if they choose to leave photos). If you throw an error, Lightroom presents a dialog asking the user whether to revert or proceed locally. Non-blocking call. First supported in version 3.0.

---

### didCreateNewPublishService
- **Signature:** `function publishServiceProvider.didCreateNewPublishService(publishSettings, info)`
- **Parameters:**
  - `publishSettings` (table): The settings for this publish service. Changes do not persist beyond this function call.
  - `info` (table): A table with these fields:
    - `connectionName` (string): The name of the newly-created service.
    - `publishService` (`LrPublishService`): The publish service object.
- **Returns:** Nothing.
- **Required:** No (optional)
- **Notes:** Called when the user creates a new publish service via the Publish Manager dialog. Allows your plug-in to perform additional initialization. Non-blocking call. First supported in version 3.0.

---

### didUpdatePublishService
- **Signature:** `function publishServiceProvider.didUpdatePublishService(publishSettings, info)`
- **Parameters:**
  - `publishSettings` (table): The settings for this publish service. Changes do not persist beyond this function call.
  - `info` (table): A table with these fields:
    - `connectionName` (string): The name of the service.
    - `nPublishedPhotos` (number): How many photos are currently published on the service.
    - `publishService` (`LrPublishService`): The publish service object.
    - `changedMoreThanName` (boolean): `true` if any setting other than the name (description) has changed.
- **Returns:** Nothing.
- **Required:** No (optional)
- **Notes:** Called when the user updates the settings of an existing publish service via the Publish Manager dialog. Non-blocking call. First supported in version 3.0.

---

### endDialogForCollectionSettings
- **Signature:** `function publishServiceProvider.endDialogForCollectionSettings(publishSettings, info)`
- **Parameters:**
  - `publishSettings` (table): The settings for this publish service. Changes do not persist beyond this function call.
  - `info` (table): A table with these fields:
    - `collectionSettings` (`LrObservableTable`): Plug-in specific settings for this collection. Values must be numbers, strings, or Booleans. Accessible via `LrPublishedCollection:getCollectionInfoSummary`.
    - `collectionType` (string): Either `"collection"` or `"smartCollection"`.
    - `isDefaultCollection` (Boolean): True if this is the default collection.
    - `name` (string): The name of the collection (at dialog close or at initiation if canceled).
    - `parents` (table): Array of parent info (only present when editing existing collection), each containing `localCollectionId`, `name`, `remoteCollectionId`.
    - `pluginContext` (`LrObservableTable`): Transient state storage, discarded after this callback.
    - `publishedCollection` (`LrPublishedCollection`): The published collection object being edited.
    - `publishService` (`LrPublishService`): The publish service object.
    - `why` (string): `"ok"` or `"cancel"`.
- **Returns:** Nothing.
- **Required:** No (optional)
- **Notes:** Called when the user closes the dialog for creating/editing a published collection. Only called if you also provide `viewForCollectionSettings`. Opportunity to clean up tasks. Do NOT update the server here; use `updateCollectionSettings` instead. This is a blocking call. First supported in version 3.0.

---

### endDialogForCollectionSetSettings
- **Signature:** `function publishServiceProvider.endDialogForCollectionSetSettings(publishSettings, info)`
- **Parameters:**
  - `publishSettings` (table): The settings for this publish service. Changes do not persist beyond this function call.
  - `info` (table): A table with these fields:
    - `collectionSettings` (`LrObservableTable`): Plug-in specific settings for this collection set. Values must be numbers, strings, or Booleans. Accessible via `LrPublishedCollectionSet:getCollectionSetInfoSummary`.
    - `collectionType` (string): `"collectionSet"`.
    - `isDefaultCollection` (boolean): Always false.
    - `name` (string): The name of the collection set.
    - `parents` (table): Array of parent info (only present when editing existing collection set), each containing `localCollectionId`, `name`, `remoteCollectionId`.
    - `pluginContext` (`LrObservableTable`): Transient state storage, discarded after this callback.
    - `publishedCollectionSet` (`LrPublishedCollectionSet`): The published collection set object being edited.
    - `publishService` (`LrPublishService`): The publish service object.
    - `why` (string): `"ok"` or `"cancel"`.
- **Returns:** Nothing.
- **Required:** No (optional)
- **Notes:** Called when the user closes the dialog for creating/editing a published collection set. Only called if you also provide `viewForCollectionSetSettings`. Opportunity to clean up tasks. Do NOT update the server here; use `updateCollectionSetSettings` instead. This is a blocking call. First supported in version 3.0.

---

### getCollectionBehaviorInfo
- **Signature:** `function publishServiceProvider.getCollectionBehaviorInfo(publishSettings)`
- **Parameters:**
  - `publishSettings` (table): The settings for this publish service. Changes do not persist beyond this function call.
- **Returns:** (table) A table with these fields:
  - `defaultCollectionName` (string): The name for the default collection. Defaults to "untitled" if not specified.
  - `defaultCollectionCanBeDeleted` (Boolean): True to allow user to delete the default collection. Default is `true`.
  - `canAddCollection` (Boolean): True to allow user to add collections through the UI. Default is `true`.
  - `maxCollectionSetDepth` (number): Maximum nesting depth for collection sets, or zero to disallow collection sets. If not specified, unlimited nesting is allowed.
- **Required:** No (optional)
- **Notes:** If provided, Lightroom calls this to retrieve the default collection behavior, then uses that information to create a built-in default collection (if one does not yet exist). This special collection is marked in italics and always listed at the top. First supported in version 3.0.

---

### getCommentsFromPublishedCollection
- **Signature:** `function publishServiceProvider.getCommentsFromPublishedCollection(publishSettings, arrayOfPhotoInfo, commentCallback)`
- **Parameters:**
  - `publishSettings` (table): The settings for this publish service. Changes do not persist beyond this function call.
  - `arrayOfPhotoInfo` (table): An array of tables, each containing:
    - `photo` (`LrPhoto`): The photo object.
    - `publishedPhoto` (`LrPublishedPhoto`): The publishing data for that photo.
    - `remoteId` (string or number): The remote system's unique identifier for the photo.
    - `url` (string, optional): The URL for the photo as recorded by the plug-in.
    - `commentCount` (number): Number of existing comments for this photo in Lightroom's catalog database.
  - `commentCallback` (function): Call for each photo to register comments. Usage: `commentCallback { publishedPhoto = photoInfo, comments = commentList }`. Each comment in `commentList` is a table with: `commentId`, `commentText`, `dateCreated` (Cocoa date format), `username`, `realname`.
- **Returns:** Nothing.
- **Required:** No (optional)
- **Notes:** Called to retrieve comments from the remote service for a collection of published photos. Called: (1) for every photo when any photo in the collection is published/re-published, (2) when the user clicks Refresh in the Comments panel, (3) after the user adds a new comment. Not called for unpublished photos. Non-blocking call. First supported in version 3.0.

---

### getRatingsFromPublishedCollection
- **Signature:** `function publishServiceProvider.getRatingsFromPublishedCollection(publishSettings, arrayOfPhotoInfo, ratingCallback)`
- **Parameters:**
  - `publishSettings` (table): The settings for this publish service. Changes do not persist beyond this function call.
  - `arrayOfPhotoInfo` (table): An array of tables, each containing:
    - `photo` (`LrPhoto`): The photo object.
    - `publishedPhoto` (`LrPublishedPhoto`): The publishing data for that photo.
    - `remoteId` (string or number): The remote system's unique identifier for the photo.
    - `url` (string, optional): The URL for the photo as recorded by the plug-in.
  - `ratingCallback` (function): Call for each photo to register ratings. Usage: `ratingCallback { publishedPhoto = photoInfo, rating = ratingNumber }`. The rating value must be a single number, displayed in the Comments panel but not otherwise parsed by Lightroom.
- **Returns:** Nothing.
- **Required:** No (optional)
- **Notes:** Called to retrieve ratings from the remote service. Same trigger conditions as `getCommentsFromPublishedCollection`. Non-blocking call. First supported in version 3.0.

---

### goToPublishedCollection
- **Signature:** `function publishServiceProvider.goToPublishedCollection(publishSettings, info)`
- **Parameters:**
  - `publishSettings` (table): The settings for this publish service. Changes do not persist beyond this function call.
  - `info` (table): A table with these fields:
    - `publishedCollection` (`LrPublishedCollection`): The published collection object.
    - `publishedCollectionInfo` (table): Publication information containing:
      - `isDefaultCollection` (boolean)
      - `name` (string)
      - `parents` (table): Array with `localCollectionId`, `name`, `remoteCollectionId`.
    - `publishService` (`LrPublishService`): The publish service object.
    - `remoteId` (string or number): The ID stored via `exportSession:recordRemoteCollectionId`.
    - `remoteUrl` (optional, string): The URL stored via `exportSession:recordRemoteCollectionUrl`.
- **Returns:** Nothing.
- **Required:** No (optional)
- **Notes:** Called when the user chooses "Go to Published Collection" context-menu item. If not provided, Lightroom uses the URL recorded via `exportSession:recordRemoteCollectionUrl`. Non-blocking call. First supported in version 3.0.

---

### goToPublishedPhoto
- **Signature:** `function publishServiceProvider.goToPublishedPhoto(publishSettings, info)`
- **Parameters:**
  - `publishSettings` (table): The settings for this publish service. Changes do not persist beyond this function call.
  - `info` (table): A table with these fields:
    - `publishedCollectionInfo` (table): Publication information containing `isDefaultCollection`, `name`, `parents` (with `localCollectionId`, `name`, `remoteCollectionId`).
    - `photo` (`LrPhoto`): The photo object.
    - `publishService` (`LrPublishService`): The publish service object.
    - `publishedPhoto` (`LrPublishedPhoto`): The object containing previously recorded publication info.
    - `remoteId` (string or number): The ID stored via `exportRendition:recordPublishedPhotoId`.
    - `remoteUrl` (optional, string): The URL stored via `exportRendition:recordPublishedPhotoUrl`.
- **Returns:** Nothing.
- **Required:** No (optional)
- **Notes:** Called when the user chooses "Go to Published Photo" context-menu item. If not provided, Lightroom invokes the URL recorded via `exportRendition:recordPublishedPhotoUrl`. Non-blocking call. First supported in version 3.0.

---

### imposeSortOrderOnPublishedCollection
- **Signature:** `function publishServiceProvider.imposeSortOrderOnPublishedCollection(publishSettings, info, remoteIdSequence)`
- **Parameters:**
  - `publishSettings` (table): The settings for this publish service. Changes do not persist beyond this function call.
  - `info` (table): A table with these fields:
    - `collectionSettings` (`LrObservableTable`): Plug-in specific settings for this collection.
    - `isDefaultCollection` (boolean)
    - `name` (string): The name of this collection.
    - `parents` (table): Array with `localCollectionId`, `name`, `remoteCollectionId`.
    - `remoteCollectionId` (string or number): The ID stored via `exportSession:recordRemoteCollectionId`.
    - `publishedUrl` (optional, string): The URL stored via `exportSession:recordRemoteCollectionUrl`.
  - `remoteIdSequence` (array of string or number): The IDs for each published photo stored via `exportRendition:recordPublishedPhotoId`, in the desired display order.
- **Returns:** Nothing.
- **Required:** No (optional)
- **Notes:** Called after each time photos are published assuming the collection is set to "User Order." Your plug-in should ensure photos are displayed in the designated sequence on the service. Non-blocking call. Requires `supportsCustomSortOrder = true`.

---

### metadataThatTriggersRepublish
- **Signature:** `function publishServiceProvider.metadataThatTriggersRepublish(publishSettings)`
- **Parameters:**
  - `publishSettings` (table): The settings for this publish service. Changes do not persist beyond this function call.
- **Returns:** (table) A table containing metadata field names as keys and Boolean `true`/`false` as values. `true` means changes to that field trigger republish status. Available keys include:
  - `default`: All built-in metadata that appears in XMP. Can be overridden by specific fields below.
  - Individual fields: `rating`, `label`, `title`, `caption`, `gps`, `gpsAltitude`, `creator`, `creatorJobTitle`, `creatorAddress`, `creatorCity`, `creatorStateProvince`, `creatorPostalCode`, `creatorCountry`, `creatorPhone`, `creatorEmail`, `creatorUrl`, `headline`, `iptcSubjectCode`, `descriptionWriter`, `iptcCategory`, `iptcOtherCategories`, `dateCreated`, `intellectualGenre`, `scene`, `location`, `city`, `stateProvince`, `country`, `isoCountryCode`, `jobIdentifier`, `instructions`, `provider`, `source`, `copyright`, `rightsUsageTerms`, `copyrightInfoUrl`, `copyrightStatus`, `keywords` (export-marked only).
  - `customMetadata`: All plug-in defined custom metadata.
  - `(plug-in ID).*`: All custom metadata from a specific plug-in.
  - `(plug-in ID).(field ID)`: A specific custom metadata field.
- **Required:** No (optional)
- **Notes:** Called whenever a new publish service is created and whenever settings are changed. Allows the plug-in to specify which metadata changes should move a photo to "Modified Photos to Re-Publish" status. This is a blocking call.

---

### renamePublishedCollection
- **Signature:** `function publishServiceProvider.renamePublishedCollection(publishSettings, info)`
- **Parameters:**
  - `publishSettings` (table): The settings for this publish service. Changes do not persist beyond this function call.
  - `info` (table): A table with these fields:
    - `isDefaultCollection` (Boolean): True if this is the default collection.
    - `name` (string): The new name being assigned to this collection.
    - `parents` (table): Array of parent info, each containing `localCollectionId`, `name`, `remoteCollectionId`.
    - `publishService` (`LrPublishService`): The publish service object.
    - `publishedCollection` (`LrPublishedCollection` or `LrPublishedCollectionSet`): The collection being renamed.
    - `remoteId` (string or number): The ID stored via `exportSession:recordRemoteCollectionId`.
    - `remoteUrl` (optional, string): The URL stored via `exportSession:recordRemoteCollectionUrl`.
- **Returns:** Nothing. Throw a Lua error via `error()` if unable to update the remote service.
- **Required:** Yes (for rename support)
- **Notes:** Called when the user has renamed a published collection. If you throw an error, Lightroom asks the user whether to revert or proceed locally. Non-blocking call. First supported in version 3.0.

---

### reparentPublishedCollection
- **Signature:** `function publishServiceProvider.reparentPublishedCollection(publishSettings, info)`
- **Parameters:**
  - `publishSettings` (table): The settings for this publish service. Changes do not persist beyond this function call.
  - `info` (table): A table with these fields:
    - `isDefaultCollection` (Boolean): True if this is the default collection.
    - `name` (string): The name of this collection.
    - `parents` (table): Array of parent info (the NEW parents), each containing `localCollectionId`, `name`, `remoteCollectionId`.
    - `publishService` (`LrPublishService`): The publish service object.
    - `publishedCollection` (`LrPublishedCollection` or `LrPublishedCollectionSet`): The collection being reparented.
    - `remoteId` (string or number): The ID stored via `exportSession:recordRemoteCollectionId`.
    - `remoteUrl` (optional, string): The URL stored via `exportSession:recordRemoteCollectionUrl`.
- **Returns:** Nothing. Throw a Lua error via `error()` if unable to update the remote service.
- **Required:** Yes (for reparent support)
- **Notes:** Called when the user has reparented (moved) a published collection via drag-and-drop in the Publish Services panel. Non-blocking call. First supported in version 3.0.

---

### shouldDeletePhotosFromServiceOnDeleteFromCatalog
- **Signature:** `function publishServiceProvider.shouldDeletePhotosFromServiceOnDeleteFromCatalog(publishSettings, nPhotos)`
- **Parameters:**
  - `publishSettings` (table): The settings for this publish service. Changes do not persist beyond this function call.
  - `nPhotos` (number): The number of photos being deleted. At least one is published through this service; some may only be published on other services or not published at all.
- **Returns:** (string) One of:
  - `"ignore"`: Leave photos on the service and forget about them.
  - `"cancel"`: Stop the deletion attempt.
  - `"delete"`: Have Lightroom delete the photos immediately from the service (triggers `deletePhotosFromPublishedCollection`).
  - `nil`: Allow Lightroom's built-in confirmation dialog to be displayed.
- **Required:** No (optional)
- **Notes:** Called when the user attempts to delete published photos from the Lightroom catalog. Allows you to customize the confirmation dialog. Do NOT delete photos from here; `deletePhotosFromPublishedCollection` handles the actual deletion. Non-blocking call. First supported in version 3.0.

---

### shouldDeletePublishService
- **Signature:** `function publishServiceProvider.shouldDeletePublishService(publishSettings, info)`
- **Parameters:**
  - `publishSettings` (table): The settings for this publish service. Changes do not persist beyond this function call.
  - `info` (table): A table with these fields:
    - `publishService` (`LrPublishService`): The publish service object.
    - `nPhotos` (number): Number of photos in published collections within this service.
    - `connectionName` (string): The name assigned to this publish service connection by the user.
- **Returns:** (string) `"cancel"`, `"delete"`, or `nil` (to allow Lightroom's default dialog).
- **Required:** No (optional)
- **Notes:** Called when the user attempts to delete the publish service. Provides an opportunity to customize the confirmation dialog. Do NOT use this hook to tear down the service; use `willDeletePublishService` instead. Non-blocking call. First supported in version 3.0.

---

### shouldDeletePublishedCollection
- **Signature:** `function publishServiceProvider.shouldDeletePublishedCollection(publishSettings, info)`
- **Parameters:**
  - `publishSettings` (table): The settings for this publish service. Changes do not persist beyond this function call.
  - `info` (table): A table with these fields:
    - `collections` (array of `LrPublishedCollection` or `LrPublishedCollectionSet`): The published collection objects.
    - `nPhotos` (number): Number of photos in the collection. Only present if a single collection is being deleted.
    - `nChildren` (number): Number of child collections within the collection set. Only present if a single collection set is being deleted.
    - `hasItemsOnService` (boolean): True if one or more photos have been published through the collection(s) to be deleted.
- **Returns:** (string) `"ignore"`, `"cancel"`, `"delete"`, or `nil` (to allow Lightroom's default dialog).
- **Required:** No (optional)
- **Notes:** Called when the user attempts to delete published collections. Provides an opportunity to customize the confirmation dialog. Do NOT use this to tear down collections; use `deletePublishedCollection` instead. Non-blocking call. First supported in version 3.0.

---

### shouldReverseSequenceForPublishedCollection
- **Signature:** `function publishServiceProvider.shouldReverseSequenceForPublishedCollection(publishSettings, collectionInfo)`
- **Parameters:**
  - `publishSettings` (table): The settings for this publish service. Changes do not persist beyond this function call.
  - `collectionInfo` (table): Information about the collection (undocumented fields).
- **Returns:** (boolean) `true` to reverse the sequence when publishing new photos.
- **Required:** No (optional)
- **Notes:** Called when new or updated photos are about to be published. Allows you to specify whether the user-specified sort order should be reversed. The Flickr sample plug-in uses this to reverse the order on the Photostream so photos appear in the Flickr web interface in the same sequence as in the library grid. Non-blocking call.

---

### updateCollectionSettings
- **Signature:** `function publishServiceProvider.updateCollectionSettings(publishSettings, info)`
- **Parameters:**
  - `publishSettings` (table): The settings for this publish service. Changes do not persist beyond this function call.
  - `info` (table): A table with these fields:
    - `collectionSettings` (`LrObservableTable`): Plug-in specific settings for this collection. Values must be numbers, strings, or Booleans. Accessible via `LrPublishedCollection:getCollectionInfoSummary`.
    - `isDefaultCollection` (Boolean): True if this is the default collection.
    - `name` (string): The name of this collection.
    - `parents` (table): Array of parent info, each containing `localCollectionId`, `name`, `remoteCollectionId`.
    - `publishedCollection` (`LrPublishedCollection` or `LrPublishedCollectionSet`): The collection being edited.
    - `publishService` (`LrPublishService`): The publish service object.
- **Returns:** Nothing.
- **Required:** No (optional)
- **Notes:** Called when the user has changed per-collection settings defined via `viewForCollectionSettings`. This is your opportunity to update the web service. Do NOT use this for dialog cleanup. Not called if the user cancels the dialog. Non-blocking call. First supported in version 3.0.

---

### updateCollectionSetSettings
- **Signature:** `function publishServiceProvider.updateCollectionSetSettings(publishSettings, info)`
- **Parameters:**
  - `publishSettings` (table): The settings for this publish service. Changes do not persist beyond this function call.
  - `info` (table): A table with these fields:
    - `collectionSettings` (`LrObservableTable`): Plug-in specific settings for this collection set. Values must be numbers, strings, or Booleans. Accessible via `LrPublishedCollectionSet:getCollectionSetInfoSummary`.
    - `isDefaultCollection` (Boolean): Always false.
    - `name` (string): The name of this collection set.
    - `parents` (table): Array of parent info, each containing `localCollectionId`, `name`, `remoteCollectionId`.
    - `publishedCollection` (`LrPublishedCollectionSet`): The collection set being edited.
    - `publishService` (`LrPublishService`): The publish service object.
- **Returns:** Nothing.
- **Required:** No (optional)
- **Notes:** Called when the user has changed per-collection-set settings defined via `viewForCollectionSetSettings`. This is your opportunity to update the web service. Do NOT use this for dialog cleanup. Not called if the user cancels. Non-blocking call. First supported in version 3.0.

---

### validatePublishedCollectionName
- **Signature:** `function publishServiceProvider.validatePublishedCollectionName(proposedName)`
- **Parameters:**
  - `proposedName` (string): The name as currently typed in the new/rename/edit collection dialog.
- **Returns:** Two values:
  1. (Boolean) `true` if the name is acceptable, `false` if not.
  2. (string) If the name is not acceptable, a string describing the reason (suitable for display).
- **Required:** Yes (for collection name validation)
- **Notes:** Called when the user attempts to change the name of a collection. This is a blocking call. Use it only to validate easily-verified characteristics (e.g., illegal characters). For server-side validation (e.g., duplicate names), accept here and reject when the server-side operation is attempted.

---

### viewForCollectionSettings
- **Signature:** `function publishServiceProvider.viewForCollectionSettings(f, publishSettings, info)`
- **Parameters:**
  - `f` (`LrView.osFactory` object): A view factory object.
  - `publishSettings` (table): The settings for this publish service. Changes do not persist beyond this function call.
  - `info` (table): A table with these fields:
    - `collectionSettings` (`LrObservableTable`): Plug-in specific settings for this collection. Values must be numbers, strings, or Booleans. Special properties:
      - `LR_canSaveCollection`: Set to `true`/`false` to enable/disable the Edit/Create button.
      - `LR_liveName`: Kept current with the name field value during the dialog's life span; allows observers to monitor name changes.
      - `LR_canEditName`: Controls whether the collection name edit field is enabled.
    - `collectionType` (string): Either `"collection"` or `"smartCollection"`.
    - `isDefaultCollection` (Boolean): True if this is the default collection.
    - `name` (string): When editing, the name at the time the edit was initiated; otherwise `nil`.
    - `parents` (table): Array of parent info (only present when editing existing), each containing `localCollectionId`, `name`, `remoteCollectionId`.
    - `pluginContext` (`LrObservableTable`): Transient state storage for the dialog duration.
    - `publishedCollection` (`LrPublishedCollection`): The collection being edited, or `nil` when creating new.
    - `publishService` (`LrPublishService`): The publish service object.
- **Returns:** (table) A single view description created from one of the methods in the view factory. (Recommended: `f:groupBox` as outermost view.)
- **Required:** No (optional)
- **Notes:** Called when the user creates a new published collection or edits an existing one. Adds additional controls to the dialog box. This is a blocking call. First supported in version 3.0.

---

### viewForCollectionSetSettings
- **Signature:** `function publishServiceProvider.viewForCollectionSetSettings(f, publishSettings, info)`
- **Parameters:**
  - `f` (`LrView.osFactory` object): A view factory object.
  - `publishSettings` (table): The settings for this publish service. Changes do not persist beyond this function call.
  - `info` (table): A table with these fields:
    - `collectionSettings` (`LrObservableTable`): Plug-in specific settings for this collection set. Values must be numbers, strings, or Booleans. Special properties:
      - `LR_canSaveCollection`: Set to `true`/`false` to enable/disable the Edit/Create button.
      - `LR_liveName`: Kept current with the name field value during the dialog's life span.
      - `LR_canEditName`: Controls whether the collection set name edit field is enabled.
    - `collectionType` (string): `"collectionSet"`.
    - `isDefaultCollection` (Boolean): Always false.
    - `name` (string): When editing, the name at the time the edit was initiated; otherwise `nil`.
    - `parents` (table): Array of parent info (only present when editing existing), each containing `localCollectionId`, `name`, `remoteCollectionId`.
    - `pluginContext` (`LrObservableTable`): Transient state storage for the dialog duration.
    - `publishedCollection` (`LrPublishedCollectionSet`): The collection set being edited, or `nil` when creating new.
    - `publishService` (`LrPublishService`): The publish service object.
- **Returns:** (table) A single view description created from one of the methods in the view factory. (Recommended: `f:groupBox` as outermost view.)
- **Required:** No (optional)
- **Notes:** Called when the user creates a new published collection set or edits an existing one. Adds additional controls to the dialog box. This is a blocking call. First supported in version 3.0.

---

### willDeletePublishService
- **Signature:** `function publishServiceProvider.willDeletePublishService(publishSettings, info)`
- **Parameters:**
  - `publishSettings` (table): The settings for this publish service. Changes do not persist beyond this function call.
  - `info` (table): A table with these fields:
    - `publishService` (`LrPublishService`): The publish service object.
    - `nPhotos` (number): Number of photos in published collections within this service.
    - `connectionName` (string): The name assigned to this publish service connection by the user.
- **Returns:** Nothing.
- **Required:** No (optional)
- **Notes:** Called when the user has confirmed deletion of the publish service. Final opportunity to remove private data before the service is removed from the catalog. Do NOT present user interface here (except progress); use `shouldDeletePublishService` for that. Non-blocking call. First supported in version 3.0.

---

## Publish Service Provider -- Properties

### small_icon
- **Type:** string
- **Required:** Yes (for Publish services)
- **Notes:** Filename of the icon to be displayed for this publish service provider in the Publish Services panel, the Publish Manager dialog, and the header shown when a published collection is selected. Must be PNG format, no more than 24 pixels wide or 19 pixels tall. First supported in version 3.0.

### supportsCustomSortOrder
- **Type:** Boolean
- **Required:** No (optional)
- **Notes:** When `true`, Lightroom enables collections from this service to be sorted manually and calls `imposeSortOrderOnPublishedCollection` after each Publish cycle.

### disableRenamePublishedCollection
- **Type:** Boolean
- **Required:** No (optional)
- **Notes:** When `true`, disables (dims) the "Rename Published Collection" command in the context menu of the Publish Services panel for all published collections created by this service. First supported in version 3.0.

### disableRenamePublishedCollectionSet
- **Type:** Boolean
- **Required:** No (optional)
- **Notes:** When `true`, disables (dims) the "Rename Published Collection Set" command in the context menu of the Publish Services panel for all published collection sets created by this service. First supported in version 3.0.

### publish_fallbackNameBinding
- **Type:** string
- **Required:** No (optional)
- **Notes:** Customizes the behavior of the Description entry in the Publish Manager dialog. If the user does not provide an explicit name, Lightroom can provide one based on another entry in the `publishSettings` property table. This value is the name of the property to use for the fallback.

### titleForGoToPublishedCollection
- **Type:** string
- **Required:** No (optional)
- **Notes:** When set to the string `"disable"`, the "Go to Published Collection" context-menu item is disabled (dimmed) for this publish service. First supported in version 3.0.

### titleForGoToPublishedPhoto
- **Type:** string
- **Required:** No (optional)
- **Notes:** Overrides the label for the "Go to Published Photo" context-menu item. Set to `"disable"` to dim the menu item for this service. First supported in version 3.0.

### titleForPhotoRating
- **Type:** string
- **Required:** No (optional)
- **Notes:** Customizes the name of viewer-defined ratings obtained from the service via `getRatingsFromPublishedCollection`. First supported in version 3.0.

### titleForPublishedCollection
- **Type:** string
- **Required:** No (optional)
- **Notes:** Customizes the name of a published collection to match your service's terminology. Typically used with verbs like "Create ^1" or "Rename ^1". Default: "Published Collection". First supported in version 3.0.

### titleForPublishedCollection_standalone
- **Type:** string
- **Required:** No (optional)
- **Notes:** Same as `titleForPublishedCollection` but used when the name appears by itself (not with a verb). Important for languages like German where grammatical forms differ. Falls back to `titleForPublishedCollection` if not provided. First supported in version 3.0.

### titleForPublishedCollectionSet
- **Type:** string
- **Required:** No (optional)
- **Notes:** Customizes the name of a published collection set to match your service's terminology. Typically used with verbs like "Create ^1". Default: "Published Collection Set". First supported in version 3.0.

### titleForPublishedCollectionSet_standalone
- **Type:** string
- **Required:** No (optional)
- **Notes:** Same as `titleForPublishedCollectionSet` but used standalone. Falls back to `titleForPublishedCollectionSet` if not provided. First supported in version 3.0.

### titleForPublishedSmartCollection
- **Type:** string
- **Required:** No (optional)
- **Notes:** Customizes the name of a published smart collection to match your service's terminology. Default: "Published Smart Collection". First supported in version 3.0.

### titleForPublishedSmartCollection_standalone
- **Type:** string
- **Required:** No (optional)
- **Notes:** Same as `titleForPublishedSmartCollection` but used standalone. Falls back to `titleForPublishedSmartCollection` if not provided. First supported in version 3.0.

---

# Appendix: Quick Reference Summary

## Export Service Provider Callbacks
| Callback | Required | Blocking |
|---|---|---|
| `startDialog` | No | Yes |
| `endDialog` | No | Yes |
| `sectionsForTopOfDialog` | No | Yes |
| `sectionsForBottomOfDialog` | No | Yes |
| `updateExportSettings` | No | -- |
| `processRenderedPhotos` | Effectively yes | No (runs in task) |

## Export Service Provider Properties
| Property | Type |
|---|---|
| `exportPresetFields` | table |
| `allowFileFormats` | table |
| `disallowFileFormats` | table |
| `allowColorSpaces` | table |
| `disallowColorSpaces` | table |
| `allowVideoExportPresets` | table |
| `disallowVideoExportPresets` | table |
| `hideSections` | table |
| `showSections` | table |
| `hidePrintResolution` | Boolean |
| `canExportVideo` | Boolean/string |
| `canExportToTemporaryLocation` | Boolean |
| `supportsIncrementalPublish` | Boolean/string |

## Publish Service Provider Callbacks (additional)
| Callback | Required | Blocking |
|---|---|---|
| `addCommentToPublishedPhoto` | No | No |
| `canAddCommentsToService` | No | No |
| `deleteFirstOnPublish` | No | -- |
| `deletePhotosFromPublishedCollection` | Yes* | No |
| `deletePublishedCollection` | Yes* | No |
| `didCreateNewPublishService` | No | No |
| `didUpdatePublishService` | No | No |
| `endDialogForCollectionSettings` | No | Yes |
| `endDialogForCollectionSetSettings` | No | Yes |
| `getCollectionBehaviorInfo` | No | -- |
| `getCommentsFromPublishedCollection` | No | No |
| `getRatingsFromPublishedCollection` | No | No |
| `goToPublishedCollection` | No | No |
| `goToPublishedPhoto` | No | No |
| `imposeSortOrderOnPublishedCollection` | No | No |
| `metadataThatTriggersRepublish` | No | Yes |
| `renamePublishedCollection` | Yes* | No |
| `reparentPublishedCollection` | Yes* | No |
| `shouldDeletePhotosFromServiceOnDeleteFromCatalog` | No | No |
| `shouldDeletePublishService` | No | No |
| `shouldDeletePublishedCollection` | No | No |
| `shouldReverseSequenceForPublishedCollection` | No | No |
| `updateCollectionSettings` | No | No |
| `updateCollectionSetSettings` | No | No |
| `validatePublishedCollectionName` | Yes* | Yes |
| `viewForCollectionSettings` | No | Yes |
| `viewForCollectionSetSettings` | No | Yes |
| `willDeletePublishService` | No | No |

*Required if your service supports the corresponding feature.

## Publish Service Provider Properties (additional)
| Property | Type |
|---|---|
| `small_icon` | string |
| `supportsCustomSortOrder` | Boolean |
| `disableRenamePublishedCollection` | Boolean |
| `disableRenamePublishedCollectionSet` | Boolean |
| `publish_fallbackNameBinding` | string |
| `titleForGoToPublishedCollection` | string |
| `titleForGoToPublishedPhoto` | string |
| `titleForPhotoRating` | string |
| `titleForPublishedCollection` | string |
| `titleForPublishedCollection_standalone` | string |
| `titleForPublishedCollectionSet` | string |
| `titleForPublishedCollectionSet_standalone` | string |
| `titleForPublishedSmartCollection` | string |
| `titleForPublishedSmartCollection_standalone` | string |
<!-- END OFFICIAL_EXPORT_PUBLISH -->
