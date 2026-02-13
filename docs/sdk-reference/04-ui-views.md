# UI: LrView, LrDialogs & LrBinding

The Lightroom Classic SDK provides a declarative UI framework for building plug-in interfaces. Three core namespaces work together:

- **LrView** -- builds the view hierarchy (containers and controls)
- **LrDialogs** -- presents dialogs (modal, floating, system panels)
- **LrBinding** -- connects UI elements to observable data tables

All UI code uses Lua tables as "view descriptions" that Lightroom interprets at runtime.

---

## LrView -- Declarative UI Framework

### Obtaining the Factory

Every UI tree starts by obtaining a platform-appropriate factory:

```lua
local LrView = import "LrView"
local f = LrView.osFactory()
```

You then call methods on `f` to create containers and controls. Each method accepts a table of properties and child views, returning a view description that Lightroom renders.

### How the View Hierarchy Works

Views are composed hierarchically -- containers hold controls and other containers:

```lua
local contents = f:column {
    spacing = f:control_spacing(),
    f:row {
        spacing = f:label_spacing(),
        f:static_text { title = "Name:" },
        f:edit_field { value = bind 'userName', width_in_chars = 20 },
    },
    f:row {
        spacing = f:label_spacing(),
        f:static_text { title = "Email:" },
        f:edit_field { value = bind 'userEmail', width_in_chars = 20 },
    },
}
```

---

## Containers

Containers group and arrange child views. All containers (except `row`, `column`, and `spacer`) support the general view properties (`visible`, `tooltip`, `bind_to_object`) and the full set of layout properties.

### `f:row { ... }` -- Horizontal Layout

Places children left-to-right. A `row` is equivalent to a `view` with `place = "horizontal"`. Row and column do **not** support `visible` or `tooltip` directly (they are pure layout containers).

```lua
f:row {
    spacing = f:label_spacing(),
    f:static_text { title = "Label:" },
    f:edit_field { value = bind 'field1' },
}
```

### `f:column { ... }` -- Vertical Layout

Places children top-to-bottom (default layout direction). Equivalent to a `view` with `place = "vertical"`.

```lua
f:column {
    spacing = f:control_spacing(),
    f:static_text { title = "Line 1" },
    f:static_text { title = "Line 2" },
}
```

### `f:view { ... }` -- Generic Container

A basic containment frame with no visual representation. Supports all view properties including `visible`. Useful for grouping controls whose visibility is toggled together.

```lua
f:view {
    visible = bind 'showAdvanced',
    f:static_text { title = "Advanced option" },
}
```

The `place` property on a `view` controls child arrangement:
- `"vertical"` (default) -- children stacked top-down
- `"horizontal"` -- children placed left-to-right
- `"overlapping"` -- children stacked on top of each other (same space)

### `f:group_box { title = '...', ... }` -- Titled Box

A visible frame with an optional title displayed near its top-left corner.

```lua
f:group_box {
    title = "Export Settings",
    fill_horizontal = 1,
    spacing = f:control_spacing(),
    f:checkbox { title = "Include metadata", value = bind 'includeMetadata' },
    f:checkbox { title = "Watermark", value = bind 'addWatermark' },
}
```

Properties: `title` (string, localizable), `show_title` (boolean, default `true`), `font`.

### `f:tab_view { ... }` -- Tabbed Container

Draws tab frames for its `tab_view_item` children. The `font` and `size` properties control the tab label text. The `value` property holds the identifier of the currently selected tab.

```lua
f:tab_view {
    f:tab_view_item {
        title = "General",
        identifier = "tab_general",
        f:column {
            f:static_text { title = "General settings go here." },
        },
    },
    f:tab_view_item {
        title = "Advanced",
        identifier = "tab_advanced",
        f:column {
            f:static_text { title = "Advanced settings go here." },
        },
    },
}
```

### `f:tab_view_item { title = '...', identifier = '...', ... }` -- Tab Page

A tabbed page within a `tab_view`. The `title` appears in the tab label; the `identifier` (string, required) uniquely identifies the page for selection.

### `f:spacer { height = N }` or `f:spacer { width = N }`

A row with no child nodes, used purely for spacing. Only supports `width` and `height` (in pixels).

```lua
f:column {
    f:static_text { title = "Above" },
    f:spacer { height = 20 },
    f:static_text { title = "Below" },
}
```

