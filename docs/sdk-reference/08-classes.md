# Class APIs

Classes are instantiated objects with methods called using colon syntax: `object:method()`.
Properties are accessed using dot syntax: `object.property`.

Objects are created by constructor functions, by factory methods in other objects/namespaces,
or are passed to your code by Lightroom Classic. You do not typically call `import` to get a
class constructor directly -- most class instances come from API calls.

---

## LrCatalog

Provides access to a Lightroom Classic catalog. Obtained via `LrApplication.activeCatalog()`.
Most other class instances provide a pointer back to their catalog (e.g. `LrPhoto.catalog`).

### Getting photos

- `catalog:getTargetPhoto()` -- currently selected photo (returns LrPhoto or nil)
- `catalog:getTargetPhotos()` -- array of selected photos
- `catalog:getMultipleSelectedOrAllPhotos()` -- returns multiple selected photos, or all photos in current source if none selected. More user-friendly than `getTargetPhotos()` for "process selected or all" workflows.
- `catalog:getAllPhotos()` -- all photos in catalog (verify with API reference)
- `catalog:findPhotos { searchDesc = {...} }` -- search with criteria (see Metadata chapter for searchDesc format)
- `catalog:findPhotoByPath(path)` -- find a single photo by file path (verify with API reference)
- `catalog:findPhotosWithProperty(pluginId, fieldId)` -- find photos with a specific plugin metadata property set

### Batch metadata retrieval

- `catalog:batchGetRawMetadata(photos, keys)` -- efficiently retrieve raw metadata for multiple photos at once. Returns a table keyed by photo objects. Pass `nil` for keys to get ALL raw metadata. Example: `local batch = catalog:batchGetRawMetadata(photos, {"path", "uuid", "isVirtualCopy"})`
- `catalog:batchGetFormattedMetadata(photos, keys)` -- same pattern for formatted metadata. Pass `nil` for all. Example: `local batch = catalog:batchGetFormattedMetadata(photos, nil)`

### Sources and folders

- `catalog:getActiveSources()` -- get currently selected sources in Library module (folder, collection, etc.)
- `catalog:setActiveSources(sources)` -- set the active/selected sources
- `catalog:getFolders()` -- top-level folders (returns LrFolder objects)
- `catalog:getFolderByPath(path)` -- find a folder by filesystem path (note: documented as `Lrcatalog:getFolderByPath()` in SDK guide -- likely a typo)

### Collections

- `catalog:createCollection(name, collectionSet)` -- create a regular collection (2 params; no canReturnExisting)
- `catalog:createCollectionSet(name, parent, canReturnExisting)` -- create a collection set (3 params; has canReturnExisting)
- `catalog:createSmartCollection(name, searchDesc, collectionSet)` -- create a smart collection with search descriptor (3 params; no canReturnExisting)
- `catalog:getCollections()` -- top-level collections (verify with API reference)
- `catalog:getChildCollections()` -- child collections at top level
- `catalog:getChildCollectionSets()` -- child collection sets at top level
- `catalog:getCollectionByLocalIdentifier(id)` -- find collection by local identifier

### Importing photos

- `catalog:addPhoto(filePath)` -- import a photo into the catalog programmatically (requires write access)

### Keywords

- `catalog:createKeyword(name, synonyms, includeOnExport, parent, canReturnExisting)` -- create a keyword
- `catalog:getKeywords()` -- top-level keywords

### Publish services

- `catalog:getPublishServices(pluginId)` -- returns LrPublishService objects. Pass `nil` or omit to get services from ALL plugins; pass a plugin identifier string to filter to that plugin's services only
- `catalog:createPublishedCollection(name, publishService)` -- create a published collection (verify exact signature)
- `catalog:getPublishedCollectionSets()` -- top-level published collection sets (verify with API reference)
- `catalog:getPublishedCollectionByLocalIdentifier(localCollectionId)` -- find a published collection by its local identifier (numeric ID)

### Write access

- `catalog:withWriteAccessDo(actionName, function(context) end, options)` -- execute a function with catalog write access
- `catalog:withPrivateWriteAccessDo(actionName, function(context) end)` -- write access for plugin-private metadata only (used internally by schema migration)
- `catalog:withReadAccessDo(function(context) end)` -- read access block (rarely needed explicitly, since most read operations do not require it)
- `catalog:assertHasPrivateWriteAccess(callerDescription)` -- assert that private write access is held (used in schema update functions)

### Write access options

```lua
catalog:withWriteAccessDo("My Action", function(context)
    -- modify catalog data here
end, { timeout = 10 })  -- wait up to 10 seconds for access; 0 = fail immediately
```

---

## LrPhoto

Represents a single photo or virtual copy in the active catalog.
Returned by many functions of LrCatalog, LrCollection, LrExportSession, etc.

### Raw metadata

- `photo:getRawMetadata(key)` -- get raw metadata (return type varies by key)
  - **Common keys:** `"path"`, `"uuid"`, `"fileSize"`, `"fileFormat"`, `"isVideo"`, `"isCropped"`, `"rating"`, `"colorNameForLabel"`, `"pick"`, `"pickStatus"`, `"isInStackInFolder"`, `"stackPositionInFolder"`, `"width"`, `"height"`, `"dimensions"`, `"orientation"`, `"aspectRatio"`, `"dateTimeOriginal"`, `"dateTimeDigitized"`, `"captureTime"`, `"gps"`, `"keywords"`, `"catalog"`, `"isVirtualCopy"`, `"masterPhoto"`, `"virtualCopies"`
  - **Note:** `"captureTime"` returns a **numeric timestamp** (seconds since epoch), not a formatted string. Use `LrDate` methods to convert.
  - **Note:** `"pickStatus"` returns an integer: -1 = rejected, 0 = unflagged, 1 = picked.
  - **Note:** `"fileFormat"` returns string constants: `"RAW"`, `"DNG"`, `"JPEG"`, `"HEIC"`, `"TIFF"`, etc.
  - **Note:** `"dimensions"` returns a table with `.width` and `.height` fields.
  - **Note:** `"fileSize"` is also available via `getFormattedMetadata` (which returns a human-readable string instead of a raw number).

### Formatted metadata

- `photo:getFormattedMetadata(key)` -- get display-formatted metadata (returns string)
  - **Common keys:** `"fileName"`, `"copyName"` (virtual copy name, nil for masters), `"folderName"`, `"fileSize"`, `"fileType"`, `"dateCreated"`, `"dateTime"`, `"dateTimeDigitized"`, `"dimensions"`, `"croppedDimensions"`, `"exposure"`, `"exposureBias"`, `"shutterSpeed"`, `"aperture"`, `"isoSpeedRating"`, `"focalLength"`, `"lens"`, `"cameraMake"`, `"cameraModel"`, `"cameraSerialNumber"`, `"title"`, `"caption"`, `"copyright"`, `"creator"`, `"city"`, `"stateProvince"`, `"country"`, `"isoCountryCode"`, `"headline"`, `"iptcSubjectCode"`, `"intellectualGenre"`, `"scene"`, `"location"`, `"gps"`, `"gpsAltitude"`, `"keywords"`, `"label"`

### Develop settings

- `photo:getDevelopSettings()` -- table of all current develop settings (hundreds of keys)
- `photo:applyDevelopSettings(settings)` -- apply a table of develop settings (requires write access)

### Writing metadata

- `photo:setRawMetadata(key, value)` -- set writable metadata (requires write access)
  - **Writable keys:** `"rating"`, `"colorNameForLabel"`, `"pick"`, `"pickStatus"` (integer, LR 4+), `"label"` (accepts arbitrary strings, not just color names), `"title"`, `"caption"`, and others (verify full list with API reference)

### Custom plugin metadata

- `photo:getPropertyForPlugin(plugin, fieldId)` -- read custom metadata defined by a plugin
- `photo:setPropertyForPlugin(plugin, fieldId, value)` -- write custom metadata (requires write access)
  - `plugin` can be a plugin ID string or the `_PLUGIN` global

```lua
local oldId = photo:getPropertyForPlugin( myPluginId, 'siteId' )
photo:setPropertyForPlugin( _PLUGIN, 'siteId', newSiteId )
```

### Keywords

- `photo:addKeyword(keyword)` -- add a keyword to this photo (requires write access)
- `photo:removeKeyword(keyword)` -- remove a keyword from this photo (requires write access)
- `photo:getKeywords()` -- get assigned keywords (returns array of LrKeyword)

### Collections

- `photo:getContainedCollections()` -- collections containing this photo
- `photo:getContainedPublishedCollections()` -- returns all published collections containing this photo

### Virtual copies and transforms

- `photo:createVirtualCopy()` -- create a virtual copy (requires write access) (verify with API reference)
- `photo:rotateLeft()` -- rotate left (requires write access) (verify with API reference)
- `photo:rotateRight()` -- rotate right (requires write access) (verify with API reference)

---

## LrCollection

Provides access to a photo collection.

**Returned by:** `LrCatalog:createCollection()`, `LrCatalog:createSmartCollection()`, `LrCatalog:getActiveSources()`, `LrCatalog:getChildCollections()`, `LrCatalog:getCollectionByLocalIdentifier()`, `LrCollectionSet:getChildren()`, `LrCollectionSet:getChildCollections()`, `LrPhoto:getContainedCollections()`

- `collection.catalog` -- property (not method) that returns the LrCatalog for this collection
- `collection:getName()` -- collection name
- `collection:getPhotos()` -- photos in collection (returns array of LrPhoto)
- `collection:addPhotos(photos)` -- add photos to collection (requires write access)
- `collection:removePhotos(photos)` -- remove photos from collection (requires write access) (verify with API reference)
- `collection:getParent()` -- parent collection set or nil
- `collection:type()` -- returns `"LrCollection"`
- `collection:getSearchDescription()` -- for smart collections, returns the search descriptor (verify with API reference)

---

## LrCollectionSet

Provides access to a photo collection set (a group of collections).

**Returned by:** `LrCatalog:createCollectionSet()`, `LrCatalog:getChildCollectionSets()`, `LrCollectionSet:getChildren()`, `LrCollection:getParent()`, `LrCollectionSet:getParent()`, `LrCollectionSet:getChildCollectionSets()`

- `collectionSet:getName()` -- collection set name
- `collectionSet:getChildren()` -- child collections and collection sets
- `collectionSet:getChildCollections()` -- child collections only
- `collectionSet:getChildCollectionSets()` -- child collection sets only
- `collectionSet:getParent()` -- parent collection set or nil
- `collectionSet:type()` -- returns `"LrCollectionSet"`

---

## LrFolder

Provides access to a file-system folder that contains photos.

**Returned by:** `LrCatalog:getFolders()`, `LrCatalog:getActiveSources()`, `LrCatalog:getFolderByPath()`, `LrFolder:getParent()`

- `folder:getName()` -- folder name
- `folder:getPath()` -- full filesystem path
- `folder:getPhotos()` -- photos in this folder (returns array of LrPhoto) (verify with API reference)
- `folder:getChildren()` -- child folders (verify with API reference)
- `folder:getParent()` -- parent folder or nil
- `folder:type()` -- returns `"LrFolder"`

---

## LrKeyword

Encapsulates a keyword.

**Returned by:** `LrCatalog:createKeyword()`, `LrCatalog:getKeywords()`, `LrKeyword:getChildren()`, `LrKeyword:getParent()`

- `keyword:getName()` -- keyword name
- `keyword:getSynonyms()` -- table of synonym strings (verify with API reference)
- `keyword:getParent()` -- parent keyword or nil
- `keyword:getChildren()` -- child keywords
- `keyword:getPhotos()` -- photos tagged with this keyword
- `keyword:getAttributes()` -- attribute table (e.g. `{includeOnExport = true/false}`) (verify with API reference)

---

## LrExportContext

Encapsulates an export context. Passed to your `processRenderedPhotos(functionContext, exportContext)` function.

Lightroom Classic creates and passes this object to your function; you cannot import or construct it directly.

### Properties

- `exportContext.propertyTable` -- the export settings table (includes both plugin-defined and Lightroom-defined settings)
- `exportContext.exportSession` -- the LrExportSession object
- `exportContext.configuredExport` -- whether this is from an actual export (verify with API reference)
- `exportContext.publishService` -- the LrPublishService if this is a publish operation (verify with API reference)
- `exportContext.publishedCollection` -- the LrPublishedCollection if applicable (verify with API reference)

