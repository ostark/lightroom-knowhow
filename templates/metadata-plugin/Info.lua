return {
    LrSdkVersion = 6.0,
    LrSdkMinimumVersion = 5.0,
    LrToolkitIdentifier = 'com.yourcompany.metadata-plugin',
    LrPluginName = "My Metadata Plugin",

    LrMetadataProvider = 'MetadataDefinition.lua',
    LrMetadataTagsetFactory = 'MetadataTagset.lua',

    LrLibraryMenuItems = {
        { title = "Set Custom Metadata", file = 'SetMetadata.lua' },
    },

    VERSION = { major = 1, minor = 0, revision = 0, build = 1 },
}
