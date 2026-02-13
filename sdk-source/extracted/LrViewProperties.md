# LrView Properties -- Complete API Reference

Extracted from Lightroom Classic SDK 11.4 official API reference HTML files.

All properties are marked **Read-Only** in the SDK documentation (set at view creation time via the view description table, not modifiable afterward). Many properties support data binding via `LrView.bind()`.

---

## 1. General View Properties

**Source:** `LrView view properties.html`

**Applies to:** Most containers and control types, **except** `row`, `column`, and `spacer`.

| Property | Type | Default | Inherited | Description |
|---|---|---|---|---|
| `bind_to_object` | object | `nil` | Yes | The default bound table for this view and its children. Sets the observable table that `LrView.bind()` calls within this view hierarchy will reference by default. |
| `tooltip` | string | `nil` | No | Tooltip for the view, shown when the cursor hovers over it. |
| `visible` | Boolean | `true` | No | True to show the view (if the parent view is also visible), or false to hide the view and its children. **TIP:** An item still affects layout even when it is hidden. |

All three properties first supported in **SDK version 1.3**.

---

## 2. Node Layout Properties

**Source:** `LrView node layout properties.html`

**Applies to:** All container and control nodes. These properties determine how children are sized and placed with respect to the parent.

### Key concepts

- Numeric fill and place values are **percentages in the range [0..1]**.
- When resizing for fill, no node is made smaller than its minimum size. Each child's fill size is treated as a proportion of the total space desired (0.25 = 25% of parent). If fill needs cannot be met, extra space is distributed proportionally.
- Place values determine how a node is positioned in extra space within its parent. Space is allocated first-come first-served. If the first child has `place_horizontal = 1`, it consumes all extra horizontal space and none is left for siblings.
- If you specify a minimum width or height for any node, it is excluded from automatic resizing in that direction. If both width and height are specified, the minimum size is not automatically calculated. If only one is specified, the minimum size is still calculated in the other direction.

| Property | Type | Default | Description |
|---|---|---|---|
| `fill` | number [0..1] | (none) | Default fill value, if not otherwise specified. Sets both horizontal and vertical fill. |
| `fill_horizontal` | number [0..1] | (none) | The horizontal free space a node is sized to fill. Overrides `fill` for horizontal direction. |
| `fill_vertical` | number [0..1] | (none) | The vertical free space a node is sized to fill. Overrides `fill` for vertical direction. |
| `height` | number (pixels) | (auto) | The minimum vertical size for this node in pixels. Excludes node from automatic vertical resizing. |
| `width` | number (pixels) | (auto) | The minimum horizontal size for this node in pixels. Excludes node from automatic horizontal resizing. |
| `place_horizontal` | number [0..1] | (none) | The percentage of horizontal free space to place to the left of the node. 0 = left-aligned, 0.5 = centered, 1 = right-aligned. |
| `place_vertical` | number [0..1] | (none) | The percentage of vertical free space to place above the node. 0 = top-aligned, 0.5 = centered, 1 = bottom-aligned. |

All properties first supported in **SDK version 1.3**.

---

## 3. Child Layout Properties

**Source:** `LrView child layout properties.html`

**Applies to:** Container nodes (`view`, `group_box`, `tab_view`, `tab_view_item`, `scrolled_view`, etc.). These container properties determine how child nodes are placed relative to one another.

| Property | Type | Default | Description |
|---|---|---|---|
| `place` | string | `'vertical'` | Determines how the children of this container are placed relative to one another. Values: `'vertical'` (children in a column, top down -- default), `'horizontal'` (children in a row, left to right), `'overlapping'` (children placed on top of one another). |
| `spacing` | number (pixels) | (none) | The amount of space placed between each child. Ignored if `place` is `'overlapping'`. |
| `margin` | number (pixels) | (none) | How much space is around the children inside the containing node (all four sides). |
| `margin_horizontal` | number (pixels) | (none) | Overrides `margin` for left and right sides. |
| `margin_vertical` | number (pixels) | (none) | Overrides `margin` for top and bottom sides. |
| `margin_left` | number (pixels) | (none) | Overrides `margin` and `margin_horizontal` for just the left side. |
| `margin_right` | number (pixels) | (none) | Overrides `margin` and `margin_horizontal` for just the right side. |
| `margin_top` | number (pixels) | (none) | Overrides `margin` and `margin_vertical` for just the top side. |
| `margin_bottom` | number (pixels) | (none) | Overrides `margin` and `margin_vertical` for just the bottom side. |

