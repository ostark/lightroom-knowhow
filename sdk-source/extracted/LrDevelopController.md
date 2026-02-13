# LrDevelopController -- Complete API Reference (SDK 11.4)

> Extracted from: `SDK 11.4 / API Reference / modules / LrDevelopController.html`
> Namespace providing functions for controlling the Develop module.
> Access functions directly from the imported namespace: `local LrDevelopController = import 'LrDevelopController'`

**Critical prerequisite:** Most functions require the Develop module to be active at time of call.

---

## Table of Contents

1. [Method Signatures (All 47 Functions)](#method-signatures)
2. [Develop Parameter Names by Panel](#develop-parameter-names-by-panel)
3. [Panel IDs](#panel-ids)
4. [Tool Modes](#tool-modes)
5. [Mask Types and Subtypes](#mask-types-and-subtypes)
6. [Process Versions](#process-versions)
7. [Color Grading Views](#color-grading-views)
8. [Localized Adjustment Parameters (by Process Version)](#localized-adjustment-parameters)
9. [Deprecated Functions](#deprecated-functions)
10. [SDK Version History](#sdk-version-history)

---

## Method Signatures

### Getting and Setting Values

#### `LrDevelopController.getValue( param )` --> value
Gets the value of a Develop adjustment for the current photo.
- **param** (string) -- a Develop parameter name
- **Returns:** the current value of the parameter
- **Requires:** Develop module active
- **Since:** SDK 6.0

#### `LrDevelopController.setValue( param, value )`
Sets the value of a Develop adjustment for the current photo.
- **param** (string) -- a Develop parameter name
- **value** (number) -- the new value for the parameter
- **Requires:** Develop module active
- **Since:** SDK 6.0
- **Notes:**
  - Temperature adjustment is **logarithmic** for RAW and DNG images; all others are linear.
  - Texture is disabled for Process Versions 1 and 2. Versions 3 and 4 will get auto-updated to the Current Process Version on changing.

#### `LrDevelopController.getRange( param )` --> min, max
Gets the min and max value of a Develop adjustment.
- **param** (string) -- a Develop parameter name
- **Returns:** (number, number) the min and max value for the given parameter
- **Requires:** Develop module active
- **Since:** SDK 6.0

#### `LrDevelopController.increment( param )`
Increments the value of a Develop adjustment.
- **param** (string) -- a Develop parameter name
- **Requires:** Develop module active
- **Since:** SDK 6.0

#### `LrDevelopController.decrement( param )`
Decrements the value of a Develop adjustment. (Note: SDK docs say "Increments" but this is the decrement function.)
- **param** (string) -- a Develop parameter name
- **Requires:** Develop module active
- **Since:** SDK 6.0

---

### Resetting Adjustments

#### `LrDevelopController.resetToDefault( param )`
Resets a single Develop adjustment for the current photo.
- **param** (string) -- a Develop parameter name
- **Requires:** Develop module active
- **Since:** SDK 6.0

#### `LrDevelopController.resetAllDevelopAdjustments()`
Resets all Develop adjustments for the current photo.
- **Requires:** Develop module active
- **Since:** SDK 6.0

#### `LrDevelopController.resetCrop()`
Resets the crop angle and frame for the current photo.
- **Requires:** Develop module active
- **Since:** SDK 6.0

#### `LrDevelopController.resetSpotRemoval()`
Clears all spot removal adjustments from the current photo.
- **Requires:** Develop module active
- **Since:** SDK 6.0

#### `LrDevelopController.resetRedeye()`
Clears all redeye removal adjustments from the current photo.
- **Requires:** Develop module active
- **Since:** SDK 6.0

#### `LrDevelopController.resetMasking()`
Clears all masks from the current photo.
- **Requires:** Develop module active
- **Since:** SDK 11.0

#### `LrDevelopController.resetTransforms()`
Clears all transforms from the current photo.
- **Requires:** Develop module active
- **Since:** SDK 6.6

---

### Auto Adjustments

#### `LrDevelopController.setAutoTone()`
Sets Auto Tone for the current photo.
- **Since:** SDK 7.4

#### `LrDevelopController.setAutoWhiteBalance()`
Sets Auto White Balance for the current photo.
- **Since:** SDK 7.4

---

### Process Version

#### `LrDevelopController.getProcessVersion()` --> string
Returns the process version of the current photo.
- **Returns:** (string) the process version
- **Requires:** Develop module active
- **Since:** SDK 6.0

#### `LrDevelopController.setProcessVersion( value )`
Sets the process version of the current photo.
- **value** (string) -- one of: `"Version 1"`, `"Version 2"`, `"Version 3"`, `"Version 4"`, `"Version 5"`
- **Requires:** Develop module active
- **Since:** SDK 6.0

---

### Tool Selection

#### `LrDevelopController.getSelectedTool()` --> string
Reports which tool mode is active in Develop.
- **Returns:** (string) current tool mode, one of: `"loupe"`, `"crop"`, `"dust"`, `"redeye"`, `"masking"`
- **Requires:** Develop module active
- **Since:** SDK 6.0

#### `LrDevelopController.selectTool( tool )`
Select a tool mode in Develop.
- **tool** (string) -- one of: `"loupe"`, `"crop"`, `"dust"`, `"redeye"`, `"masking"`, `"upright"`
- **Requires:** Develop module active
- **Since:** SDK 6.0
- **Note:** `selectTool` accepts `"upright"` which `getSelectedTool` does not return.

---

### Panel Navigation

#### `LrDevelopController.revealPanel( paramOrPanelID )`
Expands and scrolls into view the panel with the given ID.
- **paramOrPanelID** (string) -- either a Develop parameter name or a panel ID (see [Panel IDs](#panel-ids))
- **Requires:** Develop module active
- **Since:** SDK 6.0

#### `LrDevelopController.revealPanelIfVisible( paramOrPanelID )`
Expands and scrolls into view the panel with the given ID, **only if** the right panel is already visible.
- **paramOrPanelID** (string) -- either a Develop parameter name or a panel ID (see [Panel IDs](#panel-ids))
- **Requires:** Develop module active
- **Since:** SDK 8.1

#### `LrDevelopController.revealAdjustedControls( reveal )`
Enables a mode where adjusting a parameter causes that panel to be automatically revealed in the panel track.
- **reveal** (bool) -- `true` to enable reveal behavior, `false` to disable it (the default mode)
- **Requires:** Develop module active
- **Since:** SDK 6.0

---

### Tracking and History

#### `LrDevelopController.startTracking( param )`
Temporarily puts the Develop module into its tracking state, causing faster, lower-quality redraw and preventing history states from being generated. Tracking will automatically be turned back off as soon as a different parameter is adjusted, or two seconds after the last adjustment is made.
- **param** (string) -- a Develop parameter name
- **Requires:** Develop module active
- **Since:** SDK 6.0

#### `LrDevelopController.stopTracking( isLocalParam )`
Causes Develop module to exit its tracking state immediately, creating a single history state for all changes that were made to the parameter that was being tracked.
- **isLocalParam** -- (documentation does not specify type; likely boolean indicating whether the tracked param is a local/masked adjustment)
- **Requires:** Develop module active
- **Since:** SDK 6.0

#### `LrDevelopController.setTrackingDelay( seconds )`
Sets the number of seconds that tracking remains enabled after each adjustment is made.
- **seconds** (number) -- number of seconds to wait before turning off tracking
- **Default:** 2 seconds
- **Requires:** Develop module active
- **Since:** SDK 6.0

#### `LrDevelopController.setMultipleAdjustmentThreshold( seconds )`
Sets the time threshold that determines when adjustments to different parameters will be grouped together into a single history state versus recorded separately. If multiple different parameters are changed within a window of time less than this threshold, they will be grouped together into a single "Multiple Settings" history state.
- **seconds** (number) -- time threshold under which multiple adjustments will be grouped together
- **Default:** 0.5 seconds
- **Note:** Has no effect if set to a value higher than the tracking delay.
- **Requires:** Develop module active
- **Since:** SDK 6.0

---

### Observer / Callback

#### `LrDevelopController.addAdjustmentChangeObserver( functionContext, observer, callback )`
Registers a callback to be called any time the adjustments in the Develop module change.
- **functionContext** (LrFunctionContext) -- the function context that retains the observation
- **observer** (object) -- an object that uniquely identifies the observer; will be passed into the callback
- **callback** (function(observer)) -- function that will be called
- **Requires:** Develop module active
- **Since:** SDK 6.0
- **Important:** Do not show modal dialogs inside the callback.

---

### External Editing

#### `LrDevelopController.editInPhotoshop()`
Edit the current photo in Photoshop.
- **Since:** SDK 7.4

---

### Navigation to Specific Tools

#### `LrDevelopController.goToMasking()`
Open Masking for the current photo.
- **Since:** SDK 11.0

#### `LrDevelopController.goToSpotRemoval()`
Open Spot Removal for the current photo.
- **Since:** SDK 7.4

---

### Clipping and Overlay

#### `LrDevelopController.showClipping()`
Shows the clipping indicators.
- **Requires:** Develop module active
- **Since:** SDK 7.4

#### `LrDevelopController.toggleOverlay()`
Toggles the mask overlay.
- **Requires:** Masking must be active
- **Since:** SDK 7.4

---

### Color Grading View

#### `LrDevelopController.getActiveColorGradingView()` --> string
Get Active Color Grading View.
- **Returns:** (string) the currently active color grading view
- **Requires:** Develop module active, Process Version 3 or above
- **Since:** SDK 10.0

#### `LrDevelopController.setActiveColorGradingView( value )`
Set Active Color Grading View.
- **value** (string) -- one of: `"3-way"`, `"shadow"`, `"midtone"`, `"highlight"`, `"global"`
- **Requires:** Develop module active, Process Version 3 or above
- **Since:** SDK 10.0

---

### Masking -- Creating and Modifying Masks (SDK 11.0+)

#### `LrDevelopController.createNewMask( maskType, maskSubtype )`
Create a new mask.
- **maskType** (string) -- one of: `"brush"`, `"gradient"`, `"radialGradient"`, `"rangeMask"`, `"aiSelection"`
- **maskSubtype** (string) -- only used when maskType is `"rangeMask"` or `"aiSelection"`, one of: `"color"`, `"luminance"`, `"depth"`, `"subject"`, `"sky"`
- **Requires:** Develop module active
- **Since:** SDK 11.0

#### `LrDevelopController.addToCurrentMask( maskType, maskSubtype )`
Add to the current mask (union / add operation).
- **maskType** (string) -- one of: `"brush"`, `"gradient"`, `"radialGradient"`, `"rangeMask"`, `"aiSelection"`
- **maskSubtype** (string) -- only used when maskType is `"rangeMask"` or `"aiSelection"`, one of: `"color"`, `"luminance"`, `"depth"`, `"subject"`, `"sky"`
- **Requires:** Develop module active
- **Since:** SDK 11.0

#### `LrDevelopController.subtractFromCurrentMask( maskType, maskSubtype )`
Subtract from the current mask.
- **maskType** (string) -- one of: `"brush"`, `"gradient"`, `"radialGradient"`, `"rangeMask"`, `"aiSelection"`
- **maskSubtype** (string) -- only used when maskType is `"rangeMask"` or `"aiSelection"`, one of: `"color"`, `"luminance"`, `"depth"`, `"subject"`, `"sky"`
- **Requires:** Develop module active
- **Since:** SDK 11.0

#### `LrDevelopController.intersectWithCurrentMask( maskType, maskSubtype )`
Intersect with the current mask.
- **maskType** (string) -- one of: `"brush"`, `"gradient"`, `"radialGradient"`, `"rangeMask"`, `"aiSelection"`
- **maskSubtype** (string) -- only used when maskType is `"rangeMask"` or `"aiSelection"`, one of: `"color"`, `"luminance"`, `"depth"`, `"subject"`, `"sky"`
- **Requires:** Develop module active
- **Since:** SDK 11.0

---

### Masking -- Querying and Selecting Masks

#### `LrDevelopController.getAllMasks()` --> table
Get all masks on the current photo.
- **Returns:** (table) A table of tables, one for each mask. Each mask entry is a table, one for each tool within that mask.
- **Requires:** Develop module active
- **Since:** SDK 11.0

#### `LrDevelopController.getSelectedMask()` --> string
Get the selected mask.
- **Returns:** (string) ID of the selected mask
- **Requires:** Develop module active, masking tool open
- **Since:** SDK 11.0

#### `LrDevelopController.getSelectedMaskTool()` --> string
Get the selected mask tool.
- **Returns:** (boolean/string) ID of the selected mask tool (SDK docs type as boolean, likely returns string ID or false/nil if none)
- **Requires:** Develop module active, masking tool open
- **Since:** SDK 11.0

#### `LrDevelopController.selectMask( id, param )`
Select a mask.
- **id** -- (undocumented type, likely number/string)
- **param** (string) -- ID of the mask to be selected
- **Requires:** Develop module active, masking tool open
- **Since:** SDK 11.0

#### `LrDevelopController.selectMaskTool( id, param )`
Select a mask tool in the current mask.
- **id** -- (undocumented type, likely number/string)
- **param** (string) -- ID of the mask tool to be selected
- **Requires:** Develop module active, masking tool open
- **Since:** SDK 11.0

---

### Masking -- Deleting Masks

#### `LrDevelopController.deleteMask( id, param )`
Delete a mask.
- **id** -- (undocumented type)
- **param** (string) -- ID of the mask to be deleted
- **Requires:** Develop module active, masking tool open
- **Since:** SDK 11.0

#### `LrDevelopController.deleteMaskTool( id, param )`
Delete a mask tool from the current mask.
- **id** -- (undocumented type)
- **param** (string) -- ID of the mask tool to be deleted
- **Requires:** Develop module active, masking tool open
- **Since:** SDK 11.0

---

### Masking -- Visibility and Inversion

#### `LrDevelopController.toggleHideMask( id, param )`
Hide/unhide a mask.
- **id** -- (undocumented type)
- **param** (string) -- ID of the mask which is to be hidden/unhidden
- **Requires:** Develop module active, masking tool open
- **Since:** SDK 11.0

#### `LrDevelopController.toggleHideMaskTool( id, param )`
Hide/unhide a mask tool in the current mask.
- **id** -- (undocumented type)
- **param** (string) -- ID of the mask tool which is to be hidden/unhidden
- **Requires:** Develop module active, masking tool open
- **Since:** SDK 11.0

#### `LrDevelopController.toggleInvertMaskTool( id, param )`
Toggle the invert state of a mask tool in the current mask.
- **id** -- (undocumented type)
- **param** (string) -- ID of the mask tool whose invert state is to be toggled
- **Requires:** Develop module active, masking tool open
- **Since:** SDK 11.0

#### `LrDevelopController.invertMask( id, param )` --> boolean
Invert a mask.
- **id** -- (undocumented type)
- **param** (string) -- ID of the mask to be inverted
- **Returns:** (boolean) true if the mask was successfully inverted
- **Requires:** Develop module active, masking tool open
- **Since:** SDK 11.4

#### `LrDevelopController.duplicateAndInvertMask( id, param )` --> boolean
Duplicate and invert a mask.
- **id** -- (undocumented type)
- **param** (string) -- ID of the mask to be duplicated and inverted
- **Returns:** (boolean) true if the mask was successfully duplicated and inverted
- **Requires:** Develop module active, masking tool open
- **Since:** SDK 11.4

---

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

## Panel IDs

These strings can be passed to `revealPanel()` and `revealPanelIfVisible()`:

| Panel ID | UI Panel Name |
|---|---|
| `"adjustPanel"` | Basic (WB, Tone, Presence) |
| `"tonePanel"` | Tone Curve |
| `"mixerPanel"` | HSL / Color / B&W |
| `"colorGradingPanel"` | Color Grading |
| `"detailPanel"` | Detail (Sharpening + NR) |
| `"lensCorrectionsPanel"` | Lens Corrections |
| `"effectsPanel"` | Effects (Vignette + Grain) |
| `"calibratePanel"` | Camera Calibration |

---

## Tool Modes

### For `selectTool( tool )`

| Tool String | Description |
|---|---|
| `"loupe"` | Standard loupe/develop view |
| `"crop"` | Crop and straighten |
| `"dust"` | Spot removal / healing |
| `"redeye"` | Red eye correction |
| `"masking"` | Masking (new in SDK 11.0) |
| `"upright"` | Upright / perspective correction |

### For `getSelectedTool()` return values

| Tool String | Description |
|---|---|
| `"loupe"` | Standard loupe/develop view |
| `"crop"` | Crop and straighten |
| `"dust"` | Spot removal / healing |
| `"redeye"` | Red eye correction |
| `"masking"` | Masking |

Note: `"upright"` can be set via `selectTool` but is **not** listed as a return value of `getSelectedTool`.

---

## Mask Types and Subtypes

Used by `createNewMask`, `addToCurrentMask`, `subtractFromCurrentMask`, `intersectWithCurrentMask`.

### maskType values

| Type | Description |
|---|---|
| `"brush"` | Brush tool |
| `"gradient"` | Linear gradient |
| `"radialGradient"` | Radial gradient / vignette |
| `"rangeMask"` | Range mask (requires subtype) |
| `"aiSelection"` | AI-powered selection (requires subtype) |

### maskSubtype values

Only used when maskType is `"rangeMask"` or `"aiSelection"`:

| Subtype | Description |
|---|---|
| `"color"` | Color range mask |
| `"luminance"` | Luminance range mask |
| `"depth"` | Depth range mask |
| `"subject"` | AI subject selection |
| `"sky"` | AI sky selection |

---

## Process Versions

| String Value | Notes |
|---|---|
| `"Version 1"` | Legacy (LR 1-3 era). Highlights = Recovery, Shadows = Fill Light, Brightness active. Whites has no effect. |
| `"Version 2"` | Legacy. Same behavior as V1 for Highlights/Shadows/Brightness/Whites. Limited local adjustment params. |
| `"Version 3"` | Modern. Full parameter set for local adjustments. Required for Color Grading. |
| `"Version 4"` | Same local adjustment params as V3. |
| `"Version 5"` | Current. Adds local_Texture, local_Hue, local_Amount to local adjustments. |

---

## Color Grading Views

Used by `setActiveColorGradingView()` / `getActiveColorGradingView()`:

| View String | Description |
|---|---|
| `"3-way"` | Three-way view (shadows, midtones, highlights) |
| `"shadow"` | Shadow wheel only |
| `"midtone"` | Midtone wheel only |
| `"highlight"` | Highlight wheel only |
| `"global"` | Global adjustment wheel |

---

## Deprecated Functions

These functions are retained for backward compatibility but should not be used in new code:

| Function | Replacement |
|---|---|
| `LrDevelopController.goToDevelopGraduatedFilter()` | Use `selectTool("masking")` + `createNewMask("gradient")` |
| `LrDevelopController.goToDevelopRadialFilter()` | Use `selectTool("masking")` + `createNewMask("radialGradient")` |
| `LrDevelopController.resetBrushing()` | Use `resetMasking()` |
| `LrDevelopController.resetCircularGradient()` | Use `resetMasking()` |
| `LrDevelopController.resetGradient()` | Use `resetMasking()` |

All deprecated since SDK 11.0 (masking replaced separate brush/gradient/radial tools). Marked as "Deprecated API - included for avoiding breakage of plugins."

---

## SDK Version History

| SDK Version | Functions Added |
|---|---|
| **6.0** | `addAdjustmentChangeObserver`, `decrement`, `getProcessVersion`, `getRange`, `getSelectedTool`, `getValue`, `increment`, `resetAllDevelopAdjustments`, `resetBrushing` (deprecated), `resetCircularGradient` (deprecated), `resetCrop`, `resetGradient` (deprecated), `resetRedeye`, `resetSpotRemoval`, `resetToDefault`, `revealAdjustedControls`, `revealPanel`, `selectTool`, `setMultipleAdjustmentThreshold`, `setProcessVersion`, `setTrackingDelay`, `setValue`, `startTracking`, `stopTracking` |
| **6.6** | `resetTransforms` |
| **7.4** | `editInPhotoshop`, `goToDevelopGraduatedFilter` (deprecated), `goToDevelopRadialFilter` (deprecated), `goToSpotRemoval`, `setAutoTone`, `setAutoWhiteBalance`, `showClipping`, `toggleOverlay` |
| **8.1** | `revealPanelIfVisible` |
| **10.0** | `getActiveColorGradingView`, `setActiveColorGradingView` |
| **11.0** | `addToCurrentMask`, `createNewMask`, `deleteMask`, `deleteMaskTool`, `getAllMasks`, `getSelectedMask`, `getSelectedMaskTool`, `goToMasking`, `intersectWithCurrentMask`, `resetMasking`, `selectMask`, `selectMaskTool`, `subtractFromCurrentMask`, `toggleHideMask`, `toggleHideMaskTool`, `toggleInvertMaskTool` |
| **11.4** | `duplicateAndInvertMask`, `invertMask` |

---

## Complete Parameter Quick Reference (Alphabetical)

All 100+ parameter key names in a single list for quick lookup:

```
-- adjustPanel (16 params)
"Blacks"
"Brightness"
"Clarity"
"Contrast"
"Dehaze"
"Exposure"
"Highlights"
"PresetAmount"
"ProfileAmount"
"Saturation"
"Shadows"
"Temperature"
"Texture"
"Tint"
"Vibrance"
"Whites"

-- calibratePanel (7 params)
"BlueHue"
"BlueSaturation"
"GreenHue"
"GreenSaturation"
"RedHue"
"RedSaturation"
"ShadowTint"

-- colorGradingPanel (14 params)
"ColorGradeBlending"
"ColorGradeGlobalHue"
"ColorGradeGlobalLum"
"ColorGradeGlobalSat"
"ColorGradeHighlightLum"
"ColorGradeMidtoneHue"
"ColorGradeMidtoneLum"
"ColorGradeMidtoneSat"
"ColorGradeShadowLum"
"SplitToningBalance"
"SplitToningHighlightHue"
"SplitToningHighlightSaturation"
"SplitToningShadowHue"
"SplitToningShadowSaturation"

-- detailPanel (10 params)
"ColorNoiseReduction"
"ColorNoiseReductionDetail"
"ColorNoiseReductionSmoothness"
"LuminanceNoiseReductionContrast"
"LuminanceNoiseReductionDetail"
"LuminanceSmoothing"
"SharpenDetail"
"SharpenEdgeMasking"
"SharpenRadius"
"Sharpness"

-- effectsPanel (9 params)
"GrainAmount"
"GrainFrequency"
"GrainSize"
"PostCropVignetteAmount"
"PostCropVignetteFeather"
"PostCropVignetteHighlightContrast"
"PostCropVignetteMidpoint"
"PostCropVignetteRoundness"
"PostCropVignetteStyle"

-- lensCorrectionsPanel (14 params)
"DefringeGreenAmount"
"DefringeGreenHueHi"
"DefringeGreenHueLo"
"DefringePurpleAmount"
"DefringePurpleHueHi"
"DefringePurpleHueLo"
"LensManualDistortionAmount"
"LensProfileDistortionScale"
"LensProfileVignettingScale"
"PerspectiveAspect"
"PerspectiveHorizontal"
"PerspectiveRotate"
"PerspectiveScale"
"PerspectiveUpright"
"PerspectiveVertical"
"PerspectiveX"
"PerspectiveY"

-- mixerPanel -- HSL (24 params)
"HueAdjustmentAqua"
"HueAdjustmentBlue"
"HueAdjustmentGreen"
"HueAdjustmentMagenta"
"HueAdjustmentOrange"
"HueAdjustmentPurple"
"HueAdjustmentRed"
"HueAdjustmentYellow"
"LuminanceAdjustmentAqua"
"LuminanceAdjustmentBlue"
"LuminanceAdjustmentGreen"
"LuminanceAdjustmentMagenta"
"LuminanceAdjustmentOrange"
"LuminanceAdjustmentPurple"
"LuminanceAdjustmentRed"
"LuminanceAdjustmentYellow"
"SaturationAdjustmentAqua"
"SaturationAdjustmentBlue"
"SaturationAdjustmentGreen"
"SaturationAdjustmentMagenta"
"SaturationAdjustmentOrange"
"SaturationAdjustmentPurple"
"SaturationAdjustmentRed"
"SaturationAdjustmentYellow"

-- mixerPanel -- B&W (8 params)
"GrayMixerAqua"
"GrayMixerBlue"
"GrayMixerGreen"
"GrayMixerMagenta"
"GrayMixerOrange"
"GrayMixerPurple"
"GrayMixerRed"
"GrayMixerYellow"

-- tonePanel (7 params)
"ParametricDarks"
"ParametricHighlightSplit"
"ParametricHighlights"
"ParametricLights"
"ParametricMidtoneSplit"
"ParametricShadowSplit"
"ParametricShadows"

-- Crop (1 param)
"straightenAngle"

-- Localized adjustments (up to 18 params in PV5)
"local_Amount"
"local_Blacks"
"local_Clarity"
"local_Contrast"
"local_Defringe"
"local_Dehaze"
"local_Exposure"
"local_Highlights"
"local_Hue"
"local_LuminanceNoise"
"local_Moire"
"local_Saturation"
"local_Shadows"
"local_Sharpness"
"local_Temperature"
"local_Texture"
"local_Tint"
"local_ToningLuminance"
"local_Whites"
```

**Total global parameters:** 110
**Total local parameters:** 19 (varies by PV; max 18 in PV5 + 1 PV2-only)
**Total methods:** 47
