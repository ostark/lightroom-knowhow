# Metadata Providers

## Overview

Custom metadata fields allow a plug-in to store per-photo data in the Lightroom Classic catalog. These fields can be visible and editable in the Metadata panel, or invisible and used for private plug-in data. The system consists of three interconnected components:

- **LrMetadataProvider** -- defines custom metadata fields stored per-photo in the catalog
- **LrMetadataTagsetFactory** -- controls how custom (and built-in) fields are displayed in the Metadata panel
- **Smart collection search** -- fields marked `searchable` can be queried via `catalog:findPhotos()`

Key limitations of custom metadata:
- Values are stored only in the Lightroom Classic catalog database. They cannot be linked to XMP values or saved with the image file.
- Only simple data types are supported (string, enum, url). Complex data structures (e.g., a spreadsheet per photo) are not possible.
- Each field holds exactly one value per photo.

---

## Metadata Definition File

### Declaration in Info.lua

A Metadata Provider is declared in `Info.lua` with the `LrMetadataProvider` entry:

```lua
return {
    LrSdkVersion = 5.0,
    LrToolkitIdentifier = 'com.adobe.lightroom.metadata.sample',
    LrPluginName = LOC "$$$/CustomMetadata/PluginName=Metadata Sample",
    LrMetadataProvider = 'SampleMetadataDefinition.lua',
}
```

The Info.lua file that declares a Metadata Provider can also declare metadata tagsets, export services, and/or export filters, but need not do so.

### Definition File Structure

The metadata definition script returns a table with two required keys and two optional keys:

| Key | Type | Required | Description |
|-----|------|----------|-------------|
| `metadataFieldsForPhotos` | table | Yes | Array of field definitions. Each entry describes a single field that can be associated with photos in the catalog. |
| `schemaVersion` | number | Yes | Version number for the field definition schema. Typically starts at 1 and is incremented when the schema changes. |
| `updateFromEarlierSchemaVersion` | function | No | Migration callback, invoked when a new schema version is detected. Receives `catalog`, `previousSchemaVersion`, and `progressScope`. |
| `noAutoUpdate` | boolean | No | When `false` (default), Lightroom auto-migrates metadata from old field definitions. Set to `true` to handle migration yourself via the `updateFromEarlierSchemaVersion` callback. |

Minimal skeleton:

```lua
return {
    metadataFieldsForPhotos = {
        -- field definitions go here
    },
    schemaVersion = 1,
}
```

---

## Field Properties

Each entry in the `metadataFieldsForPhotos` array is a table describing one metadata field. The following properties are recognized:

### `id` (string) -- Required

A unique identifier that allows the plug-in to access this field. Must conform to Lua variable naming conventions: starts with a letter, followed by letters or numbers, case-sensitive.

### `title` (string) -- Optional

The localizable display name shown in the Metadata panel. Should be short (under ~100 pixels wide); longer names are truncated but shown in full in the tooltip.

If omitted, the field is not visible in the Metadata panel. This is useful for storing private per-image data such as external service IDs or cross-reference information. Other plug-ins can read such a field but cannot write to it.

### `dataType` (string) -- Optional

Constrains the data type stored in this field. `nil` is always permitted regardless of type. You cannot require that a field have a value.

| Value | Description |
|-------|-------------|
| `"string"` | Field value must be a string. Displayed as an editable text field. This is the default if `dataType` is omitted. |
| `"enum"` | Field value must be one of the allowed values specified in `values`. Displayed as a pop-up menu. |
| `"url"` | Field value must be a string. Displayed with a button that opens the value in the user's web browser. |

### `values` (table) -- Required when `dataType = "enum"`, otherwise disallowed

An array of allowed values. Each entry is a table containing:
- `value` -- the stored value (string, number, boolean, or `nil`)
- `title` -- the localizable display string shown in the pop-up menu

Only one entry may have `value = nil`. If present, its title is used when no value has been assigned to the field for a photo.

The table can also include `allowPluginToSetOtherValues = true`:
- If present, the plug-in can store values outside the enumerated set.
- If absent, attempting to set an unenumerated value triggers a Lua error and the stored value is not changed.

### `readOnly` (boolean) -- Optional

Use only when `title` is provided. When `true`, the field is visible in the Metadata panel but not editable by the user. The value can still be set programmatically via `photo:setPropertyForPlugin()`.

### `searchable` (boolean) -- Optional

Use only when `title` is provided. When `true`, this field is stored in a separate indexed table for faster searching, and can be chosen by users as a search criterion for smart collections. Strings stored in this field must not exceed 511 bytes. Default is `false`.

### `browsable` (boolean) -- Optional

Use only when `title` is provided and `searchable` is `true`. When `true`, this field can be used as a filter in the Library metadata browser (Library filter bar).

### `version` (number) -- Optional

A version number specifically for this field, distinct from the top-level `schemaVersion`. If you make an incompatible change to a field definition (e.g., changing the value of `searchable`), you must bump the field's version number. A migration script can then search for photos containing the old version and manually migrate values.

---

## Schema Versioning

The `schemaVersion` at the top level of the definition table provides version control for the entire metadata schema. When Lightroom detects a new schema version, it calls `updateFromEarlierSchemaVersion` to allow data migration.

Key details about the update callback:
- **Parameters**: `catalog`, `previousSchemaVersion`, `progressScope`
- When the plug-in is first installed, `previousSchemaVersion` is `nil`
- The `progressScope` parameter (available since Lightroom 3.0) can be used to signal migration progress
- The function is called from within a `catalog:withPrivateWriteAccessDo` block -- you must **not** call any `with___Do` functions yourself inside this callback
- Use `catalog:assertHasPrivateWriteAccess()` to verify the write context

### Migration Example

```lua
updateFromEarlierSchemaVersion = function( catalog, previousSchemaVersion, progressScope )
    -- Verify we have write access (safety check)
    catalog:assertHasPrivateWriteAccess(
        "SampleMetadataDefinition.updateFromEarlierSchemaVersion" )

    local myPluginId = 'com.adobe.lightroom.metadata.sample'

    if previousSchemaVersion == 1 then
        -- Find all photos that have a value for the 'siteId' field
        local photosToMigrate = catalog:findPhotosWithProperty(
            myPluginId, 'siteId' )
        -- Optional: can also pass a property version number as third argument

        for i, photo in ipairs( photosToMigrate ) do
            local oldSiteId = photo:getPropertyForPlugin( myPluginId, 'siteId' )
            local newSiteId = "new:" .. oldSiteId
            photo:setPropertyForPlugin( _PLUGIN, 'siteId', newSiteId )
        end

    elseif previousSchemaVersion == 2 then
        -- Handle migration from version 2 to current...
    end
end,
```

---

## Complete Metadata Definition Example

This example defines three fields of representative types:

```lua
return {
    metadataFieldsForPhotos = {
        {
            id = 'siteId',
            -- No title: invisible field, internal to the plug-in.
            -- Useful for storing an external database ID or service reference.
        },
        {
            id = 'randomString',
            title = LOC "$$$/Sample/Fields/RandomString=Random String",
            dataType = 'string',
            searchable = true,
            browsable = true,
        },
        {
            id = 'modelRelease',
            title = LOC "$$$/Sample/Fields/ModelRelease=Model Release",
            dataType = 'enum',
            values = {
                {
                    value = nil,
                    title = LOC "$$$/Sample/Fields/ModelRelease/NotSure=Not Sure",
                },
                {
                    value = 'yes',
                    title = LOC "$$$/Sample/Fields/ModelRelease/Yes=Yes",
                },
                {
                    value = 'no',
                    title = LOC "$$$/Sample/Fields/ModelRelease/No=No",
                },
                -- optional: allowPluginToSetOtherValues = true,
            },
        },
    },

    schemaVersion = 1,

    updateFromEarlierSchemaVersion = function( catalog, previousSchemaVersion, progressScope )
        catalog:assertHasPrivateWriteAccess(
            "SampleMetadataDefinition.updateFromEarlierSchemaVersion" )

        local myPluginId = 'com.adobe.lightroom.metadata.sample'

        if previousSchemaVersion == 1 then
            local photosToMigrate = catalog:findPhotosWithProperty(
                myPluginId, 'siteId' )

            for i, photo in ipairs( photosToMigrate ) do
                local oldSiteId = photo:getPropertyForPlugin( myPluginId, 'siteId' )
                local newSiteId = "new:" .. oldSiteId
                photo:setPropertyForPlugin( _PLUGIN, 'siteId', newSiteId )
            end
        elseif previousSchemaVersion == 2 then
            -- handle future migrations...
        end
    end,
}
```

How these fields appear in the Metadata panel:
- **siteId** does not appear (no `title` defined) -- it is private plug-in data.
- **randomString** appears with the label "Random String" as an editable text field.
- **modelRelease** appears with the label "Model Release" as a pop-up menu of allowed values.

---

## Custom Metadata Tagsets

### Purpose

The drop-down menu at the top left of the Metadata panel allows users to select a **metadata tagset** -- a predefined set of metadata fields to display. Lightroom Classic includes built-in tagsets (such as "All" and "All Plug-in Metadata"), and plug-ins can define custom tagsets that mix built-in fields with plug-in-defined fields.

### Declaration in Info.lua

```lua
LrMetadataTagsetFactory = 'SampleTagset.lua',
```

You can specify multiple tagset files:

```lua
LrMetadataTagsetFactory = { 'Tagset1.lua', 'Tagset2.lua', 'Tagset3.lua' },
```

The metadata-tagset provider can appear in the same plug-in with export-service providers, export-filter providers, and Metadata Providers.

### Tagset Structure

Each tagset definition file returns a table (or an array of tables for multiple tagsets) with these entries:

| Key | Type | Required | Description |
|-----|------|----------|-------------|
| `id` | string | Yes | Unique identifier within this plug-in. Must follow Lua variable naming conventions. |
| `title` | string | Yes | Localizable display name shown in the Metadata panel dropdown menu. |
| `items` | table | Yes | Ordered array of metadata fields to display in this tagset. |

### Item Entries

Each entry in the `items` array identifies a field to include. It can be:

- A **simple string** specifying the field name (e.g., `'com.adobe.filename'`)
- A **table** specifying the field name plus additional display options (e.g., `{ 'com.adobe.caption', height_in_lines = 3 }`)

### Special Field Names

| Name | Description |
|------|-------------|
| `'com.adobe.separator'` | Inserts a dividing line in the Metadata panel. |
| `'com.adobe.label'` | Inserts a section label. Requires a `label` entry: `{ 'com.adobe.label', label = LOC "$$$/Metadata/MyLabel=My Section" }` |
| `'com.adobe.allPluginMetadata'` | Includes all visible metadata from all plug-ins (used by the built-in "All Plug-in Metadata" preset). |
| `'pluginToolkitId.*'` | Wildcard -- includes all visible metadata fields from the specified plug-in, in their definition order. The asterisk can appear only at the end. If the plug-in is missing or defines no visible metadata, the block is silently omitted. |

### Built-in Field References

Common built-in fields you can include in tagsets:

**File info:**
- `com.adobe.filename`, `com.adobe.copyname`, `com.adobe.folder`, `com.adobe.filesize`
- `com.adobe.imageFileDimensions`, `com.adobe.imageCroppedDimensions`

**Dates:**
- `com.adobe.dateCreated`

**IPTC content:**
- `com.adobe.title`, `com.adobe.caption`, `com.adobe.headline`
- `com.adobe.keywords`, `com.adobe.descriptionWriter`
- `com.adobe.intellectualGenre`, `com.adobe.scene`, `com.adobe.iptcSubjectCode`

**IPTC creator/copyright:**
- `com.adobe.copyright`, `com.adobe.copyrightInfoURL`, `com.adobe.rightsUsageTerms`
- `com.adobe.creator`, `com.adobe.creatorJobTitle`
- `com.adobe.creatorAddress`, `com.adobe.creatorCity`, `com.adobe.creatorState`
- `com.adobe.creatorZip`, `com.adobe.creatorCountry`
- `com.adobe.creatorWorkPhone`, `com.adobe.creatorWorkEmail`, `com.adobe.creatorWorkWebsite`

**IPTC workflow/source:**
- `com.adobe.jobIdentifier`, `com.adobe.instructions`
- `com.adobe.provider`, `com.adobe.source`

**Location:**
- `com.adobe.location`, `com.adobe.city`, `com.adobe.state`, `com.adobe.country`
- `com.adobe.isoCountryCode`
- `com.adobe.GPS`, `com.adobe.GPSAltitude`

**Camera/EXIF:**
- `com.adobe.make`, `com.adobe.model`, `com.adobe.serialNumber`
- `com.adobe.lens`, `com.adobe.artist`, `com.adobe.software`
- `com.adobe.exposure`, `com.adobe.focalLength`, `com.adobe.focalLength35mm`
- `com.adobe.brightnessValue`, `com.adobe.exposureBiasValue`, `com.adobe.subjectDistance`
- `com.adobe.ISOSpeedRating`, `com.adobe.flash`
- `com.adobe.exposureProgram`, `com.adobe.meteringMode`

**Ratings/labels:**
- `com.adobe.rating.string`, `com.adobe.colorLabels.string`

**Accessibility:**
- `com.adobe.altTextAccessibility`, `com.adobe.extDescrAccessibility`

### Complete Tagset Example