### Margin override hierarchy

```
margin (all sides)
  |-- margin_horizontal (left + right)
  |     |-- margin_left
  |     |-- margin_right
  |-- margin_vertical (top + bottom)
        |-- margin_top
        |-- margin_bottom
```

More specific properties override more general ones.

All properties first supported in **SDK version 1.3**.

---

## 4. Control View Properties

**Source:** `LrView control view properties.html`

**Applies to:** All control types (buttons, checkboxes, sliders, edit fields, popup menus, static text, etc.).

| Property | Type | Default | Inherited | Description |
|---|---|---|---|---|
| `enabled` | Boolean | `true` | No | Indicates whether the control should be enabled (interactive) or disabled (grayed out). |
| `font` | string or table | `nil` | No | The font to be used for this control. Can be a string with a font name or one of the canonical name strings: `<system>`, `<system/small>`, `<system/bold>`, `<system/small/bold>`. Can also be a table with keys: **name** (string, font family name) and **size** (number or string). On Mac, size can also be a string: `'regular'`, `'small'`, `'mini'`. |
| `size` | string | `'regular'` | Yes | The size of text in this control (if not otherwise determined by the font specification) and of other visual features in non-text controls (e.g., affects slider track and thumb size). Values: `'regular'`, `'small'`, `'mini'`. |

All properties first supported in **SDK version 1.3**.

---

## 5. Edit View Properties

**Source:** `LrView edit view properties.html`

**Applies to:** Controls with editable text: `edit_field`, `combo_box`, and `password_field`. Properties marked "numeric edit fields only" are **not** applicable to `combo_box` or `password_field`.

| Property | Type | Default | Applies to | Description |
|---|---|---|---|---|
| `value` | any | `nil` | All edit views | The display text / current value. Typically bound to an observable table key. |
| `alignment` | string | `'left'` | All edit views | Alignment of text in frame. Values: `'left'`, `'center'`, `'right'`. |
| `immediate` | Boolean | `false` | All edit views | True to validate the value as the user is typing. The validate function is called for every change, but the new value returned by validate does not replace the text until the field loses input focus. When false, the value is committed when the control loses focus. **Platform note:** On Windows, losing focus happens on Enter or clicking outside. On Mac, it happens only on Enter; clicking outside does NOT cause commit. |
| `placeholder_string` | string | `nil` | All edit views | A placeholder displayed by the field until a value is supplied or, on Windows, until the user puts focus on the item. Example: `placeholder_string = "Enter your new value here"`. |
| `text_color` | LrColor | black | All edit views | The color of displayed text. Mac only for Lightroom 3 and earlier; cross-platform in later versions. |
| `wraps` | Boolean | `true` | All edit views | True to wrap text. **Mac only.** |
| `validate` | function | `nil` | All edit views | A validation function: `myValidate(view, value)`. Returns three values: (1) `result` (Boolean) true if valid, (2) `value` (any) the new/corrected value, (3) `message` (string) error message if result is false. |
| `string_to_value` | function | `nil` | All edit views | Conversion function from display string to a non-string value: `myStringToValue(view, string)` -> returns the converted value. |
| `value_to_string` | function | `nil` | All edit views | Conversion function from a non-string value to a display string: `myValueToString(view, value)` -> returns a display string. |
| `auto_completion` | Boolean | `false` | `edit_field`, `combo_box` | True to auto-complete as the user types using the `completion` table. On Mac, `completion` can also be a function. |
| `completion` | table or function | `nil` | `edit_field`, `combo_box` | A table of strings for completion. On Mac, can also be a function: `myCompletion(view, partialWord)` -> returns array of strings. |
| `completion_delimiters` | string | `/;:,` | `edit_field`, `combo_box` | Characters to use as delimiters in the values. Set to empty string `''` to disallow any delimiters. Default delimiters include: slash `/`, semi-colon `;`, colon `:`, comma `,`. |
| `precision` | number | `2` | Numeric `edit_field` only | The number of decimal places to display. **If specified, the field becomes numeric.** |
| `min` | number | `nil` | Numeric `edit_field` only | The minimum value allowed. |
| `max` | number | `nil` | Numeric `edit_field` only | The maximum value allowed. |
| `increment` | number | `1` or `0.1` | Numeric `edit_field` only | Increment value when Shift is NOT held down. Default is `1` if precision is 0, otherwise `0.1`. |
| `large_increment` | number | `10` or `1` | Numeric `edit_field` only | Increment value when Shift IS held down. Default is `10` if precision is 0, otherwise `1`. |