---

## Controls

All controls support the general view properties (`visible`, `tooltip`, `bind_to_object`), the control-specific properties (`enabled`, `font`, `size`), and layout properties.

### `f:static_text { title = 'text' }` -- Label / Display Text

Displays non-editable text. Although the user cannot change the text, it can be made dynamic by binding the `title` to a data value.

| Property | Type | Description |
|---|---|---|
| `title` | string | The display text (localizable, bindable) |
| `alignment` | string | `"left"`, `"center"`, or `"right"` |
| `text_color` | LrColor | Color of the text (default black) |
| `truncation` | string | Where to truncate: `"head"`, `"middle"`, or `"tail"` |
| `selectable` | boolean | If true, text is selectable (macOS only) |
| `mouse_down` | function | Called on click: `function(view) end` |
| `width_in_chars` | number | Min width by character count (m-widths) |
| `height_in_lines` | number | Min height by line count |

```lua
f:static_text {
    title = bind 'statusMessage',
    text_color = LrColor(0.5, 0, 0),
    alignment = 'center',
    fill_horizontal = 1,
}
```

### `f:edit_field { value = bind 'key' }` -- Text Input

An editable text field that accepts keyboard input. Input is committed on focus loss by default, or on every keystroke if `immediate = true`.

| Property | Type | Description |
|---|---|---|
| `value` | any | The current value (bindable) |
| `width_in_chars` | number | Min width by character count (default 15) |
| `width_in_digits` | number | Min width by digit count (default 0) |
| `height_in_lines` | number | Min height by line count (default 1) |
| `immediate` | boolean | Commit value on every keystroke (default false) |
| `min` | number | Minimum allowed value (makes field numeric) |
| `max` | number | Maximum allowed value (makes field numeric) |
| `precision` | number | Decimal places for numeric fields (default 2) |
| `increment` | number | Step for numeric changes (default 1 or 0.1) |
| `large_increment` | number | Step when SHIFT held (default 10 or 1) |
| `alignment` | string | `"left"` (default), `"center"`, `"right"` |
| `text_color` | LrColor | Color of displayed text |
| `wraps` | boolean | Wrap text (default true) |
| `auto_completion` | boolean | Auto-complete as user types (default false) |
| `completion` | table/function | Strings for completion, or `function(view, partialWord)` |
| `validate` | function | `function(view, value)` returns `result, value, message` |
| `value_to_string` | function | Convert value to display string |
| `string_to_value` | function | Convert display string back to value |

```lua
f:edit_field {
    value = bind 'exportPath',
    width_in_chars = 40,
    immediate = true,
    validate = function(view, value)
        if value == "" then
            return false, value, "Path cannot be empty"
        end
        return true, value
    end,
}
```

**Platform note:** On macOS, the field loses focus on TAB (not on clicking outside). On Windows, it loses focus when the user clicks outside. When the user presses ENTER/RETURN, the dialog's default button is invoked.

### `f:password_field { value = bind 'key' }` -- Password Input

An editable text field that obscures entered text with bullet characters. Supports all the same edit-field and text properties as `edit_field`.

```lua
f:password_field {
    value = bind 'apiSecret',
    width_in_chars = 30,
}
```

### `f:checkbox { title = 'label', value = bind 'key' }` -- Boolean Toggle

Displays a platform-style checkbox. Checked when `value == checked_value`, unchecked when `value == unchecked_value`. If value matches neither, shows a mixed state.

| Property | Type | Description |
|---|---|---|
| `title` | string | Display label |
| `value` | any | The control value (bindable) |
| `checked_value` | any | Value when checked (default `true`) |
| `unchecked_value` | any | Value when unchecked (default `false`) |

**Important:** Value comparisons are strict -- `0`, `false`, `nil`, and `""` are all distinct.

```lua
f:checkbox {
    title = "Include EXIF data",
    value = bind 'includeExif',
    -- defaults: checked_value = true, unchecked_value = false
}

-- String-valued checkbox
f:checkbox {
    title = "Enable feature",
    value = bind 'featureState',
    checked_value = 'enabled',
    unchecked_value = 'disabled',
}
```

### `f:radio_button { title = 'label', value = bind 'key', checked_value = 'val' }` -- Radio Option

Displays a platform-style radio button. Checked when `value == checked_value`, unchecked when value differs, mixed state when value is `nil`.

