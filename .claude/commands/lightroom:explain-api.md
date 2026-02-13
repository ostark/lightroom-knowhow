---
description: Look up and explain any Lightroom SDK API
allowed-tools: Read, Grep, Glob
---

# Explain SDK API

The user wants to know about: $ARGUMENTS

## Instructions

1. Search `docs/sdk-reference/` for the requested API:
   - Check `07-namespaces.md` for namespace functions (LrHttp, LrFileUtils, etc.)
   - Check `08-classes.md` for class methods (LrPhoto, LrCatalog, etc.)
   - Check `02-export-publish.md` for export/publish callbacks
   - Check `03-metadata.md` for metadata APIs
   - Check `04-ui-views.md` for UI/view APIs

2. If found, present:
   - **Full method signature** with parameter types
   - **Description** of what it does
   - **Parameters** table (name, type, description)
   - **Return value** (type and description)
   - **Code example** showing typical usage
   - **Related APIs** that are commonly used together
   - **Gotchas** if any from `10-limitations.md`

3. If not found in docs, say so honestly and suggest:
   - The API may be documented in the full API Reference (not yet loaded)
   - Check the Lightroom SDK documentation at adobe.com
   - The method name might be slightly different

4. If the query is vague (e.g., "photos" or "export"), list the relevant APIs and ask which one they want details on.
