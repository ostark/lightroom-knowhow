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