Radio buttons do **not** automatically form groups. You enforce mutual exclusion by binding all buttons in a set to the **same key**, each with a different `checked_value`:

```lua
f:group_box {
    title = "Output Format",
    fill_horizontal = 1,
    spacing = f:control_spacing(),
    f:radio_button {
        title = "JPEG",
        value = bind 'outputFormat',
        checked_value = 'jpeg',
    },
    f:radio_button {
        title = "TIFF",
        value = bind 'outputFormat',
        checked_value = 'tiff',
    },
    f:radio_button {
        title = "PSD",
        value = bind 'outputFormat',
        checked_value = 'psd',
    },
}
```

### `f:popup_menu { value = bind 'key', items = {...} }` -- Dropdown Menu

A pop-up menu of choices. Each item has a `title` (display text) and `value`. When the user selects an item, its value becomes the control's value and its title is displayed.

| Property | Type | Description |
|---|---|---|
| `value` | any | Currently selected item's value (bindable) |
| `items` | table | Array of `{title=..., value=...}` entries. Use `{separator=true}` for a divider line. |
| `value_equal` | function | Custom comparison: `function(value1, value2)` returns boolean |

The `items` property itself is bindable, allowing dynamic menus (but you can only set the whole list at once, not individual items).

```lua
f:popup_menu {
    value = bind 'imageFormat',
    items = {
        { title = "JPEG", value = "jpeg" },
        { title = "TIFF", value = "tiff" },
        { separator = true },
        { title = "Original", value = "original" },
    },
}
```

**Case-insensitive matching with `value_equal`:**

```lua
f:popup_menu {
    value = bind 'format',
    items = {
        { title = "JPEG", value = "jpeg" },
        { title = "TIFF", value = "tiff" },
    },
    value_equal = function(value1, value2)
        return LrStringUtils.lower(value1) == LrStringUtils.lower(value2)
    end,
}
```

### `f:combo_box { value = bind 'key', items = {'a','b','c'} }` -- Editable Dropdown

An editable text field with a pop-up menu of predefined values. The user can type any text or select from the menu. Unlike `popup_menu`, items are simple values (not title/value pairs). If you need localization, build the array with localized strings.

```lua
f:combo_box {
    value = bind 'keyword',
    items = { "landscape", "portrait", "macro", "street" },
}
```

Supports all edit-field and text properties (see `edit_field` above).

### `f:slider { value = bind 'key', min = 0, max = 100 }` -- Range Slider

A draggable control that changes a numeric value within a range.

| Property | Type | Description |
|---|---|---|
| `value` | number | Current numeric value (bindable) |
| `min` | number | Low end of range |
| `max` | number | High end of range |
| `integral` | boolean | If true, only integer increments (default false) |

```lua
f:row {
    spacing = f:label_spacing(),
    f:static_text { title = "Quality:" },
    f:slider {
        value = bind 'jpegQuality',
        min = 0,
        max = 100,
        fill_horizontal = 1,
    },
    f:edit_field {
        value = bind 'jpegQuality',
        width_in_digits = 3,
        min = 0,
        max = 100,
        precision = 0,
    },
}
```

Note: binding the slider and edit_field to the same key keeps them synchronized automatically.

### `f:push_button { title = 'Click', action = function() end }` -- Button

A clickable button drawn in platform-standard style.

| Property | Type | Description |
|---|---|---|
| `title` | string | Display label |
| `action` | function | Called on click: `function(button)` |

```lua
f:push_button {
    title = "Browse...",
    action = function(button)
        local path = LrDialogs.runOpenPanel {
            title = "Select Folder",
            canChooseDirectories = true,
            canChooseFiles = false,
        }
        if path then
            properties.exportFolder = path[1]
        end
    end,
}
```

### `f:picture { value = 'resource.png' }` -- Image Display

Displays a static image or icon.

| Property | Type | Description |
|---|---|---|
| `value` | string | Full path to a JPG or PNG image file |
| `frame_width` | number | Pixel width of a frame around the image (default 0) |
| `frame_color` | LrColor | Frame color (default black) |

```lua
f:picture {
    value = _PLUGIN:resourceId('logo.png'),
    frame_width = 1,
    frame_color = LrColor(0.8, 0.8, 0.8),
}
```

**Tip:** Use `_PLUGIN:resourceId('filename.png')` to get the full path to an image bundled in your plug-in's resources.

