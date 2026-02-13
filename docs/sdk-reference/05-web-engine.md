# Web Engine Plugins (Web Gallery)

## Overview

Web engine plugins define custom HTML photo gallery types that appear in the **Web module** of Lightroom Classic. They use a fundamentally different architecture from standard plugins:

- They are **not** managed by the Plug-in Manager dialog.
- They appear in the **Engine panel** at the upper right of the Web module, alongside Lightroom's built-in gallery types.
- They use **HTML/CSS/JavaScript templates** with **Lua-based data insertion** (LuaPages) rather than pure Lua service scripts.
- Gallery configuration and data model are defined in `galleryInfo.lrweb` (not `Info.lua`).
- The plugin folder extension is `.lrwebengine` (not `.lrdevplugin` or `.lrplugin`).

### Installation Location

The plugin folder must be placed in a specific directory:

- **macOS:** `~/Library/Application Support/Adobe/Lightroom/Web Galleries/`
- **Windows:** `LightroomRoot\shared\webengines\`

The folder name must end with `.lrwebengine`, for example `myGallery.lrwebengine`.

---

## Plugin Structure for Web Engines

A web engine plugin folder contains the following:

| File/Folder | Purpose |
|---|---|
| `manifest.lrweb` | Plugin manifest -- maps template sources to output files |
| `galleryInfo.lrweb` | Gallery configuration, data model, and UI definitions |
| HTML template files | LuaPages templates (e.g., `grid.html`, `detail.html`, `head.html`, `foot.html`) |
| `resources/` | CSS, JavaScript, and image assets |
| `strings/` | Localization dictionaries (`de/TranslatedStrings.txt`, etc.) |
| `iconic_preview/` | Flash SWF for the preview panel (legacy) |
| `about.html` | Simple HTML file shown in the engine's About box |

### Example Folder Layout

```
myGallery.lrwebengine/
    manifest.lrweb
    galleryInfo.lrweb
    about.html
    grid.html              -- LuaPage template for grid/index pages
    detail.html            -- LuaPage template for individual photo pages
    head.html              -- shared header include
    foot.html              -- shared footer include
    resources/
        css/
            master.css
        js/
            live_update.js
        images/
            shadow.png
    strings/
        en/TranslatedStrings.txt
        de/TranslatedStrings.txt
        fr/TranslatedStrings.txt
    iconic_preview/
        flash_gallery_preview.swf
```

---

## manifest.lrweb

The manifest is a Lua file in the plugin's root directory. It maps LuaPage source files and resource files to the HTML output files that make up the published gallery. It uses a special command set (not the same as `Info.lua`).

### Manifest Commands

| Command | Description |
|---|---|
| `AddPage` | Maps one LuaPage source file to one output HTML file |
| `AddPhotoPages` | Builds a separate page for each photo using a LuaPage template |
| `AddGridPages` | Builds a page for each grid of photos using a LuaPage template |
| `AddResource` | Copies one resource file directly (no interpretation) |
| `AddResources` | Copies a set of resource files from a folder |
| `AddCustomCSS` | Generates a CSS file from the `appearance` properties in the data model |
| `IdentityPlate` | Exports the identity plate as a PNG file |
| `importTags()` | Loads a tagset definition file for use in LuaPages |

### AddPage

Maps one LuaPage source to one HTML output file. The source is interpreted by the LuaPage engine.

```lua
AddPage {
    filename = "content/pages/myWebPage.html",  -- output path in published gallery
    template = "myWebPage.html",                -- source LuaPage file relative to manifest
}
```

### AddPhotoPages

Builds a separate page for **each photo** in the current Lightroom selection.

```lua
AddPhotoPages {
    template = "detail.html",   -- source LuaPage template
    variant = "_large",         -- optional suffix appended to file name
    destination = "content",    -- output directory in published gallery
    filetype = "html",          -- optional, default is "html"
}
```

**LuaPages environment variables** available within `AddPhotoPages` templates:

| Variable | Description |
|---|---|
| `filename` | The file name of the current page |
| `root` | Relative path to the root of the gallery |
| `gridPageLink` | Relative path from this page to the corresponding grid page containing this photo |
| `pageType` | Always `"photo"` |
| `index` | The index position of the photo within the gallery |

### AddGridPages

Builds a page for each **grid of photos** in the current selection.

```lua
AddGridPages {
    destination = "content",
    template = "grid.html",
    rows = model.nonDynamic.numRows,
    columns = model.nonDynamic.numCols,
}
```

**LuaPages environment variables** available within `AddGridPages` templates:

| Variable | Description |
|---|---|
| `filename` | The file name of the current page |
| `pageType` | Always `"grid"` |
| `page` | Position index of the current page among all grid pages |

Additionally, if you use `AddGridPages`, **all** LuaPages in the gallery gain access to:

| Variable | Description |
|---|---|
| `numGridPages` | Total number of grid pages |
| `filenameOfGridPage(pageNumber)` | Returns the file name string for a given grid page number |
| `gridPageForPhotoAtIndex(photoIndex)` | Returns the file name for the grid page containing the given photo |
| `rows` | Number of rows on the grid pages |
| `columns` | Number of columns on the grid pages |

### AddResource / AddResources

Copy resource files directly into the published gallery without interpretation.

```lua
-- Single resource
AddResource {
    source = "image.png",
    destination = "content/resources/image.png",
}