All properties first supported in **SDK version 1.3** unless otherwise noted. `placeholder_string`, `text_color`, and `wraps` have no specific SDK version annotation (available from early versions).

---

## 6. Text Properties

**Source:** `LrView text properties.html`

**Applies to:** Controls with editable or static text: `edit_field`, `combo_box`, `password_field`, `popup_menu`, `static_text`, `push_button`.

| Property | Type | Default | Description |
|---|---|---|---|
| `height_in_lines` | number | `1` | Calculates the minimum height using this as the number of lines that should fit. If set to `-1` and `width` or `width_in_digits` or `width_in_chars` is specified, text wraps. |
| `width_in_chars` | number | `15` | Calculates the minimum width using this as the number of "m" characters that should fit. Considered together with `width_in_digits`. If `height_in_lines` is `-1` and a width is specified, text wraps. |
| `width_in_digits` | number | `0` | Calculates the minimum width using this as the number of "0" digits that should fit. Considered together with `width_in_chars`. If `height_in_lines` is `-1` and a width is specified, text wraps. |

### Width calculation

The total minimum width is calculated from both `width_in_chars` and `width_in_digits` combined. For example, `width_in_chars = 5, width_in_digits = 3` means space for 5 "m" characters plus 3 "0" digits.

### Text wrapping

To enable text wrapping, set `height_in_lines = -1` and specify at least one of: `width`, `width_in_chars`, or `width_in_digits`.

All properties first supported in **SDK version 1.3**.

---

## 7. Metadata Tagset Provider

**Source:** `SDK - Metadata tagset provider.html`

The metadata tagset provider is a Lua file that returns a tagset definition for filtering metadata displayed in the Library module's Metadata panel. Tagset definitions available to Lightroom are selected using the drop-down menu at the top left of the Metadata panel.

First supported in **SDK version 2.0**.

### Provider Properties

| Property | Type | Required | Description |
|---|---|---|---|
| `id` | string | Yes | A unique identifier for this tagset within this plug-in. Must conform to Lua variable naming conventions (start with letter, followed by letters or numbers, case-sensitive). |
| `title` | string | Yes | The localizable display name of the tagset, which appears in the popup menu for the Metadata panel. |
| `items` | table | Yes | An array of metadata fields that appear in this tagset, in order of appearance. Each entry can be a simple string (field name) or an array with the field name and additional info (e.g., `height_in_lines`, `label`). |

### Items array entry format

Each entry in the `items` array can be:

1. **Simple string:** Just the field name, e.g. `'com.adobe.filename'`
2. **Table with options:**
   - First element (string): The unique identifying name of the field
   - `height_in_lines` (number, optional): For text-entry fields, the number of lines of text
   - `label` (string, optional): When the field name is `'com.adobe.label'`, this is the localizable string to use as the section label

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

## Quick Reference: Property Applicability by View Type

| Property Category | Applies To |
|---|---|
| **View properties** (bind_to_object, tooltip, visible) | All containers and controls except `row`, `column`, `spacer` |
| **Node layout properties** (fill, width, height, place) | All containers and control nodes |
| **Child layout properties** (place, margin, spacing) | Container nodes only (`view`, `group_box`, `tab_view`, etc.) |
| **Control view properties** (enabled, font, size) | All control types |
| **Edit view properties** (value, validate, precision, min, max, etc.) | `edit_field`, `combo_box`, `password_field` |
| **Edit view numeric properties** (precision, min, max, increment, large_increment) | `edit_field` only (numeric mode) |
| **Text properties** (width_in_chars, width_in_digits, height_in_lines) | `edit_field`, `combo_box`, `password_field`, `popup_menu`, `static_text`, `push_button` |
| **Metadata tagset provider** (id, title, items) | Tagset definition Lua files referenced in `LrMetadataTagsetFactory` |

---

## Total Property Count Summary

| Category | Count |
|---|---|
| General view properties | 3 |
| Node layout properties | 7 |
| Child layout properties | 9 |
| Control view properties | 3 |
| Edit view properties | 17 |
| Text properties | 3 |
| Metadata tagset provider properties | 3 |
| **Total unique properties** | **45** |
| Metadata tagset field names | 120+ |