### `f:color_well { value = bind 'key' }` -- Color Picker

Displays a color and responds to a click by showing a platform color-selection UI.

| Property | Type | Description |
|---|---|---|
| `value` | LrColor | The current color (bindable) |

```lua
f:color_well {
    value = bind 'textColor',
}
```

### `f:separator { fill_horizontal = 1 }` -- Horizontal/Vertical Line

Draws a 2-pixel line across its container. The direction depends on the fill values -- the larger fill value determines whether the line is horizontal or vertical.

```lua
f:separator { fill_horizontal = 1 }  -- horizontal line
f:separator { fill_vertical = 1 }    -- vertical line
```

---

## Common View Properties

### Layout & Sizing

| Property | Type | Description |
|---|---|---|
| `fill_horizontal` | number [0..1] | Fraction of parent's free horizontal space to fill |
| `fill_vertical` | number [0..1] | Fraction of parent's free vertical space to fill |
| `fill` | number [0..1] | Default fill if specific direction not set |
| `width` | number | Minimum width in pixels |
| `height` | number | Minimum height in pixels |
| `width_in_chars` | number | Min width by m-character count |
| `width_in_digits` | number | Min width by digit (0) count |
| `height_in_lines` | number | Min height by line count |
| `place_horizontal` | number [0..1] | Alignment within extra horizontal space (0=left, 1=right) |
| `place_vertical` | number [0..1] | Alignment within extra vertical space (0=top, 1=bottom) |
| `spacing` | number | Pixels between children (containers only) |
| `margin` | number | Interior margin around children (containers only) |
| `margin_horizontal` | number | Override margin for left and right |
| `margin_vertical` | number | Override margin for top and bottom |
| `margin_left`, `margin_right` | number | Override for specific side |
| `margin_top`, `margin_bottom` | number | Override for specific side |

### Appearance & Behavior

| Property | Type | Description |
|---|---|---|
| `visible` | boolean | Show/hide (bindable). Must be `true` or `false`, not `nil`. Hidden items still affect layout. |
| `enabled` | boolean | Enable/disable (controls only, bindable). Disabled controls appear grayed. |
| `font` | string/table | `'<system>'`, `'<system/bold>'`, `'<system/small>'`, `'<system/small/bold>'`, or `{name='...', size='...'}` |
| `size` | string | `"regular"` (default), `"small"`, or `"mini"` -- affects text and visual features like slider thumb |
| `tooltip` | string | Hover text |
| `alignment` | string | Text alignment: `"left"`, `"center"`, `"right"` |
| `text_color` | LrColor | Color of text |
| `bind_to_object` | table | Default bound property table for this view and its children |

### Factory Functions for Layout Values

Call these on the factory object for platform-appropriate spacing:

```lua
f:dialog_spacing()    -- pixels between top-level items (views, group boxes)
f:control_spacing()   -- pixels between controls or groups of controls
f:label_spacing()     -- pixels between a label and its control
```

### Shared Width with `LrView.share()`

Use `LrView.share()` to make properties share the same value across the hierarchy. This is especially useful for aligning labels:

```lua
f:column {
    spacing = f:control_spacing(),
    f:row {
        spacing = f:label_spacing(),
        f:static_text {
            title = "Name:",
            alignment = "right",
            width = LrView.share "label_width",  -- shared binding
        },
        f:edit_field { width_in_chars = 20 },
    },
    f:row {
        spacing = f:label_spacing(),
        f:static_text {
            title = "Occupation:",
            alignment = "right",
            width = LrView.share "label_width",  -- same identifier -> same width
        },
        f:edit_field { width_in_chars = 20 },
    },
}
```

The largest width among all views sharing the same identifier is used for all of them, ensuring labels align properly.

---

## LrDialogs -- Modal Dialogs

The `LrDialogs` namespace provides functions for displaying messages, prompts, and custom dialogs.

### `LrDialogs.message(title, message, style)`

Displays a simple alert dialog with a single OK button.

- `style`: `"info"`, `"warning"`, or `"critical"`

```lua
LrDialogs.message("Export Complete", "All photos exported successfully.", "info")
```

### `LrDialogs.confirm(title, message, okButton, cancelButton, otherButton)`

Displays a confirmation dialog with configurable buttons. Returns a string indicating which button was clicked (`"ok"`, `"cancel"`, or `"other"`).

