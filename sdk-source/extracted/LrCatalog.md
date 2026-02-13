# LrCatalog -- Lightroom SDK 11.4 API Reference

This class provides access to a catalog of photos. Retrieve the object for the active catalog by calling `LrApplication.activeCatalog()`, or from the `catalog` property of many contained objects (export sessions, publish services, keywords, photos, collections, collection sets, published collections, and published collection sets).

---

## Methods

---

### addPhoto
- **Signature:** `catalog:addPhoto(path, stackWithPhoto, position)`
- **Parameters:**
  - path (string) -- The path to the photo on disk.
  - stackWithPhoto (optional, LrPhoto) -- If present, stack the new photo with this existing photo.
  - position (optional, string) -- If stacking, the stacking order for the new photo with respect to the existing photos, `'above'` or `'below'`. Default is `'below'`.
- **Returns:** LrPhoto -- The photo that was added. If the photo cannot be added because the path does not exist or the file's format is not supported, the function throws an error.
- **Since:** 2.0 (`position` parameter since 3.0; in 2.x the new photo is always placed below)
- **Notes:** Must be called from within a `withWriteAccessDo` or `withProlongedWriteAccessDo` gate.

---

### assertHasPrivateWriteAccess
- **Signature:** `catalog:assertHasPrivateWriteAccess(funcName)`
- **Parameters:**
  - funcName (string) -- Name of a function whose value appears in the error message, if any.
- **Returns:** Nothing. If the catalog does not have at least private write access, throws an error.
- **Since:** 2.0
- **Notes:** Use to verify the correct write-access context before performing operations.

---

### assertHasWriteAccess
- **Signature:** `catalog:assertHasWriteAccess(funcName)`
- **Parameters:**
  - funcName (string) -- Name of a function whose value appears in the error message, if any.
- **Returns:** Nothing. If the catalog does not have write access, throws an error.
- **Since:** 2.0
- **Notes:** Use to verify the correct write-access context before performing operations.

---

### batchGetFormattedMetadata
- **Signature:** `catalog:batchGetFormattedMetadata(photos, keys)`
- **Parameters:**
  - photos (array of LrPhoto) -- The photo objects to inspect.
  - keys (array of string) -- The metadata items to retrieve, or nil to get all available metadata fields. See `LrPhoto:getFormattedMetadata` for list of valid keys.
- **Returns:** table -- A table keyed by LrPhoto objects, each mapping to a table of key/value metadata pairs. Example:
  ```lua
  result = {
      [LrPhoto #1] = { fileName = "filename_1.jpg", rating = 3 },
      [LrPhoto #2] = { fileName = "filename_2.jpg", rating = 5 },
  }
  ```
- **Since:** 3.0
- **Notes:** Metadata is formatted as shown in the metadata panel. Do not attempt to parse the returned display strings.

---

### batchGetPropertyForPlugin
- **Signature:** `catalog:batchGetPropertyForPlugin(photos, plugin, fieldIds)`
- **Parameters:**
  - photos (array of LrPhoto) -- The photo objects to inspect.
  - plugin (string or _PLUGIN) -- Your plug-in object or the unique identifying string for the plug-in that declares this field.
  - fieldIds (array of string) -- The metadata items to retrieve.
- **Returns:** table -- A table keyed by LrPhoto objects, each mapping to a table of field/value pairs. Example:
  ```lua
  result = {
      [LrPhoto #1] = { field1 = value1, field2 = value2 },
      [LrPhoto #2] = { field1 = value1, field2 = value2 },
  }
  ```
- **Since:** 3.0

---

### batchGetRawMetadata
- **Signature:** `catalog:batchGetRawMetadata(photos, keys)`
- **Parameters:**
  - photos (array of LrPhoto) -- The photo objects to inspect.
  - keys (array of string) -- The metadata items to retrieve, or nil to get all available metadata fields. See `LrPhoto:getRawMetadata` for list of valid keys.
