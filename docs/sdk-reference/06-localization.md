# Localization

## Overview

The Lightroom Classic SDK uses **ZStrings** -- an Adobe convention for defining localizable strings. ZStrings identify a string by its usage in the user interface and allow Lightroom to look up language-specific versions at runtime.

The localization system has three parts:

1. **ZStrings** -- A special string format with a hierarchical key path and a default English value
2. **The `LOC` function** -- A global function that resolves ZStrings to the correct language at runtime
3. **Translation dictionary files** -- Per-language text files that map ZString keys to translated text

Important: Reloading a plug-in interactively or automatically after export does **not** reload any localization dictionaries supplied with that plug-in. The translation dictionaries are read only when the plug-in is first loaded or Lightroom Classic is restarted.

---

## ZString Format

The format of a ZString is:

```
$$$/ZString_path/stringKey=defaultValue
```

| Component | Description |
|-----------|-------------|
| `$$$` | The ZString marker. Always required to identify a ZString and distinguish it from any other string. |
| `/ZString_path/stringKey=` | The path and key that uniquely identify the string. Used to look up translations in dictionary files. The path is a series of 7-bit ASCII strings separated by `/`. No white space is allowed. The last element is the key name, separated from the default value by `=`. |
| `defaultValue` | The default display string. If no matching key exists in the active localization dictionary (or if no appropriate dictionary is found), this value is displayed to the user. |

Each plug-in has its own mapping of context paths, so your path names will not conflict with those used by other plug-ins or by Lightroom Classic itself.

### Examples

```lua
-- A simple ZString with path and default value
"$$$/MyPlugin/Dialogs/Description/sectionName=Description"

-- ZStrings can use single or double quotes (standard Lua string rules)
LOC "$$$/MyPlugin/Dialogs/Description/sectionName=Description"
LOC '$$$/MyPlugin/Dialogs/Description/Title=Document Title:'
```

### ZString Characters and Escape Sequences

ZStrings in code should consist entirely of low-ASCII characters. The key should only contain characters in the set `a-zA-Z0-9/`. The value can contain any low-ASCII character.

ZStrings support special escape sequences using the `^` character:

| Sequence | Replacement |
|----------|-------------|
| `^r` | carriage return |
| `^n` | line feed |
| `^B` | bullet |
| `^C` | copyright |
| `^D` | degree |
| `^I` | increment |
| `^R` | registered trademark |
| `^S` | n-ary summation |
| `^T` | trademark |
| `^!` | not |
| `^{` | left single straight quote |
| `^}` | right single straight quote |
| `^[` | left double quote |
| `^]` | right double quote |
| `^'` | right single curly quote |
| `^.` | ellipsis ("...") |
| `^e` | Latin small e with acute accent |
| `^E` | Latin small e with circumflex |
| `^d` | Greek capital delta |
| `^L` | backslash (`\`) |
| `^V` | vertical bar (`\|`) |
| `^#` | command key (macOS) |
| `` ^` `` | accent grave |
| `^^` | circumflex (`^`) |
| `^0` - `^9` | Insertion points for additional `LOC` argument strings |
| `^U+xxxx` | Unicode code point U+xxxx |

---

## The LOC Function

`LOC` is a **global function** -- it is available without importing any namespace. It takes a ZString argument and automatically performs the dictionary lookup to resolve the display string for the current locale. If it cannot find a matching string in a dictionary for the current locale, or if there is no dictionary for the current locale, it returns the default string provided with the ZString.

### Basic Usage

You can use the `LOC` function anywhere you specify display strings:

- In the title for your Export Service Provider
- In the title for menu items that you add
- In the title and value properties of UI elements

```lua
-- In an Export Service Provider definition (Info.lua)
LrExportServiceProvider = {
    title = LOC "$$$/MyPlugin/Name=My Plug-in",
    file = 'MyPluginExportServiceProvider.lua',
},

-- In a menu item definition
LrExportMenuItems = {
    {
        title = LOC "$$$/MyPlugin/Menu/Export=Export Photos",
        file = "ExportMenuItem.lua",
    },
},

-- In a UI element
f:static_text {
    title = LOC "$$$/MyPlugin/Dialog/Label=Select a folder:",
},
```

You are not required to use the `LOC` function if you do not need to localize the text of your plug-in.

### String Substitution with Placeholders

The `LOC` function allows you to combine strings using placeholders in the ZString's value. Placeholders use "hat" notation with a numeric value: `^1` for the first argument, `^2` for the second, and so on. You can specify up to 9 additional string arguments (`^1` through `^9`).

```lua
-- Single substitution
LOC( "$$$/MyPlugin/Status/Count=^1 photos selected", tostring( count ) )
-- Result: "5 photos selected" (if count is 5)

-- Multiple substitutions
LOC( "$$$/MyPlugin/Error/FileOpen=Could not open the file ^1 because ^2.",
     "myfile.jpg", "a disk error occurred" )
-- Result: "Could not open the file myfile.jpg because a disk error occurred."

-- Substitution in a dialog
LrDialogs.message(
    LOC "$$$/MyPlugin/Upload/Title=Upload Complete",
    LOC( "$$$/MyPlugin/Upload/Summary=Successfully uploaded ^1 of ^2 photos.",
         tostring( successCount ), tostring( totalCount ) )
)
```

The advantage of using `^1`, `^2` placeholders instead of Lua string concatenation is that translators can reorder the substitution points for their language's grammar. For example, in a language where the word order differs, the translator can write:

```
"$$$/MyPlugin/Error/FileOpen=^2 raison: impossible d'ouvrir ^1."
```

---

## Translation Dictionary Files

To localize your plug-in's user interface, you must provide a localization dictionary file for each language you want to support.

### File Naming and Location

- Each translation dictionary must be named `TranslatedStrings_XX.txt`, where `XX` is the language code
- The dictionary files must be located in the **top plug-in folder**, alongside the `Info.lua` file

```
MyPlugin.lrdevplugin/
    Info.lua
    TranslatedStrings_de.txt
    TranslatedStrings_fr.txt
    TranslatedStrings_es.txt
    TranslatedStrings_ja.txt
    MyExportServiceProvider.lua
    ...
```

Lightroom Classic automatically selects the appropriate translation file based on the current language in use for the application.

### Dictionary File Format

A localization dictionary file is a **UTF-8 encoded** text file containing one ZString translation entry per line. Each ZString's final value is in the destination language.

Rules:
- One ZString per line
- Each ZString must be enclosed in **double quotes**
- No newline characters or comments are allowed on a line (after the first character)
- A leading UTF-8 byte-order marker (EF BB BF) is permitted

Recommended editors:
- On macOS: TextEdit, saved as "UTF-8" (not UTF-16 or UCS-2)
- On Windows: Notepad, saved as type "UTF-8"

### Example: German Dictionary (`TranslatedStrings_de.txt`)

```
"$$$/MyPlugin/Size/Small=Klein"
"$$$/MyPlugin/Size/Medium=Mittel"
"$$$/MyPlugin/Size/Large=Gro^U+00DF"
"$$$/MyPlugin/Size/Large/Extra=Sehr gro^U+00DF"
"$$$/MyPlugin/Image/Title=Titel"
"$$$/MyPlugin/Image/Quality=Qualit^U+00E4t"
"$$$/MyPlugin/Image/View=Ansicht"
"$$$/MyPlugin/Enabled=Aktiviert"
```

### Example: French Dictionary (`TranslatedStrings_fr.txt`)

```
"$$$/MyPlugin/Size/Small=Petit"
"$$$/MyPlugin/Size/Medium=Moyen"
"$$$/MyPlugin/Size/Large=Grand"
"$$$/MyPlugin/Image/Title=Titre"
"$$$/MyPlugin/Image/Quality=Qualit^e"
"$$$/MyPlugin/Image/View=Aper^U+00E7u"
"$$$/MyPlugin/Enabled=Activ^e"
```

### How Translation Lookup Works

When `LOC` encounters a ZString:

1. It looks for the localization dictionary matching the current locale (e.g., `TranslatedStrings_fr.txt` for French)
2. If found, it searches the dictionary for a line whose key path matches the ZString's key path (everything before the `=`)
3. If a matching line is found, it returns the translated value (everything after the `=` in the dictionary entry)
4. If no matching dictionary file exists, no matching line is found, or no dictionary is provided at all, it returns the default value from the original ZString

---

## Supported Languages

| Language | Code |
|----------|------|
| German | `de` |
| English | `en` |
| Spanish | `es` |
| French | `fr` |
| Italian | `it` |
| Japanese | `ja` |
| Korean | `ko` |
| Dutch | `nl` |
| Portuguese | `pt` |
| Russian | `ru` |
| Swedish | `sv` |
| Thai | `th` |
| Chinese, simplified | `zh_cn` |
| Chinese, traditional | `zh_tw` |

---

## LrAlsoUseBuiltInTranslations

You can set this optional Boolean property in your `Info.lua`:

```lua
return {
    LrSdkVersion = 5.0,
    LrToolkitIdentifier = 'com.example.myplugin',
    LrPluginName = LOC "$$$/MyPlugin/Name=My Plugin",
    LrAlsoUseBuiltInTranslations = true,
    -- ...
}
```

When set to `true`, strings that are **not** found in the plug-in's own translation file are checked against Lightroom Classic's built-in translation file for the current language. This is useful for common terms that Lightroom already translates, so you do not need to duplicate those translations in your own dictionary files.

**Caveats:**
- String keys in Lightroom's built-in translations are not guaranteed to remain the same across version releases
- Requires Lightroom Classic 3.0 or later (ignored in older versions)

---

## LrLocalization Namespace

The `LrLocalization` namespace allows you to localize your plug-in for use in multiple languages. Import it with:

```lua
local LrLocalization = import 'LrLocalization'
```

This namespace provides programmatic access to localization information, such as querying the current UI language at runtime.

---

## Complete Example

Here is a full example showing how to use localization throughout a plug-in.

### Info.lua

```lua
return {
    LrSdkVersion = 5.0,
    LrSdkMinimumVersion = 3.0,
    LrToolkitIdentifier = 'com.example.photouploader',
    LrPluginName = LOC "$$$/PhotoUploader/PluginName=Photo Uploader",
    LrAlsoUseBuiltInTranslations = true,

    LrExportServiceProvider = {
        title = LOC "$$$/PhotoUploader/Export/Title=Photo Uploader",
        file = 'ExportServiceProvider.lua',
    },

    LrExportMenuItems = {
        {
            title = LOC "$$$/PhotoUploader/Menu/Upload=Upload Selected Photos",
            file = "UploadMenuItem.lua",
        },
    },

    VERSION = { major = 1, minor = 0, revision = 0, display = "1.0.0" },
}
```

### ExportServiceProvider.lua (excerpt)

```lua
local LrView = import 'LrView'
local LrDialogs = import 'LrDialogs'

local exportServiceProvider = {}

function exportServiceProvider.sectionsForTopOfDialog( f, propertyTable )
    return {
        {
            title = LOC "$$$/PhotoUploader/Settings/Title=Upload Settings",
            f:row {
                f:static_text {
                    title = LOC "$$$/PhotoUploader/Settings/Destination=Destination:",
                },
                f:edit_field {
                    value = LrView.bind 'destinationUrl',
                    width_in_chars = 40,
                },
            },
            f:row {
                f:static_text {
                    title = LOC "$$$/PhotoUploader/Settings/Quality=Image Quality:",
                },
                f:popup_menu {
                    value = LrView.bind 'quality',
                    items = {
                        { title = LOC "$$$/PhotoUploader/Quality/High=High", value = "high" },
                        { title = LOC "$$$/PhotoUploader/Quality/Medium=Medium", value = "medium" },
                        { title = LOC "$$$/PhotoUploader/Quality/Low=Low", value = "low" },
                    },
                },
            },
        },
    }
end

function exportServiceProvider.processRenderedPhotos( functionContext, exportContext )
    local exportSession = exportContext.exportSession
    local nPhotos = exportSession:countRenditions()

    -- Use substitution for dynamic text
    local progressScope = LrDialogs.showModalProgressDialog {
        title = LOC( "$$$/PhotoUploader/Progress=Uploading ^1 photos^e",
                     tostring( nPhotos ) ),
        functionContext = functionContext,
    }

    local successCount = 0
    for i, rendition in exportContext:renditions() do
        local success, pathOrMessage = rendition:waitForRender()
        if success then
            successCount = successCount + 1
            -- upload logic here
        end
    end

    LrDialogs.message(
        LOC "$$$/PhotoUploader/Done/Title=Upload Complete",
        LOC( "$$$/PhotoUploader/Done/Summary=^1 of ^2 photos uploaded successfully.",
             tostring( successCount ), tostring( nPhotos ) )
    )
end

return exportServiceProvider
```

### TranslatedStrings_de.txt

```
"$$$/PhotoUploader/PluginName=Foto-Uploader"
"$$$/PhotoUploader/Export/Title=Foto-Uploader"
"$$$/PhotoUploader/Menu/Upload=Ausgew^U+00E4hlte Fotos hochladen"
"$$$/PhotoUploader/Settings/Title=Upload-Einstellungen"
"$$$/PhotoUploader/Settings/Destination=Ziel:"
"$$$/PhotoUploader/Settings/Quality=Bildqualit^U+00E4t:"
"$$$/PhotoUploader/Quality/High=Hoch"
"$$$/PhotoUploader/Quality/Medium=Mittel"
"$$$/PhotoUploader/Quality/Low=Niedrig"
"$$$/PhotoUploader/Progress=^1 Fotos werden hochgeladen^."
"$$$/PhotoUploader/Done/Title=Upload abgeschlossen"
"$$$/PhotoUploader/Done/Summary=^1 von ^2 Fotos erfolgreich hochgeladen."
```

### TranslatedStrings_fr.txt

```
"$$$/PhotoUploader/PluginName=T^el^echargeur de photos"
"$$$/PhotoUploader/Export/Title=T^el^echargeur de photos"
"$$$/PhotoUploader/Menu/Upload=T^el^echarger les photos s^electionn^ees"
"$$$/PhotoUploader/Settings/Title=Param^U+00E8tres de t^el^echargement"
"$$$/PhotoUploader/Settings/Destination=Destination :"
"$$$/PhotoUploader/Settings/Quality=Qualit^e de l^{image :"
"$$$/PhotoUploader/Quality/High=^U+00C9lev^ee"
"$$$/PhotoUploader/Quality/Medium=Moyenne"
"$$$/PhotoUploader/Quality/Low=Basse"
"$$$/PhotoUploader/Progress=T^el^echargement de ^1 photos^."
"$$$/PhotoUploader/Done/Title=T^el^echargement termin^e"
"$$$/PhotoUploader/Done/Summary=^1 photos sur ^2 t^el^echarg^ees avec succ^U+00E8s."
```

---

## Best Practices

- **Always use ZStrings for user-visible text** -- Even if you do not plan to localize initially, using ZStrings from the start makes future localization straightforward.
- **Keep key paths organized** -- Use a hierarchical structure grouped by feature or dialog (e.g., `$$$/MyPlugin/Export/...`, `$$$/MyPlugin/Settings/...`).
- **Provide meaningful default English text** -- The default value after the `=` should be proper, readable English since it serves as the fallback.
- **Use `^1`, `^2` substitution instead of string concatenation** -- This allows translators to reorder arguments for different grammars.
- **Test with different languages** -- Switch Lightroom's language setting to verify your translations display correctly.
- **Remember that dictionaries are loaded only once** -- Changing a dictionary file requires restarting Lightroom Classic or removing and re-adding the plug-in; simply reloading the plug-in is not sufficient.
- **Use `LrAlsoUseBuiltInTranslations = true` sparingly** -- Built-in key paths can change between Lightroom versions, so do not rely on them for critical strings.
- **Keep ZString keys in low-ASCII** -- Keys should only contain `a-zA-Z0-9/`. Use escape sequences for special characters in values.