```lua
local result = LrDialogs.confirm(
    "Delete Photos?",
    "This will permanently remove 5 photos.",
    "Delete",      -- OK button text
    "Cancel",      -- Cancel button text
    "Keep Copies"  -- optional third button
)
if result == "ok" then
    -- proceed with delete
end
```

### `LrDialogs.presentModalDialog { ... }` -- Custom Modal Dialog

Creates a fully custom dialog box. Returns `"ok"` or `"cancel"` based on which button the user clicks.

| Parameter | Type | Description |
|---|---|---|
| `title` | string | Dialog window title (not bindable) |
| `contents` | view | LrView hierarchy for the dialog body |
| `actionVerb` | string | Label for the OK/action button (default "OK") |
| `cancelVerb` | string | Label for the cancel button (default "Cancel"); use `"< exclude >"` to hide it |
| `otherVerb` | string | Label for a third button, placed between action and cancel. When clicked, `presentModalDialog` returns `"other"`. Return values become: `"ok"` (action button), `"other"` (third button), `"cancel"`. |
| `resizable` | boolean | Whether the user can resize the dialog |
| `save_frame` | string | An identifier to persist the dialog's size and position |
| `accessoryView` | view | View to display alongside OK/Cancel buttons in the button bar (e.g. extra action buttons) |

```lua
LrFunctionContext.callWithContext("myDialog", function(context)
    local f = LrView.osFactory()
    local props = LrBinding.makePropertyTable(context)
    props.url = "https://example.com"

    local contents = f:row {
        spacing = f:label_spacing(),
        bind_to_object = props,
        f:static_text { title = "URL:" },
        f:edit_field { value = bind 'url', width_in_chars = 30 },
    }

    local result = LrDialogs.presentModalDialog {
        title = "Enter URL",
        contents = contents,
        actionVerb = "Go",
    }

    if result == "ok" then
        LrHttp.openUrlInBrowser(props.url)
    end
end)
```

### `LrDialogs.presentFloatingDialog { ... }` -- Non-Modal Dialog

Similar to `presentModalDialog` but non-modal -- the user can interact with Lightroom's main window while the dialog is open. Accepts the same parameters.

### `LrDialogs.runOpenPanel { ... }` -- File Picker

Displays the platform file-open dialog. Returns a table of selected paths, or `nil` if cancelled.

| Parameter | Type | Description |
|---|---|---|
| `title` | string | Dialog title |
| `canChooseFiles` | boolean | Allow file selection |
| `canChooseDirectories` | boolean | Allow directory selection |
| `allowsMultipleSelection` | boolean | Allow selecting multiple items |
| `fileTypes` | table or string | Allowed extensions as a table of strings (e.g. `{"jpg","png"}`) or a single string (e.g. `"jpg"`) |
| `initialDirectory` | string | Path to start browsing from |

```lua
local paths = LrDialogs.runOpenPanel {
    title = "Select Images",
    canChooseFiles = true,
    canChooseDirectories = false,
    allowsMultipleSelection = true,
    fileTypes = { "jpg", "jpeg", "png", "tif" },
}
if paths then
    for _, path in ipairs(paths) do
        -- process each selected file
    end
end
```

### `LrDialogs.runSavePanel { ... }` -- Save Dialog

Displays the platform save-file dialog. Returns the chosen path, or `nil` if cancelled. Accepts similar parameters to `runOpenPanel`.

### `LrDialogs.showBezel(message, seconds)` -- Temporary Overlay

Displays a temporary translucent message overlay (a "bezel") that fades away after the specified time.

```lua
LrDialogs.showBezel("Upload complete!", 3)
```

---

## LrBinding -- Data Binding

Bindings create a two-way relationship between UI element properties and values in an observable table. When the data changes, the UI updates; when the user interacts with a control, the data updates.

### Creating Observable Property Tables

Observable tables must be created within a function context (so Lightroom can clean up if errors occur):

```lua
local LrBinding = import "LrBinding"
local LrFunctionContext = import "LrFunctionContext"

LrFunctionContext.callWithContext("myContext", function(context)
    local properties = LrBinding.makePropertyTable(context)
    properties.url = "https://example.com"   -- initialize a value
    properties.quality = 80
    -- keys don't need to exist before binding; unbound keys start as nil
end)
```