```lua
return {
    title = LOC "$$$/SampleTagset/Title=Sample Tagset from Plug-in",
    id = 'sampleTagset',

    items = {
        -- Built-in file metadata
        'com.adobe.filename',
        'com.adobe.copyname',
        'com.adobe.folder',

        'com.adobe.separator',

        -- Built-in content metadata with display options
        'com.adobe.title',
        { 'com.adobe.caption', height_in_lines = 3 },

        'com.adobe.separator',

        -- Labeled section for location fields
        { 'com.adobe.label',
          label = LOC "$$$/Metadata/SampleLabel=Location Info" },
        'com.adobe.dateCreated',
        'com.adobe.location',
        'com.adobe.city',
        'com.adobe.state',
        'com.adobe.country',
        'com.adobe.isoCountryCode',
        'com.adobe.GPS',
        'com.adobe.GPSAltitude',

        'com.adobe.separator',

        -- All visible fields from our plug-in (wildcard)
        'com.adobe.lightroom.metadata.sample.*',

        -- Accessibility fields
        'com.adobe.altTextAccessibility',
        'com.adobe.extDescrAccessibility',
    },
}
```

### Tagset with Explicit Custom Fields

Instead of using the wildcard, you can reference individual custom fields by their fully qualified name (`pluginToolkitId.fieldId`):

```lua
return {
    title = LOC "$$$/MyTagset/Title=My Custom View",
    id = 'myCustomView',

    items = {
        { 'com.adobe.label',
          label = LOC "$$$/Metadata/StdLabel=Standard Metadata" },
        'com.adobe.filename',
        'com.adobe.folder',

        'com.adobe.separator',

        { 'com.adobe.label',
          label = LOC "$$$/Metadata/CustomLabel=My Custom Fields" },
        'sample.metadata.mymetadatasample.myString',
        'sample.metadata.mymetadatasample.myboolean',
    },
}
```

---

## Reading and Writing Custom Metadata

### Reading a Field Value

```lua
local value = photo:getPropertyForPlugin( _PLUGIN, 'fieldId' )
```

Or using a plugin identifier string:

```lua
local value = photo:getPropertyForPlugin( 'com.mycompany.myplugin', 'fieldId' )
```

### Writing a Field Value

Writing requires catalog write access:

```lua
catalog:withWriteAccessDo( "Set custom metadata", function()
    photo:setPropertyForPlugin( _PLUGIN, 'fieldId', 'newValue' )
end )
```

The `_PLUGIN` global refers to the current plug-in object. When writing from within the `updateFromEarlierSchemaVersion` callback, write access is already granted (the callback runs inside `withPrivateWriteAccessDo`), so you call `setPropertyForPlugin` directly.

### Finding Photos by Custom Field

```lua
local photos = catalog:findPhotosWithProperty( pluginId, 'fieldId' )
-- Optional: pass a property version number as third argument
local photos = catalog:findPhotosWithProperty( pluginId, 'fieldId', 2 )
```

### Complete Read/Write Example

```lua
local LrApplication = import 'LrApplication'
local LrTasks = import 'LrTasks'

LrTasks.startAsyncTask( function()
    local catalog = LrApplication.activeCatalog()

    -- Read metadata
    local photos = catalog:getTargetPhotos()
    for _, photo in ipairs( photos ) do
        local status = photo:getPropertyForPlugin( _PLUGIN, 'modelRelease' )
        if status == nil then
            -- Write metadata (requires write access)
            catalog:withWriteAccessDo( "Set default model release", function()
                photo:setPropertyForPlugin( _PLUGIN, 'modelRelease', 'pending' )
            end )
        end
    end
end )
```

---

## Searching with Smart Collections

Fields marked `searchable = true` appear in the Edit Smart Collection dialog, allowing users to create filter rules based on custom metadata. You can also build these searches programmatically.

### Basic Search

```lua
local LrApplication = import 'LrApplication'
local LrTasks = import 'LrTasks'

LrTasks.startAsyncTask( function()
    local catalog = LrApplication.activeCatalog()
    local photos = catalog:findPhotos {
        searchDesc = {
            criteria = "rating",
            operation = ">",
            value = 3,
        },
    }

    for _, photo in ipairs( photos ) do
        -- process each matching photo
    end
end )
```

### Searching Plugin-Defined Fields

Use the `sdktext:` prefix with the plugin toolkit identifier and field name:

```lua
local photos = catalog:findPhotos {
    searchDesc = {
        criteria = "sdktext:com.adobe.lightroom.metadata.sample.randomString",
        operation = "any",
        value = "test",
    },
}
```

To search all searchable fields from a specific plug-in:

```lua
criteria = "sdktext:com.adobe.lightroom.metadata.sample.*"
```

To search all plug-in metadata:

```lua
criteria = "allPluginMetadata"
```

### Search Operations by Data Type

**String values:**

| Operation | Description |
|-----------|-------------|
| `"any"` | contains |
| `"all"` | contains all |
| `"words"` | contains words |
| `"noneOf"` | does not contain |
| `"beginsWith"` | starts with |
| `"endsWith"` | ends with |
| `"empty"` | are empty (only for items that can be empty) |
| `"notEmpty"` | are not empty (only for items that can be empty) |
| `"=="` | is (only for items with exact match) |
| `"!="` | is not (only for items with exact match) |

**Number/rating values:**

| Operation | Description |
|-----------|-------------|
| `"=="` | is |
| `"!="` | is not |
| `">"` | is greater than |
| `"<"` | is less than |
| `">="` | is greater than or equal to |
| `"<="` | is less than or equal to |
| `"in"` | is in range (end value in `value2` parameter) |

**Enumerated values:**

| Operation | Description |
|-----------|-------------|
| `"=="` | is |
| `"!="` | is not |

**Boolean values:**

| Operation | Description |
|-----------|-------------|
| `"isTrue"` | is true |
| `"isFalse"` | is false |

**Date values:**

| Operation | Description |
|-----------|-------------|
| `"=="` | is |
| `"!="` | is not |
| `">"` | is after |
| `"<"` | is before |
| `"in"` | is in range (end value in `value2`) |
| `"inLast"` | is in the last (unit in `value_unit`: `"hours"`, `"days"`, `"weeks"`, `"months"`, `"years"`) |
| `"notInLast"` | is not in the last (unit in `value_unit`) |
| `"today"` | is today |
| `"yesterday"` | is yesterday |
| `"thisWeek"` | is in this week |
| `"thisMonth"` | is in this month |
| `"thisYear"` | is in this year |

### Combining Search Criteria

Use `combine` to build compound search descriptors:

```lua
local photos = catalog:findPhotos {
    searchDesc = {
        combine = "intersect",   -- all criteria must match
        {
            criteria = "rating",
            operation = ">",
            value = 3,
        },
        {
            criteria = "captureTime",
            operation = ">",
            value = "2007-01-01",
        },
    },
}
```

The three combine modes:

| Mode | Description |
|------|-------------|
| `"union"` | Any of the criteria match (OR) |
| `"intersect"` | All of the criteria match (AND) |
| `"exclude"` | None of the criteria match (NOT) |

Combine entries can be nested for complex Boolean logic:

```lua
local photos = catalog:findPhotos {
    searchDesc = {
        combine = "union",
        {
            combine = "intersect",
            {
                criteria = "rating",
                operation = ">=",
                value = 1,
            },
            {
                criteria = "labelColor",
                operation = "==",
                value = 1,
            },
        },
        {
            criteria = "rating",
            operation = "==",
            value = 5,
        },
    },
}
-- Equivalent to: (rating >= 1 AND labelColor == 1) OR (rating == 5)
```

### Available Built-in Search Criteria

| Criteria | Type | Notes |
|----------|------|-------|
| `rating` | number | |
| `pick` | enum | `1` (flagged), `0` (unflagged), `-1` (rejected) |
| `labelColor` | enum | `1`-`5` (red, yellow, green, blue, purple), `"custom"`, `"none"` |
| `labelText` | string | User-assigned label name |
| `folder` | string | Full path including parent folders |
| `collection` | string | Name of containing collection |
| `all` | string | Any searchable text |
| `filename` | string | |
| `copyname` | string | Copy Name from Metadata panel |
| `fileFormat` | enum | `"DNG"`, `"RAW"`, `"JPG"`, `"TIFF"`, `"PSD"` |
| `metadata` | string | Any searchable metadata |
| `title` | string | |
| `caption` | string | |
| `keywords` | string | Plural, can be empty |
| `iptc` | string | Any indexed IPTC metadata |
| `exif` | string | Any indexed EXIF metadata |
| `captureTime` | date | |
| `touchTime` | date | Edit date |
| `camera` | string | Exact match |
| `cameraSN` | string | Camera serial number, exact match |
| `lens` | string | Exact match |
| `isoSpeedRating` | number | |
| `hasGPSData` | boolean | |
| `country` | string | Exact match |
| `state` | string | Exact match |
| `city` | string | Exact match |
| `location` | string | Exact match |
| `creator` | string | Exact match |
| `jobIdentifier` | string | Exact match |
| `copyrightState` | enum | `true` (copyrighted), `false` (public domain), `"unknown"` |
| `hasAdjustments` | boolean | |
| `developPreset` | enum | `"default"`, `"specified"`, `"custom"` |
| `treatment` | enum | `"grayscale"`, `"color"` |
| `cropped` | boolean | |
| `aspectRatio` | enum | `"portrait"`, `"landscape"`, `"square"` |

### Tip: Creating Searches Interactively

If you are unsure how to construct a particular search descriptor, Lightroom Classic can build it for you:

1. Create the search as a Smart Collection in Lightroom Classic.
2. Right-click the collection in the Collections panel and choose "Export Smart Collection Settings."
3. Open the resulting `.lrsmcol` file in a text editor.
4. Copy the `value` entry and rename it to `searchDesc`.
5. Include it in your call to `catalog:findPhotos()` and adjust as needed.

---

<!-- BEGIN OFFICIAL_METADATA_KEYS -->
## Official Metadata Key Reference (SDK 11.4)

Official built-in metadata key catalogs and tagset field-name catalogs.

### Metadata Tagset Field Names

### Available Field Names

#### File Information
| Field Name | Description |
|---|---|
| `com.adobe.filename` | Leaf name of the file (e.g., "myFile.jpg") |
| `com.adobe.originalFilename.ifDiffers` | Original filename prior to renaming (only shown if different) |
| `com.adobe.sidecars` | Extensions of associated sidecar files (.xmp, .thm, etc.) |
| `com.adobe.copyname` | Name associated with this virtual copy |
| `com.adobe.folder` | Name of the folder the file is in |
| `com.adobe.filesize` | Formatted size (e.g., "6.01 MB") |
| `com.adobe.fileFormat` | User-visible file type (DNG, RAW, etc.) |
| `com.adobe.metadataStatus` | Status of metadata vs. catalog ("Up to date", "Has been changed", "Conflict exists") |
| `com.adobe.metadataDate` | Date/time when Lightroom last updated metadata in this file |
| `com.adobe.audioAnnotation` | Name of associated audio file (only shown if exists) |

#### Display Helpers
| Field Name | Description |
|---|---|
| `com.adobe.separator` | Inserts a dividing line |
| `com.adobe.label` | Inserts a custom section label (use `label` key for the text) |

#### Rating and Labels
| Field Name | Description |
|---|---|
| `com.adobe.rating` | User rating (number of stars) |
| `com.adobe.colorLabels` | Assigned color label name (despite plural name, only one allowed) |

#### Title and Caption
| Field Name | Description |
|---|---|
| `com.adobe.title` | Title of the photo |
| `com.adobe.caption` | Caption for the photo |

#### Image Dimensions
| Field Name | Description |
|---|---|
| `com.adobe.imageFileDimensions` | Original dimensions (e.g., "3072 x 2304") |
| `com.adobe.imageCroppedDimensions` | Cropped dimensions (e.g., "3072 x 2304") |

#### Exposure / Camera Settings
| Field Name | Description |
|---|---|
| `com.adobe.exposure` | Exposure summary (e.g., "1/60 sec at f/2.8") |
| `com.adobe.shutterSpeedValue` | Shutter speed (e.g., "1/60 sec") |
| `com.adobe.apertureValue` | Aperture (e.g., "f/2.8") |
| `com.adobe.brightnessValue` | Brightness value |
| `com.adobe.exposureBiasValue` | Exposure bias/compensation (e.g., "-2/3 EV") |
| `com.adobe.flash` | Whether the flash fired (e.g., "Did fire") |
| `com.adobe.exposureProgram` | Exposure program (e.g., "Aperture priority") |
| `com.adobe.meteringMode` | Metering mode (e.g., "Pattern") |
| `com.adobe.ISOSpeedRating` | ISO speed rating (e.g., "ISO 200") |
| `com.adobe.focalLength` | Focal length as shot (e.g., "132 mm") |
| `com.adobe.focalLength35mm` | Focal length as 35mm equivalent (e.g., "211 mm") |
| `com.adobe.lens` | Lens (e.g., "28.0-135.0 mm") |
| `com.adobe.subjectDistance` | Subject distance (e.g., "3.98 m") -- approximate only |

#### Dates
| Field Name | Description |
|---|---|
| `com.adobe.dateTimeOriginal` | Date and time of capture (e.g., "09/15/2005 17:32:50") |
| `com.adobe.dateTimeDigitized` | Date and time of scanning |
| `com.adobe.dateTime` | Adjusted date and time |

#### Camera Information
| Field Name | Description |
|---|---|
| `com.adobe.make` | Camera manufacturer |
| `com.adobe.model` | Camera model |
| `com.adobe.serialNumber` | Camera serial number |

#### Other Embedded Metadata
| Field Name | Description |
|---|---|
| `com.adobe.userComment` | Comments recorded by user in camera |
| `com.adobe.artist` | Artist's name |
| `com.adobe.software` | Software used to process/create photo |

