---
trigger: glob
description: "Standardize resource file usage in Front layer"
globs: ["*ToCSharpViewModel*", "*ToCSharpFront*"]
---
# Resource File Rules

- Location: Root folder of FrontResources project
- Files: `{ProgramName}FrontResources_msgrsc.resx` (English), `{ProgramName}FrontResources_msgrsc.id.resx` (Indonesian)
- Use `R_FrontUtility.R_GetError(typeof(Resources_Dummy_Class), pcErrorId)`
- Never hardcode messages
