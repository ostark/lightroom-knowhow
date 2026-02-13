return {
    metadataFieldsForPhotos = {
        {
            id = 'customField',
            title = LOC "$$$/MyPlugin/Fields/CustomField=Custom Field",
            dataType = 'string',
            searchable = true,
            browsable = true,
        },
        {
            id = 'status',
            title = LOC "$$$/MyPlugin/Fields/Status=Status",
            dataType = 'enum',
            values = {
                { value = 'none', title = LOC "$$$/MyPlugin/Fields/Status/None=None" },
                { value = 'pending', title = LOC "$$$/MyPlugin/Fields/Status/Pending=Pending" },
                { value = 'approved', title = LOC "$$$/MyPlugin/Fields/Status/Approved=Approved" },
                { value = 'rejected', title = LOC "$$$/MyPlugin/Fields/Status/Rejected=Rejected" },
            },
            searchable = true,
        },
    },
    schemaVersion = 1,
}