### Methods

- `exportContext:renditions()` -- iterator of `(index, rendition)` pairs; automatically updates the progress indicator
- `exportContext:configureProgress { title = "..." }` -- configure the progress indicator text

```lua
processRenderedPhotos = function( functionContext, exportContext )
    local progressScope = exportContext:configureProgress {
        title = "Publishing photos...",
    }
    for i, rendition in exportContext:renditions() do
        local success, pathOrMessage = rendition:waitForRender()
        if success then
            -- pathOrMessage contains the file path of the rendered photo
        else
            rendition:uploadFailed( pathOrMessage )
        end
    end
end
```

---

## LrExportRendition

Encapsulates a single photo rendition operation generated during an export.

**Returned by:** `LrExportSession:renditions()`, or via the `exportContext:renditions()` iterator.

### Properties

- `rendition.photo` -- the source LrPhoto object
- `rendition.publishedPhotoId` -- existing remote ID if republishing (verify with API reference)

### Methods

- `rendition:waitForRender()` -- blocks until rendered; returns `success, pathOrMessage`
  - When `success` is true, `pathOrMessage` is the file path of the rendered file
  - When `success` is false, `pathOrMessage` is an error message string
- `rendition:skipRender()` -- skip this rendition (verify with API reference)
- `rendition:renditionIsDone(success, message)` -- mark rendition complete (used in filter contexts)
  - Called automatically by the `filterContext:renditions()` iterator if not called explicitly
  - Typically only needs to be called explicitly on failure
- `rendition:uploadFailed(message)` -- report an upload failure for this rendition

---

## LrExportSession

Provides access to the list of photos and renditions generated during an export operation.

**Created by:** Import constructor `local LrExportSession = import 'LrExportSession'`, or accessed via `exportContext.exportSession`.

- `session:countRenditions()` -- total rendition count (verify with API reference)
- `session:renditions()` -- rendition iterator
- `session:doExportOnCurrentTask()` -- begin the export pipeline (verify with API reference)
- `exportSession:recordRemoteCollectionId(remoteId)` -- record the collection's remote ID
- `exportSession:recordRemoteCollectionUrl(url)` -- record the collection's remote URL

---

## LrFilterContext

Provides access to choices the user has made in the Export dialog for export filter processing. Passed to your `postProcessRenderedPhotos(functionContext, filterContext)` function.

You cannot import this namespace or access its properties/functions in any other way.

- `filterContext:renditions(renditionOptions)` -- iterator yielding `(sourceRendition, renditionToSatisfy)` pairs

```lua
for sourceRendition, renditionToSatisfy in filterContext:renditions( renditionOptions ) do
    local success, pathOrMessage = sourceRendition:waitForRender()
    if success then
        -- process the rendered photo
    else
        renditionToSatisfy:renditionIsDone( false, "error message" )
    end
end
```

---

## LrPublishedCollection / LrPublishedCollectionSet

Similar to LrCollection/LrCollectionSet but for publish services. Access functions are parallel.

**LrPublishedCollection returned by:** `LrCatalog:createPublishedCollection()`, `LrPublishedCollectionSet:getChildren()`

**LrPublishedCollectionSet returned by:** `LrCatalog:getPublishedCollectionSets()`, `LrPublishService:getChildCollectionSets()`

### LrPublishedCollection

- `publishedCollection:getName()` -- collection name
- `publishedCollection:getPublishedPhotos()` -- returns array of LrPublishedPhoto objects
- `publishedCollection:getRemoteId()` -- remote service identifier (verify with API reference)
- `publishedCollection:getRemoteUrl()` -- URL on remote service (verify with API reference)
- `publishedCollection:getParent()` -- parent collection set or nil (verify with API reference)
- `publishedCollection:getCollectionSetInfoSummary()` -- get collection set info
- `publishedCollection:setCollectionSetSettings(settings)` -- set collection settings
- `publishedCollection:type()` -- returns `"LrPublishedCollection"` (verify with API reference)
- `publishedCollection:addPhotoByRemoteId(photo, remoteId, remoteUrl, alreadyPublished)` -- mark a photo as published without uploading. When `alreadyPublished` is `true`, the photo is marked as up-to-date.
- `publishedCollection:getCollectionInfoSummary()` -- returns table with collectionSettings, isDefaultCollection, etc.
- `publishedCollection:setCollectionSettings(settings)` -- save collection-specific settings
- `publishedCollection:setRemoteUrl(url)` -- set the remote URL for "Go to Collection"

### LrPublishedCollectionSet

- `publishedCollectionSet:getName()` -- collection set name (verify with API reference)
- `publishedCollectionSet:getChildren()` -- child collections and sets
- `publishedCollectionSet:getParent()` -- parent collection set or nil (verify with API reference)
- `publishedCollectionSet:type()` -- returns `"LrPublishedCollectionSet"` (verify with API reference)

---

## LrPublishedPhoto

Encapsulates the publishing information associated with a photo that is part of a published collection.

**Returned by:** `LrPublishedCollection:getPublishedPhotos()`

- `publishedPhoto:getRemoteId()` -- remote service ID
- `publishedPhoto:getRemoteUrl()` -- URL on remote service (verify with API reference)
- `publishedPhoto:getPhoto()` -- underlying LrPhoto object
- `publishedPhoto:getEditedFlag()` -- returns whether the photo has been edited since the last publish
- `publishedPhoto:setRemoteId(id)` -- update the remote ID (post-publish)
- `publishedPhoto:setRemoteUrl(url)` -- set remote URL (verify with API reference)
- `publishedPhoto:getPublishState()` -- one of: `"toPublish"`, `"toRepublish"`, `"toDelete"` (verify with API reference)

---

## LrPublishService

Provides access to a named publishing service.

**Returned by:** `LrCatalog:getPublishServices()`

- `publishService:getCollections()` -- published collections (verify with API reference)
- `publishService:getChildCollections()` -- child collections (alias for getCollections)
- `publishService:getChildCollectionSets()` -- child collection sets
- `publishService:getName()` -- service name (verify with API reference)
- `publishService:getPluginId()` -- toolkit identifier of the plugin providing this service (confirmed by SamsTools plugin)

---

## LrDevelopPreset / LrDevelopPresetFolder

### LrDevelopPreset

Provides access to a develop preset.

**Returned by:** `LrDevelopPresetFolder:getDevelopPresets()`

- `preset:getName()` -- preset name (verify with API reference)
- `preset:getSetting(key)` -- get a specific develop setting value (verify with API reference)
- `preset:getParent()` -- parent LrDevelopPresetFolder
- `preset:type()` -- returns `"LrDevelopPreset"`

### LrDevelopPresetFolder

Provides access to a develop-preset folder.

**Returned by:** `LrApplication.developPresetFolders()`, `LrDevelopPreset:getParent()`

- `folder:getName()` -- folder name (verify with API reference)
- `folder:getDevelopPresets()` -- presets in this folder
- `folder:type()` -- returns `"LrDevelopPresetFolder"`

---

## LrObservableTable

Implements an observable properties table. Created via `LrBinding.makePropertyTable(context)`.
Some API functions create observable tables for you (e.g. the export `propertyTable`).

Must be created within a function context for proper cleanup.

- `table:addObserver(key, callback)` -- watch for changes to a key
  - Callback signature: `function(properties, key, newValue)`
  - You can use the same handler for multiple keys, but must call `addObserver()` separately for each key
- `table:removeObserver(key, callback)` -- stop watching a key (verify with API reference)
- Supports direct property access: `table.myKey = value`

```lua
LrFunctionContext.callWithContext("example", function( context )
    local properties = LrBinding.makePropertyTable( context )
    properties.url = "http://www.example.com"
    properties:addObserver( 'url', function( props, key, newValue )
        -- react to URL changes
    end )
end)
```

---

## LrPlugin

Provides access to the plug-in configuration. Available as the global variable `_PLUGIN`.

- `_PLUGIN.id` -- toolkit identifier string (from `LrToolkitIdentifier` in Info.lua)
- `_PLUGIN.path` -- plugin directory path on the filesystem
- `_PLUGIN.enabled` -- whether the plugin is currently enabled (verify with API reference)
- `_PLUGIN:resourceId('filename')` -- get the full path to a resource file bundled in the plugin

```lua
local iconPath = _PLUGIN:resourceId('myIcon.png')
```

---

## LrFunctionContext

Both a namespace and a class. The namespace functions allow you to make function calls with defined methods for cleaning up resources. The object represents a specific function execution context.

### Namespace functions (called with dot syntax)

- `LrFunctionContext.callWithContext(name, function(context) end)` -- call a function with error-handling context
- `LrFunctionContext.postAsyncTaskWithContext(name, function(context) end)` -- start an async task with context (verify with API reference)

### Instance methods (called with colon syntax on the context object)

- `context:addCleanupHandler(function() end)` -- run a function on context exit (regardless of success/failure) (verify with API reference)
- `context:addFailureHandler(function(message) end)` -- run a function on error (verify with API reference)

Property tables (LrObservableTable) created within a context automatically clean up when the context exits.

```lua
local LrFunctionContext = import 'LrFunctionContext'
LrFunctionContext.callWithContext( 'my operation', function( context )
    LrDialogs.attachErrorDialogToFunctionContext( context )
    -- If an error occurs, a dialog is shown automatically
end )
```

---

## LrProgressScope

Allows you to provide feedback to the user about the progress of a long-running task.
Both a namespace (import constructor) and a class.

**Created by:** `local LrProgressScope = import 'LrProgressScope'` then calling the constructor.

- `scope:setCaption(text)` -- update progress text (verify with API reference)
- `scope:setPortionComplete(done, total)` -- update progress bar (verify with API reference)
- `scope:done()` -- mark the operation as complete (verify with API reference)
- `scope:isCanceled()` -- check if user canceled (verify with API reference)
- `scope:cancel()` -- cancel programmatically (verify with API reference)
- `scope:getPortionComplete()` -- current progress fraction (verify with API reference)

Note: In export contexts, use `exportContext:configureProgress { title = "..." }` instead of creating your own LrProgressScope -- the `exportContext:renditions()` iterator automatically updates progress.

---

## LrXml

Both a namespace and a class. Two types of objects:

- **Builder objects** -- created with `LrXml.createXmlBuilder()`, allow you to create and manipulate XML documents
- **DOM objects** -- created with `LrXml.parseXml(xmlString)`, read-only objects for examining existing XML documents

### DOM object methods (verify all with API reference)

- `node:name()` -- element name
- `node:text()` -- text content
- `node:attributes()` -- attribute table
- `node:childAtIndex(n)` -- nth child node
- `node:childCount()` -- number of children
- `node:type()` -- node type string

---

## LrColor

Encapsulates a color value. Used for UI elements.

**Created by:** Import constructor `local LrColor = import 'LrColor'`

```lua
local red = LrColor( 1, 0, 0 )  -- RGB values from 0 to 1
```

---

## LrLogger

Provides logging capability. Both a namespace and a class.

**Created by:** Import constructor, then calling as a constructor function.

```lua
local LrLogger = import 'LrLogger'
local logger = LrLogger( 'myPlugin' )
logger:enable( 'print' )   -- or 'logfile'
logger:warn( 'something happened' )
logger:trace( 'debug info' )
logger:info( 'informational message' )
logger:error( 'error occurred' )
```

---

## LrRecursionGuard

Provides a simple recursion guard for function execution. Both a namespace and a class.

**Created by:** Import constructor `local LrRecursionGuard = import 'LrRecursionGuard'`

Used to prevent infinite loops when observers trigger changes that would re-trigger the same observer (verify usage details with API reference).

---

## LrVideoExportPreset

Represents a single video export preset.

**Returned by:** `LrExportSettings.videoExportPresets` (verify with API reference)

---

## Quick Reference: Object Creation Summary

