# LrPhoto -- Lightroom Classic SDK 11.4 API Reference

An object of this class represents a single photo or virtual copy in Lightroom's active catalog. Use the functions to access metadata stored with the image, or to associate your own data with a photo.

Objects of this type are returned by various functions of `LrCatalog` and `LrExportSession`.

---

## Properties

### photo.catalog
- **Type:** `LrCatalog` (Read-Only)
- **Description:** The catalog object that contains this photo.
- **Since:** 1.3

### photo.localIdentifier
- **Type:** number (Read-Only)
- **Description:** The local identifier of the photo, unique within this catalog.
- **Since:** 4.0

---

## Methods by Category

---

## 1. Keyword Methods

### addKeyword
- **Signature:** `photo:addKeyword( keyword )`
- **Parameters:** keyword (`LrKeyword`) -- The keyword object.
- **Returns:** (none)
- **Since:** 3.0
- **Notes:** Must be called from within a `catalog:withWriteAccessDo` or `catalog:withProlongedWriteAccessDo` gate. Can be used within the same `catalog:with___WriteAccessDo` call that created the keyword.

### removeKeyword
- **Signature:** `photo:removeKeyword( keyword )`
- **Parameters:** keyword (`LrKeyword`) -- The keyword object.
- **Returns:** (none)
- **Since:** 3.0
- **Notes:** Must be called from within a `catalog:withWriteAccessDo` or `catalog:withProlongedWriteAccessDo` gate. Can be used within the same `catalog:with___WriteAccessDo` call that created the keyword.

---

## 2. Metadata Retrieval Methods

### getRawMetadata
- **Signature:** `photo:getRawMetadata( key )`
- **Parameters:** key (string) -- The metadata item to retrieve, or nil to get all available metadata fields.
- **Returns:** (any) The value of the specified metadata property as the appropriate data type, or nil if not applicable. If no key is specified, returns a table of all available metadata fields as key/value pairs.
- **Since:** 1.3
- **Notes:** As of version 2.0, ISO8601 strings are generally more reliable than the Cocoa date stamp. As of Lightroom 3.0, no longer needs to be called from within one of the `catalog:with___AccessDo` gates, but must be called from within a task started using `LrTasks`.

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

### getFormattedMetadata
- **Signature:** `photo:getFormattedMetadata( key )`
- **Parameters:** key (string) -- Which metadata item to retrieve, or nil to return a table of all available fields as key/value pairs.
- **Returns:** (string or table) The formatted-string value of the specified metadata property, or nil if not applicable. If no key is specified, returns a table of all available metadata fields as key/value pairs.
- **Since:** 1.3
- **Notes:** Metadata is formatted as shown in the metadata panel. The returned value strings are formatted for display; you should not attempt to parse them. As of Lightroom 3.0, no longer needs to be called from within one of the `catalog:with___AccessDo` gates, but must be called from within a task started using `LrTasks`.

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

### getPropertyForPlugin
- **Signature:** `photo:getPropertyForPlugin( plugin, fieldId, optVersion, noThrow )`
- **Parameters:**
  - plugin (string or `_PLUGIN`) -- The plug-in object or unique identifying string for the plug-in that declares this field.
  - fieldId (string) -- The metadata field's unique identifying key.
  - optVersion (optional, number) -- The version number for the field (only valid in schema update handlers).
  - noThrow (optional, Boolean) -- True to return `(nil, error)` instead of throwing an exception on error. (SDK 3.0+)
- **Returns:**
  1. (any) The value of the specified metadata property, or nil if not applicable. If no key is specified, returns a table of all available metadata fields as key/value pairs.
  2. An error message on error, if `noThrow` is true.
- **Since:** 2.0
- **Notes:** As of Lightroom 3.0, no longer needs to be called from within one of the `catalog:with___AccessDo` gates, but must be called from within an asynchronous task started using `LrTasks`.

---

## 3. Metadata Write Methods

### setRawMetadata
- **Signature:** `photo:setRawMetadata( key, value )`
- **Parameters:**
  - key (string) -- The metadata item to set. See writable keys below.
  - value (any) -- The value to set. String if not otherwise specified.
- **Returns:** (none)
- **Since:** 2.0
- **Notes:** Must be called from within a `catalog:withWriteAccessDo` or `catalog:withProlongedWriteAccessDo` gate.

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

### setPropertyForPlugin
- **Signature:** `photo:setPropertyForPlugin( plugin, fieldId, value, optVersion )`
- **Parameters:**
  - plugin (`_PLUGIN`) -- The plug-in object.
  - fieldId (string) -- The field name, as declared in an `LrMetadataProvider` script.
  - value (string) -- The new value for this field. Must agree with the declared data type.
  - optVersion (optional, number) -- The version number for the field (only valid in schema update handlers). (SDK 3.0+)
