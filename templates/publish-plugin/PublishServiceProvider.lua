local LrView = import 'LrView'
local LrDialogs = import 'LrDialogs'
local LrHttp = import 'LrHttp'
local LrLogger = import 'LrLogger'
local LrPathUtils = import 'LrPathUtils'
local LrErrors = import 'LrErrors'

local bind = LrView.bind
local logger = LrLogger('MyPublishService')
logger:enable('print')

local publishServiceProvider = {}

publishServiceProvider.small_icon = 'icon.png'
publishServiceProvider.supportsIncrementalPublish = 'only'
publishServiceProvider.canExportToTemporaryLocation = true

publishServiceProvider.exportPresetFields = {
    { key = 'serverUrl', default = '' },
    { key = 'username', default = '' },
}

-- What metadata changes trigger republish
publishServiceProvider.metadataThatTriggersRepublish = function(publishSettings)
    return {
        default = false,
        title = true,
        caption = true,
        keywords = true,
    }
end

-- Collection behavior
publishServiceProvider.getCollectionBehaviorInfo = function(publishSettings)
    return {
        defaultCollectionName = "Default Collection",
        defaultCollectionCanBeDeleted = false,
        canAddCollection = true,
        maxCollectionSetDepth = 0, -- 0 = no sets allowed
    }
end

function publishServiceProvider.startDialog(propertyTable)
    logger:info('Publish dialog opened')
end

function publishServiceProvider.sectionsForTopOfDialog(f, propertyTable)
    return {
        {
            title = "Service Settings",
            synopsis = bind 'serverUrl',

            f:row {
                f:static_text { title = "Server URL:", width = LrView.share 'label_width' },
                f:edit_field { value = bind 'serverUrl', width_in_chars = 30 },
            },

            f:row {
                f:static_text { title = "Username:", width = LrView.share 'label_width' },
                f:edit_field { value = bind 'username', width_in_chars = 20 },
            },
        },
    }
end

function publishServiceProvider.processRenderedPhotos(functionContext, exportContext)
    local nPhotos = exportContext.exportSession:countRenditions()
    logger:infof('Publishing %d photos', nPhotos)

    for i, rendition in exportContext:renditions { stopIfCanceled = true } do
        local success, pathOrMessage = rendition:waitForRender()

        if success then
            local filePath = pathOrMessage
            local fileName = LrPathUtils.leafName(filePath)
            logger:infof('Publishing: %s', fileName)

            -- TODO: Upload to your service
            -- local remoteId = uploadToService(filePath, exportContext.propertyTable)

            local remoteId = fileName -- placeholder
            rendition:recordPublishedPhotoId(remoteId)
            -- rendition:recordPublishedPhotoUrl("https://example.com/photo/" .. remoteId)
        else
            rendition:uploadFailed(pathOrMessage)
        end
    end
end

function publishServiceProvider.deletePhotosFromPublishedCollection(publishSettings, arrayOfPhotoIds, deletedCallback, localCollectionId)
    for i, remoteId in ipairs(arrayOfPhotoIds) do
        logger:infof('Deleting remote photo: %s', remoteId)
        -- TODO: Delete from remote service
        deletedCallback(remoteId)
    end
end

return publishServiceProvider
