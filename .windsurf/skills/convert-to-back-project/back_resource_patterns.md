---
name: back_resource_patterns
description: "Standardize resource file usage in Back layer"
---
# Resource File Rules

- Location: Root folder of BackResources project
- Files: `{ProgramName}BackResources_msgrsc.resx` (English), `{ProgramName}BackResources_msgrsc.id.resx` (Indonesian)
- Use `R_Utility.R_GetError(typeof(Resources_Dummy_Class), pcErrorId)`
- Never hardcode messages