| Class | How to obtain |
|-------|---------------|
| LrCatalog | `LrApplication.activeCatalog()` |
| LrPhoto | Returned by LrCatalog methods, LrCollection methods, etc. |
| LrCollection | `LrCatalog:createCollection()`, `LrCatalog:getChildCollections()`, etc. |
| LrCollectionSet | `LrCatalog:createCollectionSet()`, `LrCatalog:getChildCollectionSets()`, etc. |
| LrFolder | `LrCatalog:getFolders()`, `LrCatalog:getFolderByPath()` |
| LrKeyword | `LrCatalog:createKeyword()`, `LrCatalog:getKeywords()` |
| LrExportContext | Passed to `processRenderedPhotos()` |
| LrExportRendition | `exportContext:renditions()` iterator |
| LrExportSession | Constructor or `exportContext.exportSession` |
| LrFilterContext | Passed to `postProcessRenderedPhotos()` |
| LrPublishedCollection | `LrCatalog:createPublishedCollection()` |
| LrPublishedPhoto | `LrPublishedCollection:getPublishedPhotos()` |
| LrPublishService | `LrCatalog:getPublishServices()` |
| LrDevelopPreset | `LrDevelopPresetFolder:getDevelopPresets()` |
| LrDevelopPresetFolder | `LrApplication.developPresetFolders()` |
| LrObservableTable | `LrBinding.makePropertyTable(context)` |
| LrPlugin | Global `_PLUGIN` |
| LrFunctionContext | Passed by `LrFunctionContext.callWithContext()` and similar |
| LrProgressScope | Import constructor |
| LrXml (DOM) | `LrXml.parseXml(xmlString)` |
| LrXml (Builder) | `LrXml.createXmlBuilder()` |
| LrColor | Import constructor |
| LrLogger | Import constructor |
| LrRecursionGuard | Import constructor |
| LrFtp | `LrFtp.create()` |
| LrView | `LrView.osFactory()` or passed to dialog section functions |

---

## Notes

- Methods marked "(verify with API reference)" are inferred from SDK guide patterns and naming conventions but not explicitly documented in the programmers guide text. Check the Lightroom Classic SDK API Reference (the separate HTML/PDF reference) for exact signatures and return types.
- All methods that modify catalog data (setting metadata, adding/removing keywords, adding/removing photos from collections, creating collections, etc.) require catalog write access via `catalog:withWriteAccessDo()`.
- The `findPhotos` search descriptor system supports complex nested boolean logic with `combine = "intersect"`, `"union"`, or `"exclude"`. See the metadata chapter for full criteria and operation reference.
- Property tables created within an `LrFunctionContext` are automatically cleaned up when the context exits.

---

<!-- BEGIN OFFICIAL_CLASSES -->
## Official Class API (SDK 11.4)

Complete class method inventories extracted from official SDK module HTML.

### Class Index

- `LrCatalog` (44 methods)
- `LrCollection` (13 methods)
- `LrCollectionSet` (9 methods)
- `LrColor` (6 methods)
- `LrDevelopController` (49 methods)
- `LrDevelopPreset` (6 methods)
- `LrDevelopPresetFolder` (4 methods)
- `LrExportContext` (3 methods)
- `LrExportRendition` (7 methods)
- `LrExportSession` (11 methods)
- `LrFilterContext` (1 methods)
- `LrFolder` (6 methods)
- `LrFtp` (15 methods)
- `LrFunctionContext` (12 methods)
- `LrKeyword` (8 methods)
- `LrLogger` (18 methods)
- `LrObservableTable` (3 methods)
- `LrPhoto` (35 methods)
- `LrPlugin` (3 methods)
- `LrProgressScope` (21 methods)
- `LrPublishService` (9 methods)
- `LrPublishedCollection` (24 methods)
- `LrPublishedCollectionSet` (16 methods)
- `LrPublishedPhoto` (9 methods)
- `LrRecursionGuard` (2 methods)
- `LrVideoExportPreset` (6 methods)
- `LrView` (29 methods)
- `LrWebViewFactory` (19 methods)
- `LrXml` (17 methods)

### LrCatalog

