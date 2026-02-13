local LrView = import 'LrView'
local LrDialogs = import 'LrDialogs'
local LrLogger = import 'LrLogger'
local LrPathUtils = import 'LrPathUtils'

local bind = LrView.bind
local logger = LrLogger('MyExportPlugin')
logger:enable('print')

local exportServiceProvider = {}

-- Define custom export settings with defaults
exportServiceProvider.exportPresetFields = {
    { key = 'customSetting', default = '' },
}

-- Control which built-in sections appear
exportServiceProvider.hideSections = { 'exportLocation' }
exportServiceProvider.allowFileFormats = { 'JPEG', 'TIFF', 'PSD' }
exportServiceProvider.allowColorSpaces = { 'sRGB', 'AdobeRGB' }
exportServiceProvider.canExportToTemporaryLocation = true

-- Called when export dialog opens
function exportServiceProvider.startDialog(propertyTable)
    logger:info('Export dialog opened')
end

-- Called when export dialog closes
function exportServiceProvider.endDialog(propertyTable)
    logger:info('Export dialog closed')
end

-- Custom UI sections at top of export dialog
function exportServiceProvider.sectionsForTopOfDialog(f, propertyTable)
    return {
        {
            title = "My Export Settings",
            synopsis = bind 'customSetting',

            f:row {
                spacing = f:control_spacing(),

                f:static_text {
                    title = "Custom Setting:",
                    alignment = 'right',
                    width = LrView.share 'label_width',
                },

                f:edit_field {
                    value = bind 'customSetting',
                    width_in_chars = 25,
                },
            },
        },
    }
end

-- Main export processing
function exportServiceProvider.processRenderedPhotos(functionContext, exportContext)
    local nPhotos = exportContext.exportSession:countRenditions()
    logger:infof('Starting export of %d photos', nPhotos)

    for i, rendition in exportContext:renditions { stopIfCanceled = true } do
        local success, pathOrMessage = rendition:waitForRender()

        if success then
            local filePath = pathOrMessage
            local fileName = LrPathUtils.leafName(filePath)
            logger:infof('Rendered: %s', fileName)

            -- TODO: Process the rendered file
            -- Upload, copy, transform, etc.

        else
            logger:errorf('Render failed: %s', pathOrMessage)
        end
    end

    logger:info('Export complete')
end

return exportServiceProvider
