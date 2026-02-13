# Lightroom Classic SDK 11.4 -- Class API Reference

Extracted from the official Adobe Lightroom Classic SDK 11.4 API Reference HTML documentation. This document covers 12 class types used in plugin development: collections, publishing, export pipeline, keywords, folders, and progress reporting.

---

## Table of Contents

- [LrCollection](#lrcollection)
- [LrCollectionSet](#lrcollectionset)
- [LrPublishedCollection](#lrpublishedcollection)
- [LrPublishedCollectionSet](#lrpublishedcollectionset)
- [LrPublishedPhoto](#lrpublishedphoto)
- [LrPublishService](#lrpublishservice)
- [LrExportSession](#lrexportsession)
- [LrExportContext](#lrexportcontext)
- [LrExportRendition](#lrexportrendition)
- [LrKeyword](#lrkeyword)
- [LrFolder](#lrfolder)
- [LrProgressScope](#lrprogressscope)

---

## LrCollection

Provides access to a photo collection and to its member photos.

Retrieve collection objects by calling `LrCatalog:getCollections()`. To retrieve collections contained in collection sets, use `LrCollectionSet:getChildCollections()`. Create a new collection with `LrCatalog:createCollection()` (must be called from within a `with___WriteAccessDo` gate).

### Properties

| Property | Type | Access | Description | Since |
|---|---|---|---|---|
| `collection.catalog` | `LrCatalog` | Read-Only | The catalog object that contains this collection. | 3.0 |
| `collection.localIdentifier` | number | Read-Only | The local identifier of the collection, unique within this catalog. | 3.0 |

### Methods

#### `collection:addPhotos( photos )`

Adds photos to this collection, if it is not a smart collection. Throws an exception if this is a smart collection.

Must be called from within a `catalog:with___WriteAccessDo` gate. Can be used within the same gate that created this collection.

**Parameters:**
- `photos` (array of `LrPhoto`) -- The photo objects.

**Returns:** Nothing.

**Since:** 3.0

---

#### `collection:delete()`

Removes this collection from the containing catalog.

Must be called from within a `catalog:with___WriteAccessDo` gate.

**Parameters:** None.

**Returns:** Nothing.

**Since:** 3.0

---

#### `collection:getName()`

Retrieves the current name of this collection.

Must be called from within an asynchronous task started using `LrTasks`.

**Parameters:** None.

**Returns:** (string) The name.

**Since:** 3.0

---

#### `collection:getParent()`

Retrieves the parent collection set, if any, that contains this collection.

Must be called from within an asynchronous task started using `LrTasks`.

**Parameters:** None.

**Returns:** (`LrCollectionSet`) The parent set object or nil.

**Since:** 3.0

---

#### `collection:getPhotos()`

Retrieves all of the photos in this collection.

Must be called from within an asynchronous task started using `LrTasks`.

**Parameters:** None.

**Returns:** (array of `LrPhoto`) An array of photo objects.

**Since:** 3.0

---

#### `collection:getSearchDescription()`

Retrieves the search description for a smart collection. Throws an exception if this is not a smart collection.

Must be called from within an asynchronous task started using `LrTasks`. See `LrCatalog:findPhotos` for details on what a search description looks like.

**Parameters:** None.

**Returns:** (table) Table containing the search description.

**Since:** 5.0

---

#### `collection:isSmartCollection()`

Reports whether this collection is a smart collection.

Must be called from within an asynchronous task started using `LrTasks`.

**Parameters:** None.

**Returns:** (Boolean) True if this is a smart collection.

**Since:** 3.0

---

#### `collection:removeAllPhotos()`

Removes all photos from this collection if it is not a smart collection. Throws an exception if this is a smart collection.

Must be called from within a `catalog:with___WriteAccessDo` gate.

**Parameters:** None.

**Returns:** Nothing.

**Since:** 3.0

---

#### `collection:removePhotos( photos )`

Removes photos from this collection if it is not a smart collection. Throws an exception if this is a smart collection.

Must be called from within a `catalog:with___WriteAccessDo` gate.

**Parameters:**
- `photos` (array of `LrPhoto`) -- The photo objects.

**Returns:** Nothing.

**Since:** 3.0

---

#### `collection:setName( name )`

Sets a new name for this collection.

Must be called from within a `catalog:with___WriteAccessDo` gate.

**Parameters:**
- `name` (string) -- The new name.

**Returns:** True on success, false if there is already a collection or collection set with the same name and parent.

**Since:** 3.0

---

#### `collection:setParent( parent )`

Sets a new parent for this collection.

Must be called from within a `catalog:with___WriteAccessDo` gate.

**Parameters:**
- `parent` (`LrCollectionSet`) -- The new parent collection set, or nil to make this a top-level collection.

**Returns:** Nothing.

**Since:** 3.0

---

#### `collection:setSearchDescription( searchDesc )`

Sets the search description for a smart collection. Throws an exception if this is not a smart collection.

Must be called from within a `catalog:with___WriteAccessDo` gate.

**Parameters:**
- `searchDesc` (table) -- A search descriptor that defines what metadata fields to search, and how to match against a given value. See `LrCatalog:findPhotos` for details.

**Returns:** Nothing.

**Since:** 3.0

---

#### `collection:type()`

Reports the type of this object.

**Parameters:** None.

**Returns:** (string) `'LrCollection'`.

**Since:** 3.0

---

## LrCollectionSet

Provides access to a photo collection set, and to the member collections and nested sets. Collection sets can be nested; they can contain both collections and other collection sets.

Retrieve top-level sets by calling `LrCatalog:getChildCollectionSets()`. To get immediate child sets, use `getChildCollectionSets()`. Create a new set with `LrCatalog:createCollectionSet()` (must be called from within a `with___WriteAccessDo` gate).

### Properties

| Property | Type | Access | Description | Since |
|---|---|---|---|---|
| `collectionSet.catalog` | `LrCatalog` | Read-Only | The catalog object that contains this collection set. | 3.0 |
| `collectionSet.localIdentifier` | number | Read-Only | The local identifier of this collection set. Must not be called from within the same `with___WriteAccessDo` gate that created this set. | 3.0 |

### Methods

#### `collectionSet:delete()`

Removes this collection set from the catalog.

Must be called from within a `catalog:with___WriteAccessDo` gate.

**Parameters:** None.

**Returns:** Nothing.

**Since:** 3.0

---

#### `collectionSet:getChildCollectionSets()`

Retrieves the collection sets that are immediate children of this set, if any. Does not go into nested sets.

Must be called from within an asynchronous task started using `LrTasks`.

**Parameters:** None.

**Returns:** (array of `LrCollectionSet`) The collection set objects, or an empty array.

**Since:** 3.0

---

#### `collectionSet:getChildCollections()`

Retrieves the collections that are immediate children of this set. Does not go into nested sets.

Must be called from within an asynchronous task started using `LrTasks`.

**Parameters:** None.

**Returns:** (array of `LrCollection`) The collection objects.

**Since:** 3.0

---

#### `collectionSet:getChildren()`

Retrieves all immediate members of this set, both collections and collection sets.

Must be called from within an asynchronous task started using `LrTasks`.

**Parameters:** None.

**Returns:** (array of `LrCollection` and `LrCollectionSet`) The collection and set objects.

**Since:** 3.0

---

#### `collectionSet:getName()`

Retrieves the current name of this set.

Must be called from within an asynchronous task started using `LrTasks`.

**Parameters:** None.

**Returns:** (string) The name.

**Since:** 3.0

---

#### `collectionSet:getParent()`

Retrieves the parent set, if any, of this collection set.

Must be called from within an asynchronous task started using `LrTasks`.

**Parameters:** None.

**Returns:** (`LrCollectionSet`) The parent set, or nil.

**Since:** 3.0

---

#### `collectionSet:setName( name )`

Sets a new name for this collection set.

Must be called from within a `catalog:with___WriteAccessDo` gate.

**Parameters:**
- `name` (string) -- The new name.

**Returns:** True on success, false if there is already a collection or collection set with the same name and parent.

**Since:** 3.0

---

#### `collectionSet:setParent( parent )`

Sets a new parent for the collection set.

Must be called from within a `catalog:with___WriteAccessDo` gate.

**Parameters:**
- `parent` (`LrCollectionSet`) -- The new parent set, or nil to make this a top-level collection set.

**Returns:** Nothing.

**Since:** 3.0

---

#### `collectionSet:type()`

Reports the type of this object.

**Parameters:** None.

**Returns:** (string) `'LrCollectionSet'`.

**Since:** 3.0

---

## LrPublishedCollection

Provides access to a published-photo collection and to its member photos and their publishing status.

Retrieve published collections by calling `LrCatalog:getPublishedCollections()`. For a particular publish service, retrieve immediate child collections with `LrPublishService:getChildCollections()`. For collections in sets, use `LrPublishedCollectionSet:getChildCollections()`. Create a new published collection with `LrCatalog:createPublishedCollection()`.

### Properties

| Property | Type | Access | Description | Since |
|---|---|---|---|---|
| `pubCollection.catalog` | `LrCatalog` | Read-Only | The catalog object that contains this collection. | 3.0 |
| `pubCollection.localIdentifier` | number | Read-Only | The local identifier of the published collection, unique within the catalog. Must not be called from within the same `with___WriteAccessDo` gate that created this collection. | 3.0 |

### Methods

#### `pubCollection:addPhotoByRemoteId( photo, remoteID, remoteUrl, published )`

Adds a photo with a remote ID and URL to this collection, if it is not a smart collection. If the photo exists in the collection, replaces the old remote ID and URL with the new values. Throws an exception if this is a smart collection and the photo is not already included. (For a smart collection, a reason to call this would be to update the published status of a photo.)

Must be called from within a `catalog:with___WriteAccessDo` gate.

**Parameters:**
- `photo` (`LrPhoto`) -- The photo object.
- `remoteID` (string or number) -- The new remote unique identifier.
- `remoteUrl` (string) -- The new URL, or nil.
- `published` (Boolean) -- True to mark the photo as "already published", false to mark as "need to publish".

**Returns:** Nothing.

**Since:** 3.0

---

#### `pubCollection:addPhotos( photos )`

Adds photos to this collection, if it is not a smart collection. Throws an exception if this is a smart collection.

Must be called from within a `catalog:with___WriteAccessDo` gate.

**Parameters:**
- `photos` (array of `LrPhoto`) -- The photo objects.

**Returns:** Nothing.

**Since:** 3.0

---

#### `pubCollection:addPublishedPhotos( publishedPhotos )`

Adds a set of published photos, along with their publication data, to this collection, if it is not a smart collection. Throws an exception if this is a smart collection.

Must be called from within a `catalog:with___WriteAccessDo` gate.

**Parameters:**
- `publishedPhotos` (array of `LrPublishedPhoto`) -- The publication-data objects. These point to the photo objects to be added.

**Returns:** Nothing.

**Since:** 3.0

---

#### `pubCollection:delete()`

Removes this collection from the containing catalog.

Must be called from within a `catalog:with___WriteAccessDo` gate.

**Parameters:** None.

**Returns:** Nothing.

**Since:** 3.0

---

#### `pubCollection:getCollectionInfoSummary()`

Retrieves an information summary about this published collection.

Must be called from within an asynchronous task started using `LrTasks`.

**Parameters:** None.

**Returns:** (table) A table with the following fields:
- **name**: Name of the published collection.
- **localIdentifier**: Internal ID number of the collection (the local identifier).
- **remoteId**: The ID of the collection on the remote service.
- **remoteUrl**: URL of the collection (if applicable) as published.
- **isDefaultCollection**: (Boolean) True if this is the default collection.
- **parents**: (array of tables) Information about any published collection sets that contain this collection. Each table contains `name`, `localCollectionId`, `remoteCollectionId`, and `publishedUrl`.
- **collectionSettings**: (table) Any collection-specific settings stored by the plug-in.
- **publishSettings**: (table) Publish settings for this plug-in.

**Since:** 3.0

---

#### `pubCollection:getName()`

Retrieves the current name of this collection.

Must be called from within an asynchronous task started using `LrTasks`. Must not be called from within the same `with___WriteAccessDo` gate that created this collection.

**Parameters:** None.

**Returns:** (string) The name.

**Since:** 3.0

---

#### `pubCollection:getParent()`

Retrieves the parent collection set, if any, that contains this collection.

Must be called from within an asynchronous task started using `LrTasks`. Must not be called from within the same `with___WriteAccessDo` gate that created this collection.

**Parameters:** None.

**Returns:** (`LrPublishedCollectionSet`) The parent set object or nil.

**Since:** 3.0

---

#### `pubCollection:getPhotos()`

Retrieves all of the photos in this collection.

Must be called from within an asynchronous task started using `LrTasks`. Must not be called from within the same `with___WriteAccessDo` gate that created this collection.

**Parameters:** None.

**Returns:** (array of `LrPhoto`) An array of photo objects.

**Since:** 3.0

---

#### `pubCollection:getPublishedPhotos()`

Retrieves the publication data for photos in this collection.

Must be called from within an asynchronous task started using `LrTasks`.

**Parameters:** None.

**Returns:** (array of `LrPublishedPhoto`) An array of publication-data objects.

**Since:** 3.0

---

#### `pubCollection:getRemoteId()`

Retrieves the remote service's unique identifier for this published collection, as previously recorded by the plug-in.

Must be called from within an asynchronous task started using `LrTasks`.

**Parameters:** None.

**Returns:** (string or number) The remote ID.

**Since:** 3.0

---

#### `pubCollection:getRemoteUrl()`

Retrieves the URL for this published collection, as assigned by the remote service and previously recorded by the plug-in.

Must be called from within an asynchronous task started using `LrTasks`.

**Parameters:** None.

**Returns:** (string or number) The remote URL.

**Since:** 3.0

---

#### `pubCollection:getSearchDescription()`

Retrieves the search description for a smart collection. Throws an exception if this is not a smart collection.

See `LrCatalog:findPhotos` for details on what a search description looks like.

**Parameters:** None.

**Returns:** (table) Table containing the search description.

**Since:** 5.0

---

#### `pubCollection:getService()`

Retrieves the service that this collection belongs to.

Must be called from within an asynchronous task started using `LrTasks`.

**Parameters:** None.

**Returns:** (`LrPublishService`) The parent publish service object.

**Since:** 3.0

---

#### `pubCollection:isSmartCollection()`

Reports whether this collection is a smart collection.

Must be called from within an asynchronous task started using `LrTasks`. Must not be called from within the same `with___WriteAccessDo` gate that created this collection.

**Parameters:** None.

**Returns:** (Boolean) True if this is a smart collection.

**Since:** 3.0

---

#### `pubCollection:publishNow( doneCallback )`

Initiates a publish operation for this collection. It is strongly recommended that plug-ins make any auto-publishing behavior opt-in via the Lightroom Publishing Manager.

**Parameters:**
- `doneCallback` (function, optional) -- A function which will be called when the publish operation has been completed.

**Returns:** Nothing.

**Since:** 4.0

---

#### `pubCollection:removeAllPhotos()`

Removes all photos from this collection if it is not a smart collection. Throws an exception if this is a smart collection.

Must be called from within a `catalog:with___WriteAccessDo` gate.

**Parameters:** None.

**Returns:** Nothing.

**Since:** 3.0

---

#### `pubCollection:removePhotos( photos )`

Removes photos from this collection if it is not a smart collection. Throws an exception if this is a smart collection.

Must be called from within a `catalog:with___WriteAccessDo` gate.

**Parameters:**
- `photos` (array of `LrPhoto`) -- The photo objects.

**Returns:** Nothing.

**Since:** 3.0

---

#### `pubCollection:setCollectionSettings( settings )`

Sets the plug-in-specific settings for this published collection. This is the same block of data that can be edited via the user interface if your plug-in implements the `viewForCollectionSettings` hook.

Must be called from within a `catalog:with___WriteAccessDo` gate.

**Parameters:**
- `settings` (table) -- The table of settings; contents are defined by the plug-in.

**Returns:** Nothing.

**Since:** 3.0

---

#### `pubCollection:setName( name )`

Sets a new name for this published collection.

Must be called from within a `catalog:with___WriteAccessDo` gate.

**Parameters:**
- `name` (string) -- The new name.

**Returns:** True on success, false if there is already a published collection or collection set with the same name and parent.

**Since:** 3.0

---

#### `pubCollection:setParent( parent )`

Sets a new parent for this published collection. This function does not enforce any restrictions on collection-set depth, nor does it call the plug-in's `reparentPublishedCollection` callback. The plug-in is responsible for ensuring synchronization with the publication site.

It is an error to set a parent that belongs to a different `LrPublishService`, or even to a different publish-service connection.

Must be called from within a `catalog:with___WriteAccessDo` gate.

**Parameters:**
- `parent` (`LrPublishedCollectionSet`) -- The new parent set in the same `LrPublishService`, or nil to make this an immediate child of the service that contains it.

**Returns:** Nothing.

**Since:** 3.0

---

#### `pubCollection:setRemoteId( remoteId )`

Sets the unique identifier for this published collection as understood by the remote service.

Must be called from within a `catalog:with___WriteAccessDo` gate.

**Parameters:**
- `remoteId` (string or number) -- The new remote ID.

**Returns:** Nothing.

**Since:** 3.0

---

#### `pubCollection:setRemoteUrl( url )`

Sets the URL for this published collection, as provided by the remote service. It is not required to have a URL on record with Lightroom. If one is provided, it is displayed in the publish header in the Library grid and used to enable the "Go to Published Collection" command in the collection context menu.

Must be called from within a `catalog:with___WriteAccessDo` gate.

**Parameters:**
- `url` (string) -- The URL.

**Returns:** Nothing.

**Since:** 3.0

---

#### `pubCollection:setSearchDescription( searchDesc )`

Sets the search description for this smart collection. Throws an exception if this is not a smart collection.

Must be called from within a `catalog:with___WriteAccessDo` gate.

**Parameters:**
- `searchDesc` (table) -- A search descriptor that defines what metadata fields to search, and how to match against a given value. See `LrCatalog:findPhotos` for details.

**Returns:** Nothing.

**Since:** 3.0

---

#### `pubCollection:type()`

Reports the type of this object.

**Parameters:** None.

**Returns:** (string) `'LrPublishedCollection'`.

**Since:** 3.0

---

## LrPublishedCollectionSet

Provides access to a set of published-photo collections, and to the member collections and nested sets. Collection sets can be nested; they can contain both collections and other collection sets.

Retrieve top-level sets by calling `LrCatalog:getPublishedCollectionSets()`. For a particular publish service, use `LrPublishService:getChildCollectionSets()`. Create a new set with `LrCatalog:createPublishedCollectionSet()`.

### Properties

| Property | Type | Access | Description | Since |
|---|---|---|---|---|
| `pubCollectionSet.catalog` | `LrCatalog` | Read-Only | The catalog object that contains this published-collection set. | 3.0 |
| `pubCollectionSet.localIdentifier` | number | Read-Only | The local identifier of the published collection set, unique within the catalog. Must not be called from within the same `with___WriteAccessDo` gate that created this set. | 3.0 |

### Methods

#### `pubCollectionSet:delete()`

Removes this published-collection set from the catalog.

Must be called from within a `catalog:with___WriteAccessDo` gate.

**Parameters:** None.

**Returns:** Nothing.

**Since:** 3.0

---

#### `pubCollectionSet:getChildCollectionSets()`

Retrieves the published collection sets that are immediate children of this set, if any.

Must be called from within an asynchronous task started using `LrTasks`.

**Parameters:** None.

**Returns:** (array of `LrPublishedCollectionSet`) The published-collection set objects, or an empty array.

**Since:** 3.0

---

#### `pubCollectionSet:getChildCollections()`

Retrieves the published collections that are immediate children of this set. Does not go into nested sets.

Must be called from within an asynchronous task started using `LrTasks`.

**Parameters:** None.

**Returns:** (array of `LrPublishedCollection`) The published-collection objects.

**Since:** 3.0

---

#### `pubCollectionSet:getChildren()`

Retrieves all immediate members of this set, both published collections and collection sets.

Must be called from within an asynchronous task started using `LrTasks`.

**Parameters:** None.

**Returns:** (array of `LrPublishedCollection` and `LrPublishedCollectionSet`) The collection and set objects.

**Since:** 3.0

---

#### `pubCollectionSet:getCollectionSetInfoSummary()`

Retrieves an information summary about this published collection set.

Must be called from within an asynchronous task started using `LrTasks`.

**Parameters:** None.

**Returns:** (table) A table with the following fields:
- **name**: Name of the published collection set.
- **localIdentifier**: Internal ID number of the collection set (the local identifier).
- **remoteId**: The ID of the collection set on the remote service.
- **remoteUrl**: URL of the collection set (if applicable) as published.
- **isDefaultCollection**: (Boolean) True if this is the default collection.
- **parents**: (array of tables) Information about any published collection sets that contain this set. Each table contains `name`, `localCollectionId`, `remoteCollectionId`, and `publishedUrl`.
- **collectionSettings**: (table) Any collection-specific settings stored by the plug-in.
- **publishSettings**: (table) Publish settings for this plug-in.

**Since:** 3.0

---

#### `pubCollectionSet:getName()`

Retrieves the current name of this set.

Must be called from within an asynchronous task started using `LrTasks`.

**Parameters:** None.

**Returns:** (string) The name.

**Since:** 3.0

---

#### `pubCollectionSet:getParent()`

Retrieves the parent set, if any, of this published-collection set.

Must be called from within an asynchronous task started using `LrTasks`.

**Parameters:** None.

**Returns:** (`LrPublishedCollectionSet`) The parent set, or nil.

**Since:** 3.0

---

#### `pubCollectionSet:getRemoteId()`

Retrieves the remote service's unique identifier for this published collection set, as previously recorded by the plug-in.

Must be called from within an asynchronous task started using `LrTasks`.

**Parameters:** None.

**Returns:** (string or number) The remote ID.

**Since:** 3.0

---

#### `pubCollectionSet:getRemoteUrl()`

Retrieves the URL for this published collection set, as assigned by the remote service and previously recorded by the plug-in.

Must be called from within an asynchronous task started using `LrTasks`.

**Parameters:** None.

**Returns:** (string or number) The remote URL.

**Since:** 3.0

---

#### `pubCollectionSet:getService()`

Retrieves the publish service that this set belongs to.

Must be called from within an asynchronous task started using `LrTasks`.

**Parameters:** None.

**Returns:** (`LrPublishService`) The publish-service object.

**Since:** 3.0

---

#### `pubCollectionSet:setCollectionSetSettings( settings )`

Sets the plug-in-specific settings for this published collection set. This is the same block of data that can be edited via the user interface if your plug-in implements the `viewForCollectionSetSettings` hook.

Must be called from within a `catalog:with___WriteAccessDo` gate.

**Parameters:**
- `settings` (table) -- The table of settings; contents are defined by the plug-in.

**Returns:** Nothing.

**Since:** 3.0

---

#### `pubCollectionSet:setName( name )`

Sets a new name for this published collection set.

Must be called from within a `catalog:with___WriteAccessDo` gate.

**Parameters:**
- `name` (string) -- The new name.

**Returns:** True on success, false if there is already a published collection or collection set with the same name and parent.

**Since:** 3.0

---

#### `pubCollectionSet:setParent( parent )`

Sets a new parent for this published collection set. This function does not enforce any restrictions on collection-set depth, nor does it call the plug-in's `reparentPublishedCollection` callback. The plug-in is responsible for ensuring synchronization with the publication site.

It is an error to set a parent that belongs to a different `LrPublishService`, or even to a different publish-service connection.

Must be called from within a `catalog:with___WriteAccessDo` gate.

**Parameters:**
- `parent` (`LrPublishedCollectionSet`) -- The new parent set in the same `LrPublishService`, or nil to make this an immediate child of the service that contains it.

**Returns:** Nothing.

**Since:** 3.0

---

#### `pubCollectionSet:setRemoteId( remoteId )`

Sets the unique identifier for this published collection set as understood by the remote service.

Must be called from within a `catalog:with___WriteAccessDo` gate.

**Parameters:**
- `remoteId` (string or number) -- The new remote ID.

**Returns:** Nothing.

**Since:** 3.0

---

#### `pubCollectionSet:setRemoteUrl( url )`

Sets the URL for this published collection set, as provided by the remote service. It is not required to have a URL on record with Lightroom. If one is provided, it is displayed in the publish header in the Library grid and used to enable the "Go to Published Collection Set" command in the collection context menu.

Must be called from within a `catalog:with___WriteAccessDo` gate.

**Parameters:**
- `url` (string) -- The URL.

**Returns:** Nothing.

**Since:** 3.0

---

#### `pubCollectionSet:type()`

Reports the type of this object.

**Parameters:** None.

**Returns:** (string) `'LrPublishedCollectionSet'`.

**Since:** 3.0

---

## LrPublishedPhoto

Represents the publishing information associated with a photo that is part of a published collection.

Retrieve published photo objects by calling `LrPublishedCollection:getPublishedPhotos()`.

### Properties

| Property | Type | Access | Description | Since |
|---|---|---|---|---|
| `publishedPhoto.catalog` | `LrCatalog` | Read-Only | The catalog object that contains this publishing-data object and the associated photo. | 3.0 |

### Methods

#### `publishedPhoto:getEditedFlag()`

Reports whether the associated photo has been edited since last published.

**Parameters:** None.

**Returns:** (Boolean) True if edited since last published.

**Since:** 3.0

---

#### `publishedPhoto:getPhoto()`

Retrieves the photo associated with this publishing data.

**Parameters:** None.

**Returns:** (`LrPhoto`) The photo object.

**Since:** 3.0

---

#### `publishedPhoto:getPublishCount()`

Reports the number of times the associated photo has been published by a publish service.

**Parameters:** None.

**Returns:** (number) The publish count.

**Since:** 3.0

---

#### `publishedPhoto:getRemoteId()`

Retrieves the unique identifier for the associated photo, as assigned by the remote service.

**Parameters:** None.

**Returns:** (string or number) The remote ID.

**Since:** 3.0

---

#### `publishedPhoto:getRemoteUrl()`

Retrieves the URL for the associated photo, assigned by the remote service.

**Parameters:** None.

**Returns:** (string) The URL.

**Since:** 3.0

---

#### `publishedPhoto:setEditedFlag( edited )`

Marks the associated photo as edited since last published, or unchanged since publishing.

Must be called from within a `catalog:with___WriteAccessDo` gate (including `withPrivateWriteAccessDo`).

**Parameters:**
- `edited` (Boolean) -- True if the photo has been edited, false to mark as unchanged.

**Returns:** Nothing.

**Since:** 3.0

---

#### `publishedPhoto:setRemoteId( remoteID )`

Updates the remote service's unique identifier associated with the published photo.

Must be called from within a `catalog:with___WriteAccessDo` gate (including `withPrivateWriteAccessDo`).

**Parameters:**
- `remoteID` (string or number) -- The new ID assigned by the remote service.

**Returns:** Nothing.

**Since:** 3.0

---

#### `publishedPhoto:setRemoteUrl( url )`

Updates the URL for the associated photo.

Must be called from within a `catalog:with___WriteAccessDo` gate (including `withPrivateWriteAccessDo`).

**Parameters:**
- `url` (string) -- The new URL assigned by the remote service.

**Returns:** Nothing.

**Since:** 3.0

---

#### `publishedPhoto:type()`

Reports the type of this object.

**Parameters:** None.

**Returns:** (string) `'LrPublishedPhoto'`.

**Since:** 4.1

---

## LrPublishService

Provides access to a named publishing service and its member collections and collection sets. The service contains the collections of photos to be published, represented by `LrPublishedCollection` objects, which can be nested in `LrPublishedCollectionSet` objects.

Retrieve publish service objects by calling `LrCatalog:getPublishServices()`.

### Properties

| Property | Type | Access | Description | Since |
|---|---|---|---|---|
| `publishService.catalog` | `LrCatalog` | Read-Only | The catalog object that contains this publish service. | 3.0 |
| `publishService.localIdentifier` | number | Read-Only | The local identifier of the publish service, unique within the catalog. | 3.0 |

### Methods

#### `publishService:createPublishedCollection( name, parent, canReturnExisting )`

Creates a new published collection in this publish service. This is the equivalent of creating a published collection in the Publish Services panel without including selected photos or creating virtual copies.

Must be called from within a `catalog:with___WriteAccessDo` gate.

**Parameters:**
- `name` (string) -- The name of the new published collection.
- `parent` (optional, `LrPublishedCollectionSet`) -- The parent of the new collection, or nil to create at the top level of this publish service.
- `canReturnExisting` (optional, Boolean) -- True to return an existing published collection with this name, otherwise return nil if such a collection exists.

**Returns:** (`LrPublishedCollection`) On success, the new published collection object. If a collection with this name (case insensitive) already exists, nil (if canReturnExisting is false) or that collection object. If a collection set with this name (case insensitive) already exists, nil.

**Since:** 3.0

---

#### `publishService:createPublishedCollectionSet( name, parent, canReturnExisting )`

Creates a new collection set in this publish service.

Must be called from within a `catalog:with___WriteAccessDo` gate.

**Parameters:**
- `name` (string) -- The name of the new collection set.
- `parent` (optional, `LrPublishedCollectionSet`) -- The parent of the new collection set, or nil to create at the top level of this publish service.
- `canReturnExisting` (optional, Boolean) -- True to return an existing published collection set with this name, otherwise return nil if such a collection set exists.

**Returns:** (`LrPublishedCollectionSet`) On success, the new published collection set object. If a collection set with this name (case insensitive) already exists, nil (if canReturnExisting is false) or that collection set object. If a collection with this name (case insensitive) already exists, nil.

**Since:** 3.0

---

#### `publishService:createPublishedSmartCollection( name, searchDesc, parent, canReturnExisting )`

Creates a new published smart collection in this publish service. This is the equivalent of creating a published smart collection in the Publish Services panel.

Must be called from within a `catalog:with___WriteAccessDo` gate.

**Parameters:**
- `name` (string) -- The name of the new published smart collection.
- `searchDesc` (table) -- A search descriptor that defines what metadata fields to search, and how to match against a given value. See `LrCatalog:findPhotos()` for details. The default value for the "combine" field is "intersect".
- `parent` (optional, `LrPublishedCollectionSet`) -- The parent of the new collection, or nil to create at the top level of this publish service.
- `canReturnExisting` (optional, Boolean) -- True to return an existing published collection with this name, otherwise return nil if such a collection exists.

**Returns:** (`LrPublishedCollection`) On success, the new published collection object. If a collection with this name (case insensitive) already exists, nil (if canReturnExisting is false) or that collection object. If a collection set with this name (case insensitive) already exists, nil.

**Since:** 3.0

---

#### `publishService:getChildCollectionSets()`

Retrieves the photo collection sets that are immediate children of this service.

Must be called from within an asynchronous task started using `LrTasks`.

**Parameters:** None.

**Returns:** (array of `LrPublishedCollectionSet`) The contained collection-set objects.

**Since:** 3.0

---

#### `publishService:getChildCollections()`

Retrieves the photo collections that are immediate children of this service. Does not recurse into collection sets.

Must be called from within an asynchronous task started using `LrTasks`.

**Parameters:** None.

**Returns:** (array of `LrPublishedCollection`) The contained collection objects.

**Since:** 3.0

---

#### `publishService:getName()`

Retrieves the current name of the publish service.

Must be called from within an asynchronous task started using `LrTasks`.

**Parameters:** None.

**Returns:** (string) The name.

**Since:** 3.0

---

#### `publishService:getPluginId()`

Retrieves the unique identifier for the plug-in to which this service belongs. Note that if the plug-in's `LrExportServiceProvider` definition is a table of tables, the plug-in ID returned by this function will have a '.' followed by a number appended to it. The number corresponds to the export service provider to which this service belongs.

Must be called from within an asynchronous task started using `LrTasks`.

**Parameters:** None.

**Returns:** (string) The plug-in ID.

**Since:** 3.0

---

#### `publishService:getPublishSettings()`

Retrieves the current plug-in defined settings for the publish service. This is the same block of data that can be edited via the user interface if your plug-in implements the `viewForCollectionSettings` hook. See `LrPublishedCollection:setCollectionSettings()`.

Must be called from within an asynchronous task started using `LrTasks`.

**Parameters:** None.

**Returns:** (table) The settings.

**Since:** 3.0

---

#### `publishService:type()`

Reports the type of this object.

**Parameters:** None.

**Returns:** (string) `'LrPublishService'`.

**Since:** 3.0

---

## LrExportSession

Provides access to a list of photos to be exported and the renditions of those photos to be generated during an export operation.

Use the imported namespace as a constructor; access the functions through the created objects. An object is also available from the `exportContext.exportSession` property.

### Properties

| Property | Type | Access | Description | Since |
|---|---|---|---|---|
| `exportSession.catalog` | `LrCatalog` | Read-Only | The catalog object for this export session. | 1.3 |

### Methods

#### `LrExportSession( params )` -- Constructor

Creates an export session object. The session acts on a specific set of photos and settings, as when a session is started in the Export dialog.

**Parameters:**
- `params` (table) -- Arguments in named-argument syntax. All are required:
  - **photosToExport** (array of `LrPhoto`): A set of photos to be exported in this session.
  - **exportSettings** (table): A set of export settings for this session, as generated by the Export dialog.

**Returns:** An `exportSession` object.

**Since:** 1.3

---

#### `exportSession:countRenditions()`

Reports the number of renditions that will be generated by this session.

**Parameters:** None.

**Returns:** (number) The number of renditions.

**Since:** 1.3

---

#### `exportSession:doExportOnCurrentTask()`

Creates all of the renditions specified by this export session. This function must be called from an asynchronous task. This task blocks until all renditions are created.

**Parameters:** None.

**Returns:** Nothing.

**Since:** 1.3

---

#### `exportSession:doExportOnNewTask()`

Starts rendering photos in a new asynchronous task. It is safe to call this function whether in a task or not. This function returns immediately; it does not wait for rendering to complete.

**Parameters:** None.

**Returns:** Nothing.

**Since:** 1.3

---

#### `exportSession:photosToExport()`

Creates an iterator with which to walk the list of photos to be exported. Use to wrap a loop that processes each photo.

```lua
for photo in exportSession:photosToExport() do
    -- (do something with photo)
end
```

**Parameters:** None.

**Returns:** An iterator yielding `LrPhoto` objects.

**Since:** 1.3

---

#### `exportSession:recordRemoteCollectionId( remoteId )`

Records the unique identifier assigned to a published collection. Use only when publishing. This ID is passed back to the plug-in whenever the collection needs to be updated.

**Parameters:**
- `remoteId` (string or number) -- The unique ID for the collection, assigned by the service.

**Returns:** Nothing.

**Since:** 3.0

---

#### `exportSession:recordRemoteCollectionUrl( remoteUrl )`

Records the URL assigned to a published collection. Use only when publishing. This URL is used by Lightroom's "Go to Published Collection" command. Do not use for services that are not web-based.

**Parameters:**
- `remoteUrl` (string or number) -- The URL of the collection, assigned by the service.

**Returns:** Nothing.

**Since:** 3.0

---

#### `exportSession:removePhoto( photo )`

Removes all renditions for a photo from the export session. It is safe to call this function while using the `photosToExport()` iterator. Be aware that `photosToExport()` takes a snapshot of the photos at the beginning and does not update in response to `removePhoto`. Thus if you remove a photo not yet seen by the iterator, the iterator will still report it.

Note: This differs from `LrExportRendition:skipRender` in that removed photos do not appear in iterations started after this call; skipped photos still appear but are not rendered.

**Parameters:**
- `photo` (`LrPhoto`) -- The photo to remove.

**Returns:** Nothing.

**Since:** 1.3

---

#### `exportSession:renditions( params )`

Creates an iterator with which to walk the list of renditions generated for this session's photos. Use in a FOR loop.

```lua
for i, rendition in exportSession:renditions() do
    -- (do something with rendition)
end
```

**Parameters:**
- `params` (table, optional) -- Arguments in named-argument syntax; all optional:
  - **exportContext** (`LrExportContext`): An export context.
  - **progressScope** (`LrProgressScope`): A progress scope.
  - **renderProgressPortion** (number): Percentage completion for progress scope when done, [0..1].
  - **stopIfCanceled** (Boolean): True to stop the iterator prematurely if progress scope is canceled. Ignored if progressScope is not supplied.

**Returns:** An iterator yielding (index, `LrExportRendition`) pairs.

**Since:** 1.3

---

#### `exportSession:renditionsForFilter( params )`

Creates an iterator with which to walk an export filter's renditions-to-satisfy list. The iterator generates a rendition from this export session (before the application of this filter) and matches it with the corresponding rendition to be satisfied by the filter.

```lua
for sourceRendition, renditionToSatisfy in exportSession:renditionsForFilter( params ) do
    -- (do something with rendition)
end
```

**Parameters:**
- `params` (table, optional) -- Arguments in named-argument syntax:
  - **plugin** (_PLUGIN object)
  - **renditionsToSatisfy** (array of `LrExportRendition`): The list of renditions that this filter must satisfy.
  - **filterSettings** (function, optional): If present, this function can alter the export settings of the rendition. Called with two arguments: the individual rendition to be satisfied, and a copy of its export settings that can be modified in place. Can optionally return a string to be used as the new path to the file.

**Returns:** An iterator yielding (sourceRendition, renditionToSatisfy) pairs.

**Since:** 2.0

---

#### `exportSession:type()`

Reports the type of this object.

**Parameters:** None.

**Returns:** (string) `'LrExportSession'`.

**Since:** 4.1

---

## LrExportContext

Provides access to the choices a user has made in the Export dialog, and the list of photos to be exported.

An `LrExportContext` object is passed to your plug-in as a parameter to your service script's `processRenderedPhotos` function. You cannot import the namespace or access the properties and functions in any other way.

### Properties

| Property | Type | Access | Description | Since |
|---|---|---|---|---|
| `exportContext.exportSession` | `LrExportSession` | Read-Only | The list of photos and renditions to be exported in this session. | 1.3 |
| `exportContext.propertyTable` | table | Read-Only | The property table containing the Export settings defined for your plug-in, along with any built-in Lightroom Export settings that you have not excluded. The settings have the values chosen by the user in the Export dialog. | 1.3 |
| `exportContext.publishService` | `LrPublishService` | Read-Only | The publish service (only when published). | 3.0 |
| `exportContext.publishedCollection` | `LrPublishedCollection` | Read-Only | The published collection (only when published). | 3.0 |
| `exportContext.publishedCollectionInfo` | table | Read-Only | Information about the published collection (only when published). Contains: **isDefaultCollection** (Boolean), **name** (string), **parents** (array of tables, each with `name`, `remoteCollectionId`), **remoteId** (string or number, from `exportSession:recordRemoteCollectionId`), **remoteUrl** (optional string, from `exportSession:recordRemoteCollectionUrl`). | 3.0 |

### Methods

#### `exportContext:configureProgress( args )`

Configures a progress scope for the export rendering sequence. Use in preference to creating a new `LrProgressScope` object, and call before calling `renditions()` in this object. This function allows the filenames and thumbnails to be updated properly.

**Parameters:**
- `args` (table) -- Arguments in named-argument syntax:
  - **title** (string): The display name that identifies the main task; e.g. "Exporting files as JPEG". (When publishing, this has no direct effect on the caption displayed.)
  - **renderPortion** (optional, number): When all renditions have been processed, the progress scope will be at this percent complete. A percentage value [0..1].

**Returns:** (`LrProgressScope`) A progress scope tied specifically to the export rendering pipeline.

**Since:** 1.3

---

#### `exportContext:renditions( args )`

Creates an iterator for all renditions in this export. Use in preference to `LrExportContext.exportSession:renditions()`. Calls `exportContext:startRendering()` if needed, and keeps the progress scope updated properly.

**IMPORTANT:** You must call `configureProgress()` on this object before calling `renditions()`.

**Parameters:**
- `args` (table) -- Arguments in named-argument syntax:
  - **exportContext** (`LrExportContext`): This value is provided.
  - **progressScope** (`LrProgressScope`): The progress scope.
  - **renderProgressPortion** (number): This value is provided.
  - **stopIfCanceled** (Boolean): True to stop the iterator prematurely if progress scope is canceled.

**Returns:** An iterator for all export renditions.

**Since:** 1.3

---

#### `exportContext:startRendering()`

Starts the rendering process in a separate task.

**Parameters:** None.

**Returns:** Nothing.

**Since:** 1.3

---

## LrExportRendition

Represents a single rendition operation, undertaken during an export operation. The end result of a rendition operation is a rendered photo; that is, the image data written in the format and with the settings specified for the export session.

Rendition objects are created by the `LrExportSession` object; you cannot create them. Use `exportSession:renditions()` to access these objects.

### Properties

| Property | Type | Access | Description | Since |
|---|---|---|---|---|
| `exportRendition.destinationPath` | string | Read-Only | The absolute path to the rendered photo. The file may not yet exist at this path if the render operation has not yet completed. | 1.3 |
| `exportRendition.photo` | `LrPhoto` | Read-Only | The photo to be rendered in this operation. | 1.3 |
| `exportRendition.publishedPhotoId` | string or number | Read-Only | If this export session is for publishing and this photo has been previously published, returns the unique identifier that was provided by the published service. | 3.0 |
| `exportRendition.wasSkipped` | Boolean | Read-Only | True if this rendition was skipped. | 3.0 |

### Methods

#### `exportRendition:recordPublishedPhotoId( publishedId )`

Records the unique identifier assigned to a photo published via this service. Use only when publishing. A publish service must make this call to inform Lightroom that the photo has been successfully published. The call moves the photo from "New photos to publish" or "Modified photos to re-publish" to the "Published photos" section of the Library grid (assuming no further changes since the publish operation was initiated).

**Parameters:**
- `publishedId` (string or number) -- The unique ID for the photo, assigned by the service.

**Returns:** Nothing.

**Since:** 3.0

---

#### `exportRendition:recordPublishedPhotoUrl( publishedUrl )`

Records the URL assigned to a photo published via this service. Use only when publishing. A publish service can make this call to inform Lightroom where the photo can be found online. This call must follow the first call to `recordPublishedPhotoId()`.

**Parameters:**
- `publishedUrl` (string) -- The URL for the photo, assigned by the service.

**Returns:** Nothing.

**Since:** 3.0

---

#### `exportRendition:renditionIsDone( success, message )`

Notifies Lightroom that an export filter provider has completed the filtered rendering.

**Parameters:**
- `success` (Boolean) -- True if rendering was successful.
- `message` (string) -- An informative message suitable for display if the operation was not successful.

**Returns:** Nothing.

**Since:** 2.0

---

#### `exportRendition:skipRender()`

Causes the export task to skip this rendition. The rendition still appears in the `exportSession:renditions()` loop, but the file is not rendered. Check `exportRendition.wasSkipped` to determine if the rendition was skipped.

Must be called before the export session starts its rendering loop.

**Parameters:** None.

**Returns:** Nothing.

**Since:** 3.0

---

#### `exportRendition:type()`

Reports the type of this object.

**Parameters:** None.

**Returns:** (string) `'LrExportRendition'`.

**Since:** 4.1

---

#### `exportRendition:uploadFailed( message )`

Signals an upload failure for this rendition.

**Parameters:**
- `message` (string) -- The failure message.

**Returns:** Nothing.

**Since:** 2.0

---

#### `exportRendition:waitForRender()`

Causes the export task to yield time to other tasks until this rendition has been fully generated. This function does not return until the rendition operation is finished and a file has been written to the destination path. During this time, other parts of Lightroom can proceed.

Exception: if you previously called `skipRender()` for this rendition, this call will return immediately with `true`, but the file will not be present.

**Parameters:** None.

**Returns:**
1. (Boolean) True if rendering was successful.
2. (string) The path to the photo if successful, or an informative message suitable for display if the operation was not successful.

**Since:** 1.3

---

## LrKeyword

Provides access to a Lightroom keyword, any contained keywords, and photos associated with the keyword.

Retrieve keyword objects by calling `LrCatalog:getKeywords()`.

### Properties

| Property | Type | Access | Description | Since |
|---|---|---|---|---|
| `keyword.catalog` | `LrCatalog` | Read-Only | The catalog object that contains this keyword. | 3.0 |
| `keyword.localIdentifier` | number | Read-Only | The local identifier of the keyword, unique within this catalog. | 3.0 |

### Methods

#### `keyword:getAttributes()`

Retrieves the attributes of this keyword.

**Parameters:** None.

**Returns:** (table) A table of attributes; see `setAttributes()`. As of Lightroom 6.0, a **keywordType** attribute may also be present. If the keyword is a face tag, this attribute will be present with the value `"person"`.

**Since:** 3.0

---

#### `keyword:getChildren()`

Retrieves the children of this keyword, if any.

Must be called from within an asynchronous task started using `LrTasks`.

**Parameters:** None.

**Returns:** (array of `LrKeyword`) The child keyword objects, or an empty array if there are no children.

**Since:** 3.0

---

#### `keyword:getName()`

Retrieves the name of this keyword.

Must be called from within an asynchronous task started using `LrTasks`.

**Parameters:** None.

**Returns:** (string) The name.

**Since:** 3.0

---

#### `keyword:getParent()`

Retrieves the parent of this keyword, if any.

Must be called from within an asynchronous task started using `LrTasks`.

**Parameters:** None.

**Returns:** (`LrKeyword`) The parent keyword object, or nil if this is a top-level keyword.

**Since:** 3.0

---

#### `keyword:getPhotos()`

Retrieves the photos that have this keyword.

Must be called from within an asynchronous task started using `LrTasks`.

**Parameters:** None.

**Returns:** (array of `LrPhoto`) The photo objects.

**Since:** 3.0

---

#### `keyword:getSynonyms()`

Retrieves the synonyms for this keyword.

Must be called from within an asynchronous task started using `LrTasks`.

**Parameters:** None.

**Returns:** (array of string) The synonyms.

**Since:** 3.0

---

#### `keyword:setAttributes( keywordInfo )`

Sets attributes for this keyword.

Must be called from within a `catalog:with___WriteAccessDo` gate.

**Parameters:**
- `keywordInfo` (table) -- A table that contains these fields:
  - **keywordName** (string): The name of the keyword.
  - **synonyms** (table): The names of synonyms.
  - **includeOnExport** (Boolean): True to include the keyword when the photo is exported.
  - If any field is nil, that field is not changed.

**Returns:** True on success, false if there is already a keyword which has the same name and parent.

**Since:** 3.0

---

#### `keyword:type()`

Reports the type of this object.

**Parameters:** None.

**Returns:** (string) `'LrKeyword'`.

**Since:** 3.0

---

## LrFolder

Provides access to a file-system folder and to its contained photos.

Retrieve folder objects by calling `LrCatalog:getFolders()`.

### Properties

| Property | Type | Access | Description | Since |
|---|---|---|---|---|
| `folder.catalog` | `LrCatalog` | Read-Only | The catalog object that contains this folder. | 3.0 |

### Methods

#### `folder:getChildren()`

Retrieves immediate subfolders of this folder. Does not go into subfolders.

**Parameters:** None.

**Returns:** (array of `LrFolder`) The folder objects.

**Since:** 3.0

---

#### `folder:getName()`

Retrieves the name of this folder.

**Parameters:** None.

**Returns:** (string) The name.

**Since:** 3.0

---

#### `folder:getParent()`

Retrieves the parent of this folder.

**Parameters:** None.

**Returns:** (`LrFolder`) The folder object.

**Since:** 3.0

---

#### `folder:getPath()`

Retrieves the path of this folder.

**Parameters:** None.

**Returns:** (string) The path.

**Since:** 3.0

---

#### `folder:getPhotos( includeChildren )`

Retrieves the photos contained in this folder.

**Parameters:**
- `includeChildren` (Boolean) -- True to include photos in subfolders in the returned set.

**Returns:** (array of `LrPhoto`) The photo objects.

**Since:** 3.0

---

#### `folder:type()`

Reports the type of this object.

**Parameters:** None.

**Returns:** (string) `'LrFolder'`.

**Since:** 3.0

---

## LrProgressScope

Provides feedback to the user about the progress of a long-running task. An entry in Lightroom's progress area at the top-left of the catalog window is created for each active progress scope.

Scopes can be nested; the UI can show progress in a subsidiary task (such as uploading a single photo) that advances the parent task (such as an upload operation for a set of photos) by a given amount. The parent task is identified by a title above the progress bar, and the current task is identified by a caption below it.

Use the imported namespace as a constructor; access the functions through the created objects.

### Properties

None (no documented read-only properties).

### Methods

#### `LrProgressScope( params )` -- Constructor

Creates a progress scope object.

**Parameters:**
- `params` (table) -- Arguments in named-argument syntax:
  - **parent** (optional, `LrProgressScope`): The parent scope, if this is a child scope.
  - **parentEndRange** (optional, number): If this is a child scope, the percentage value [0..1] for the degree of completion of the parent scope when this task completes.
  - **title** (optional, string): For a parent scope, the display name that identifies this scope for its entire lifetime; e.g. "Exporting files as JPEG".
  - **caption** (optional, string): For a child scope, the display name of the current task; e.g. "IMG0057.JPG".
  - **functionContext** (optional, `LrFunctionContext`): A function context to attach to this progress scope. If provided, the progress scope is terminated when the function scope completes.

**Returns:** An `LrProgressScope` object. Use this object to make function calls.

**Since:** 1.3

---

#### `progressScope:attachToFunctionContext( context )`

Attaches this progress scope to a function context so that it can be cleared when the function ends, regardless of how the function is terminated.

**Parameters:**
- `context` (`LrFunctionContext`) -- The function context.

**Returns:** Nothing.

**Since:** 1.3

---

#### `progressScope:cancel()`

Signals that this operation should be canceled. Called when the user clicks the X at the right end of the progress bar. This does not immediately cancel the operation; that happens when the task polls `:isCanceled()` and stops the operation in response to a true result.

**Parameters:** None.

**Returns:** Nothing.

**Since:** 1.3

---

#### `progressScope:done()`

Marks this progress scope as complete.

**Parameters:** None.

**Returns:** Nothing.

**Since:** 1.3

---

#### `progressScope:getParentScope()`

Returns the parent progress scope, if any.

**Parameters:** None.

**Returns:** (`LrProgressScope` or nil) The parent scope.

**Since:** 4.0

---

#### `progressScope:getPortionComplete()`

Retrieves the portion of this task that has been marked as completed.

**Parameters:** None.

**Returns:** (number) The proportion of the work that has been done, in the range [0..totalAmount].

**Since:** 1.3

---

#### `progressScope:isCancelable()`

Reports whether this progress scope can be canceled.

**Parameters:** None.

**Returns:** (Boolean) True if scope can be canceled.

**Since:** 1.3

---

#### `progressScope:isCanceled()`

Reports whether this operation has been canceled by the user.

**Parameters:** None.

**Returns:** (Boolean) True if `progressScope:cancel()` has been called.

**Since:** 1.3

---

#### `progressScope:isDone()`

Reports whether this progress scope has been completed.

**Parameters:** None.

**Returns:** (Boolean) True if `done()` has been called.

**Since:** 1.3

---

#### `progressScope:isIndeterminate()`

Reports whether this progress scope is indeterminate. When a scope is indeterminate, you cannot determine how much of the task remains to be completed. `getPortionComplete()` returns -1.

**Parameters:** None.

**Returns:** (Boolean) True if `setIndeterminate()` has been called, false otherwise.

**Since:** 1.3

---

#### `progressScope:isLowUiPriority()`

Reports whether this progress scope has low UI priority.

**Parameters:** None.

**Returns:** (Boolean) True if scope has low UI priority.

**Since:** 8.4

---

#### `progressScope:isPausable()`

Reports whether this progress scope can be paused.

**Parameters:** None.

**Returns:** (Boolean) True if scope can be paused.

**Since:** 7.5

---

#### `progressScope:isPaused()`

Reports whether this operation has been paused by the user.

**Parameters:** None.

**Returns:** (Boolean) True if `progressScope:pause()` has been called.

**Since:** 7.5

---

#### `progressScope:pause()`

Signals that this operation should be paused. Called when the user clicks the || at the right end of the progress bar. This does not immediately pause the operation; that happens when the task polls `:isPaused()` and pauses the operation in response to a true result.

**Parameters:** None.

**Returns:** Nothing.

**Since:** 7.5

---

#### `progressScope:setCancelable( cancelable )`

Allows or disallows user cancellation of this progress scope.

**Parameters:**
- `cancelable` (Boolean) -- True to allow cancellation, false to disallow it.

**Returns:** Nothing.

**Since:** 1.3

---

#### `progressScope:setCaption( caption )`

Changes the caption that identifies this child task.

**Parameters:**
- `caption` (string) -- The new caption.

**Returns:** Nothing.

**Since:** 1.3

---

#### `progressScope:setIndeterminate()`

Makes this progress scope indeterminate. When a scope is indeterminate, you cannot determine how much of the task remains. `getPortionComplete()` returns -1. Indeterminate progress scopes are only useful in the context of `LrDialogs:showModalProgressDialog()`; they do not display properly in the Lightroom catalog window.

**Parameters:** None.

**Returns:** Nothing.

**Since:** 1.3

---

#### `progressScope:setLowUiPriority( inPrior )`

Sets or clears low UI priority for this progress scope.

**Parameters:**
- `inPrior` (Boolean) -- True to set low UI priority, false to set high UI priority.

**Returns:** Nothing.

**Since:** 8.4

---

#### `progressScope:setPausable( pausable, cancelable )`

Allows or disallows the capability of the user to pause this progress scope.

**Parameters:**
- `pausable` (Boolean) -- True to allow pausing, false to disallow it.
- `cancelable` (Boolean) -- True to allow, false to disallow it.

**Returns:** Nothing.

**Since:** 7.5

---

#### `progressScope:setPortionComplete( amountDone, totalAmount )`

Sets the portion of this task that has been completed.

**Parameters:**
- `amountDone` (number) -- The degree of completion; a value between 0 and totalAmount, inclusive.
- `totalAmount` (number) -- The end value of the range, or nil to use the default range of [0..1].

**Returns:** Nothing.

**Since:** 1.3

---

#### `progressScope:type()`

Reports the type of this object.

**Parameters:** None.

**Returns:** (string) `'LrProgressScope'`.

**Since:** 4.1
