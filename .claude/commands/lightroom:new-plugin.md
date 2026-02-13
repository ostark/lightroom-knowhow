---
description: Scaffold a new Lightroom plugin project
allowed-tools: Read, Write, Glob
---

# Create New Lightroom Plugin

The user wants to create a new plugin of type: $ARGUMENTS

## Instructions

1. Determine the plugin type from the arguments. Valid types:
   - `export` — Export service plugin
   - `publish` — Publish service plugin
   - `metadata` — Custom metadata plugin
   - `menu` — Library menu plugin

2. If the type is not specified or not recognized, ask the user which type they want.

3. Ask the user for:
   - Plugin name (e.g., "My Photo Uploader")
   - Toolkit identifier (e.g., "com.mycompany.photo-uploader")
   - Output directory (default: current directory)

4. Read the matching template from `templates/<type>-plugin/` in this project.

5. Create a new `.lrdevplugin` folder with the template files, replacing:
   - Toolkit identifier with the user's value
   - Plugin name with the user's value
   - Logger name with a reasonable derivative of the plugin name

6. Report what was created and next steps:
   - Open Lightroom Classic
   - File > Plug-in Manager > Add
   - Navigate to the .lrdevplugin folder
   - The plugin will hot-reload on file changes