-- Multiple resources from a folder
AddResources {
    source = "resources",
    destination = "content/resources",
}

-- Shorthand syntax for AddResources
AddResources "resources"
```

### AddCustomCSS

Generates a CSS file from all data model entries whose keys begin with `"appearance."`.

```lua
AddCustomCSS {
    filename = "content/custom.css",
}
```

This command works in conjunction with the `appearance` section of the data model. See the galleryInfo section below for how to define CSS-generating properties.

### IdentityPlate

Exports the user's identity plate as a PNG file.

```lua
IdentityPlate {
    destination = "content/logo.png",
    enabledBinding = [[appearance.logo.display]],
}
```

The `enabledBinding` links to a boolean property in the data model. When the user disables the identity plate checkbox, the PNG is not generated on upload.

### importTags()

Loads a tagset definition file and makes its tags available in LuaPages under a namespace prefix.

```lua
-- Load the built-in default tagset into the "lr" namespace
importTags( "lr", "com.adobe.lightroom.default" )

-- Load a custom tagset
importTags( "xmpl", "myTags.lrweb" )
```

---

## galleryInfo.lrweb

The information file defines the data model, UI, and metadata for the gallery. It returns a Lua table with predefined top-level entries.

### Top-Level Entries

| Property | Description |
|---|---|
| `title` | Localizable title string shown in the Web module's Engine list |
| `id` | Unique identifier string (reverse-domain convention, e.g. `"com.myCompany.myGallery"`) |
| `galleryType` | Must be `"lua"` for HTML galleries using Lua Server Pages |
| `maximumGallerySize` | Maximum number of photos the gallery can reasonably display |
| `model` | Table of user-configurable options (colors, labels, dimensions, quality, etc.) |
| `views` | Function returning UI panel descriptions for the Web module right panels |
| `iconicPreview` | Table controlling the live preview movie in the Preview panel |
| `aboutBoxFile` | Name of an HTML file for the engine's About box (simple, self-contained HTML) |
| `supportsLiveUpdate` | Boolean, `true` if the engine supports the Live Update mechanism |
| `LrSdkVersion` | SDK version number |
| `LrSdkMinimumVersion` | Minimum SDK version required |

### Example galleryInfo.lrweb Top-Level

```lua
return {
    LrSdkVersion = 5.0,
    LrSdkMinimumVersion = 2.0,

    title = LOC "$$$/AgWPG/Templates/HTML/Title=Lightroom HTML Gallery",
    id = "com.adobe.wpg.templates.jardinePro",
    galleryType = "lua",
    maximumGallerySize = 50000,
    aboutBoxFile = "about.html",
    supportsLiveUpdate = true,

    model = { ... },
    views = function( controller, f ) ... end,
    iconicPreview = { ... },
}
```

---

### Data Model

The `model` entry defines all configurable properties for the gallery. Keys use **dot-separated notation** to organize into sections. There are both predefined sections and plugin-defined sections.

#### Predefined Model Sections

##### `appearance.cssClass.cssProp` -- CSS Appearance

Entries in the `appearance` section are automatically available in CSS form. Each key follows this format:

```
appearance.cssClassName.cssPropertyName
```

For each unique class name, you must also specify a CSS selector via a `cssID` entry:

```lua
model = {
    -- Define a CSS property and its default value
    ["appearance.body.background-color"] = "#ff0000",
    -- Map the class name to a CSS selector
    ["appearance.body.cssID"] = "body",

    -- Another example: text color
    ["appearance.textColor.color"] = "#166AF2",
    ["appearance.textColor.cssID"] = ".textColor",
}
```

When used with `AddCustomCSS`, this generates CSS like:

```css
body {
    background-color: #ff0000;
}
.textColor {
    color: #166AF2;
}
```

##### `photoSizes.sizeClass.property` -- Image Sizes

Defines size classes of rendered JPEGs that Lightroom should create. A gallery typically has multiple size classes (thumbnail, small, full-size). The size-class names are defined by the plugin.

```lua
model = {
    ["photoSizes.large.width"] = 250,
    ["photoSizes.large.height"] = 250,
    ["photoSizes.large.maxWidth"] = 2048,
    ["photoSizes.large.maxHeight"] = 2048,
    ["photoSizes.large.metadataExportMode"] = "copyright",

    ["photoSizes.thumb.width"] = 130,
    ["photoSizes.thumb.height"] = 130,
}
```

Properties per size class:

| Property | Description |
|---|---|
| `width`, `height` | Size in pixels as chosen by the user |
| `maxWidth`, `maxHeight` | Largest allowed size in pixels |
| `metadataExportMode` | What metadata to include: `"copyright"` or `"all"` |
| `tracking` | Binds to the image-size slider; Lightroom sets to `true` while resizing is in progress |

##### `lightroomApplication.property` -- Application Behavior

Controls how Lightroom Classic behaves when creating the gallery:

```lua
model = {
    ["lightroomApplication.identityPlateExport"] = "(main)",
    ["lightroomApplication.jpegQuality"] = 70,
    ["lightroomApplication.useWatermark"] = false,
    ["lightroomApplication.outputSharpeningOn"] = true,
    ["lightroomApplication.outputSharpening"] = 2,  -- 1=low, 2=standard, 3=high
}
```

| Property | Description |
|---|---|
| `identityPlateExport` | Use `"(main)"` if the gallery incorporates a PNG of the identity plate |
| `jpegQuality` | Quality of rendered JPEGs, range `[0..100]` |
| `useWatermark` | `true` to include a copyright watermark |
| `outputSharpeningOn` | `true` to sharpen rendered JPEGs (default `true`) |
| `outputSharpening` | Sharpening level: `1` (low), `2` (standard, default), or `3` (high) |

##### `perImageSetting.property` -- Per-Image Text

Defines per-image text descriptions that customize the **Image Info** panel. Each setting adds a checkbox, label, and edit text control.

```lua
model = {
    ["perImageSetting.details"] = {
        enabled = true,
        value = "Default Custom-Text value",
        title = LOC "$$$/WPG/HTML/CSS/properties/ImageDetails=Details",
    },
    ["perImageSetting.datatext"] = {
        enabled = true,
        value = "Default Custom-Text value",
        title = LOC "$$$/WPG/HTML/CSS/properties/ImageData=Metadata",
    },
}
```

Each table entry:

| Key | Description |
|---|---|
| `title` | Localizable display name shown as the label |
| `value` | Default text, can contain text-token placeholders in double curly braces |
| `enabled` | Whether the checkbox is checked by default |

Access per-image text in templates using `$image.metadata.propertyName`. For example:

```html
<lr:ThumbnailGrid>
    <lr:GridPhotoCell>
        <pre>
            $image.metadata.datatext, $image.metadata.details
        </pre>
    </lr:GridPhotoCell>
    <lr:GridRowEnd><br></lr:GridRowEnd>