**Tip:** Use a naming convention (e.g., underscore prefix `_tempUrl`) to distinguish local/temporary data from persistent export settings.

### The `bind` Shortcut

```lua
local bind = LrView.bind   -- shortcut for the bind() function
```

Then use `bind 'keyName'` as the value of any view property:

```lua
f:edit_field { value = bind 'url' }
f:checkbox { title = "Enable", value = bind 'isEnabled' }
f:static_text { visible = bind 'showStatus', title = bind 'statusText' }
```

### How Binding Works

1. Set `bind_to_object` at some level of the hierarchy to specify the default table. In Export dialog sections, this is set automatically to the `propertyTable` passed to your function.
2. For each dynamic property, use `bind 'key'` to associate it with a key in the bound table.
3. The binding is two-way: table changes update the UI, and UI changes update the table.
4. Two controls bound to the same key are effectively bound to each other.

```lua
local contents = f:column {
    bind_to_object = properties,    -- set once for all children
    f:slider { value = bind 'quality', min = 0, max = 100 },
    f:edit_field { value = bind 'quality', width_in_digits = 3 },
    -- slider and edit_field stay synchronized via the shared key
}
```

**Note:** Bindings work for dynamic values in LrView objects only. Dialog titles and section titles cannot be bound.

### Observable Tables and Observers

You can register observer functions to respond to changes in an observable table:

```lua
propertyTable:addObserver('key', function(properties, key, newValue)
    -- properties: the observed table (access other values here)
    -- key: which key changed (useful if same handler watches multiple keys)
    -- newValue: the new value
end)
```

Remove an observer with:

```lua
propertyTable:removeObserver('key', callbackFunction)
```

**Practical example -- combo box with dynamic items:**

```lua
LrFunctionContext.callWithContext("comboExample", function(context)
    local f = LrView.osFactory()
    local props = LrBinding.makePropertyTable(context)

    -- Add observer: when storeValue changes, add it to storeItems if new
    props:addObserver('storeValue', function(properties, key, newValue)
        local items = properties.storeItems or {}
        local found = false
        for _, v in ipairs(items) do
            if v == newValue then found = true; break end
        end
        if not found then
            items[#items + 1] = newValue
        end
        properties.storeItems = items  -- triggers UI update
    end)

    local contents = f:column {
        spacing = f:control_spacing(),
        bind_to_object = props,
        f:combo_box {
            value = bind 'storeValue',
            items = bind 'storeItems',  -- dynamically updated
        },
    }

    LrDialogs.presentModalDialog {
        title = "Dynamic Combo Box",
        contents = contents,
    }
end)
```

### Simple Bindings

The simplest binding keeps a property and a key synchronized (same datatype):

```lua
visible = bind 'showPanel'          -- boolean <-> boolean
title = bind 'currentStatus'        -- string <-> string
value = bind 'sliderValue'          -- number <-> number
```

### LrBinding Helper Functions

For common transformations without writing custom functions:

| Function | Description |
|---|---|
| `LrBinding.negativeOfKey("key")` | Negate boolean or numeric value (two-way) |
| `LrBinding.keyEquals("key", value)` | True when key equals value (one-way, boolean) |
| `LrBinding.keyIsNot("key", value)` | True when key does not equal value (one-way, boolean) |
| `LrBinding.keyIsNil("key")` | True when key value is nil (one-way, boolean) |
| `LrBinding.keyIsNotNil("key")` | True when key value is not nil (one-way, boolean) |
| `LrBinding.andAllKeys("key1", "key2", ...)` | True when all specified boolean keys are true (one-way) |
| `LrBinding.orAllKeys("key1", "key2", ...)` | True when any specified boolean key is true (one-way) |

All except `negativeOfKey` are one-way: table changes drive the property, but not the reverse.

```lua
-- Show compression options only when format is TIFF
f:view {
    visible = LrBinding.keyEquals("format", "tiff"),
    f:popup_menu {
        value = bind 'tiffCompression',
        items = {
            { title = "None", value = "none" },
            { title = "LZW", value = "lzw" },
            { title = "ZIP", value = "zip" },
        },
    },
}
```

### Complex Bindings -- Transform

Pass a table to `bind` with a `key` and a `transform` function to map between the key value and the property value:

```lua
bind {
    key = 'fieldName',
    transform = function(value, fromTable)
        -- value: the new value
        -- fromTable: true if change came from the table, false if from the view
        return transformedValue
    end,
}
```

Return `LrBinding.kUnsupportedDirection` to indicate one direction is not supported.

**Example -- show warning text only when slider exceeds 100:**

```lua
f:slider {
    min = 0,
    max = 110,
    value = bind 'sliderValue',
},
f:static_text {
    title = "Warning: value over 100!",
    visible = bind {
        key = 'sliderValue',
        transform = function(value, fromTable)
            return value > 100
        end,
    },
}
```

**Example -- show text only when edit field is non-empty:**

```lua
f:edit_field {
    immediate = true,
    value = bind 'text',
    width_in_chars = 20,
},
f:static_text {
    title = "Text entered above will appear here",
    visible = bind {
        key = 'text',
        transform = function(value, fromTable)
            if fromTable then
                return value ~= nil and value ~= ''
            end
            return LrBinding.kUnsupportedDirection
        end,
    },
}
```

### Complex Bindings -- Multiple Keys

Bind a property to multiple keys using `keys` and an `operation` function:

```lua
bind {
    keys = { 'key1', 'key2' },
    operation = function(binder, values, fromTable)
        -- values: lookup table of current key values
        -- Return the computed value for the bound property
        return computedResult
    end,
    transform = function(value, fromTable)  -- optional further transform
        return finalValue
    end,
}
```

The `operation` function is called at the end of an event cycle when any specified key changes, so multiple key changes may be batched.

Each entry in the `keys` table can be a simple string or a table with a `key` field (and optionally `bind_to_object` to bind to a different table). The expanded form is useful for combining keys from different property tables:

```lua
visible = LrView.bind {
    keys = { { key = "key1" }, { key = "key2" } },
    operation = function(binder, values, fromTable)
        return values.key1 and values.key2
    end,
}
```

**Example -- show text only when two fields match:**

```lua
f:edit_field {
    immediate = true,
    value = bind 'password',
    width_in_chars = 20,
},
f:edit_field {
    immediate = true,
    value = bind 'confirmPassword',
    width_in_chars = 20,
},
f:static_text {
    title = "Passwords match!",
    visible = bind {
        keys = { 'password', 'confirmPassword' },
        operation = function(binder, values, fromTable)
            if fromTable then
                return values.password == values.confirmPassword
            end
            return LrBinding.kUnsupportedDirection
        end,
    },
}
```

### Binding to a Different Table

Override the default bound table for a specific binding:

```lua
enabled = bind {
    key = 'mySetting',
    bind_to_object = otherTable,
}
```

This lets you bind different properties in the same view to keys in different tables.

For multi-key bindings with different tables, use `uniqueKey` to avoid name collisions:

```lua
bind {
    keys = {
        { key = 'name', bind_to_object = tableA },
        { key = 'name', bind_to_object = tableB, uniqueKey = 'nameB' },
    },
    operation = function(binder, values, fromTable)
        return values.name .. " / " .. values.nameB
    end,
}
```

### Dot-Separated Hierarchical Keys

Keys in the bound table support dot notation: `bind 'x.y'` binds to key `y` in the table bound to key `x`.

---

## Section Definitions for Export Dialog

Export and Publish service providers define custom UI sections using `sectionsForTopOfDialog` and `sectionsForBottomOfDialog`. These functions receive the view factory and the export-settings property table (which is automatically set as `bind_to_object` for the whole hierarchy).

```lua
function exportServiceProvider.sectionsForTopOfDialog(f, propertyTable)
    return {
        {
            title = "My Service Settings",
            synopsis = bind { key = 'serviceSetting', object = propertyTable },
            -- NOTE: synopsis is not part of the view hierarchy,
            -- so you must specify bind_to_object explicitly

            f:row {
                spacing = f:label_spacing(),
                f:static_text {
                    title = "API Endpoint:",
                    alignment = "right",
                    width = LrView.share "label_width",
                },
                f:edit_field {
                    value = bind 'apiEndpoint',
                    width_in_chars = 40,
                    fill_horizontal = 1,
                },
            },

            f:row {
                spacing = f:label_spacing(),
                f:static_text {
                    title = "Quality:",
                    alignment = "right",
                    width = LrView.share "label_width",
                },
                f:slider {
                    value = bind 'jpegQuality',
                    min = 0,
                    max = 100,
                    fill_horizontal = 1,
                },
                f:edit_field {
                    value = bind 'jpegQuality',
                    width_in_digits = 3,
                    min = 0,
                    max = 100,
                    precision = 0,
                },
            },

            f:row {
                f:checkbox {
                    title = "Resize to fit",
                    value = bind 'resizeToFit',
                },
            },
        },
    }
end
```