- **Returns:** table -- A table keyed by LrPhoto objects, each mapping to a table of key/value metadata pairs. Example:
  ```lua
  result = {
      [LrPhoto #1] = { fileName = "filename_1.jpg", rating = 3 },
      [LrPhoto #2] = { fileName = "filename_2.jpg", rating = 5 },
  }
  ```
- **Since:** 3.0

---

### buildSmartPreviews
- **Signature:** `catalog:buildSmartPreviews(photos)`
- **Parameters:**
  - photos (array of LrPhoto) -- The photos for which to build smart previews.
- **Returns:** table of arrays -- A table with sub-arrays indicating the result of the smart preview build attempt. The sub-arrays are `'created'`, `'existed'`, and `'failed'`, and they contain LrPhoto objects corresponding to the photos for which the indicated status is appropriate.
- **Since:** 5.0
- **Notes:** Does nothing for videos. Must be called from within an asynchronous task started using `LrTasks`. Creates a progress bar. May return upon first failure or user cancellation -- not every photo may have been attempted.

---

### createCollection
- **Signature:** `catalog:createCollection(name, parent, canReturnPrior)`
- **Parameters:**
  - name (string) -- The name of the new collection.
  - parent (optional, LrCollectionSet) -- The parent of the new collection, or nil to create at the top level.
  - canReturnPrior (optional, Boolean) -- True to return an existing collection with this name, otherwise return nil if such a collection exists.
- **Returns:** LrCollection -- On success, the new collection object. If a collection with this name already exists, nil or that collection object (depending on `canReturnPrior`).
- **Since:** 3.0
- **Notes:** Must be called from within one of the `with__WriteAccessDo` gates. The new collection is not available for access until that function returns.

---

### createCollectionSet
- **Signature:** `catalog:createCollectionSet(name, parent, canReturnPrior)`
- **Parameters:**
  - name (string) -- The name of the new collection set.
  - parent (optional, LrCollectionSet) -- The parent of the new collection set, or nil to create at the top level.
  - canReturnPrior (optional, Boolean) -- True to return an existing collection set with this name, otherwise return nil if such a collection set exists.
- **Returns:** LrCollectionSet -- On success, the new collection set object. If a collection set with this name already exists, nil or that collection set object (depending on `canReturnPrior`).
- **Since:** 3.0
- **Notes:** Must be called from within one of the `with__WriteAccessDo` gates. The new collection set is not available for access until that function returns.

---

### createKeyword
- **Signature:** `catalog:createKeyword(keywordName, synonyms, includeOnExport, parent, returnExisting)`
- **Parameters:**
  - keywordName (string) -- The name of the keyword.
  - synonyms (table) -- The names of synonyms.
  - includeOnExport (Boolean) -- True to include the keyword when the photo is exported.
  - parent (LrKeyword) -- The parent of the keyword, or nil to create at the top level.
  - returnExisting (Boolean) -- True if an LrKeyword instance is to be returned when a keyword with the specified name and parent already exists.
- **Returns:** LrKeyword -- The new keyword object, or false if a keyword already exists with the same name and parent (when `returnExisting` is not specified or false). If `returnExisting` is true and the keyword exists, that keyword object is returned.
- **Since:** 3.0 (`returnExisting` parameter since 4.0)
- **Notes:** Must be called from within one of the `with__WriteAccessDo` gates. The new keyword is not available for access until that function returns.

---

### createSmartCollection
- **Signature:** `catalog:createSmartCollection(name, searchDesc, parent, canReturnPrior)`
- **Parameters:**
  - name (string) -- The name of the new smart collection.
  - searchDesc (table) -- A search descriptor that defines what metadata fields to search and how to match against a given value. See `LrCatalog:findPhotos()` for details. The default value for the `combine` field is `"intersect"`.
  - parent (optional, LrCollectionSet) -- The parent of the new collection, or nil to create at the top level.
  - canReturnPrior (optional, Boolean) -- True to return an existing collection with this name, otherwise return nil if such a collection exists.