#### GPS
| Field Name | Description |
|---|---|
| `com.adobe.GPS` | Location (e.g., "37deg56'10\" N 27deg20'42\" E") |
| `com.adobe.GPSAltitude` | GPS altitude (e.g., "82.3 m") |
| `com.adobe.GPSImgDirection` | GPS direction (e.g., "South") |

#### IPTC Creator / Contact
| Field Name | Description |
|---|---|
| `com.adobe.creator` | Name of the person that created this image |
| `com.adobe.creatorJobTitle` | Job title of the creator |
| `com.adobe.creatorAddress` | Address of the creator |
| `com.adobe.creatorCity` | City of the creator |
| `com.adobe.creatorState` | State of the creator |
| `com.adobe.creatorZip` | Postal code of the creator |
| `com.adobe.creatorCountry` | Country of the creator |
| `com.adobe.creatorWorkPhone` | Phone number of the creator |
| `com.adobe.creatorWorkEmail` | Email address of the creator |
| `com.adobe.creatorWorkWebsite` | Web URL of the creator |

#### IPTC Content
| Field Name | Description |
|---|---|
| `com.adobe.headline` | Brief publishable synopsis or summary |
| `com.adobe.iptcSubjectCode` | Values from IPTC Subject NewsCode Controlled Vocabulary |
| `com.adobe.descriptionWriter` | Name of person involved in writing/editing/correcting the description |
| `com.adobe.category` | Deprecated; for legacy metadata transfer |
| `com.adobe.supplementalCategories` | Deprecated; for legacy metadata transfer |
| `com.adobe.dateCreated` | IPTC-formatted creation date (e.g., "2005-09-20T15:10:55Z") |
| `com.adobe.intellectualGenre` | Nature of the image (daybook, feature, etc.) |
| `com.adobe.scene` | Values from IPTC Scene NewsCodes Controlled Vocabulary |

#### IPTC Location
| Field Name | Description |
|---|---|
| `com.adobe.location` | Details about a location shown in the image |
| `com.adobe.city` | Name of city pictured |
| `com.adobe.state` | Name of state pictured |
| `com.adobe.country` | Name of country pictured |
| `com.adobe.isoCountryCode` | 2 or 3 letter ISO 3166 Country Code |

#### IPTC Workflow
| Field Name | Description |
|---|---|
| `com.adobe.jobIdentifier` | Number or identifier for workflow control or tracking |
| `com.adobe.instructions` | Information about embargoes or other restrictions |
| `com.adobe.provider` | Name of person to credit when image is published |
| `com.adobe.source` | Original owner of the copyright |

#### Copyright / Rights
| Field Name | Description |
|---|---|
| `com.adobe.copyright` | Copyright text |
| `com.adobe.rightsUsageTerms` | Instructions on how image can legally be used |
| `com.adobe.copyrightInfoURL` | URL for copyright information |

#### Plug-in Metadata
| Field Name | Description |
|---|---|
| `com.adobe.allPluginMetadata` | All metadata defined by plug-ins |
| `(plugin ID).*` | All metadata defined by the plug-in with the given ID |
| `(plugin ID).(field ID)` | A specific plug-in provided metadata field |

#### IPTC Extension Fields (SDK 3.0+)
| Field Name | Description |
|---|---|
| `com.adobe.personInImage` | Name of a person shown in the image |
| `com.adobe.locationCreated` | Location where the photo was taken (LocationDetails structure) |
| `com.adobe.locationShown` | Location shown in the image (LocationDetails structure) |
| `com.adobe.organisationInImageName` | Name of organization featured in the image |
| `com.adobe.organisationInImageCode` | Code for identifying organization in the image |
| `com.adobe.event` | Specific event at which the photo was taken |
| `com.adobe.artworkOrObject` | Metadata about artwork or object in the image (ArtworkOrObjectDetails) |
| `com.adobe.additionalModelInfo` | Ethnicity and other facets of model(s) |
| `com.adobe.modelAge` | Age of model(s) at time image was taken |
| `com.adobe.minorModelAgeDisclosure` | Age of youngest model pictured |
| `com.adobe.modelReleaseStatus` | Availability/scope of model releases |
| `com.adobe.modelReleaseID` | PLUS-ID for each Model Release |
| `com.adobe.imageSupplier` | Most recent supplier of item (ImageSupplierDetail) |
| `com.adobe.imageSupplierImageId` | Identifier assigned by Image Supplier |
| `com.adobe.registryId` | Registry Item Id and Registry Organization Id (RegistryEntryDetail) |
| `com.adobe.maxAvailWidth` | Max available width in pixels of original photo |
| `com.adobe.maxAvailHeight` | Max available height in pixels of original photo |
| `com.adobe.digitalSourceType` | Type of digital image source (controlled vocabulary) |
| `com.adobe.imageCreator` | Creator(s) of the image (ImageCreatorDetail) |
| `com.adobe.copyrightOwner` | Copyright owner(s) (CopyrightOwnerDetail) |
| `com.adobe.licensor` | Person/company to contact for licensing (LicensorDetail) |
| `com.adobe.propertyReleaseID` | PLUS-ID for each Property Release |
| `com.adobe.propertyReleaseStatus` | Availability/scope of property releases |
| `com.adobe.digImageGUID` | Globally unique identifier for the item |
| `com.adobe.plusVersion` | Version of PLUS standards at time of transaction |

#### Video / Dynamic Media Fields (SDK 4.0+)
| Field Name | Description |
|---|---|
| `com.adobe.duration` | Duration of media file (e.g., "01:59.0") |
| `com.adobe.duration.combined.optional` | Duration + trimmed duration (if trimmed) |
| `com.adobe.trimmed_duration.optional` | Duration of trimmed media file (if trimmed) |
| `com.adobe.videoFrameRate` | Video frame rate (fps) |
| `com.adobe.videoAlphaMode` | Alpha mode (straight, pre-multiplied, or none) |
| `com.adobe.videoFrameSize` | Frame size in pixels (e.g., "640 x 480") |
| `com.adobe.audioChannelType` | Audio channel type (XMP Dynamic Media namespace) |
| `com.adobe.audioSampleRate` | Audio sample rate (e.g., 32000, 44100, 48000 Hz) |
| `com.adobe.audioSampleType` | Audio sample type |
| `com.adobe.speakerPlacement` | Speaker angles from centre front in degrees |
| `com.adobe.tapeName` | Tape name from capture process |
| `com.adobe.altTapeName` | Alternative tape name |
| `com.adobe.dm_scene` | Name of the scene |
| `com.adobe.shotName` | Name of the shot or take |
| `com.adobe.shotDate` | Date and time when video was shot |
| `com.adobe.shotLocation` | Location where video was shot |
| `com.adobe.logComment` | User's log comments |
| `com.adobe.dm_artist` | Name of the artist(s) |
| `com.adobe.album` | Name of the album |
| `com.adobe.genre` | Name of the genre |
| `com.adobe.releaseDate` | Date the title was released |
| `com.adobe.composer` | Composer's name |
| `com.adobe.engineer` | Engineer's name |
| `com.adobe.instrument` | Musical instrument |
| `com.adobe.comment` | User's comments |
| `com.adobe.client` | Client for the job |
| `com.adobe.good` | Keeper selection tracking |
| `com.adobe.projectName` | Name of the project |
| `com.adobe.director` | Director of the scene |
| `com.adobe.directorPhotography` | Director of photography |
| `com.adobe.cameraModel` | Make and model of camera |
| `com.adobe.cameraAngle` | Camera orientation to subject (XMP Dynamic Media vocabulary) |
| `com.adobe.cameraMove` | Camera movement during shot (XMP Dynamic Media vocabulary) |
| `com.adobe.shotDay` | Day in a multiday shoot (e.g., "Day 2", "Friday") |