</lr:ThumbnailGrid>
```

##### Plugin-Defined Properties

You can define additional properties for gallery-wide text labels (site title, collection title) or appearance parameters that do not work through CSS (number of rows/columns, dynamic color properties accessed by JavaScript). The names are defined entirely by your plugin.

```lua
model = {
    ["metadata.siteTitle.value"] = LOC
        "$$$/Templates/HTML/Defaults/props/SiteTitle=Site Title",
    ["nonCSS.numRows"] = 4,
    ["nonCSS.numCols"] = 5,
    ["nonCSS.cellBorderColor"] = "#cccccc",
}
```

#### Dynamic Data Model

Model properties can have simple number, string, or color values. To make a property **dynamic**, assign a function definition as its value. Lightroom executes the function and uses the return value whenever it needs the property. The evaluation context makes the entire data model available in global scope.

A typical use is tying two properties together:

```lua
model = {
    -- height always equals width (square aspect ratio)
    ["photoSizes.large.height"] = function() return photoSizes.large.width end,
    ["photoSizes.large.width"] = 450,
}
```

You can use Lua's basic `math` and `string` functions in dynamic properties. Lightroom also provides `LrColorToWebColor` to convert an `LrColor` object to a CSS-compatible string.

---

### Defining a UI for Your Model (views)

The `views` entry is a function that receives two arguments:

1. `controller` -- an observable table containing the model data
2. `f` -- a web view factory object (`LrWebViewFactory`) for creating UI elements

The function returns a table of view descriptions, with entries corresponding to the Web module's right-side panels:

| Panel Key | Web Module Panel |
|---|---|
| `labels` | **Site Info** -- text associated with the site |
| `colorPalette` | **Color Palette** -- color adjustments for site elements |
| `appearanceConfiguration` | **Appearance** -- appearance of individual photos |
| `outputSettings` | **Output Settings** -- image quality, metadata, sharpening |

#### Example views Function

```lua
return {
    ...
    views = function( controller, f )
        local LrView = import "LrView"
        local bind = LrView.bind
        return {
            labels = f:panel_content {
                bind_to_object = controller,
                f:subdivided_sections {
                    f:labeled_text_input {
                        title = "Site Title",
                        value = bind "metadata.siteTitle.value",
                    },
                    -- additional content
                },
            },
            colorPalette = f:panel_content {
                bind_to_object = controller,
                f:label_and_color_row {
                    bindingValue = "appearance.body.background-color",
                    title = "Background",
                },
            },
            appearanceConfiguration = f:panel_content {
                bind_to_object = controller,
                -- define content
            },
            outputSettings = f:panel_content {
                bind_to_object = controller,
                -- define content
            },
        }
    end,
    ...
}
```

#### LrWebViewFactory -- Additional UI Functions

The `LrWebViewFactory` extends the standard `LrViewFactory` with controls suited to the Web module:

**Container functions:**

| Function | Description |
|---|---|
| `panel_content` | Top-level panel in the Web module, containing sections divided by heavy black lines |
| `subdivided_sections` | Section within a panel, with rows/columns separated by light gray lines |
| `content_column` | Column-style container for controls within a section |
| `slider_content_column` | Column container specialized for sliders |
| `color_content_column` | Column container specialized for color controls |
| `content_section` | Generic section container |
| `header_section` | Section with header formatting |

**Row/control functions:**

| Function | Description |
|---|---|
| `header_section_label` | Text label for a section, with suitable formatting |
| `row` | Generic row container |
| `popup_row` | Row containing a popup menu |
| `slider_row` | Row containing a slider |
| `checkbox_and_color_row` | Row with a checkbox and color picker |
| `label_and_color_row` | Row with a label and color picker |
| `checkbox_row` | Row with a checkbox |
| `labeled_text_input` | Row with a label and text input field |

**Specialized controls:**

| Function | Description |
|---|---|
| `metadataModeControl` | Metadata mode selection control |
| `warning_icon` | Warning icon display |
| `identity_plate` | Identity plate selection control |
| `row_column_picker` | Row/column grid size picker |

---

## LuaPage Syntax

A LuaPage is a Lua-language source file that is evaluated to produce one destination web page. In the manifest, `AddPage` maps each source LuaPage to a destination file location.

### Embedding Lua in HTML

LuaPages use special tags to embed Lua code in HTML:

```html
<!-- Execute Lua code (no output) -->
<% lua_code_here %>

