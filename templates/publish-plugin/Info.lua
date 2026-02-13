return {
    LrSdkVersion = 6.0,
    LrSdkMinimumVersion = 5.0,
    LrToolkitIdentifier = 'com.yourcompany.publish-plugin',
    LrPluginName = "My Publish Service",

    LrExportServiceProvider = {
        title = "My Publish Service",
        file = 'PublishServiceProvider.lua',
        builtInPresetsDir = 'presets',
    },

    LrLibraryMenuItems = {
        { title = "My Publish Service Settings", file = 'MenuItems.lua' },
    },

    VERSION = { major = 1, minor = 0, revision = 0, build = 1 },
}