**Key points about section definitions:**
- The `title` of a section is not bindable.
- The `synopsis` (collapsed summary text) is not part of the view hierarchy, so you must specify `bind_to_object` or `object` explicitly if you want it to be dynamic. The `synopsis` can also be a **function** receiving the props table, returning a computed string: `synopsis = function(props) return props.user .. "@" .. props.host end`
- The `propertyTable` contains both your custom export settings (from `exportPresetFields`) and Lightroom's built-in export settings (prefixed with `LR_`).

---

## Complete Example: Dynamic Format-Dependent UI

This example brings together overlapping layout, bindings, and conditional visibility to show different controls based on a format selection:

```lua
LrFunctionContext.callWithContext("formatDialog", function(context)
    local f = LrView.osFactory()
    local props = LrBinding.makePropertyTable(context)
    props.format = "jpeg"
    props.jpeg_quality = 80
    props.tiff_compression = "none"

    local contents = f:column {
        spacing = f:control_spacing(),
        bind_to_object = props,

        -- Format selector
        f:popup_menu {
            value = bind 'format',
            items = {
                { title = "JPEG", value = "jpeg" },
                { title = "TIFF", value = "tiff" },
            },
        },

        -- Overlapping views: only one visible at a time
        f:column {
            place = "overlapping",

            -- JPEG options
            f:view {
                visible = LrBinding.keyEquals("format", "jpeg"),
                margin = 3,
                f:row {
                    spacing = f:label_spacing(),
                    f:static_text { title = "Quality:" },
                    f:slider {
                        value = bind 'jpeg_quality',
                        min = 0, max = 100,
                        fill_horizontal = 1,
                    },
                    f:edit_field {
                        value = bind 'jpeg_quality',
                        width_in_digits = 3,
                        min = 0, max = 100, precision = 0,
                    },
                },
            },

            -- TIFF options
            f:view {
                visible = LrBinding.keyEquals("format", "tiff"),
                margin = 3,
                f:row {
                    spacing = f:label_spacing(),
                    f:static_text { title = "Compression:" },
                    f:popup_menu {
                        value = bind 'tiff_compression',
                        items = {
                            { title = "None", value = "none" },
                            { title = "LZW", value = "lzw" },
                            { title = "ZIP", value = "zip" },
                        },
                    },
                },
            },
        },
    }

    LrDialogs.presentModalDialog {
        title = "Export Format",
        contents = contents,
    }
end)
```

This pattern -- `place = "overlapping"` with `LrBinding.keyEquals()` on each child's `visible` -- is the standard SDK approach for showing/hiding groups of controls based on user selection.

---

<!-- BEGIN OFFICIAL_UI_VIEWS -->
## Official UI/View Property Reference (SDK 11.4)

Authoritative view-property and factory-method catalog from official docs.

### LrView Factory Methods

- `viewFactory:catalog_photo( args )`
- `viewFactory:checkbox( args )`
- `viewFactory:color_well( args )`
- `viewFactory:column( args )`
- `viewFactory:combo_box( args )`
- `viewFactory:control_spacing()`
- `viewFactory:dialog_spacing()`
- `viewFactory:edit_field( args )`
- `viewFactory:group_box( args )`
- `viewFactory:label_spacing()`
- `viewFactory:password_field( args )`
- `viewFactory:picture( args )`
- `viewFactory:popup_menu( args )`
- `viewFactory:push_button( args )`
- `viewFactory:radio_button( args )`
- `viewFactory:row( args )`
- `viewFactory:scrolled_view( args )`
- `viewFactory:separator( args )`
- `viewFactory:simple_list( args )`
- `viewFactory:slider( args )`
- `viewFactory:spacer( args )`
- `viewFactory:static_text( args )`
- `viewFactory:tab_view( args )`
- `viewFactory:tab_view_item( args )`
- `viewFactory:view( args )`

### Full View Property Reference

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
<!-- END OFFICIAL_UI_VIEWS -->