- **Returns:** LrCollection -- On success, the new collection object. If a collection with this name already exists, nil or that collection object (depending on `canReturnPrior`).
- **Since:** 3.0
- **Notes:** Must be called from within one of the `with__WriteAccessDo` gates. The new collection is not available for access until that function returns.

---

### createVirtualCopies
- **Signature:** `catalog:createVirtualCopies(copyName)`
- **Parameters:**
  - copyName (optional, string) -- The name to apply to each of the virtual copies.
- **Returns:** array of LrPhoto -- The new virtual copies.
- **Since:** 5.0
- **Notes:** Creates a virtual copy for each of the currently selected photos and videos. Must be called from within an asynchronous task started using `LrTasks`. After this call, the new virtual copies will be selected.

---

### findPhotoByPath
- **Signature:** `catalog:findPhotoByPath(path, caseSensitivity)`
- **Parameters:**
  - path (string) -- The absolute path to the photo file on disk.
  - caseSensitivity -- (type not specified in documentation)
- **Returns:** LrPhoto -- The corresponding photo object, or nil if no such photo is in the catalog.
- **Since:** 2.0
- **Notes:** Must be called from within an asynchronous task started using `LrTasks`.

---

### findPhotoByUuid
- **Signature:** `catalog:findPhotoByUuid(uuid)`
- **Parameters:**
  - uuid (string) -- The UUID for the photo. (Parameter is named `path` in the HTML but represents a UUID.)
- **Returns:** LrPhoto -- The corresponding photo object, or nil if no such photo is in the catalog.
- **Since:** 2.0
- **Notes:** Must be called from within an asynchronous task started using `LrTasks`. See also: `LrPhoto`.

---

### findPhotos
- **Signature:** `catalog:findPhotos(args)`
- **Parameters:**
  - args (table) -- Arguments in named-argument syntax:
    - **sort** (optional, string) -- How matching photos are sorted. One of `"captureTime"` (default), `"fileName"`, `"extension"`.
    - **ascending** (optional, Boolean) -- True to display photos in ascending order. Default is false.
    - **searchDesc** (table) -- A search descriptor defining what metadata fields to search and how to match. Can contain a single criterion table or combine several via a `combine` entry.
      - **combine** (optional, string) -- One of: `"union"` (any match), `"intersect"` (all match), `"exclude"` (none match). Followed by an array of criterion entries (which can contain nested `combine` entries).
      - Each criterion table has:
        - **criteria** (string) -- The metadata field to search. Valid values include: `"rating"`, `"pick"`, `"labelColor"`, `"labelText"`, `"folder"`, `"collection"`, `"all"`, `"filename"`, `"copyname"`, `"fileFormat"`, `"metadata"`, `"title"`, `"caption"`, `"keywords"`, `"iptc"`, `"exif"`, `"captureTime"`, `"touchTime"`, `"camera"`, `"cameraSN"`, `"lens"`, `"isoSpeedRating"`, `"hasGPSData"`, `"country"`, `"state"`, `"city"`, `"location"`, `"creator"`, `"jobIdentifier"`, `"copyrightState"`, `"hasAdjustments"`, `"developPreset"`, `"treatment"`, `"cropped"`, `"aspectRatio"`, `"allPluginMetadata"`, `sdktext:(pluginID).(fieldName)`, `sdktext:(pluginID).*`
        - **operation** (string) -- How to match. Depends on data type:
          - Strings: `"any"`, `"all"`, `"words"`, `"noneOf"`, `"beginsWith"`, `"endsWith"`, `"empty"`, `"notEmpty"`, `"=="`, `"!="`
          - Booleans: `"isTrue"`, `"isFalse"`
          - Enums: `"=="`, `"!="`
          - Numbers/ratings: `"=="`, `"!="`, `">"`, `"<"`, `">="`, `"<="`, `"in"`
          - Dates: `"=="`, `"!="`, `">"`, `"<"`, `"inLast"`, `"notInLast"`, `"in"`, `"today"`, `"yesterday"`, `"thisWeek"`, `"thisMonth"`, `"thisYear"`
        - **value** -- The value to match against. For dates use `"YYYY-MM-DD"` format.
        - **value2** (optional, number) -- For `operation = "in"`, the end value of the range.
        - **value_units** (optional, string) -- For date fields with `"inLast"` or `"notInLast"`. One of: `"hours"`, `"days"`, `"weeks"`, `"months"`, `"years"`.