<!-- Output an expression value -->
<%= expression %>

<!-- Include another file (compile-time) -->
<%@ include file="subdir/foo.html" %>
```

### Example: Simple LuaPage Template

```html
<html>
<body>
    <h1>My web gallery</h1>
    <p>This gallery contains <%= numImages %> photos.</p>

    <% if mode == "preview" then %>
        <p>You are previewing this gallery.</p>
    <% end %>

    <!-- Include a shared header -->
    <%@ include file="head.html" %>

    <!-- Loop over photos -->
    <% for i = 0, numImages - 1 do
        local img = getImage(i) %>
        <div class="photo">
            <img src="thumbs/<%= img.exportFilename %>.jpg" />
        </div>
    <% end %>

    <!-- Runtime file include -->
    <% includeFile( "foot.html" ) %>
</body>
</html>
```

### Environment Variables Available to LuaPages

| Variable | Description |
|---|---|
| `getImage(imageIndex)` | Returns an `imageProxy` object for the photo at the given index |
| `mode` | `"preview"` during in-Lightroom preview; `"publish"` during export/upload/preview-in-browser |
| `numImages` | Total number of photos in the gallery |
| `string`, `math` | Standard Lua namespaces |
| `table` | Subset of Lua `table` namespace (contains `insert`) |
| `ipairs`, `pairs`, `type`, `tostring` | Standard Lua functions |
| `LOC` | Localization function for ZStrings |
| `includeFile()` | Runtime function to include another file |
| `LrTagFuncs` | Table of private helper functions for `lr:` tags |

### LuaPage Data Types

#### imageProxy

Returned by `getImage(index)`. Properties:

| Property | Type | Description |
|---|---|---|
| `exportFilename` | string | Base name of the JPEG that will be written to disk |
| `rating` | number or nil | Numeric star rating, or nil if unrated |
| `imageID` | string | The `id_global` string for this image |
| `renditions` | array | Array of `imageRendition` objects |
| `metadata` | table | Per-image settings based on `perImageSetting` entries |
| `colorLabel` | string or nil | Localized text for the color label (e.g. `"red"`), or nil |

#### imageRendition

Represents a rendered version of a photo. Properties:

| Property | Type | Description |
|---|---|---|
| `width` | number | Width in pixels |
| `height` | number | Height in pixels |
| `relPath` | array of string | Array of directory names; last entry is the file name |
| `dir` | array of string | Array of directory names |
| `cropMode` | string | `"minimum"` (fit within photoSize) or `"maximum"` (scale to at least photoSize) |
| `metadataExportMode` | string | `"copyright"` (minimize metadata) or `"all"` |

---

## Grid vs. Detail Pages

Web galleries typically have a **multi-page structure** with two types of pages:

1. **Grid pages** (index/thumbnail pages) -- Show a grid of photo thumbnails; generated by `AddGridPages`
2. **Detail pages** (photo pages) -- Show individual photos at larger size; generated by `AddPhotoPages`

Navigation between pages is handled by the built-in pagination tagset and by environment variables that link grid pages to detail pages and vice versa.

### Grid Page Example

```html
<html>
<head>
    <link rel="stylesheet" href="<%= root %>resources/css/master.css" />
