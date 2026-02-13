local LrApplication = import 'LrApplication'
local LrDialogs = import 'LrDialogs'
local LrTasks = import 'LrTasks'
local LrLogger = import 'LrLogger'
local LrFunctionContext = import 'LrFunctionContext'
local LrProgressScope = import 'LrProgressScope'

local logger = LrLogger('MyMenuPlugin')
logger:enable('print')

LrTasks.startAsyncTask(function()
    LrFunctionContext.callWithContext('myMenuAction', function(context)
        context:addFailureHandler(function(status, message)
            LrDialogs.showError("Error: " .. (message or "unknown"))
        end)

        local catalog = LrApplication.activeCatalog()
        local photos = catalog:getTargetPhotos()

        if #photos == 0 then
            LrDialogs.message("No Selection", "Please select one or more photos.", "info")
            return
        end

        local progress = LrProgressScope {
            title = "Processing photos",
            functionContext = context,
        }

        catalog:withWriteAccessDo("My Plugin Action", function()
            for i, photo in ipairs(photos) do
                if progress:isCanceled() then break end
                progress:setPortionComplete(i - 1, #photos)

                local fileName = photo:getFormattedMetadata('fileName')
                progress:setCaption("Processing " .. fileName)
                logger:infof('Processing: %s', fileName)

                -- TODO: Your action here
                -- photo:setRawMetadata('rating', 5)
            end
        end)

        progress:done()
        LrDialogs.showBezel("Done! Processed " .. #photos .. " photos.", 3)
    end)
end)