- **Returns:** array of LrPhoto -- The photos that match the criteria.
- **Since:** 2.0
- **Notes:** Must be called from within a task started using `LrTasks`. Used internally by the Smart Collections feature. Tip: build a smart collection in the UI, export its settings as `.lrsmcol`, and use the `value =` portion as the argument.

---

### findPhotosWithProperty
- **Signature:** `catalog:findPhotosWithProperty(pluginId, fieldName, optFieldVersion)`
- **Parameters:**
  - pluginId (string) -- The plug-in identifier.
  - fieldName (string) -- The field identifier.
  - optFieldVersion (optional, number) -- The version for the field. Use `0` to reference an old version that was not assigned a version number.
- **Returns:** array of LrPhoto -- The photos that match the criteria.
- **Since:** 2.0
- **Notes:** Must be called from within an asynchronous task started using `LrTasks`.

---

### getActiveSources
- **Signature:** `catalog:getActiveSources()`
- **Parameters:** None.
- **Returns:** table -- Array of the currently viewed objects as `LrCollection`, `LrCollectionSet`, `LrPublishedCollection`, `LrPublishedCollectionSet`, `LrFolder`, or one of the string constants: `kAllPhotos`, `kQuickCollectionIdentifier`, `kPreviousImport`, `kTemporaryImages`, `kLastCatalogExport`.
- **Since:** 3.0

---

### getAllPhotos
- **Signature:** `catalog:getAllPhotos()`
- **Parameters:** None.
- **Returns:** table -- An array of LrPhoto objects.
- **Since:** 3.0
- **Notes:** Must be called from within an asynchronous task started using `LrTasks`. See also: `LrPhoto`.

---

### getChildCollectionSets
- **Signature:** `catalog:getChildCollectionSets()`
- **Parameters:** None.
- **Returns:** array of LrCollectionSet -- The top-level collection set objects. Does not get nested sets.
- **Since:** 3.0
- **Notes:** Must be called from within an asynchronous task started using `LrTasks`.

---

### getChildCollections
- **Signature:** `catalog:getChildCollections()`
- **Parameters:** None.
- **Returns:** array of LrCollection -- The top-level collection objects. Does not go into collection sets.
- **Since:** 3.0
- **Notes:** Must be called from within an asynchronous task started using `LrTasks`.

---

### getCollectionByLocalIdentifier
- **Signature:** `catalog:getCollectionByLocalIdentifier(id)`
- **Parameters:**
  - id (number) -- The unique, local identifier of the collection or collection set. See `LrCollection.localIdentifier`.
- **Returns:** LrCollection or LrCollectionSet -- The collection or collection set object.
- **Since:** 3.0
- **Notes:** Must be called from within an asynchronous task started using `LrTasks`.

---