#### DNG-Specific Fields (SDK 4.0+)
| Field Name | Description |
|---|---|
| `com.adobe.dng.version` | DNG standard version |
| `com.adobe.dng.backwardVersion` | DNG backward compatibility version |
| `com.adobe.dng.compatibility` | Earliest compatible Lightroom version |
| `com.adobe.dng.hasFastLoadData` | Whether DNG has fast load data (e.g., "Embedded") |
| `com.adobe.dng.lossyCompression` | Whether DNG uses lossy compression (e.g., "No") |
| `com.adobe.dng.hasEmbeddedOriginalRawFile` | Whether DNG has embedded original raw (e.g., "None Embedded") |
| `com.adobe.dng.hasMosaicData` | Whether DNG contains mosaic data (e.g., "Yes") |
| `com.adobe.dng.hasTransparency` | Whether DNG contains transparency data (e.g., "No") |
| `com.adobe.dng.floatingPointType` | Integer or floating point pixel data (e.g., "Integer") |
| `com.adobe.dng.bitsPerSample` | Bits per DNG data sample |
| `com.adobe.dng.originalRawFileName` | Name of original raw file used to create DNG |
| `com.adobe.dng.originalImageDimensions` | Dimensions of original raw file (e.g., "4288 x 2848") |
| `com.adobe.dng.imageDimensions` | Dimensions of the DNG file (e.g., "4288 x 2848") |
| `com.adobe.dng.previewDimensions` | Dimensions of embedded preview (e.g., "3882 x 2579") |

---


### LrPhoto Raw Metadata Keys

#### Raw Metadata Keys (SDK 1.3)

| Key | Return Type | Description |
|-----|-------------|-------------|
| `fileSize` | number | The size of the file in bytes, or, if the file is offline but there is a smart preview, the size of the smart preview in bytes |
| `rating` | number | The user rating of the file (either nil or number of stars) |
| `dimensions` | table | The original dimensions of file (e.g., `{ width = 2304, height = 3072 }`) |
| `croppedDimensions` | table | The cropped dimensions of file (e.g., `{ width = 2304, height = 3072 }`) |
| `shutterSpeed` | number | The shutter speed, in seconds (e.g., 1/60 sec = 0.016666) |
| `aperture` | number | The denominator of the aperture (e.g., 2.8) |
| `exposureBias` | number | The exposure bias/compensation (e.g., -0.666666) |
| `flash` | Boolean | Whether flash fired (true = fired; false = did not fire; nil = unknown) |
| `isoSpeedRating` | number | The ISO speed rating (e.g., 200) |
| `focalLength` | number | The focal length of lens as shot, in millimeters (e.g., 132) |
| `focalLength35mm` | number | The focal length as 35mm equivalent, in millimeters (e.g., 211.2) |
| `dateTimeOriginal` | number | The date and time of capture (seconds since midnight GMT January 1, 2001) |
| `dateTimeDigitized` | number | The date and time of scanning (seconds since midnight GMT January 1, 2001) |
| `dateTime` | number | The adjusted date and time (seconds since midnight GMT January 1, 2001) |
| `gps` | table | The location of this photo (e.g., `{ latitude = 37.9362, longitude = 27.3451 }`) |
| `gpsAltitude` | number | The GPS altitude for this photo, in meters (e.g., 82.317) |
| `countVirtualCopies` | number | The number of virtual copies. Zero if this photo is itself a virtual copy. |
| `virtualCopies` | array of LrPhoto | All virtual copies of this photo. |
| `masterPhoto` | LrPhoto | The master photo from which this virtual copy is derived. |
| `isVirtualCopy` | Boolean | True if this photo is a virtual copy of another photo. |
| `countStackInFolderMembers` | number | The number of members of the stack this photo is in. |
| `stackInFolderMembers` | array of LrPhoto | All members of the stack this photo is in. |
| `isInStackInFolder` | Boolean | True if the photo is in a stack. |
| `stackInFolderIsCollapsed` | Boolean | True if the stack containing this photo is collapsed. |
| `stackPositionInFolder` | number | Position in stack. Top = 1; others numbered from 2. |
| `topOfStackInFolderContainingPhoto` | LrPhoto | The parent photo of the stack containing this photo. |
| `colorNameForLabel` | string | Color name for the label. One of 'red', 'yellow', 'green', 'blue', 'purple', 'none'. |

#### Raw Metadata Keys (SDK 2.0)

| Key | Return Type | Description |
|-----|-------------|-------------|
| `fileFormat` | string | The format of the file. One of 'RAW', 'DNG', 'JPG', 'PSD', 'TIFF', or 'VIDEO'. |
| `width` | number | The width of the original source photo in pixels. |
| `height` | number | The height of the original source photo in pixels. |
| `aspectRatio` | number | The aspect ratio (width / height). E.g., 1.5 for landscape 35mm. |
| `isCropped` | Boolean | True if the photo has been cropped from its original dimensions. |
| `dateTimeOriginalISO8601` | string | The date and time of capture (ISO 8601 string format). |
| `dateTimeDigitizedISO8601` | string | The date and time of scanning (ISO 8601 string format). |
| `dateTimeISO8601` | string | The adjusted date and time (ISO 8601 string format). |
| `lastEditTime` | number | The date and time of the last edit (seconds since midnight GMT January 1, 2001). |
| `editCount` | number | Counter for edits on this photo. (Consecutive changes within a few seconds count as one.) |
| `copyrightState` | string | One of 'unknown', 'copyrighted', or 'public domain'. |

#### Raw Metadata Keys (SDK 3.0)

| Key | Return Type | Description |
|-----|-------------|-------------|
| `uuid` | string | Persistent ID for this photo. |
| `path` | string | The current path to the photo file if available; otherwise, the last known path. |
| `isVideo` | boolean | True if this file is a video. |
| `durationInSeconds` | number | The duration in seconds if the file is a video. |
| `keywords` | array of `LrKeyword` | The list of keyword objects for the photo. |
| `customMetadata` | table | Custom metadata for this photo. Each element is a table with: `id` (string), `value` (any), `sourcePlugin` (string). |

#### Raw Metadata Keys (SDK 4.0)