- **Returns:** (none)
- **Since:** 2.0
- **Notes:** Must be called from within one of the `catalog:withWriteAccessDo` gates (including `withPrivateWriteAccessDo`).

### applyMetadataPreset
- **Signature:** `photo:applyMetadataPreset( presetId )`
- **Parameters:** presetId (string) -- The unique identifier of the metadata preset. See `LrApplication.metadataPresets`.
- **Returns:** (none)
- **Since:** 3.0
- **Notes:** Must be called from within a `catalog:withWriteAccessDo` or `catalog:withProlongedWriteAccessDo` gate.

---

## 4. Develop Settings Methods

### getDevelopSettings
- **Signature:** `photo:getDevelopSettings()`
- **Parameters:** (none)
- **Returns:** (table) Develop settings table. See full key listing below.
- **Since:** 3.0
- **Notes:** Must be called from within a task started using `LrTasks`. **WARNING:** The develop settings APIs are considered experimental. You should not depend on the contents of the settings table remaining compatible in future versions of Lightroom. The definitive list is the one shown in the UI.

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

### applyDevelopSettings
- **Signature:** `photo:applyDevelopSettings( settings, optHistoryName, optFlattenAutoNow )`
- **Parameters:**
  - settings (table) -- Table of settings to be applied.
  - optHistoryName (optional, string) -- Name of the history step.
  - optFlattenAutoNow (optional, boolean) -- True to resolve Auto settings synchronously within the context of this API call.
- **Returns:** (none)
- **Since:** 6.0
- **Notes:** For this call to be successful, the caller must ensure that the photo exists and it is an image, not a video.

### applyDevelopPreset
- **Signature:** `photo:applyDevelopPreset( preset, plugin, presetAmount )`
- **Parameters:**
  - preset (`LrDevelopPreset`) -- The preset object.
  - plugin (optional, `_PLUGIN`) -- The plug-in object with which the preset is associated, if the preset was obtained using `LrApplication:getDevelopPresetsForPlugin()`.
  - presetAmount (optional, integer) -- Preset amount value. The range is 0 to 200.
- **Returns:** (none)
- **Since:** 3.0
- **Notes:** Must be called from within a `catalog:withWriteAccessDo` or `catalog:withProlongedWriteAccessDo` gate.
- **See also:** `LrDevelopPreset`

### copySettings
- **Signature:** `photo:copySettings()`
- **Parameters:** (none)
- **Returns:** (Boolean) True if copy settings is successful.
- **Since:** 10.3
- **Notes:** Must be called from within an asynchronous task started using `LrTasks`. The caller must ensure that the photo exists.

### pasteSettings
- **Signature:** `photo:pasteSettings()`
- **Parameters:** (none)
- **Returns:** (Boolean) True if paste settings is successful.
- **Since:** 10.3
- **Notes:** The caller must ensure that the photo exists.

---

## 5. Develop Snapshot Methods

### createDevelopSnapshot
- **Signature:** `photo:createDevelopSnapshot( snapshotName, updateInPlace )`
- **Parameters:**
  - snapshotName (string) -- The name of the new snapshot.
  - updateInPlace (Boolean) -- True to update the snapshot in place if one already exists with this name. If false, take no action and return false.
- **Returns:** (Boolean) True on success. False if a snapshot with this name already exists and was not updated.
- **Since:** 3.0
- **Notes:** Must be called from within a `catalog:withWriteAccessDo` or `catalog:withProlongedWriteAccessDo` gate.

### getDevelopSnapshots
- **Signature:** `photo:getDevelopSnapshots()`
- **Parameters:** (none)
- **Returns:** (table) A table of tables, one for each snapshot. Each snapshot entry contains `snapshotID`, `name`, and `id_global`.
- **Since:** 3.2

### applyDevelopSnapshot
- **Signature:** `photo:applyDevelopSnapshot( id )`
- **Parameters:** id (string) -- ID of the snapshot to be applied.
- **Returns:** (none)
- **Since:** 3.2

### deleteDevelopSnapshot
- **Signature:** `photo:deleteDevelopSnapshot( id )`
- **Parameters:** id (string) -- ID of the snapshot to be deleted.
- **Returns:** (none)
- **Since:** 5.0

---

## 6. Quick Develop Methods

### quickDevelopAdjustImage
- **Signature:** `photo:quickDevelopAdjustImage( settingName, size )`
- **Parameters:**
  - settingName (string) -- Can be "Exposure", "Contrast", "Highlights", "Shadows", "Whites", "Blacks", "Clarity", "Vibrance", "Saturation".
  - size (string or number) -- Can be "small", "large", or a number.
- **Returns:** (none)
- **Since:** 7.4