### getCurrentViewFilter
- **Signature:** `catalog:getCurrentViewFilter()`
- **Parameters:** None.
- **Returns:** Two values:
  1. (table) The current library view filter with these members:
     - **columnBrowserActive** (Boolean) -- True if Metadata filter is active.
     - **filtersActive** (Boolean) -- True if Attribute filter is active.
     - **searchStringActive** (Boolean) -- True if Text filter is active.
     - **label1** (Boolean) -- True if red label filter is active.
     - **label2** (Boolean) -- True if yellow label filter is active.
     - **label3** (Boolean) -- True if green label filter is active.
     - **label4** (Boolean) -- True if blue label filter is active.
     - **label5** (Boolean) -- True if purple label filter is active.
     - **customLabel** (Boolean) -- True if custom filter is active.
     - **nolabel** (Boolean) -- True if "no label" filter is active.
     - **minRating** (number) -- The star value of active rating filter.
     - **ratingOp** (string) -- The active rating comparison operation: `">="`, `"<="`, or `"=="`.
     - **pick** (string) -- Any combination of `"flagged"`, `"rejected"`, `"unflagged"`.
     - **edit** (string) -- Any combination of `"edited"`, `"unedited"`.
     - **whichCopies** (string) -- Any combination of `"masterImages"`, `"virtualCopies"`, `"videos"`.
     - **searchOp** (string) -- One of `"all"`, `"words"`, `"noneof"`, `"beginwith"`, `"endswith"`.
     - **searchString** (string) -- The active search string.
     - **searchTarget** (string) -- One of `"all"`, `"filename"`, `"copyname"`, `"title"`, `"caption"`, `"keyword"`, `"metadata"`, `"iptc"`, `"exif"`, `"allPluginMetadata"`.
     - **columnBrowserDesc** (table) -- The metadata to consider, in format `{ { criteria = metadataName }, ... }`.
  2. (string) The preset's name if the current view filter is a preset, otherwise nil.
- **Since:** 3.0

---

### getFolderByPath
- **Signature:** `catalog:getFolderByPath(path)`
- **Parameters:**
  - path (string) -- The path. You cannot use the short filename in Windows.
- **Returns:** LrFolder -- The folder object.
- **Since:** 3.0
- **Notes:** Must be called from a context in which `LrTasks.yield()` can be called. See also: `LrTasks`.

---

### getFolders
- **Signature:** `catalog:getFolders()`
- **Parameters:** None.
- **Returns:** array of LrFolder -- A table containing the folder objects at the root of the hierarchy.
- **Since:** 3.0

---

### getKeywords
- **Signature:** `catalog:getKeywords()`
- **Parameters:** None.
- **Returns:** array of LrKeyword -- A table containing the keyword objects at the root of the hierarchy.
- **Since:** 3.0
- **Notes:** Must be called from within an asynchronous task started using `LrTasks`.

---

### getKeywordsByLocalId
- **Signature:** `catalog:getKeywordsByLocalId(ids)`
- **Parameters:**
  - ids (table) -- An array of local identifiers for the keywords to retrieve, as obtained via the `localIdentifier` property of an LrKeyword instance.
- **Returns:** array of LrKeyword -- A table containing the keyword objects. An empty table if no keywords matching the supplied identifiers are found.
- **Since:** 4.1
- **Notes:** Must be called from within an asynchronous task started using `LrTasks`.

---

### getLabelMapToColorName
- **Signature:** `catalog:getLabelMapToColorName()`
- **Parameters:** None.
- **Returns:** table -- A table in which each entry maps a color name to a label. Example: `{ red = "Do Not Show", ... }`. Color names are: `red`, `yellow`, `green`, `blue`, `purple`.
- **Since:** 3.0
- **Notes:** Must be called from within an asynchronous task started using `LrTasks`.

---

### getMultipleSelectedOrAllPhotos
- **Signature:** `catalog:getMultipleSelectedOrAllPhotos()`
- **Parameters:** None.
- **Returns:** array of LrPhoto -- All selected photos if more than one is selected, or all visible photos if only one or none is selected.
- **Since:** 3.0
- **Notes:** See also: `LrPhoto`.

---

### getPath
- **Signature:** `catalog:getPath()`
- **Parameters:** None.
- **Returns:** string -- The absolute path of the `.lrcat` file.
- **Since:** 3.0

---

### getPropertyForPlugin
- **Signature:** `catalog:getPropertyForPlugin(plugin, fieldId)`
- **Parameters:**
  - plugin (string or _PLUGIN) -- Your plug-in object or the unique identifying string for the plug-in that declares this field.
  - fieldId (string) -- The unique identifier of the metadata field.
- **Returns:** string -- The value for the field, or nil if no value had been stored by the plug-in.
- **Since:** 3.0

---