| Key | Return Type | Description |
|-----|-------------|-------------|
| `pickStatus` | number | 1 = 'picked', 0 = flag not set, -1 = 'rejected'. |

#### Raw Metadata Keys (SDK 4.1)

| Key | Return Type | Description |
|-----|-------------|-------------|
| `trimmedDurationInSeconds` | number | If video, the trimmed duration in seconds; otherwise nil. |
| `durationRatio` | table | If video, a table with keys 'numerator' and 'denominator' for untrimmed duration; otherwise nil. |
| `trimmedDurationRatio` | table | If video, a table with keys 'numerator' and 'denominator' for trimmed duration; otherwise nil. |
| `locationIsPrivate` | Boolean | True if the photo's location has been marked as private. |

#### Raw Metadata Keys (SDK 5.0)

| Key | Return Type | Description |
|-----|-------------|-------------|
| `smartPreviewInfo` | table | Info about the smart preview. If none exists, the table is empty. Contains: `smartPreviewPath` (string), `smartPreviewSize` (number, bytes). |

#### Raw Metadata Keys (SDK 6.0)

| Key | Return Type | Description |
|-----|-------------|-------------|
| `gpsImgDirection` | number | The GPS direction in degrees (e.g., 312.23). Only up to four digits beyond the decimal point are stored. |

---


### LrPhoto Formatted Metadata Keys

#### Formatted Metadata Keys (SDK 1.3)

| Key | Return Type | Description |
|-----|-------------|-------------|
| `keywordTags` | string | Keywords as in Keyword Tags panel (Enter Keywords selected). The exact set of tags directly applied, no filtering. |
| `keywordTagsForExport` | string | Keywords as in Keyword Tags panel (Will Export selected). Removes hidden tags, inserts ancestor tags. (SDK 2.0+) |
| `fileName` | string | The leaf name of the file (e.g., "myFile.jpg") |
| `preservedFileName` | string | The preserved file name of the file |
| `copyName` | string | The name associated with this copy |
| `folderName` | string | The name of the folder the file is in |
| `fileSize` | string | The formatted size of the file (e.g., "6.01 MB"), or smart preview size if offline |
| `fileType` | string | The user-visible file type (DNG, RAW, etc.) |
| `rating` | number | The user rating (either nil or number of stars) |
| `label` | string | The name of assigned color label |
| `title` | string | The title of photo |
| `caption` | string | The caption for photo |
| `dimensions` | string | The original dimensions (e.g., "3072 x 2304") |
| `croppedDimensions` | string | The cropped dimensions (e.g., "3072 x 2304") |
| `exposure` | string | The exposure summary (e.g., "1/60 sec at f/2.8") |
| `shutterSpeed` | string | The shutter speed (e.g., "1/60 sec") |
| `aperture` | string | The aperture (e.g., "f/2.8") |
| `brightnessValue` | string | The brightness value |
| `exposureBias` | string | The exposure bias/compensation (e.g., "-2/3 EV") |
| `flash` | string | Whether the flash fired or not (e.g., "Did fire") |
| `exposureProgram` | string | The exposure program (e.g., "Aperture priority") |
| `meteringMode` | string | The metering mode (e.g., "Pattern") |
| `isoSpeedRating` | string | The ISO speed rating (e.g., "ISO 200") |
| `focalLength` | string | The focal length as shot (e.g., "132 mm") |
| `focalLength35mm` | string | The focal length as 35mm equivalent (e.g., "211 mm") |
| `lens` | string | The lens (e.g., "28.0-135.0 mm") |
| `subjectDistance` | string | The subject distance (e.g., "3.98 m") |
| `dateTimeOriginal` | string | Date and time of capture (e.g., "09/15/2005 17:32:50"). Formatting varies by locale. |
| `dateTimeDigitized` | string | Date and time of scanning. Formatting varies by locale. |
| `dateTime` | string | Adjusted date and time. Formatting varies by locale. |
| `cameraMake` | string | The camera manufacturer |
| `cameraModel` | string | The camera model |
| `cameraSerialNumber` | string | The camera serial number |
| `artist` | string | The artist's name |
| `software` | string | The software used to process/create photo |
| `gps` | string | The location (e.g., "37deg56'10\" N 27deg20'42\" E") |
| `gpsAltitude` | string | The GPS altitude (e.g., "82.3 m") |
| `creator` | string | The name of the person that created this image |
| `creatorJobTitle` | string | The job title of the creator |
| `creatorAddress` | string | The address for the creator |
| `creatorCity` | string | The city for the creator |
| `creatorStateProvince` | string | The state or province for the creator |
| `creatorPostalCode` | string | The postal code for the creator |
| `creatorCountry` | string | The country for the creator |
| `creatorPhone` | string | The phone number for the creator |
| `creatorEmail` | string | The email address for the creator |
| `creatorUrl` | string | The web URL for the creator |
| `headline` | string | A brief, publishable synopsis or summary of the contents |
| `iptcSubjectCode` | string | Values from the IPTC Subject NewsCode Controlled Vocabulary |
| `descriptionWriter` | string | The person who wrote, edited or corrected the description |
| `iptcCategory` | string | Deprecated field; for legacy metadata |
| `iptcOtherCategories` | string | Deprecated field; for legacy metadata |
| `dateCreated` | string | The IPTC-formatted creation date (e.g., "2005-09-20T15:10:55Z") |
| `intellectualGenre` | string | Nature of the image (e.g., daybook, feature) |
| `scene` | string | Values from the IPTC Scene NewsCodes Controlled Vocabulary |
| `location` | string | Details about a location shown in this image |
| `city` | string | The name of the city shown in this image |
| `stateProvince` | string | The name of the state shown in this image |
| `country` | string | The name of the country shown in this image |
| `isoCountryCode` | string | The 2 or 3 letter ISO 3166 Country Code |
| `jobIdentifier` | string | A number or identifier for workflow control or tracking |
| `instructions` | string | Information about embargoes or other restrictions |
| `provider` | string | Name of person to be credited when published |
| `source` | string | The original owner of the copyright |
| `copyright` | string | The copyright text |
| `copyrightState` | string | The copyright state |
| `rightsUsageTerms` | string | Instructions on legal use |
| `copyrightInfoUrl` | string | The copyright info URL |

#### Formatted Metadata Keys (SDK 3.0) -- IPTC Extension / PLUS