### quickDevelopAdjustWhiteBalance
- **Signature:** `photo:quickDevelopAdjustWhiteBalance( settingName, amount )`
- **Parameters:**
  - settingName (string) -- White Balance parameter name ("Temperature" or "Tint").
  - amount (number) -- Incremental number.
- **Returns:** (none)
- **Since:** 7.4

### quickDevelopSetTreatment
- **Signature:** `photo:quickDevelopSetTreatment( value )`
- **Parameters:** value (string) -- Can be "color" or "grayscale".
- **Returns:** (none)
- **Since:** 7.4

### quickDevelopSetWhiteBalance
- **Signature:** `photo:quickDevelopSetWhiteBalance( value )`
- **Parameters:** value (string) -- Can be "Auto", "Daylight", "Cloudy", "Shade", "Tungsten", "Fluorescent", or "Flash" as applicable to the image type.
- **Returns:** (none)
- **Since:** 7.4

### quickDevelopSetWhiteBalacne (Deprecated)
- **Signature:** `photo:quickDevelopSetWhiteBalacne( value )`
- **Parameters:** value (string) -- Can be "Auto", "Daylight", "Cloudy", "Shade", "Tungsten", "Fluorescent", or "Flash" as applicable to the image type.
- **Returns:** (none)
- **Since:** 7.4
- **Notes:** Deprecated API -- included for avoiding breakage of plugins. Note the typo in the method name ("Balacne" instead of "Balance"). Use `quickDevelopSetWhiteBalance` instead.

### quickDevelopCropAspect
- **Signature:** `photo:quickDevelopCropAspect( aspectRatio )`
- **Parameters:** aspectRatio (string or table) -- Can be "original", "asshot", or a table specifying Crop Ratio with `w` and `h` values.
- **Returns:** (none)
- **Since:** 7.4

---

## 7. Smart Preview Methods

### buildSmartPreview
- **Signature:** `photo:buildSmartPreview()`
- **Parameters:** (none)
- **Returns:** (string) A string indicating the result: 'created' if a smart preview was built, 'existed' if a smart preview already existed, 'failed' if smart preview creation failed (e.g., invoked on a video).
- **Since:** 5.0
- **Notes:** Does nothing for video. Must be called from within an asynchronous task started using `LrTasks`.

### deleteSmartPreview
- **Signature:** `photo:deleteSmartPreview()`
- **Parameters:** (none)
- **Returns:** (string) 'deleted' if deletion was successful, 'failed' if deletion failed. In the failure case, a second string may be returned with more detail about the error.
- **Since:** 5.0
- **Notes:** Does nothing for video. This is a blocking call.

---

## 8. Collection Methods

### getContainedCollections
- **Signature:** `photo:getContainedCollections()`
- **Parameters:** (none)
- **Returns:** (table of `LrCollection`) The list of collection objects.
- **Since:** 3.0
- **Notes:** Only standard collections are listed; smart collections are not included. Must be called from within an asynchronous task started using `LrTasks`.
- **See also:** `LrCollection`

### getContainedPublishedCollections
- **Signature:** `photo:getContainedPublishedCollections()`
- **Parameters:** (none)
- **Returns:** (table of `LrPublishedCollection`) The list of published collection objects.
- **Since:** 3.0
- **Notes:** Only standard published collections are listed; smart published collections are not included. Must be called from within an asynchronous task started using `LrTasks`.
- **See also:** `LrPublishedCollection`

### addOrRemoveFromTargetCollection
- **Signature:** `photo:addOrRemoveFromTargetCollection()`
- **Parameters:** (none)
- **Returns:** (none)
- **Since:** 7.4
- **Notes:** Adds or removes photos from the Target Collection.

---

## 9. Export Methods

### openExportDialog
- **Signature:** `photo:openExportDialog()`
- **Parameters:** (none)
- **Returns:** (none)
- **Since:** 7.4
- **Notes:** Opens the export dialog for the current photo.

### openExportWithPreviousDialog
- **Signature:** `photo:openExportWithPreviousDialog()`
- **Parameters:** (none)
- **Returns:** (none)
- **Since:** 7.4
- **Notes:** Opens export with previous settings for the current photo.

---

## 10. Naming Methods

### getNameViaPreset
- **Signature:** `photo:getNameViaPreset( filenamePresetId, customString, sequenceNumber )`
- **Parameters:**
  - filenamePresetId (string) -- The unique identifier of the filename preset.
  - customString (string) -- The name string.
  - sequenceNumber (number) -- The sequence number to append to the name string.
- **Returns:** (string) The new name.
- **Since:** 3.0
- **Notes:** See `LrApplication.filenamePresets`. Must be called from within an asynchronous task started using `LrTasks`.

---

## 11. Thumbnail Methods