</head>
<body>
    <lr:ThumbnailGrid>
        <lr:GridPhotoCell>
            <a href="<%= image.exportFilename %>_large.html">
                <img src="thumbs/<%= image.exportFilename %>.jpg"
                     id="<%= image.imageID %>"
                     class="thumb" />
            </a>
        </lr:GridPhotoCell>
        <lr:GridEmptyCell>
            <div class="empty-cell"></div>
        </lr:GridEmptyCell>
        <lr:GridRowEnd><br class="clear" /></lr:GridRowEnd>
    </lr:ThumbnailGrid>

    <!-- Pagination for multi-page grids -->
    <% if numGridPages > 1 then %>
    <div class="pagination">
        <ul>
            <lr:Pagination>
                <lr:PreviousEnabled>
                    <li><a href="$link">Previous</a></li>
                </lr:PreviousEnabled>
                <lr:PreviousDisabled>
                    <li>Previous</li>
                </lr:PreviousDisabled>
                <lr:CurrentPage>
                    <li>$page</li>
                </lr:CurrentPage>
                <lr:OtherPages>
                    <li><a href="$link">$page</a></li>
                </lr:OtherPages>
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
</body>
</html>
```

### Detail Page Example

```html
<html>
<head>
    <link rel="stylesheet" href="<%= root %>resources/css/master.css" />
</head>
<body>
    <div class="detail-view">
        <a href="<%= gridPageLink %>">Back to gallery</a>
        <img src="<%= image.exportFilename %>_large.jpg"
             id="<%= image.imageID %>" />
        <p><%= image.metadata.details %></p>
    </div>
