---
description: Quick feasibility check for a Lightroom plugin idea
allowed-tools: Read, Grep, Glob
---

# Validate Plugin Idea

The user wants to validate this plugin idea: $ARGUMENTS

## Instructions

1. Search `docs/sdk-reference/` for relevant APIs and capabilities.
2. Check `docs/sdk-reference/10-limitations.md` for relevant constraints.
3. Provide a concise assessment:

### Assessment Format

**Idea**: [restate the idea concisely]

**Verdict**: Possible / Partially Possible / Not Possible

**Plugin Type**: Export / Publish / Metadata / Menu / Web Engine

**Key APIs Needed**:
- List the main APIs

**Complexity**: Simple / Moderate / Complex / Very Complex

**Approach** (2-3 sentences): How you'd build it.

**Risks/Limitations**: Any SDK constraints that matter.

**Next Step**: Suggest using the plugin-builder agent or /lightroom:new-plugin command.