### getPublishServices
- **Signature:** `catalog:getPublishServices(pluginId)`
- **Parameters:**
  - pluginId (string) -- Unique identifier of a plug-in, or nil to get all services.
- **Returns:** array of LrPublishService -- The publish service objects.
- **Since:** 3.0
- **Notes:** Must be called from within an asynchronous task started using `LrTasks`.

---

### getPublishedCollectionByLocalIdentifier
- **Signature:** `catalog:getPublishedCollectionByLocalIdentifier(id)`
- **Parameters:**
  - id (number) -- The unique, local identifier of the publish collection or collection set. See `LrPublishedCollection.localIdentifier`.
- **Returns:** LrPublishedCollection or LrPublishedCollectionSet -- The publish collection or collection set object.
- **Since:** 3.0

---

### getTargetPhoto
- **Signature:** `catalog:getTargetPhoto()`
- **Parameters:** None.
- **Returns:** LrPhoto -- The active (most selected) photo object, or nil if none is selected.
- **Since:** 3.0
- **Notes:** See also: `LrPhoto`.

---

### getTargetPhotos
- **Signature:** `catalog:getTargetPhotos()`
- **Parameters:** None.
- **Returns:** array of LrPhoto -- The selected photos, or (if no selection) the entire list of photos in the filmstrip.
- **Since:** 3.0
- **Notes:** See also: `LrPhoto`.

---

### setActiveSources
- **Signature:** `catalog:setActiveSources(sources)`
- **Parameters:**
  - sources (string or array) -- Can be an array of objects or a string identifying a predefined set of photos.
    - If an array, can contain any mix of `LrCollection`, `LrCollectionSet`, `LrPublishedCollection`, `LrPublishedCollectionSet`, or one or more `LrFolder` objects. Do not mix collections with folders.
    - If a string, must be one of: `kAllPhotos`, `kQuickCollectionIdentifier`, `kPreviousImport`, `kTemporaryImages`, `kLastCatalogExport`, `kTargetCollection`.
- **Returns:** Boolean -- True on success, false if the sources are not correctly specified.
- **Since:** 3.0

---

### setPropertyForPlugin
- **Signature:** `catalog:setPropertyForPlugin(plugin, fieldId, value)`
- **Parameters:**
  - plugin (_PLUGIN) -- Your plug-in object.
  - fieldId (string) -- The unique identifier of the metadata field.
  - value (nil, number, string, or Boolean) -- The new value for this field. Cannot be a table or function value.
- **Returns:** Nothing.
- **Since:** 3.0
- **Notes:** Must be called from within one of the `with___WriteAccessDo` gates. Unlike custom metadata fields for photos, catalog-wide fields need not be declared anywhere.

---

### setSelectedPhotos
- **Signature:** `catalog:setSelectedPhotos(activePhoto, otherSelectedPhotos)`
- **Parameters:**
  - activePhoto (LrPhoto) -- The active photo; if multiple photos are selected, this is the brightest, "most selected" one.
  - otherSelectedPhotos (table of LrPhoto) -- Additional photos to select.
- **Returns:** Nothing.
- **Since:** 3.0

---

### setViewFilter
- **Signature:** `catalog:setViewFilter(filter)`
- **Parameters:**
  - filter (string or table) -- A view filter preset or a set of filter values:
    - (string) The unique identifying string of a view filter preset. See `LrApplication:viewFilterPresets`.
    - (table) The view filter values in a table, as returned by `LrCatalog:getCurrentViewFilter`.
- **Returns:** Boolean -- True if the filter was changed, false if it was already set as specified, or nil if the given filter preset could not be found.
- **Since:** 3.0

---

### triggerImportFromPathWithPreviousSettings
- **Signature:** `catalog:triggerImportFromPathWithPreviousSettings(path)`
- **Parameters:**
  - path (string) -- The path to a directory from which to import images.
- **Returns:** Nothing.
- **Since:** 4.0
- **Notes:** Triggers an import bypassing the import dialog, using the settings from the most recent import.

---