### requestJpegThumbnail
- **Signature:** `photo:requestJpegThumbnail( width, height, callback )`
- **Parameters:**
  - width (optional, number) -- The width of the thumbnail you're requesting. Nil returns the smallest preview.
  - height (optional, number) -- If specifying width, this controls the height of the pixels returned.
  - callback (function) -- Called when the thumbnail is available. Receives JPEG data on success, or `(nil, errorString)` on failure.
- **Returns:** (object) Request object. Hold a reference to this object until your callback is called, then release it.
- **Since:** 5.0
- **Notes:** If the preview system does not already contain a preview at the requested size, one will be rendered. Request sizes are treated as minimums; the returned preview may be larger. If both dimensions are specified, the smallest preview satisfying either one is returned. Must be called from within an asynchronous task started using `LrTasks`.

---

## 12. Rotation Methods

### rotateLeft
- **Signature:** `photo:rotateLeft()`
- **Parameters:** (none)
- **Returns:** (none)
- **Since:** 7.4
- **Notes:** Rotates the photo to the left.

### rotateRight
- **Signature:** `photo:rotateRight()`
- **Parameters:** (none)
- **Returns:** (none)
- **Since:** 7.4
- **Notes:** Rotates the photo to the right.

---

## 13. Availability Check

### checkPhotoAvailability
- **Signature:** `photo:checkPhotoAvailability()`
- **Parameters:** (none)
- **Returns:** (Boolean) True if the file is thought to exist at this time.
- **Since:** 2.0
- **Notes:** Reports whether this photo is believed to be present on disk. This is not a guarantee (volumes might be disconnected at any time), but a reasonably good estimate. If true, proceed but be prepared for failure. If false, skip the file operation. Must be called from within an asynchronous task started using `LrTasks`.

---

## 14. Type Inspection

### type
- **Signature:** `photo:type()`
- **Parameters:** (none)
- **Returns:** (string) `'LrPhoto'`
- **Since:** 4.1

---

## Complete Method Index (Alphabetical)

| # | Method | Since | Category |
|---|--------|-------|----------|
| 1 | `addKeyword` | 3.0 | Keywords |
| 2 | `addOrRemoveFromTargetCollection` | 7.4 | Collections |
| 3 | `applyDevelopPreset` | 3.0 | Develop Settings |
| 4 | `applyDevelopSettings` | 6.0 | Develop Settings |
| 5 | `applyDevelopSnapshot` | 3.2 | Develop Snapshots |
| 6 | `applyMetadataPreset` | 3.0 | Metadata Write |
| 7 | `buildSmartPreview` | 5.0 | Smart Previews |
| 8 | `checkPhotoAvailability` | 2.0 | Availability |
| 9 | `copySettings` | 10.3 | Develop Settings |
| 10 | `createDevelopSnapshot` | 3.0 | Develop Snapshots |
| 11 | `deleteDevelopSnapshot` | 5.0 | Develop Snapshots |
| 12 | `deleteSmartPreview` | 5.0 | Smart Previews |
| 13 | `getContainedCollections` | 3.0 | Collections |
| 14 | `getContainedPublishedCollections` | 3.0 | Collections |
| 15 | `getDevelopSettings` | 3.0 | Develop Settings |
| 16 | `getDevelopSnapshots` | 3.2 | Develop Snapshots |
| 17 | `getFormattedMetadata` | 1.3 | Metadata Retrieval |
| 18 | `getNameViaPreset` | 3.0 | Naming |
| 19 | `getPropertyForPlugin` | 2.0 | Metadata Retrieval |
| 20 | `getRawMetadata` | 1.3 | Metadata Retrieval |
| 21 | `openExportDialog` | 7.4 | Export |
| 22 | `openExportWithPreviousDialog` | 7.4 | Export |
| 23 | `pasteSettings` | 10.3 | Develop Settings |
| 24 | `quickDevelopAdjustImage` | 7.4 | Quick Develop |
| 25 | `quickDevelopAdjustWhiteBalance` | 7.4 | Quick Develop |
| 26 | `quickDevelopCropAspect` | 7.4 | Quick Develop |
| 27 | `quickDevelopSetTreatment` | 7.4 | Quick Develop |
| 28 | `quickDevelopSetWhiteBalance` | 7.4 | Quick Develop |
| 29 | `quickDevelopSetWhiteBalacne` | 7.4 | Quick Develop (Deprecated) |
| 30 | `removeKeyword` | 3.0 | Keywords |
| 31 | `requestJpegThumbnail` | 5.0 | Thumbnails |
| 32 | `rotateLeft` | 7.4 | Rotation |
| 33 | `rotateRight` | 7.4 | Rotation |
| 34 | `setPropertyForPlugin` | 2.0 | Metadata Write |
| 35 | `setRawMetadata` | 2.0 | Metadata Write |
| 36 | `type` | 4.1 | Type Inspection |