| Method Signature | Description |
|---|---|
| `addPhoto` | - |
| `assertHasPrivateWriteAccess` | - |
| `assertHasWriteAccess` | - |
| `batchGetFormattedMetadata` | result = { |
| `batchGetPropertyForPlugin` | result = { |
| `batchGetRawMetadata` | result = { |
| `buildSmartPreviews` | - |
| `createCollection` | - |
| `createCollectionSet` | - |
| `createKeyword` | - |
| `createSmartCollection` | - |
| `createVirtualCopies` | - |
| `findPhotoByPath` | - |
| `findPhotoByUuid` | - |
| `findPhotos` | - |
| `findPhotosWithProperty` | - |
| `getActiveSources` | - |
| `getAllPhotos` | - |
| `getChildCollectionSets` | - |
| `getChildCollections` | - |
| `getCollectionByLocalIdentifier` | - |
| `getCurrentViewFilter` | 1. (table) The current library view filter with these members: |
| `getFolderByPath` | - |
| `getFolders` | - |
| `getKeywords` | - |
| `getKeywordsByLocalId` | - |
| `getLabelMapToColorName` | - |
| `getMultipleSelectedOrAllPhotos` | - |
| `getPath` | - |
| `getPropertyForPlugin` | - |
| `getPublishServices` | - |
| `getPublishedCollectionByLocalIdentifier` | - |
| `getTargetPhoto` | - |
| `getTargetPhotos` | - |
| `setActiveSources` | - |
| `setPropertyForPlugin` | - |
| `setSelectedPhotos` | - |
| `setViewFilter` | - |
| `triggerImportFromPathWithPreviousSettings` | - |
| `triggerImportUI` | - |
| `type` | - |
| `withPrivateWriteAccessDo` | - |
| `withProlongedWriteAccessDo` | 1. (Boolean) True if user clicked "Proceed"; false if user clicked "Cancel". |
| `withWriteAccessDo` | - |

### LrCollection

| Method Signature | Description |
|---|---|
| `collection:addPhotos( photos )` | Adds photos to this collection, if it is not a smart collection. Throws an exception if this is a smart collection. |
| `collection:delete()` | Removes this collection from the containing catalog. |
| `collection:getName()` | Retrieves the current name of this collection. |
| `collection:getParent()` | Retrieves the parent collection set, if any, that contains this collection. |
| `collection:getPhotos()` | Retrieves all of the photos in this collection. |
| `collection:getSearchDescription()` | Retrieves the search description for a smart collection. Throws an exception if this is not a smart collection. |
| `collection:isSmartCollection()` | Reports whether this collection is a smart collection. |
| `collection:removeAllPhotos()` | Removes all photos from this collection if it is not a smart collection. Throws an exception if this is a smart collection. |
| `collection:removePhotos( photos )` | Removes photos from this collection if it is not a smart collection. Throws an exception if this is a smart collection. |
| `collection:setName( name )` | Sets a new name for this collection. |
| `collection:setParent( parent )` | Sets a new parent for this collection. |
| `collection:setSearchDescription( searchDesc )` | Sets the search description for a smart collection. Throws an exception if this is not a smart collection. |
| `collection:type()` | Reports the type of this object. |

### LrCollectionSet

| Method Signature | Description |
|---|---|
| `collectionSet:delete()` | Removes this collection set from the catalog. |
| `collectionSet:getChildCollectionSets()` | Retrieves the collection sets that are immediate children of this set, if any. Does not go into nested sets. |
| `collectionSet:getChildCollections()` | Retrieves the collections that are immediate children of this set. Does not go into nested sets. |
| `collectionSet:getChildren()` | Retrieves all immediate members of this set, both collections and collection sets. |
| `collectionSet:getName()` | Retrieves the current name of this set. |
| `collectionSet:getParent()` | Retrieves the parent set, if any, of this collection set. |
| `collectionSet:setName( name )` | Sets a new name for this collection set. |
| `collectionSet:setParent( parent )` | Sets a new parent for the collection set. |
| `collectionSet:type()` | Reports the type of this object. |

### LrColor

| Method Signature | Description |
|---|---|
| `LrColor( ... )` | Creates an `LrColor` object. Set the color values using a number in the range [0..1]. For red, green, and blue, 1 is saturation. For alpha (transparency), 0 is fully transparent and 1 is fully opaque. For a grayscale value, 0 is white and 1 is black. You can also specify a color by name. First supported in version 1.3 of the Lightroom SDK. |
| `color:alpha()` | Retrieves the alpha (transparency) value of this color. First supported in version 1.3 of the Lightroom SDK. |
| `color:blue()` | Retrieves the blue value of this color. First supported in version 1.3 of the Lightroom SDK. |
| `color:green()` | Retrieves the green value of this color. First supported in version 1.3 of the Lightroom SDK. |
| `color:red()` | Retrieves the red value of this color. First supported in version 1.3 of the Lightroom SDK. |
| `color:type()` | Reports the type of this object. First supported in version 4.1 of the Lightroom SDK. |

### LrDevelopController

| Method Signature | Description |
|---|---|
| `LrDevelopController.getValue( param )` | Gets the value of a Develop adjustment for the current photo. |
| `LrDevelopController.setValue( param, value )` | Sets the value of a Develop adjustment for the current photo. |
| `LrDevelopController.getRange( param )` | Gets the min and max value of a Develop adjustment. |
| `LrDevelopController.increment( param )` | Increments the value of a Develop adjustment. |
| `LrDevelopController.decrement( param )` | Decrements the value of a Develop adjustment. (Note: SDK docs say "Increments" but this is the decrement function.) |
| `LrDevelopController.resetToDefault( param )` | Resets a single Develop adjustment for the current photo. |
| `LrDevelopController.resetAllDevelopAdjustments()` | Resets all Develop adjustments for the current photo. |
| `LrDevelopController.resetCrop()` | Resets the crop angle and frame for the current photo. |
| `LrDevelopController.resetSpotRemoval()` | Clears all spot removal adjustments from the current photo. |
| `LrDevelopController.resetRedeye()` | Clears all redeye removal adjustments from the current photo. |
| `LrDevelopController.resetMasking()` | Clears all masks from the current photo. |
| `LrDevelopController.resetTransforms()` | Clears all transforms from the current photo. |
| `LrDevelopController.setAutoTone()` | Sets Auto Tone for the current photo. |
| `LrDevelopController.setAutoWhiteBalance()` | Sets Auto White Balance for the current photo. |
| `LrDevelopController.getProcessVersion()` | Returns the process version of the current photo. |
| `LrDevelopController.setProcessVersion( value )` | Sets the process version of the current photo. |
| `LrDevelopController.getSelectedTool()` | Reports which tool mode is active in Develop. |
| `LrDevelopController.selectTool( tool )` | Select a tool mode in Develop. |
| `LrDevelopController.revealPanel( paramOrPanelID )` | Expands and scrolls into view the panel with the given ID. |
| `LrDevelopController.revealPanelIfVisible( paramOrPanelID )` | Expands and scrolls into view the panel with the given ID, **only if** the right panel is already visible. |
| `LrDevelopController.revealAdjustedControls( reveal )` | Enables a mode where adjusting a parameter causes that panel to be automatically revealed in the panel track. |
| `LrDevelopController.startTracking( param )` | Temporarily puts the Develop module into its tracking state, causing faster, lower-quality redraw and preventing history states from being generated. Tracking will automatically be turned back off as soon as a different parameter is adjusted, or two seconds after the last adjustment is made. |
| `LrDevelopController.stopTracking( isLocalParam )` | Causes Develop module to exit its tracking state immediately, creating a single history state for all changes that were made to the parameter that was being tracked. |
| `LrDevelopController.setTrackingDelay( seconds )` | Sets the number of seconds that tracking remains enabled after each adjustment is made. |
| `LrDevelopController.setMultipleAdjustmentThreshold( seconds )` | Sets the time threshold that determines when adjustments to different parameters will be grouped together into a single history state versus recorded separately. If multiple different parameters are changed within a window of time less than this threshold, they will be grouped together into a single "Multiple Settings" history state. |
| `LrDevelopController.addAdjustmentChangeObserver( functionContext, observer, callback )` | Registers a callback to be called any time the adjustments in the Develop module change. |
| `LrDevelopController.editInPhotoshop()` | Edit the current photo in Photoshop. |
| `LrDevelopController.goToMasking()` | Open Masking for the current photo. |
| `LrDevelopController.goToSpotRemoval()` | Open Spot Removal for the current photo. |
| `LrDevelopController.showClipping()` | Shows the clipping indicators. |
| `LrDevelopController.toggleOverlay()` | Toggles the mask overlay. |
| `LrDevelopController.getActiveColorGradingView()` | Get Active Color Grading View. |
| `LrDevelopController.setActiveColorGradingView( value )` | Set Active Color Grading View. |
| `LrDevelopController.createNewMask( maskType, maskSubtype )` | Create a new mask. |
| `LrDevelopController.addToCurrentMask( maskType, maskSubtype )` | Add to the current mask (union / add operation). |
| `LrDevelopController.subtractFromCurrentMask( maskType, maskSubtype )` | Subtract from the current mask. |
| `LrDevelopController.intersectWithCurrentMask( maskType, maskSubtype )` | Intersect with the current mask. |
| `LrDevelopController.getAllMasks()` | Get all masks on the current photo. |
| `LrDevelopController.getSelectedMask()` | Get the selected mask. |
| `LrDevelopController.getSelectedMaskTool()` | Get the selected mask tool. |
| `LrDevelopController.selectMask( id, param )` | Select a mask. |
| `LrDevelopController.selectMaskTool( id, param )` | Select a mask tool in the current mask. |
| `LrDevelopController.deleteMask( id, param )` | Delete a mask. |
| `LrDevelopController.deleteMaskTool( id, param )` | Delete a mask tool from the current mask. |
| `LrDevelopController.toggleHideMask( id, param )` | Hide/unhide a mask. |
| `LrDevelopController.toggleHideMaskTool( id, param )` | Hide/unhide a mask tool in the current mask. |
| `LrDevelopController.toggleInvertMaskTool( id, param )` | Toggle the invert state of a mask tool in the current mask. |
| `LrDevelopController.invertMask( id, param )` | Invert a mask. |
| `LrDevelopController.duplicateAndInvertMask( id, param )` | Duplicate and invert a mask. |

### LrDevelopPreset

| Method Signature | Description |
|---|---|
| `preset:getFile()` | Retrieves the file path of this preset. First supported in version 3.0 of the Lightroom SDK. |
| `preset:getName()` | Retrieves the name of this preset. First supported in version 3.0 of the Lightroom SDK. |
| `preset:getParent()` | Retrieves the parent folder of this preset. First supported in version 3.0 of the Lightroom SDK. |
| `preset:getSetting()` | Retrieves the settings for this preset. First supported in version 3.0 of the Lightroom SDK. WARNING:The develop settings APIs are experimental. The contents of the settings table are not guaranteed to remain compatible in future versions of Lightroom.The definitive list is the one shown in the UI. |
| `preset:getUuid()` | Retrieves the unique identifier of this preset. First supported in version 3.0 of the Lightroom SDK. |
| `preset:type()` | Reports the type of this object. First supported in version 4.1 of the Lightroom SDK. |

### LrDevelopPresetFolder

| Method Signature | Description |
|---|---|
| `folder:getDevelopPresets()` | Retrieves the develop-preset children of this folder. First supported in version 3.0 of the Lightroom SDK. |
| `folder:getName()` | Retrieves the name of this folder. First supported in version 3.0 of the Lightroom SDK. |
| `folder:getPath()` | Retrieves the path of this folder. First supported in version 3.0 of the Lightroom SDK. |
| `folder:type()` | Reports the type of this object. First supported in version 4.1 of the Lightroom SDK. |

### LrExportContext

| Method Signature | Description |
|---|---|
| `exportContext:configureProgress( args )` | Configures a progress scope for the export rendering sequence. Use in preference to creating a new `LrProgressScope` object, and call before calling `renditions()` in this object. This function allows the filenames and thumbnails to be updated properly. |
| `exportContext:renditions( args )` | Creates an iterator for all renditions in this export. Use in preference to `LrExportContext.exportSession:renditions()`. Calls `exportContext:startRendering()` if needed, and keeps the progress scope updated properly. |
| `exportContext:startRendering()` | Starts the rendering process in a separate task. |

### LrExportRendition

| Method Signature | Description |
|---|---|
| `exportRendition:recordPublishedPhotoId( publishedId )` | Records the unique identifier assigned to a photo published via this service. Use only when publishing. A publish service must make this call to inform Lightroom that the photo has been successfully published. The call moves the photo from "New photos to publish" or "Modified photos to re-publish" to the "Published photos" section of the Library grid (assuming no further changes since the publish operation was initiated). |
| `exportRendition:recordPublishedPhotoUrl( publishedUrl )` | Records the URL assigned to a photo published via this service. Use only when publishing. A publish service can make this call to inform Lightroom where the photo can be found online. This call must follow the first call to `recordPublishedPhotoId()`. |
| `exportRendition:renditionIsDone( success, message )` | Notifies Lightroom that an export filter provider has completed the filtered rendering. |
| `exportRendition:skipRender()` | Causes the export task to skip this rendition. The rendition still appears in the `exportSession:renditions()` loop, but the file is not rendered. Check `exportRendition.wasSkipped` to determine if the rendition was skipped. |
| `exportRendition:type()` | Reports the type of this object. |
| `exportRendition:uploadFailed( message )` | Signals an upload failure for this rendition. |
| `exportRendition:waitForRender()` | Causes the export task to yield time to other tasks until this rendition has been fully generated. This function does not return until the rendition operation is finished and a file has been written to the destination path. During this time, other parts of Lightroom can proceed. |

### LrExportSession

| Method Signature | Description |
|---|---|
| `LrExportSession( params )` | Creates an export session object. The session acts on a specific set of photos and settings, as when a session is started in the Export dialog. |
| `exportSession:countRenditions()` | Reports the number of renditions that will be generated by this session. |
| `exportSession:doExportOnCurrentTask()` | Creates all of the renditions specified by this export session. This function must be called from an asynchronous task. This task blocks until all renditions are created. |
| `exportSession:doExportOnNewTask()` | Starts rendering photos in a new asynchronous task. It is safe to call this function whether in a task or not. This function returns immediately; it does not wait for rendering to complete. |
| `exportSession:photosToExport()` | Creates an iterator with which to walk the list of photos to be exported. Use to wrap a loop that processes each photo. |
| `exportSession:recordRemoteCollectionId( remoteId )` | Records the unique identifier assigned to a published collection. Use only when publishing. This ID is passed back to the plug-in whenever the collection needs to be updated. |
| `exportSession:recordRemoteCollectionUrl( remoteUrl )` | Records the URL assigned to a published collection. Use only when publishing. This URL is used by Lightroom's "Go to Published Collection" command. Do not use for services that are not web-based. |
| `exportSession:removePhoto( photo )` | Removes all renditions for a photo from the export session. It is safe to call this function while using the `photosToExport()` iterator. Be aware that `photosToExport()` takes a snapshot of the photos at the beginning and does not update in response to `removePhoto`. Thus if you remove a photo not yet seen by the iterator, the iterator will still report it. |
| `exportSession:renditions( params )` | Creates an iterator with which to walk the list of renditions generated for this session's photos. Use in a FOR loop. |
| `exportSession:renditionsForFilter( params )` | Creates an iterator with which to walk an export filter's renditions-to-satisfy list. The iterator generates a rendition from this export session (before the application of this filter) and matches it with the corresponding rendition to be satisfied by the filter. |
| `exportSession:type()` | Reports the type of this object. |

### LrFilterContext

| Method Signature | Description |
|---|---|
| `filterContext:renditions( params )` | Alias for filterContext.sourceExportSession:renditionsForFilter. (The `plugin` and `renditionsToSatisfy`arguments are provided automatically by this version of the function.) Creates an iterator with which to walk an export filter's renditions-to-satisfy list. The iterator generates a rendition from this export session (that is, before the application of this filter) and matches it with the corresponding rendition to be satisfied by the filter. First supported in version 2.0 of the Lightroom SDK. For example: `for sourceRendition, renditionToSatisfy in exportSession:renditions( args ) do -- (do something with rendition) end` |

### LrFolder

| Method Signature | Description |
|---|---|
| `folder:getChildren()` | Retrieves immediate subfolders of this folder. Does not go into subfolders. |
| `folder:getName()` | Retrieves the name of this folder. |
| `folder:getParent()` | Retrieves the parent of this folder. |
| `folder:getPath()` | Retrieves the path of this folder. |
| `folder:getPhotos( includeChildren )` | Retrieves the photos contained in this folder. |
| `folder:type()` | Reports the type of this object. |

### LrFtp

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

| Method Signature | Description |
|---|---|
| `LrFunctionContext.callWithContext( name, func, ... )` | Calls the main function, then calls all of the cleanup handlers before returning control. Call this function directly from the imported namespace. If this is called from within an asynchronous task (that is, a task started from `LrTasks.startAsyncTask()`), it uses `LrTasks.pcall()` to make a yield-safe call. If an error is thrown by the main function, that error is rethrown after the cleanup handlers are called. First supported in version 1.3 of the Lightroom SDK. |
| `LrFunctionContext.callWithContext_noyield( name, func, ... )` | Same as callWithContext, but calls the function in a fashion that disables LrTasks.yield from working. Use if you need to ensure that the called function is completed as an atomic unit. Call this function directly from the imported namespace. If this is called from within an asynchronous task (that is, a task started from `LrTasks.startAsyncTask()`), it uses `LrTasks.pcall()` to make a yield-safe call. If an error is thrown by the main function, that error is rethrown after the cleanup handlers are called. First supported in version 2.0 of the Lightroom SDK. |
| `LrFunctionContext.callWithEmptyEnvironment( func, ... )` | Runs the main function in a known-safe function environment. Equivalent to `setfenv( func, {} ); return func( ... )`. The passed-in function is subjected to string.dump for safety reasons, so any variables declared in the scope of the calling function are not automatically passed through to the inner function. In particular, imported namespaces and classes do not carry through. First supported in version 3.0 of the Lightroom SDK. |
| `LrFunctionContext.callWithEnvironment( func, env, ... )` | Runs the main function in a caller-provided function environment. Equivalent to `setfenv( func, env ); return func( ... )`. The passed-in function is subjected to string.dump for safety reasons, so any variables declared in the scope of the calling function are not automatically passed through to the inner function. In particular, imported namespaces and classes do not carry through. First supported in version 3.0 of the Lightroom SDK. |
| `LrFunctionContext.pcallWithContext( name, func, ... )` | Makes a protected call, like Lua's standard `pcall`, but calls all of the cleanup handlers before returning control. Call this function directly from the imported namespace. If this is called from within an asynchronous task (that is, a task started from `LrTasks.startAsyncTask()`), it uses `LrTasks.pcall()` to make a yield-safe call. The cleanup handlers are deferred until the coroutine runs to completion or failure. They are not called when yielding. First supported in version 1.3 of the Lightroom SDK. |
| `LrFunctionContext.pcallWithContext_noyield( name, func, ... )` | Same as `pcallWithContext`, but calls the function in a fashion that disables `LrTasks.yield` from working. Use if you need to ensure that the called function is completed as an atomic unit. First supported in version 2.0 of the Lightroom SDK. |
| `LrFunctionContext.pcallWithEmptyEnvironment( func, ... )` | Runs the main function in a known-safe function environment, catching any exceptions that occur. Equivalent to `setfenv( func, {} ); return pcall( func, ... )`. The passed-in function is subjected to string.dump for safety reasons, so any variables declared in the scope of the calling function are not automatically passed through to the inner function. In particular, imported namespaces and classes do not carry through. First supported in version 3.0 of the Lightroom SDK. |
| `LrFunctionContext.pcallWithEnvironment( func, env, ... )` | Runs the main function in a caller-provided function environment, catching any exceptions that occur. Equivalent to `setfenv( func, {} ); return pcall( func, ... )`. Variables declared in the scope of the calling function are NOT automatically passed through to the inner function. In particular, imported namespaces and classes do not carry through. First supported in version 3.0 of the Lightroom SDK. |
| `LrFunctionContext.postAsyncTaskWithContext( name, func )` | Runs the main function in an asynchronous/cooperative task, then calls any cleanup handlers. Call this function directly from the imported namespace. First supported in version 1.3 of the Lightroom SDK. |
| `functionContext:addCleanupHandler( func )` | Registers a cleanup handler in an instance. This function is called when the main function finishes or throws an error. Cleanup handlers are called in reverse order of registration; that is, the last cleanup handler registered is called first. First supported in version 1.3 of the Lightroom SDK. |
| `functionContext:addFailureHandler( func )` | Registers a failure handler in an instance. This function is called only if the main function fails; that is, throws an error. This is a convenience function. It calls your registered cleanup handler with a wrapper around your function that calls through in the event of a failure. First supported in version 1.3 of the Lightroom SDK. |
| `functionContext:addOperationTitleForError( title )` | Attaches a string to this function context to be shown in any error dialog triggered by `LrDialogs.attachErrorDialogToFunctionContext`. This string acts as a title to the actual error message, which is shown in smaller text below this message. Use the form "Unable to perform operation." First supported in version 3.0 of the Lightroom SDK. |

### LrKeyword

| Method Signature | Description |
|---|---|
| `keyword:getAttributes()` | Retrieves the attributes of this keyword. |
| `keyword:getChildren()` | Retrieves the children of this keyword, if any. |
| `keyword:getName()` | Retrieves the name of this keyword. |
| `keyword:getParent()` | Retrieves the parent of this keyword, if any. |
| `keyword:getPhotos()` | Retrieves the photos that have this keyword. |
| `keyword:getSynonyms()` | Retrieves the synonyms for this keyword. |
| `keyword:setAttributes( keywordInfo )` | Sets attributes for this keyword. |
| `keyword:type()` | Reports the type of this object. |

### LrLogger

| Method Signature | Description |
|---|---|
| `LrLogger( name )` | Creates a new logger or finds and returns an existing one. Loggers are silent until configured with `LrLogger:enable()`. First supported in version 1.3 of the Lightroom SDK. |
| `logger:debug( ... )` | Feeds log output through the action function defined for 'debug' messages. First supported in version 1.3 of the Lightroom SDK. |
| `logger:debugf( format, ... )` | Feeds log output through the action function defined for 'debug' messages, using string.format to prepare the output. First supported in version 2.0 of the Lightroom SDK. |
| `logger:disable()` | Disables all log output from this logger. Equivalent to `logger:enable( false )`. First supported in version 1.3 of the Lightroom SDK. |
| `logger:enable( actions )` | Enables specific log output from this logger. First supported in version 1.3 of the Lightroom SDK. |
| `logger:error( ... )` | Feeds log output through the action function defined for 'error' messages. First supported in version 1.3 of the Lightroom SDK. |
| `logger:errorf( format, ... )` | Feeds log output through the action function defined for 'error' messages, using string.format to prepare the output. First supported in version 2.0 of the Lightroom SDK. |
| `logger:fatal( ... )` | Feeds log output through the action function defined for 'fatal' messages. First supported in version 1.3 of the Lightroom SDK. |
| `logger:fatalf( format, ... )` | Feeds log output through the action function defined for 'fatal' messages, using string.format to prepare the output. First supported in version 2.0 of the Lightroom SDK. |
| `logger:info( ... )` | Feeds log output through the action function defined for 'info' messages. First supported in version 1.3 of the Lightroom SDK. |
| `logger:infof( format, ... )` | Feeds log output through the action function defined for 'info' messages, using string.format to prepare the output. First supported in version 2.0 of the Lightroom SDK. |
| `logger:quick( ... )` | Creates optimized versions of specified log functions for use in tight loops. This version avoids the overhead of the method lookup, and is reduced to a no-op function when logging is disabled. For example: `local warn, info = logger:quick( 'warn', 'info' ) warn( 'something bad happened' )` First supported in version 1.3 of the Lightroom SDK. |
| `logger:quickf( ... )` | Creates optimized versions of specified log functions for use in tight loops. This version avoids the overhead of the method lookup, and is reduced to a no-op function when logging is disabled. Unlike the functions returned by `logger:quick`, these functions take `string.format` instructions. For example: `local warnf, infof = logger:quickf( 'warn', 'info' ) warnf( 'something %s happened', 'bad' )` First supported in version 2.0 of the Lightroom SDK. |
| `logger:trace( ... )` | Feeds log output through the action function defined for 'trace' messages. First supported in version 1.3 of the Lightroom SDK. |
| `logger:tracef( format, ... )` | Feeds log output through the action function defined for 'trace' messages, using string.format to prepare the output. First supported in version 2.0 of the Lightroom SDK. |
| `logger:type()` | Reports the type of this object. First supported in version 4.1 of the Lightroom SDK. |
| `logger:warn( ... )` | Feeds log output through the action function defined for 'warn' messages. First supported in version 1.3 of the Lightroom SDK. |
| `logger:warnf( format, ... )` | Feeds log output through the action function defined for 'warn' messages, using string.format to prepare the output. First supported in version 2.0 of the Lightroom SDK. |

### LrObservableTable

| Method Signature | Description |
|---|---|
| `observableTable:addObserver( condition, table, func )` | Registers an observer for a property table. The observer is notified when a specified value in the observed table changes, and responds by invoking a handler function. There are two forms of this function: One simply registers a callback function; the other associates that callback function with a table (any arbitrary table) so that the observer can later be removed via `removeObserver`. First supported in version 1.3 of the Lightroom SDK. For example (simple form): `local propertyTable = LrBinding.makePropertyTable( functionContext ) local function colorSpaceChanged( propertyTable, key, value ) -- do something with new value end propertyTable:addObserver( 'colorSpace', colorSpaceChanged )` For example (longer form, with removeObserver): `local propertyTable = LrBinding.makePropertyTable( functionContext ) local myTable = {} local function colorSpaceChanged( myTable, propertyTable, key, value ) -- do something with new value -- note that myTable becomes first parameter in this usage end propertyTable:addObserver( 'colorSpace', myTable, colorSpaceChanged ) -- (later ...) propertyTable:removeObserver( 'colorSpace', myTable )` |
| `observableTable:pairs()` | Iterate the contents of this table. Like Lua's built-in `pairs` function, except that it actually works on the observable table. First supported in version 1.3 of the Lightroom SDK. |
| `observableTable:removeObserver( condition, table )` | Unregisters an existing observer on a property table. The observer is no longer notified when the specified value in the observed table changes. Important: This form can only be used if a table was provided to the `addObserver` function. (See second example code under `addObserver`.) First supported in version 1.3 of the Lightroom SDK. |

### LrPhoto

| Method Signature | Description |
|---|---|
| `addKeyword` | - |
| `removeKeyword` | - |
| `getRawMetadata` | - |
| `getFormattedMetadata` | - |
| `getPropertyForPlugin` | 1. (any) The value of the specified metadata property, or nil if not applicable. If no key is specified, returns a table of all available metadata fields as key/value pairs. |
| `setRawMetadata` | - |
| `setPropertyForPlugin` | - |
| `applyMetadataPreset` | - |
| `getDevelopSettings` | - |
| `applyDevelopSettings` | - |
| `applyDevelopPreset` | - |
| `copySettings` | - |
| `pasteSettings` | - |
| `createDevelopSnapshot` | - |
| `getDevelopSnapshots` | - |
| `applyDevelopSnapshot` | - |
| `deleteDevelopSnapshot` | - |
| `quickDevelopAdjustImage` | - |
| `quickDevelopAdjustWhiteBalance` | - |
| `quickDevelopSetTreatment` | - |
| `quickDevelopSetWhiteBalance` | - |
| `quickDevelopCropAspect` | - |
| `buildSmartPreview` | - |
| `deleteSmartPreview` | - |
| `getContainedCollections` | - |
| `getContainedPublishedCollections` | - |
| `addOrRemoveFromTargetCollection` | - |
| `openExportDialog` | - |
| `openExportWithPreviousDialog` | - |
| `getNameViaPreset` | - |
| `requestJpegThumbnail` | - |
| `rotateLeft` | - |
| `rotateRight` | - |
| `checkPhotoAvailability` | - |
| `type` | - |

### LrPlugin

| Method Signature | Description |
|---|---|
| `plugin:hasResource( name )` | Reports whether a resource exists in this plug-in. Typically this is a file in the plug-in folder. First supported in version 1.3 of the Lightroom SDK. |
| `plugin:resourceId( name )` | Retrieves a reference to a resource in this plug-in. Typically this is a file in the plug-in folder. First supported in version 1.3 of the Lightroom SDK. |
| `plugin:type()` | Reports the type of this object. First supported in version 4.1 of the Lightroom SDK. |

### LrProgressScope

| Method Signature | Description |
|---|---|
| `LrProgressScope( params )` | Creates a progress scope object. |
| `progressScope:attachToFunctionContext( context )` | Attaches this progress scope to a function context so that it can be cleared when the function ends, regardless of how the function is terminated. |
| `progressScope:cancel()` | Signals that this operation should be canceled. Called when the user clicks the X at the right end of the progress bar. This does not immediately cancel the operation; that happens when the task polls `:isCanceled()` and stops the operation in response to a true result. |
| `progressScope:done()` | Marks this progress scope as complete. |
| `progressScope:getParentScope()` | Returns the parent progress scope, if any. |
| `progressScope:getPortionComplete()` | Retrieves the portion of this task that has been marked as completed. |
| `progressScope:isCancelable()` | Reports whether this progress scope can be canceled. |
| `progressScope:isCanceled()` | Reports whether this operation has been canceled by the user. |
| `progressScope:isDone()` | Reports whether this progress scope has been completed. |
| `progressScope:isIndeterminate()` | Reports whether this progress scope is indeterminate. When a scope is indeterminate, you cannot determine how much of the task remains to be completed. `getPortionComplete()` returns -1. |
| `progressScope:isLowUiPriority()` | Reports whether this progress scope has low UI priority. |
| `progressScope:isPausable()` | Reports whether this progress scope can be paused. |
| `progressScope:isPaused()` | Reports whether this operation has been paused by the user. |
| `progressScope:pause()` | Signals that this operation should be paused. Called when the user clicks the \|\| at the right end of the progress bar. This does not immediately pause the operation; that happens when the task polls `:isPaused()` and pauses the operation in response to a true result. |
| `progressScope:setCancelable( cancelable )` | Allows or disallows user cancellation of this progress scope. |
| `progressScope:setCaption( caption )` | Changes the caption that identifies this child task. |
| `progressScope:setIndeterminate()` | Makes this progress scope indeterminate. When a scope is indeterminate, you cannot determine how much of the task remains. `getPortionComplete()` returns -1. Indeterminate progress scopes are only useful in the context of `LrDialogs:showModalProgressDialog()`; they do not display properly in the Lightroom catalog window. |
| `progressScope:setLowUiPriority( inPrior )` | Sets or clears low UI priority for this progress scope. |
| `progressScope:setPausable( pausable, cancelable )` | Allows or disallows the capability of the user to pause this progress scope. |
| `progressScope:setPortionComplete( amountDone, totalAmount )` | Sets the portion of this task that has been completed. |
| `progressScope:type()` | Reports the type of this object. |

### LrPublishService

| Method Signature | Description |
|---|---|
| `publishService:createPublishedCollection( name, parent, canReturnExisting )` | Creates a new published collection in this publish service. This is the equivalent of creating a published collection in the Publish Services panel without including selected photos or creating virtual copies. |
| `publishService:createPublishedCollectionSet( name, parent, canReturnExisting )` | Creates a new collection set in this publish service. |
| `publishService:createPublishedSmartCollection( name, searchDesc, parent, canReturnExisting )` | Creates a new published smart collection in this publish service. This is the equivalent of creating a published smart collection in the Publish Services panel. |
| `publishService:getChildCollectionSets()` | Retrieves the photo collection sets that are immediate children of this service. |
| `publishService:getChildCollections()` | Retrieves the photo collections that are immediate children of this service. Does not recurse into collection sets. |
| `publishService:getName()` | Retrieves the current name of the publish service. |
| `publishService:getPluginId()` | Retrieves the unique identifier for the plug-in to which this service belongs. Note that if the plug-in's `LrExportServiceProvider` definition is a table of tables, the plug-in ID returned by this function will have a '.' followed by a number appended to it. The number corresponds to the export service provider to which this service belongs. |
| `publishService:getPublishSettings()` | Retrieves the current plug-in defined settings for the publish service. This is the same block of data that can be edited via the user interface if your plug-in implements the `viewForCollectionSettings` hook. See `LrPublishedCollection:setCollectionSettings()`. |
| `publishService:type()` | Reports the type of this object. |

### LrPublishedCollection

| Method Signature | Description |
|---|---|
| `pubCollection:addPhotoByRemoteId( photo, remoteID, remoteUrl, published )` | Adds a photo with a remote ID and URL to this collection, if it is not a smart collection. If the photo exists in the collection, replaces the old remote ID and URL with the new values. Throws an exception if this is a smart collection and the photo is not already included. (For a smart collection, a reason to call this would be to update the published status of a photo.) |
| `pubCollection:addPhotos( photos )` | Adds photos to this collection, if it is not a smart collection. Throws an exception if this is a smart collection. |
| `pubCollection:addPublishedPhotos( publishedPhotos )` | Adds a set of published photos, along with their publication data, to this collection, if it is not a smart collection. Throws an exception if this is a smart collection. |
| `pubCollection:delete()` | Removes this collection from the containing catalog. |
| `pubCollection:getCollectionInfoSummary()` | Retrieves an information summary about this published collection. |
| `pubCollection:getName()` | Retrieves the current name of this collection. |
| `pubCollection:getParent()` | Retrieves the parent collection set, if any, that contains this collection. |
| `pubCollection:getPhotos()` | Retrieves all of the photos in this collection. |
| `pubCollection:getPublishedPhotos()` | Retrieves the publication data for photos in this collection. |
| `pubCollection:getRemoteId()` | Retrieves the remote service's unique identifier for this published collection, as previously recorded by the plug-in. |
| `pubCollection:getRemoteUrl()` | Retrieves the URL for this published collection, as assigned by the remote service and previously recorded by the plug-in. |
| `pubCollection:getSearchDescription()` | Retrieves the search description for a smart collection. Throws an exception if this is not a smart collection. |
| `pubCollection:getService()` | Retrieves the service that this collection belongs to. |
| `pubCollection:isSmartCollection()` | Reports whether this collection is a smart collection. |
| `pubCollection:publishNow( doneCallback )` | Initiates a publish operation for this collection. It is strongly recommended that plug-ins make any auto-publishing behavior opt-in via the Lightroom Publishing Manager. |
| `pubCollection:removeAllPhotos()` | Removes all photos from this collection if it is not a smart collection. Throws an exception if this is a smart collection. |
| `pubCollection:removePhotos( photos )` | Removes photos from this collection if it is not a smart collection. Throws an exception if this is a smart collection. |
| `pubCollection:setCollectionSettings( settings )` | Sets the plug-in-specific settings for this published collection. This is the same block of data that can be edited via the user interface if your plug-in implements the `viewForCollectionSettings` hook. |
| `pubCollection:setName( name )` | Sets a new name for this published collection. |
| `pubCollection:setParent( parent )` | Sets a new parent for this published collection. This function does not enforce any restrictions on collection-set depth, nor does it call the plug-in's `reparentPublishedCollection` callback. The plug-in is responsible for ensuring synchronization with the publication site. |
| `pubCollection:setRemoteId( remoteId )` | Sets the unique identifier for this published collection as understood by the remote service. |
| `pubCollection:setRemoteUrl( url )` | Sets the URL for this published collection, as provided by the remote service. It is not required to have a URL on record with Lightroom. If one is provided, it is displayed in the publish header in the Library grid and used to enable the "Go to Published Collection" command in the collection context menu. |
| `pubCollection:setSearchDescription( searchDesc )` | Sets the search description for this smart collection. Throws an exception if this is not a smart collection. |
| `pubCollection:type()` | Reports the type of this object. |

### LrPublishedCollectionSet

| Method Signature | Description |
|---|---|
| `pubCollectionSet:delete()` | Removes this published-collection set from the catalog. |
| `pubCollectionSet:getChildCollectionSets()` | Retrieves the published collection sets that are immediate children of this set, if any. |
| `pubCollectionSet:getChildCollections()` | Retrieves the published collections that are immediate children of this set. Does not go into nested sets. |
| `pubCollectionSet:getChildren()` | Retrieves all immediate members of this set, both published collections and collection sets. |
| `pubCollectionSet:getCollectionSetInfoSummary()` | Retrieves an information summary about this published collection set. |
| `pubCollectionSet:getName()` | Retrieves the current name of this set. |
| `pubCollectionSet:getParent()` | Retrieves the parent set, if any, of this published-collection set. |
| `pubCollectionSet:getRemoteId()` | Retrieves the remote service's unique identifier for this published collection set, as previously recorded by the plug-in. |
| `pubCollectionSet:getRemoteUrl()` | Retrieves the URL for this published collection set, as assigned by the remote service and previously recorded by the plug-in. |
| `pubCollectionSet:getService()` | Retrieves the publish service that this set belongs to. |
| `pubCollectionSet:setCollectionSetSettings( settings )` | Sets the plug-in-specific settings for this published collection set. This is the same block of data that can be edited via the user interface if your plug-in implements the `viewForCollectionSetSettings` hook. |
| `pubCollectionSet:setName( name )` | Sets a new name for this published collection set. |
| `pubCollectionSet:setParent( parent )` | Sets a new parent for this published collection set. This function does not enforce any restrictions on collection-set depth, nor does it call the plug-in's `reparentPublishedCollection` callback. The plug-in is responsible for ensuring synchronization with the publication site. |
| `pubCollectionSet:setRemoteId( remoteId )` | Sets the unique identifier for this published collection set as understood by the remote service. |
| `pubCollectionSet:setRemoteUrl( url )` | Sets the URL for this published collection set, as provided by the remote service. It is not required to have a URL on record with Lightroom. If one is provided, it is displayed in the publish header in the Library grid and used to enable the "Go to Published Collection Set" command in the collection context menu. |
| `pubCollectionSet:type()` | Reports the type of this object. |

### LrPublishedPhoto

| Method Signature | Description |
|---|---|
| `publishedPhoto:getEditedFlag()` | Reports whether the associated photo has been edited since last published. |
| `publishedPhoto:getPhoto()` | Retrieves the photo associated with this publishing data. |
| `publishedPhoto:getPublishCount()` | Reports the number of times the associated photo has been published by a publish service. |
| `publishedPhoto:getRemoteId()` | Retrieves the unique identifier for the associated photo, as assigned by the remote service. |
| `publishedPhoto:getRemoteUrl()` | Retrieves the URL for the associated photo, assigned by the remote service. |
| `publishedPhoto:setEditedFlag( edited )` | Marks the associated photo as edited since last published, or unchanged since publishing. |
| `publishedPhoto:setRemoteId( remoteID )` | Updates the remote service's unique identifier associated with the published photo. |
| `publishedPhoto:setRemoteUrl( url )` | Updates the URL for the associated photo. |
| `publishedPhoto:type()` | Reports the type of this object. |

### LrRecursionGuard

| Method Signature | Description |
|---|---|
| `LrRecursionGuard( name )` | Creates a new recursion guard. First supported in version 2.0 of the Lightroom SDK. |
| `recursionGuard:performWithGuard( func, ... )` | Calls a function, but only if we are not already inside a call that has been guarded by this guard. If `recursionGuard.active == true`, does nothing. First supported in version 2.0 of the Lightroom SDK. |

### LrVideoExportPreset

| Method Signature | Description |
|---|---|
| `videoExportPreset:extension()` | This function returns the target extension for the video format associated with this video export preset. First supported in version 4.0 of the Lightroom SDK. |
| `videoExportPreset:formatID()` | This function returns the identifier of the format corresponding to this video export preset. First supported in version 4.0 of the Lightroom SDK. |
| `videoExportPreset:name()` | This function returns the name of the video export preset. First supported in version 4.0 of the Lightroom SDK. |
| `videoExportPreset:presetPath()` | For a preset provided by a plug-in, this function returns the path to the preset file associated with this video export preset. For any of the default presets, this function will return nil. First supported in version 4.0 of the Lightroom SDK. |
| `videoExportPreset:targetInfo()` | This function returns the string which appears in the 'Target' information of the Video section in the Export Dialog when this video export preset is selected. In the case of custom video export preset, this is the string supplied for 'targetInfo' when the preset was added via the LrExportSettings.addVideoExportPresets API. Note that for some of the default (built-in) presets, the target info is generated dynamically based on certain properties of the source video. For such presets, this function returns nil. First supported in version 4.0 of the Lightroom SDK. |
| `videoExportPreset:type()` | Reports the type of this object. First supported in version 4.1 of the Lightroom SDK. |

### LrView

| Method Signature | Description |
|---|---|
| `LrView.bind( binding )` | This namespace function declares a binding to a data value in a property table. First supported in version 1.3 of the Lightroom SDK. |
| `LrView.conditionalItem( condition, view )` | This namespace function allows you to define a view that is added to the layout only if a specific condition is true. If the condition is false, the view is ignored. (Note that this is not a binding; the condition is evaluated once when the view description is generated.) First supported in version 2.0 of the Lightroom SDK. |
| `LrView.osFactory()` | This namespace function produces a factory object that can be used to create views and controls. First supported in version 1.3 of the Lightroom SDK. |
| `LrView.share( name )` | This namespace function declares the sharing of an attribute value with other views. Typically used with a size value (width or height), in which case the greatest of the shared values is used for all objects that share the value. First supported in version 1.3 of the Lightroom SDK. |
| `viewFactory:catalog_photo( args )` | Creates a view containing a photo from the catalog. First supported in version 4.0 of the Lightroom SDK. |
| `viewFactory:checkbox( args )` | Creates a checkbox control, which displays the title text with a platform-style checkbox button. A checkbox is checked (selected) when its `value` is equal to its `checked_value`, and unchecked (deselected) when its `value` is equal to its `unchecked_value`. If its `value` has any other value, the button shows a mixed state. First supported in version 1.3 of the Lightroom SDK. |
| `viewFactory:color_well( args )` | Creates a color well control, which displays the current color, and when clicked shows a UI that lets the user choose a different color. First supported in version 1.3 of the Lightroom SDK. |
| `viewFactory:column( args )` | Creates a column container, which lays out its children vertically. This view is affected by property values in its parent (such as `visible`), but has no non-layout properties of its own. First supported in version 1.3 of the Lightroom SDK. |
| `viewFactory:combo_box( args )` | Creates a combo box control, with an editable text field and a pop-up menu of predefined text values. The user can enter any text, or select from the menu. When an item is selected from the menu, its value becomes the control value, and is displayed in the text field. First supported in version 1.3 of the Lightroom SDK. |
| `viewFactory:control_spacing()` | Retrieves a spacing value suitable for assignment to the spacing property of a group of controls. First supported in version 1.3 of the Lightroom SDK. |
| `viewFactory:dialog_spacing()` | Retrieves a spacing value suitable for assignment to the spacing property of a group of items at the top level of a dialog. First supported in version 1.3 of the Lightroom SDK. |
| `viewFactory:edit_field( args )` | Creates an edit-field control, which accepts keyboard input when it has the input focus. User input is committed (that is, the `value` is updated) with every keystroke if `immediate` is true. If `immediate` is false, input is committed when the control loses focus. There is a platform difference in the focus behavior: First supported in version 1.3 of the Lightroom SDK. In Windows, the control loses focus when the user clicks outside it. In Mac OS, it loses focus when the user uses Tab to shift the focus, not when the user clicks outside the control. |
| `viewFactory:group_box( args )` | Creates a group box container, a visible containment frame for a set of controls. Can have a localizable title, which is displayed near the top left corner of the frame. First supported in version 1.3 of the Lightroom SDK. |
| `viewFactory:label_spacing()` | Retrieves a spacing value suitable for assignment to the spacing property of a group of items where the items are closely related and one of the items serves as a label for the other items. First supported in version 1.3 of the Lightroom SDK. |
| `viewFactory:password_field( args )` | Creates a password field control, an editable text field that obscures the entered text, displaying only bullet characters. First supported in version 1.3 of the Lightroom SDK. |
| `viewFactory:picture( args )` | Creates a picture control, which displays a static image or icon. First supported in version 1.3 of the Lightroom SDK. |
| `viewFactory:popup_menu( args )` | Creates a pop-up menu control, which offers a pop-up menu of choices, each with a title and value. When the user pops up the menu and makes a choice, the selected item's title and value become those of the control. The current title text is displayed in the control when the menu is not open. First supported in version 1.3 of the Lightroom SDK. |
| `viewFactory:push_button( args )` | Creates a push button control, which responds to a click with an action. Drawn in platform-standard style with a rounded appearance. First supported in version 1.3 of the Lightroom SDK. |
| `viewFactory:radio_button( args )` | Creates a radio button control. The button is checked (selected) when the control `value` is equal to its `checked_value`, and unchecked (deselected) when `value` has any other value, except nil. When `value` is nil, the button shows a mixed state. Within a container, only one of a set of radio buttons should be selected. Selecting one button should deselect all others in the set. You must enforce this in the way you bind the button values; it is not automatic. First supported in version 1.3 of the Lightroom SDK. As of version 6.0 of the Lightroom SDK, on Mac only, radio buttons with the same parent view will be automatically 'linked', i.e. checking one will clear all the others, as a result of a change in the underlying OS provided API. This should only be noticeable in a view construct where radio buttons are declared via the `osFactory:row` or `osFactory:column` method within the same parent view. If you wish to have more than two radio buttons in a row or column, use the `osFactory:view` method instead, with a `place` attribute of `horizontal` or `vertical`. Do not attempt to take advantage of OS X's automatic behavior, as the automatically changed radio button states will not necessarily be reflected in the property table to which the radio buttons' values are bound. |
| `viewFactory:row( args )` | Creates a row container, which lays out its children horizontally. This view is affected by property values in its parent (such as `visible`), but has no non-layout properties of its own. First supported in version 1.3 of the Lightroom SDK. |
| `viewFactory:scrolled_view( args )` | Creates a container view with horizontal and vertical scroll bars. First supported in version 4.0 of the Lightroom SDK. On Mac OS, the scroll bars will automatically be hidden if the content of the scroll view does not require vertical and/or horizontal scrolling ability. On Windows, the scroll bar(s) will be grayed out in such a case. |
| `viewFactory:separator( args )` | Creates a separator, which draws a line 2 pixels in width in its container, but has no other behavior. First supported in version 1.3 of the Lightroom SDK. |
| `viewFactory:simple_list( args )` | Creates a simple scrolling list control, which is similar to popup_menu in that it offers a simple non-hierarchical list of choices, each with a title and value. When the user clicks on an item in the list, that selected item's value becomes the value of the control. First supported in version 4.0 of the Lightroom SDK. |
| `viewFactory:slider( args )` | Creates a slider control, which has a draggable indicator that changes an associated numeric value. First supported in version 1.3 of the Lightroom SDK. |
| `viewFactory:spacer( args )` | Creates a view to consume space for the purposes of layout.This is an empty row, which affects the layout of other children of its parent. It has no properties of its own except for size; these are typically shared with its sibling rows, using the `LrView.share()` function. First supported in version 1.3 of the Lightroom SDK. |
| `viewFactory:static_text( args )` | Creates a static text control that does not respond to user input, typically a label or instructions. First supported in version 1.3 of the Lightroom SDK. |
| `viewFactory:tab_view( args )` | Creates a container of tabbed pages. The containing tab view draws the frames for its `tab_view_item` children, but has no title. The `font` value is the default for the tab text of the children. First supported in version 1.3 of the Lightroom SDK. |
| `viewFactory:tab_view_item( args )` | Creates a tabbed page container in a tab view container. The localizable title text is displayed in the tab. First supported in version 1.3 of the Lightroom SDK. |
| `viewFactory:view( args )` | Creates a basic containment frame for a set of controls, with no visual representation. First supported in version 1.3 of the Lightroom SDK. |

### LrWebViewFactory

| Method Signature | Description |
|---|---|
| `webViewFactory:checkbox_and_color_row( args )` | Creates a row containing a check box, a label, and a color well, within a section in a Web-module panel. First supported in version 2.0 of the Lightroom SDK. |
| `webViewFactory:checkbox_row( args )` | Creates a row containing a label and a checkbox, within a column container in a section in a Web-module panel. First supported in version 2.0 of the Lightroom SDK. |
| `webViewFactory:color_content_column( args )` | Creates a container for color swatches within a section in a Web-module panel. Has a column layout(that is, `place='vertical'`) and appropriate spacing and margins for properly positioning `label_and_color_row` elements. First supported in version 2.0 of the Lightroom SDK. |
| `webViewFactory:content_column( args )` | Creates a general-purpose container within a section in a Web-module panel. Has a column layout and appropriate spacing and margins for properly positioning labels, checkboxes, and so on. First supported in version 2.0 of the Lightroom SDK. |
| `webViewFactory:content_section( args )` | Creates a generic column-layout container within a section in a Web-module panel. This can contain checkboxes or other labels that do not require any additional indentation. First supported in version 2.0 of the Lightroom SDK. |
| `webViewFactory:header_section( args )` | Creates a generic row-layout container within a header section in a Web-module panel. This can contain checkboxes or other labels that do not require any additional indentation, used as the first element of a section. |
| `webViewFactory:header_section_label( args )` | Creates a label with an appropriate color, font, size and margins to be used as a section header. Must be the immediate child of a `subdivided_sections` view. First supported in version 2.0 of the Lightroom SDK. |
| `webViewFactory:identity_plate( args )` | Creates an identity plate control. Must be the immediate child of a `subdivided_sections` container within a Web-module panel. First supported in version 2.0 of the Lightroom SDK. |
| `webViewFactory:label_and_color_row( args )` | Creates a row containing a label and a color well, within a `color_content_column` in a section in a Web-module panel. First supported in version 2.0 of the Lightroom SDK. |
| `webViewFactory:labeled_text_input( args )` | Creates a row containing a label and an edit text, with optional most-recently-used (MRU) menu. First supported in version 2.0 of the Lightroom SDK. |
| `webViewFactory:metadataModeControl( args )` | Creates a row containing a pop-up menu with metadata mode choices, within a section in a Web-module panel. |
| `webViewFactory:panel_content( args )` | Creates a top-level Web-module panel. Use only at the top level of containment; immediate children are created with `subdivided_sections()`. Each child section within this container is separated by a heavy black divider line. First supported in version 2.0 of the Lightroom SDK. |
| `webViewFactory:popup_row( args )` | Creates a row container for `popup_menu` controls. First supported in version 2.0 of the Lightroom SDK. |
| `webViewFactory:row( args )` | Creates a generic row-layout container within a section in a Web-module panel, with correct spacing and horizontal fill. First supported in version 2.0 of the Lightroom SDK. |
| `webViewFactory:row_column_picker( args )` | Creates a control for selecting the number of rows and columns in a grid. First supported in version 2.0 of the Lightroom SDK. |
| `webViewFactory:slider_content_column( args )` | Creates a container for `slider_row` views within a section in a Web-module panel. Has a column layout(that is, `place='vertical'`) and appropriate spacing and margins for properly positioning `slider_row` controls. First supported in version 2.0 of the Lightroom SDK. |
| `webViewFactory:slider_row( args )` | Creates a row containing a label, a slider, and an edit text, within a `slider_content_column` in a section in a Web-module panel. First supported in version 2.0 of the Lightroom SDK. |
| `webViewFactory:subdivided_sections( args )` | Creates a section within a Web-module panel created by `panel_content()`. Each child view within this container is separated by a light gray divider line. This container sets appropriate margins for aligning headers and checkboxes. Its children are row, column, and heading containers. First supported in version 2.0 of the Lightroom SDK. |
| `webViewFactory:warning_icon( args )` | Creates a small symbol that appears to warn the user about a specific property value. |

### LrXml

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
| `xmlDomInstance:transform( xsltString )` | Transforms this XML into string output by applying an XSLT transformation. Depending on the operating system, the result of the transform can contain different amounts and/or kinds of whitespace. To normalize the result, apply a substitution pattern such as this: `string.gsub( result, "[
 ]+", " " )` This must be called on the root node. Note: The error messages from this function can be misleading. If you see the message "out of memory", you may want to review the application or OS console for other messages that may be more helpful. First supported in version 1.3 of the Lightroom SDK. |
| `xmlDomInstance:type()` | Retrieves the type of the `xml` node from this XML document. First supported in version 1.3 of the Lightroom SDK. |
<!-- END OFFICIAL_CLASSES -->

---

<!-- BEGIN OFFICIAL_DEVELOP_KEYS -->
## Develop Settings Key Reference (Official SDK 11.4)

Complete develop-setting key reference merged from `LrPhoto` and `LrDevelopController`.

### LrPhoto Develop Settings Keys

#### Develop Settings Keys (SDK 3.0)

| Key | Type | Description |
|-----|------|-------------|
| `AutoBrightness` | boolean | |
| `AutoContrast` | boolean | |
| `AutoExposure` | boolean | |
| `AutoShadows` | boolean | |
| `BlueHue` | number | |
| `BlueSaturation` | number | |
| `Brightness` | number | |
| `CameraProfile` | string | |
| `ChromaticAberrationB` | number | |
| `ChromaticAberrationR` | number | |
| `Clarity` | number | |
| `ColorNoiseReduction` | number | |
| `ColorNoiseReductionDetail` | number | |
| `Contrast` | number | |
| `ConvertToGrayscale` | boolean | |
| `CropAngle` | number | |
| `CropBottom` | number | |
| `CropLeft` | number | |
| `CropRight` | number | |
| `CropTop` | number | |
| `Dehaze` | number | |
| `Defringe` | number | |
| `EnableCalibration` | boolean | |
| `EnableColorAdjustments` | boolean | |
| `EnableDetail` | boolean | |
| `EnableEffects` | boolean | |
| `EnableGrayscaleMix` | boolean | |
| `EnableLensCorrections` | boolean | |
| `EnableTransform` | boolean | |
| `EnableMaskGroupBasedCorrections` | boolean | |
| `EnableRedEye` | boolean | |
| `EnableRetouch` | boolean | |
| `EnableSplitToning` | boolean | |
| `Exposure` | number | |
| `FillLight` | number | |
| `GrainAmount` | number | |
| `GrainFrequency` | number | |
| `GrainSize` | number | |
| `GreenHue` | number | |
| `GreenSaturation` | number | |
| `HighlightRecovery` | number | |
| `HueAdjustmentAqua` | number | |
| `HueAdjustmentBlue` | number | |
| `HueAdjustmentGreen` | number | |
| `HueAdjustmentMagenha` | number | Note: typo in original SDK docs ("Magenha" instead of "Magenta") |
| `HueAdjustmentOrange` | number | |
| `HueAdjustmentPurple` | number | |
| `HueAdjustmentRed` | number | |
| `HueAdjustmentYellow` | number | |
| `LuminanceAdjustmentAque` | number | Note: typo in original SDK docs ("Aque" instead of "Aqua") |
| `LuminanceAdjustmentBlue` | number | |
| `LuminanceAdjustmentGreen` | number | |
| `LuminanceAdjustmentMagenta` | number | |
| `LuminanceAdjustmentOrange` | number | |
| `LuminanceAdjustmentPurple` | number | |
| `LuminanceAdjustmentRed` | number | |
| `LuminanceAdjustmentYellow` | number | |
| `LuminanceNoiseReductionContrast` | number | |
| `LuminanceNoiseReductionDetail` | number | |
| `LuminanceSmoothing` | number | |
| `ParametricDarks` | number | |
| `ParametricHighlightSplit` | number | |
| `ParametricHighlights` | number | |
| `Parametriclights` | number | Note: lowercase 'l' in original SDK docs |
| `ParametricMidtoneSplit` | number | |
| `ParametricShadowSplit` | number | |
| `ParametricShadows` | number | |
| `PostCropVignetteAmount` | number | |
| `PostCropVignetteFeather` | number | |
| `PostCropVignetteHighlightContrast` | number | |
| `PostCropVignetteMidpoint` | number | |
| `PostCropVignetteRoundness` | number | |
| `PostCropVignetteStyle` | number | |
| `ProcessVersion` | string | |
| `RedEyeInfo` | table | |
| `RedHue` | number | |
| `RedSaturation` | number | |
| `RetouchInfo` | table | |
| `Saturation` | number | |
| `SaturationAdjustmentAqua` | number | |
| `SaturationAdjustmentBlue` | number | |
| `SaturationAdjustmentGreen` | number | |
| `SaturationAdjustmentMagenta` | number | |
| `SaturationAdjustmentOrange` | number | |
| `SaturationAdjustmentPurple` | number | |
| `SaturationAdjustmentRed` | number | |
| `SaturationAdjustmentYellow` | number | |
| `ShadowTint` | number | |
| `Shadows` | number | |
| `SharpenDetail` | number | |
| `SharpenEdgeMasking` | number | |
| `SharpenRadius` | number | |
| `Sharpness` | number | |
| `SplitToningBalance` | number | |
| `SplitToningHighlightHue` | number | |
| `SplitToningHighlightSaturation` | number | |
| `SplitToningShadowHue` | number | |
| `SplitToningShadowSaturation` | number | |
| `ToneCurve` | table | |
| `ToneCurveName` | string | |
| `Vibrance` | number | |
| `VignetteAmount` | number | |
| `VignetteMidpoint` | number | |
| `WhiteBalance` | string | |
| `Orientation` | string | |

#### Develop Settings Keys (SDK 4.0)

| Key | Type | Description |
|-----|------|-------------|
| `TrimStart` | table | Contains 'numerator' and 'denominator' for trim start in seconds. Video only. |
| `TrimEnd` | table | Contains 'numerator' and 'denominator' for trim end in seconds. Video only. |
| `Blacks2012` | number | |
| `Clarity2012` | number | |
| `Contrast2012` | boolean | |
| `Exposure2012` | number | |
| `Highlights2012` | number | |
| `Shadows2012` | number | |
| `ToneCurvePV2012` | table | |
| `ToneCurvePV2012Blue` | table | |
| `ToneCurvePV2012Green` | table | |
| `ToneCurvePV2012Red` | table | |
| `ToneCurveName2012` | string | |
| `Whites2012` | number | |

---


### LrDevelopController Parameter Names by Panel

## Develop Parameter Names by Panel

All parameter names below are strings that can be passed to `getValue`, `setValue`, `getRange`, `increment`, `decrement`, `resetToDefault`, and `startTracking`. They can also be passed to `revealPanel` / `revealPanelIfVisible` to reveal the panel that contains that parameter.

### adjustPanel -- Basic Tone and Presence

| Parameter | Notes |
|---|---|
| `"Temperature"` | White balance temperature. **Logarithmic for RAW/DNG, linear otherwise.** |
| `"Tint"` | White balance tint |
| `"Exposure"` | Overall exposure |
| `"Highlights"` | Controls Recovery in Process Version 1 and 2 |
| `"Shadows"` | Controls Fill Light in Process Version 1 and 2 |
| `"Brightness"` | **No effect unless in Process Version 1 or Version 2** |
| `"Contrast"` | Contrast |
| `"Whites"` | **No effect in Process Version 1 and 2** |
| `"Blacks"` | Blacks |
| `"Texture"` | **Disabled for Process Versions 1 and 2. Versions 3 and 4 auto-update to current PV on change.** |
| `"Clarity"` | Clarity / midtone contrast |
| `"Dehaze"` | Dehaze amount |
| `"Vibrance"` | Vibrance |
| `"Saturation"` | Saturation |
| `"PresetAmount"` | Preset amount |
| `"ProfileAmount"` | Profile amount |

### tonePanel -- Tone Curve (Parametric)

| Parameter | Notes |
|---|---|
| `"ParametricDarks"` | Darks region of parametric curve |
| `"ParametricLights"` | Lights region of parametric curve |
| `"ParametricShadows"` | Shadows region of parametric curve |
| `"ParametricHighlights"` | Highlights region of parametric curve |
| `"ParametricShadowSplit"` | Split point between shadows and darks |
| `"ParametricMidtoneSplit"` | Split point between darks and lights |
| `"ParametricHighlightSplit"` | Split point between lights and highlights |

### mixerPanel -- HSL / Color / B&W

#### HSL / Color Adjustments

| Saturation | Hue | Luminance |
|---|---|---|
| `"SaturationAdjustmentRed"` | `"HueAdjustmentRed"` | `"LuminanceAdjustmentRed"` |
| `"SaturationAdjustmentOrange"` | `"HueAdjustmentOrange"` | `"LuminanceAdjustmentOrange"` |
| `"SaturationAdjustmentYellow"` | `"HueAdjustmentYellow"` | `"LuminanceAdjustmentYellow"` |
| `"SaturationAdjustmentGreen"` | `"HueAdjustmentGreen"` | `"LuminanceAdjustmentGreen"` |
| `"SaturationAdjustmentAqua"` | `"HueAdjustmentAqua"` | `"LuminanceAdjustmentAqua"` |
| `"SaturationAdjustmentBlue"` | `"HueAdjustmentBlue"` | `"LuminanceAdjustmentBlue"` |
| `"SaturationAdjustmentPurple"` | `"HueAdjustmentPurple"` | `"LuminanceAdjustmentPurple"` |
| `"SaturationAdjustmentMagenta"` | `"HueAdjustmentMagenta"` | `"LuminanceAdjustmentMagenta"` |

Colors available: Red, Orange, Yellow, Green, Aqua, Blue, Purple, Magenta (8 channels).

#### B&W Mix

| Parameter |
|---|
| `"GrayMixerRed"` |
| `"GrayMixerOrange"` |
| `"GrayMixerYellow"` |
| `"GrayMixerGreen"` |
| `"GrayMixerAqua"` |
| `"GrayMixerBlue"` |
| `"GrayMixerPurple"` |
| `"GrayMixerMagenta"` |

### colorGradingPanel -- Color Grading (formerly Split Toning)

| Parameter | Notes |
|---|---|
| `"SplitToningShadowHue"` | Shadow hue |
| `"SplitToningShadowSaturation"` | Shadow saturation |
| `"ColorGradeShadowLum"` | Shadow luminance |
| `"SplitToningHighlightHue"` | Highlight hue |
| `"SplitToningHighlightSaturation"` | Highlight saturation |
| `"ColorGradeHighlightLum"` | Highlight luminance |
| `"ColorGradeMidtoneHue"` | Midtone hue |
| `"ColorGradeMidtoneSat"` | Midtone saturation |
| `"ColorGradeMidtoneLum"` | Midtone luminance |
| `"ColorGradeGlobalHue"` | Global hue |
| `"ColorGradeGlobalSat"` | Global saturation |
| `"ColorGradeGlobalLum"` | Global luminance |
| `"SplitToningBalance"` | Balance between shadows and highlights |
| `"ColorGradeBlending"` | Blending amount |

### detailPanel -- Sharpening and Noise Reduction

| Parameter | Notes |
|---|---|
| `"Sharpness"` | Sharpening amount |
| `"SharpenRadius"` | Sharpening radius |
| `"SharpenDetail"` | Sharpening detail |
| `"SharpenEdgeMasking"` | Sharpening edge masking |
| `"LuminanceSmoothing"` | Luminance noise reduction |
| `"LuminanceNoiseReductionDetail"` | Luminance NR detail |
| `"LuminanceNoiseReductionContrast"` | Luminance NR contrast |
| `"ColorNoiseReduction"` | Color noise reduction |
| `"ColorNoiseReductionDetail"` | Color NR detail |
| `"ColorNoiseReductionSmoothness"` | Color NR smoothness |

### effectsPanel -- Post-Crop Vignetting and Grain

| Parameter | Notes |
|---|---|
| `"PostCropVignetteAmount"` | Vignette amount |
| `"PostCropVignetteMidpoint"` | Vignette midpoint |
| `"PostCropVignetteFeather"` | Vignette feather |
| `"PostCropVignetteRoundness"` | Vignette roundness |
| `"PostCropVignetteStyle"` | Vignette style |
| `"PostCropVignetteHighlightContrast"` | Vignette highlight contrast |
| `"GrainAmount"` | Grain amount |
| `"GrainSize"` | Grain size |
| `"GrainFrequency"` | Grain roughness/frequency |

### lensCorrectionsPanel -- Lens Corrections and Transform

#### Profile

| Parameter | Notes |
|---|---|
| `"LensProfileDistortionScale"` | Lens profile distortion scale |
| `"LensProfileVignettingScale"` | Lens profile vignetting scale |
| `"LensManualDistortionAmount"` | Manual distortion amount |

#### Defringe (Chromatic Aberration)

| Parameter | Notes |
|---|---|
| `"DefringePurpleAmount"` | Purple fringe removal amount |
| `"DefringePurpleHueLo"` | Purple fringe hue range (low) |
| `"DefringePurpleHueHi"` | Purple fringe hue range (high) |
| `"DefringeGreenAmount"` | Green fringe removal amount |
| `"DefringeGreenHueLo"` | Green fringe hue range (low) |
| `"DefringeGreenHueHi"` | Green fringe hue range (high) |

#### Manual Perspective / Transform

| Parameter | Notes |
|---|---|
| `"PerspectiveVertical"` | Vertical perspective correction |
| `"PerspectiveHorizontal"` | Horizontal perspective correction |
| `"PerspectiveRotate"` | Rotation correction |
| `"PerspectiveScale"` | Scale |
| `"PerspectiveAspect"` | Aspect ratio correction |
| `"PerspectiveX"` | X offset |
| `"PerspectiveY"` | Y offset |
| `"PerspectiveUpright"` | Upright mode |

### calibratePanel -- Camera Calibration

| Parameter | Notes |
|---|---|
| `"ShadowTint"` | Shadow tint |
| `"RedHue"` | Red primary hue |
| `"RedSaturation"` | Red primary saturation |
| `"GreenHue"` | Green primary hue |
| `"GreenSaturation"` | Green primary saturation |
| `"BlueHue"` | Blue primary hue |
| `"BlueSaturation"` | Blue primary saturation |

### Crop Angle (not in a panel)

| Parameter |
|---|
| `"straightenAngle"` |

---

## Localized Adjustment Parameters

Parameters available for localized/masked adjustments vary by Process Version.

### Process Version 2

| Parameter |
|---|
| `"local_ToningLuminance"` |
| `"local_Exposure"` |
| `"local_Contrast"` |
| `"local_Clarity"` |
| `"local_Saturation"` |
| `"local_Sharpness"` |

### Process Version 3

| Parameter |
|---|
| `"local_Temperature"` |
| `"local_Tint"` |
| `"local_Exposure"` |
| `"local_Contrast"` |
| `"local_Highlights"` |
| `"local_Shadows"` |
| `"local_Clarity"` |
| `"local_Saturation"` |
| `"local_Sharpness"` |
| `"local_LuminanceNoise"` |
| `"local_Moire"` |
| `"local_Defringe"` |
| `"local_Blacks"` |
| `"local_Whites"` |
| `"local_Dehaze"` |

### Process Version 4

Same as Process Version 3 (identical parameter set):

| Parameter |
|---|
| `"local_Temperature"` |
| `"local_Tint"` |
| `"local_Exposure"` |
| `"local_Contrast"` |
| `"local_Highlights"` |
| `"local_Shadows"` |
| `"local_Clarity"` |
| `"local_Saturation"` |
| `"local_Sharpness"` |
| `"local_LuminanceNoise"` |
| `"local_Moire"` |
| `"local_Defringe"` |
| `"local_Blacks"` |
| `"local_Whites"` |
| `"local_Dehaze"` |

### Process Version 5 (Current)

Adds 3 parameters vs. Version 3/4:

| Parameter | New in V5? |
|---|---|
| `"local_Temperature"` | |
| `"local_Tint"` | |
| `"local_Exposure"` | |
| `"local_Contrast"` | |
| `"local_Highlights"` | |
| `"local_Shadows"` | |
| `"local_Clarity"` | |
| `"local_Saturation"` | |
| `"local_Sharpness"` | |
| `"local_LuminanceNoise"` | |
| `"local_Moire"` | |
| `"local_Defringe"` | |
| `"local_Blacks"` | |
| `"local_Whites"` | |
| `"local_Dehaze"` | |
| `"local_Texture"` | YES |
| `"local_Hue"` | YES |
| `"local_Amount"` | YES |

---
<!-- END OFFICIAL_DEVELOP_KEYS -->