</body>
</html>
```

---

## Built-in Tagsets

Lightroom Classic provides a default tagset at `"com.adobe.lightroom.default"`. Import it in your manifest:

```lua
importTags( "lr", "com.adobe.lightroom.default" )
```

### Thumbnail Grid Tags

Used on pages added via `AddGridPages`. The `ThumbnailGrid` tag is the container for grid cell definitions.

| Tag | Description |
|---|---|
| `<lr:ThumbnailGrid>` | Container for the entire thumbnail grid |
| `<lr:GridPhotoCell>` | Content repeated for each cell containing a photo |
| `<lr:GridEmptyCell>` | Content for empty cells (when photos don't fill the grid) |
| `<lr:GridRowStart>` | Content placed at the start of each row |
| `<lr:GridRowEnd>` | Content placed at the end of each row |

**Variables available inside `ThumbnailGrid`:**

| Variable | Description |
|---|---|
| `cellIndex` | 1-based index for the current cell in the grid |
| `row` | 1-based row number for the current cell |
| `column` | 1-based column number for the current cell |
| `image` | The `imageProxy` object for the current photo |

### Pagination Tags

Used to add page navigation buttons to multi-page galleries.

| Tag | Description |
|---|---|
| `<lr:Pagination>` | Container for pagination controls |
| `<lr:CurrentPage>` | Icon or text for the current page |
| `<lr:OtherPages>` | Navigation link for other pages |
| `<lr:PreviousEnabled>` | Previous-page button (when a previous page exists) |
| `<lr:PreviousDisabled>` | Previous-page indicator (on the first page) |
| `<lr:NextEnabled>` | Next-page button (when a next page exists) |
| `<lr:NextDisabled>` | Next-page indicator (on the last page) |

**Variables available inside `Pagination`:**

| Variable | Description |
|---|---|
| `$page` | The page number (current page within `CurrentPage`, target page within `OtherPages`) |
| `$link` | URL to the appropriate page for the navigation button |

---

## Custom Tagsets

Tagsets are external files containing macro-like definitions that can be loaded by your web pages. They are similar to JSP Tag Libraries but simpler. They allow you to extract common content and logic that appears on multiple pages into reusable tags.

### Defining a Custom Tagset

A tagset file defines a `tags` table. Each entry names a tag and provides `startTag` and `endTag` Lua code strings:

```lua
-- myTags.lrweb
globals = {
    myOpenTagFunction = function()
        -- body of function
    end,
    myCloseTagFunction = function()
        -- body of function
    end,
}

tags = {
    myTag = {
        startTag = "myOpenTagFunction()",
        endTag = "myCloseTagFunction()",
    },
}
```

### Using Custom Tags

1. Include the tagset file in the root directory of your web engine.
2. Import it in `manifest.lrweb`:

```lua
importTags( "xmpl", "myTags.lrweb" )
```

3. Use the tags in LuaPages with the namespace prefix:

```html
<xmpl:myTag>Hello world</xmpl:myTag>
```

4. At runtime, the LuaPage replaces the tags with Lua code:

```lua
myOpenTagFunction() write( [[Hello world]] ) myCloseTagFunction()
```

### Custom Tag Example: Text Wrapping

```lua
-- myTags.lua
globals = {
    myFn = function( x )
        write( "You said, \"" )
        x()
        write( "!\"" )
    end,
}

tags = {
    exclaim = {
        startTag = "myFn( function()",
        endTag = "end )",
    },
}
```

Import and use:

```lua
-- manifest.lrweb
importTags( "xmpl", "myTags.lua" )
```

```html
<!-- In a LuaPage -->
<xmpl:exclaim>Hello world</xmpl:exclaim>