### triggerImportUI
- **Signature:** `catalog:triggerImportUI(path)`
- **Parameters:**
  - path (optional, string) -- The path to a directory which will be selected as the initial source in the import dialog.
- **Returns:** Nothing.
- **Since:** 4.0
- **Notes:** Triggers an import via the import dialog.

---

### type
- **Signature:** `catalog:type()`
- **Parameters:** None.
- **Returns:** string -- `'LrCatalog'`.
- **Since:** 4.1

---

### withPrivateWriteAccessDo
- **Signature:** `catalog:withPrivateWriteAccessDo(func, timeoutParams)`
- **Parameters:**
  - func (function) -- The function to call with catalog access. Receives a function context as of SDK 3.0.
  - timeoutParams (optional, table) -- A table containing:
    - **timeout** (number, required) -- Seconds to wait for write access before giving up.
    - **callback** (optional, function) -- Called if the timeout expires and write access is abandoned.
    - **asynchronous** (optional, Boolean) -- If true, returns immediately upon queueing the task. Default is false (returns on completion).
- **Returns:** string -- One of `"executed"`, `"queued"`, or `"aborted"`.
  - `"executed"` -- `func` was executed; `callback` was ignored.
  - `"queued"` -- `func` will execute within `timeout` seconds or `callback` will execute.
  - `"aborted"` -- `func` was ignored; `callback` was executed.
- **Since:** 2.0 (timeoutParams and return value since 4.0)
- **Notes:** Use this instead of `withWriteAccessDo()` if you are only modifying metadata for your plug-in and do not want to add the operation to the undo stack. Only `LrPhoto:setPropertyForPlugin()` and a handful of other calls requiring write access can be called via this gate. As of SDK 3.0, you can call `LrTasks.yield()` from within, and must call from a context where `LrTasks.yield()` can be called. If `timeoutParams` is not provided and write access cannot be immediately obtained, an error is thrown. See also: `LrFunctionContext`, `LrTasks`.

---

### withProlongedWriteAccessDo
- **Signature:** `catalog:withProlongedWriteAccessDo(params, timeoutParams)`
- **Parameters:**
  - params (table) -- Arguments in named-argument syntax:
    - **title** (string) -- Title of the modal progress dialog. Cannot be changed once the operation begins.
    - **caption** (optional, string) -- Subtitle for the current task. Can be changed while the operation is in progress.
    - **pluginName** (string) -- The name of your plug-in, used in the warning message.
    - **optionalMessage** (optional, string) -- An extra message to accompany Lightroom's warning about clearing the undo stack.
    - **func** (function) -- The function that will perform database changes. Receives two parameters: a function context and a progress scope.
  - timeoutParams (optional, table) -- A table containing:
    - **timeout** (number, required) -- Seconds to wait for write access before giving up.
    - **callback** (optional, function) -- Called if the timeout expires and write access is abandoned.
    - **asynchronous** (optional, Boolean) -- If true, returns immediately upon queueing the task. Default is false.
- **Returns:** Two values:
  1. (Boolean) True if user clicked "Proceed"; false if user clicked "Cancel".
  2. (string, only if `timeoutParams` specified) One of `"executed"`, `"queued"`, or `"aborted"`.
     - `"executed"` -- `func` was executed; `callback` was ignored.
     - `"queued"` -- `func` will execute within `timeout` seconds or `callback` will execute.
     - `"aborted"` -- `func` was ignored; `callback` was executed.
- **Since:** 2.0 (timeoutParams and second return value since 4.0)
- **Notes:** Shows a warning dialog to the user at the beginning of the operation. If the user clicks "Proceed", a modal progress dialog is created and all other portions of the Lightroom UI are blocked until the task completes. Call `LrTasks.yield()` periodically within the task to allow UI updates. As of Lightroom 3.0, this no longer clears the undo stack. If `timeoutParams` is not provided and write access cannot be immediately obtained, an error is thrown. The warning dialog appears as soon as the call is queued, not when execution begins. See also: `LrFunctionContext`, `LrProgressScope`, `LrTasks`, `LrDialogs.showModalProgressDialog`.