| Key | Return Type | Description |
|-----|-------------|-------------|
| `personShown` | string | Name of a person shown in this image |
| `locationCreated` | table | The location where the photo was taken. Each element is a LocationDetails structure (IPTC Extension). |
| `locationShown` | table | The location shown in this image. Each element is a LocationDetails structure (IPTC Extension). |
| `nameOfOrgShown` | string | Name of organization or company featured |
| `codeOfOrgShown` | string | Code from controlled vocabulary for identifying the org |
| `event` | string | Names or describes the specific event at which the photo was taken |
| `artworksShown` | table | Artwork/object metadata. Each element is an ArtworkOrObjectDetails structure (IPTC Extension). |
| `additionalModelInfo` | string | Info about ethnicity and other facets of models |
| `modelAge` | string | Age of human models at the time the image was taken |
| `minorModelAge` | string | Age of the youngest model at the time the image was made |
| `modelReleaseStatus` | string | Availability and scope of model releases |
| `modelReleaseID` | string | A PLUS-ID identifying each Model Release |
| `imageSupplier` | table | Most recent supplier. Each element is an ImageSupplierDetail (PLUS). |
| `imageSupplierImageId` | string | Identifier assigned by the Image Supplier |
| `registryId` | table | Registry Item Id and Registry Organization Id. Each element is a RegistryEntryDetail (IPTC Extension). |
| `maxAvailWidth` | number | Max available width in pixels of the original photo |
| `maxAvailHeight` | number | Max available height in pixels of the original photo |
| `sourceType` | string | Type of source of this digital image (from controlled vocabulary) |
| `imageCreator` | table | Creator(s) of the image. Each element is an ImageCreatorDetail (PLUS). |
| `copyrightOwner` | table | Copyright owner(s). Each element is a CopyrightOwnerDetail (PLUS). |
| `licensor` | table | Person or company for licensing. Each element is a LicensorDetail (PLUS). |
| `propertyReleaseID` | string | A PLUS-ID identifying each Property Release |
| `propertyReleaseStatus` | string | Availability and scope of property releases |
| `digImageGUID` | string | Globally unique identifier for the item |
| `plusVersion` | string | The version number of the PLUS standards at the time of the transaction |

#### Formatted Metadata Keys (SDK 6.0)

| Key | Return Type | Description |
|-----|-------------|-------------|
| `gpsImgDirection` | string | The GPS direction (e.g., "South-East") |

---


### LrPhoto Writable Metadata Keys

#### Writable Metadata Keys (SDK 2.0)

| Key | Value Type | Description |
|-----|------------|-------------|
| `rating` | number | The user rating (either nil or number of stars) |
| `label` | string | The name of assigned color label |
| `title` | string | The title of this photo |
| `caption` | string | The caption for this photo |
| `copyName` | string | The name associated with this copy |
| `creator` | string | The name of the person that created this image |
| `creatorJobTitle` | string | The job title of the creator |
| `creatorAddress` | string | The address for the creator |
| `creatorCity` | string | The city for the creator |
| `creatorStateProvince` | string | The state or province for the creator |
| `creatorPostalCode` | string | The postal code for the creator |
| `creatorCountry` | string | The country for the creator |
| `creatorPhone` | string | The phone number for the creator |
| `creatorEmail` | string | The email address for the creator |
| `creatorUrl` | string | The web URL for the creator |
| `headline` | string | A brief, publishable synopsis or summary |
| `iptcSubjectCode` | string | IPTC Subject NewsCode Controlled Vocabulary values |
| `descriptionWriter` | string | The person who wrote, edited, or corrected the description |
| `iptcCategory` | string | Deprecated field; for legacy metadata |
| `iptcOtherCategories` | string | Deprecated field; for legacy metadata |
| `dateCreated` | string | IPTC-formatted creation date (e.g., "2005-09-20T15:10:55Z") |
| `intellectualGenre` | string | Nature of the image (e.g., daybook, feature) |
| `scene` | string | IPTC Scene NewsCodes values |
| `location` | string | Details about a location in this image |
| `city` | string | The city shown in this image |
| `stateProvince` | string | The state shown in this image |
| `country` | string | The country shown in this image |
| `isoCountryCode` | string | 2 or 3 letter ISO 3166 Country Code |
| `jobIdentifier` | string | A number or identifier for workflow control or tracking |
| `instructions` | string | Info about embargoes or other restrictions |
| `provider` | string | Name of person to be credited when published |
| `source` | string | The original owner of the copyright |
| `copyright` | string | The copyright text |
| `copyrightState` | string | One of 'unknown', 'copyrighted', or 'public domain' |
| `rightsUsageTerms` | string | Instructions on legal use |
| `copyrightInfoUrl` | string | The copyright info URL |
| `colorNameForLabel` | string | One of 'red', 'yellow', 'green', 'blue', 'purple', 'none' (not case sensitive). Other strings show white label. |

#### Writable Metadata Keys (SDK 3.0) -- IPTC Extension / PLUS

| Key | Value Type | Description |
|-----|------------|-------------|
| `personShown` | string | Name of a person shown in this image |
| `locationCreated` | table | Locations shown; each element is a LocationDetails structure (IPTC Extension) |
| `locationShown` | table | Locations where taken; each element is a LocationDetails structure (IPTC Extension) |
| `nameOfOrgShown` | string | Name of organization or company featured |
| `codeOfOrgShown` | string | Code for identifying the organization |
| `event` | string | The specific event at which the photo was taken |
| `artworksShown` | table | Artwork metadata; each element is an ArtworkOrObjectDetails (IPTC Extension) |
| `additionalModelInfo` | string | Info about ethnicity and other facets of models |
| `modelAge` | string | Age of human models at time image was taken |
| `minorModelAge` | string | Age of youngest model at time image was made |
| `modelReleaseStatus` | string | Availability and scope of model releases |
| `modelReleaseID` | string | A PLUS-ID for each Model Release |
| `imageSupplier` | table | Most recent supplier; each element is an ImageSupplierDetail (PLUS) |
| `imageSupplierImageId` | string | Identifier assigned by the Image Supplier |
| `registryId` | table | Registry Item ID and Organization ID; each element is a RegistryEntryDetail (IPTC Extension) |
| `maxAvailWidth` | number | Max available width in pixels of the original |
| `maxAvailHeight` | number | Max available height in pixels of the original |
| `sourceType` | string | Type of source of this digital image |
| `imageCreator` | table | Creator(s); each element is an ImageCreatorDetail (PLUS) |
| `copyrightOwner` | table | Copyright owner(s); each element is a CopyrightOwnerDetail (PLUS) |
| `licensor` | table | Licensor contact; each element is a LicensorDetail (PLUS) |
| `propertyReleaseID` | string | A PLUS-ID for each Property Release |
| `propertyReleaseStatus` | string | Availability and scope of property releases |

#### Writable Metadata Keys (SDK 4.0)

| Key | Value Type | Description |
|-----|------------|-------------|
| `gps` | table | Location, e.g. `{ latitude = 35.1, longitude = 86.7 }`. Pass nil to unset. |
| `gpsAltitude` | number | GPS altitude in meters (e.g., 82.3) |
| `pickStatus` | number | 1 = 'picked', 0 = 'not set', -1 = 'rejected' |

#### Writable Metadata Keys (SDK 6.0)

| Key | Value Type | Description |
|-----|------------|-------------|
| `gpsImgDirection` | number | GPS direction in degrees (e.g., 312.23). Up to four decimal digits stored. |

---
<!-- END OFFICIAL_METADATA_KEYS -->