<!-- Output: You said, "Hello world!" -->
```

---

## Web HTML Live Update

When previewing a gallery inside Lightroom Classic, changes to gallery parameters can be reflected **without a full page reload** using the Live Update mechanism. This uses DHTML/AJAX techniques executed in the built-in web browser.

### How It Works

Communication is **bidirectional**:

1. **Lightroom to page:** Lightroom calls JavaScript `liveUpdate()` functions on the page whenever the user changes a model parameter. If the call succeeds, Lightroom skips the page reload.
2. **Page to Lightroom:** JavaScript on the page sends messages back to Lightroom in response to user events (text editing, model overrides).

To enable Live Update, set `supportsLiveUpdate = true` in `galleryInfo.lrweb` and include the JavaScript implementation (e.g. `live_update.js`) in your pages:

```html
<script type="text/javascript" src="$theRoot/resources/js/live_update.js"></script>
```

### document.liveUpdate

Handles changes to gallery appearance (CSS properties) and text labels.

```javascript
document.liveUpdate = function( path, newValue, cssId, property ) {
    var result = "failed";
    // Locate the document node and alter appearance/content
    // to reflect the changed data values
    result = "invalidateAllContent";
    return result;
}
```

Parameters:

| Parameter | Description |
|---|---|
| `path` | Dot-separated path to the node in the `appearance` portion of `galleryInfo.lrweb` |
| `newValue` | The new value (e.g. `"ffffff"` for white) |
| `cssId` | The corresponding `cssId` for the node (e.g. `"body"`) |
| `property` | The CSS property changing (e.g. `"margin"`) |

### document.liveUpdateImageSize

Handles live update of image size. Called repeatedly while the mouse is held down on the image size slider. A full reload occurs when the mouse is released.

```javascript
document.liveUpdateImageSize = function( imageID, width, height ) {
    var img = document.getElementById( imageID );
    if ( img ) {
        img.width = width;
        img.height = height;
        return "invalidateAllContent";
    }
    return "failed";
}
```

### Live Update Return Values

| Return Value | Behavior |
|---|---|
| `"invalidateOldHTML"` | Clears browser cache and HTML page cache. JPEGs unchanged. Reload deferred until navigation. |
| `"invalidateAllContent"` | Clears browser cache and all page caches (HTML and resources). JPEGs unchanged. Reload deferred. |
| `"failed"` (or exception) | Causes immediate reload with full cache clearing. |

### Messages from Page to Lightroom (Callbacks)

JavaScript on the page can call into Lightroom using the `callCallback()` function from `live_update.js`:

```javascript
callCallback( "callback_name", param1, param2, ... );
```

Available callbacks:

| Callback | Description |
|---|---|
| `showInPhotoBin( id )` | Reveals a photo in the filmstrip whose `id_global` matches `id` |
| `setActiveImageSize( size )` | Tells Lightroom which `photoSizes` class is currently displayed |
| `inPlaceEdit( target, x, y, width, height, fontFamily, fontSize )` | Opens a text edit overlay at the given coordinates |
| `updateModel( key, value )` | Alters the data model for the given dot-separated key path |
| `fetchURL( url, callbackName )` | Asynchronously downloads a URL and returns the content to a callback function on the document object |

### In-Place Editing

The `clickTarget()` function in `live_update.js` simplifies in-place text editing. Add it to any text-containing element:

```html
<h1 onclick="clickTarget( this, 'metadata.siteTitle.value' );"
    id="metadata.siteTitle.value"
    class="textColor">
    $model.metadata.siteTitle.value
</h1>
```

The `id` attribute on the element must match the dot-separated path in the model definition. When the user clicks the element, an edit text window is superimposed on the web page at the element's position.

---

## Localizing the UI

Strings in the UI can be localized using the `LOC` function with ZStrings (see the ZStrings chapter for full details). Your plugin supplies localization dictionaries in a `strings` subfolder:

```
myWebPlugin.lrwebengine/
    strings/
        de/TranslatedStrings.txt
        fr/TranslatedStrings.txt
        ja/TranslatedStrings.txt
```

Localization occurs when the user publishes the gallery. To get different language versions, the user must run Lightroom Classic in the desired locale and publish again.

---

## Complete Manifest Example

Here is a complete `manifest.lrweb` showing how all the commands fit together:

```lua
-- manifest.lrweb

-- Import the built-in tagset
importTags( "lr", "com.adobe.lightroom.default" )

-- Import custom tags
importTags( "xmpl", "myTags.lrweb" )

-- Generate CSS from appearance model properties
AddCustomCSS {
    filename = "content/custom.css",
}

-- Export identity plate PNG
IdentityPlate {
    destination = "content/logo.png",
    enabledBinding = [[appearance.logo.display]],
}

-- Static pages (processed through LuaPage engine)
AddPage {
    filename = "index.html",
    template = "grid.html",
}

-- Grid pages (one per grid of photos)
AddGridPages {
    destination = "content",
    template = "grid.html",
    rows = model.nonDynamic.numRows,
    columns = model.nonDynamic.numCols,
}