---

### withWriteAccessDo
- **Signature:** `catalog:withWriteAccessDo(actionName, func, timeoutParams)`
- **Parameters:**
  - actionName (string) -- The display name for this operation, used in Lightroom's Undo/Redo menu.
  - func (function) -- The function to call with catalog access. Receives a function context as of SDK 3.0.
  - timeoutParams (optional, table) -- A table containing:
    - **timeout** (number, required) -- Seconds to wait for write access before giving up.
    - **callback** (optional, function) -- Called if the timeout expires and write access is abandoned.
    - **asynchronous** (optional, Boolean) -- If true, returns immediately upon queueing the task. Default is false.
- **Returns:** string -- One of `"executed"`, `"queued"`, or `"aborted"`.
  - `"executed"` -- `func` was executed; `callback` was ignored.
  - `"queued"` -- `func` will execute within `timeout` seconds or `callback` will execute.
  - `"aborted"` -- `func` was ignored; `callback` was executed.
- **Since:** 2.0 (timeoutParams and return value since 4.0)
- **Notes:** Do not call recursively. If an error is thrown during the function, any changes made to the database are rolled back. As of SDK 3.0, the callback receives a function context. You can call `LrTasks.yield()` from within, and must call from a context where `LrTasks.yield()` can be called. Changes are written to the database upon successful completion of the callback (not immediately). If you create a new item (e.g. via `createCollection()`), you generally cannot retrieve information about it until `with___AccessDo` has finished. On Mac OS, multiple successive calls without intervening user interaction are coalesced into a single undoable event using the name of the last one. If `timeoutParams` is not provided and write access cannot be immediately obtained, an error is thrown.

---

## Properties

---

### catalog.hasPrivateWriteAccess
- **Type:** Read-Only
- **Value:** Boolean -- True if execution is currently inside the `withPrivateWriteAccessDo()` or `withWriteAccessDo()` call.
- **Since:** 2.0
- **Notes:** Use in your catalog-manipulation function to determine if it is being called with the correct context.

---

### catalog.hasWriteAccess
- **Type:** Read-Only
- **Value:** Boolean -- True if execution is currently inside the `withWriteAccessDo()` call.
- **Since:** 2.0
- **Notes:** Use in your catalog-manipulation function to determine if it is being called with the correct context.

---

### catalog.kAllPhotos
- **Type:** Read-Only
- **Value:** string -- The "All Photographs" collection in the "Catalog" section of the library left-side panel.
- **Since:** 3.0
- **Notes:** See `LrCatalog:setActiveSources()`.

---

### catalog.kLastCatalogExport
- **Type:** Read-Only
- **Value:** string -- The "Last catalog export" collection in the "Catalog" section of the library left-side panel.
- **Since:** 3.0
- **Notes:** See `LrCatalog:setActiveSources()`.

---

### catalog.kPreviousImport
- **Type:** Read-Only
- **Value:** string -- The "Previous import" collection in the "Catalog" section of the library left-side panel.
- **Since:** 3.0
- **Notes:** See `LrCatalog:setActiveSources()`.

---

### catalog.kQuickCollectionIdentifier
- **Type:** Read-Only
- **Value:** string -- The "Quick collection" collection in the "Catalog" section of the library left-side panel.
- **Since:** 3.0
- **Notes:** See `LrCatalog:setActiveSources()`.

---

### catalog.kTargetCollection
- **Type:** Read-Only
- **Value:** string -- The collection currently set as the target for adding operations.
- **Since:** 3.0
- **Notes:** See `LrCatalog:setActiveSources()`.

---

### catalog.kTemporaryImages
- **Type:** Read-Only
- **Value:** string -- The "Temporary Images" collection, which might be named "Photos That Failed to Export" or "Missing Photographs".
- **Since:** 3.0
- **Notes:** See `LrCatalog:setActiveSources()`.

---

## Summary Count

- **Methods:** 37
- **Properties:** 8 (2 state properties + 6 constants)