-- Photo detail pages (one per photo)
AddPhotoPages {
    template = "detail.html",
    destination = "content",
}

-- Copy resources
AddResources "resources"
```

---

## Complete galleryInfo.lrweb Example

```lua
-- galleryInfo.lrweb
return {
    LrSdkVersion = 5.0,
    LrSdkMinimumVersion = 2.0,

    title = LOC "$$$/MyPlugin/Gallery/Title=My Custom Gallery",
    id = "com.example.mycustomgallery",
    galleryType = "lua",
    maximumGallerySize = 50000,
    aboutBoxFile = "about.html",
    supportsLiveUpdate = true,

    model = {
        -- Photo sizes
        ["photoSizes.large.width"] = 600,
        ["photoSizes.large.height"] = function() return photoSizes.large.width end,
        ["photoSizes.large.maxWidth"] = 2048,
        ["photoSizes.large.maxHeight"] = 2048,
        ["photoSizes.large.metadataExportMode"] = "copyright",
        ["photoSizes.thumb.width"] = 150,
        ["photoSizes.thumb.height"] = 150,

        -- CSS appearance
        ["appearance.body.background-color"] = "#ffffff",
        ["appearance.body.cssID"] = "body",
        ["appearance.textColor.color"] = "#333333",
        ["appearance.textColor.cssID"] = ".textColor",
        ["appearance.logo.cssID"] = ".logo",
        ["appearance.logo.display"] = false,

        -- Lightroom application settings
        ["lightroomApplication.identityPlateExport"] = "(main)",
        ["lightroomApplication.jpegQuality"] = 80,
        ["lightroomApplication.useWatermark"] = false,
        ["lightroomApplication.outputSharpeningOn"] = true,
        ["lightroomApplication.outputSharpening"] = 2,

        -- Plugin-defined: site metadata
        ["metadata.siteTitle.value"] = LOC
            "$$$/MyPlugin/Defaults/SiteTitle=My Photo Gallery",
        ["metadata.groupDescription.value"] = LOC
            "$$$/MyPlugin/Defaults/Description=A collection of photos",

        -- Plugin-defined: non-CSS properties
        ["nonCSS.numRows"] = 3,
        ["nonCSS.numCols"] = 4,

        -- Per-image settings
        ["perImageSetting.description"] = {
            enabled = true,
            value = "{{com.adobe.caption}}",
            title = LOC "$$$/MyPlugin/Properties/Description=Description",
        },
    },

    views = function( controller, f )
        local LrView = import "LrView"
        local bind = LrView.bind

        return {
            labels = f:panel_content {
                bind_to_object = controller,
                f:subdivided_sections {
                    f:labeled_text_input {
                        title = "Site Title",
                        value = bind "metadata.siteTitle.value",
                    },
                    f:labeled_text_input {
                        title = "Description",
                        value = bind "metadata.groupDescription.value",
                    },
                },
            },
            colorPalette = f:panel_content {
                bind_to_object = controller,
                f:subdivided_sections {
                    f:label_and_color_row {
                        bindingValue = "appearance.body.background-color",
                        title = "Background",
                    },
                    f:label_and_color_row {
                        bindingValue = "appearance.textColor.color",
                        title = "Text",
                    },
                },
            },
            appearanceConfiguration = f:panel_content {
                bind_to_object = controller,
                f:subdivided_sections {
                    f:slider_row {
                        title = "Thumbnail Size",
                        value = bind "photoSizes.thumb.width",
                        tracking = bind "photoSizes.thumb.tracking",
                        unit = "px",
                        max = 300,
                        min = 50,
                    },
                    f:row_column_picker {
                        numRows = bind "nonCSS.numRows",
                        numCols = bind "nonCSS.numCols",
                        maxRows = 10,
                        maxCols = 10,
                    },
                },
            },
            outputSettings = f:panel_content {
                bind_to_object = controller,
                f:subdivided_sections {
                    f:slider_row {
                        title = "JPEG Quality",
                        value = bind "lightroomApplication.jpegQuality",
                        unit = "",
                        max = 100,
                        min = 0,
                    },
                    f:metadataModeControl {
                        value = bind "photoSizes.large.metadataExportMode",
                    },
                    f:identity_plate {
                        value = bind "lightroomApplication.identityPlateExport",
                        enabled = bind "appearance.logo.display",
                    },
                },
            },
        }
    end,
}
```
