---
trigger: model_decision
description: "Use in ToCSharpViewModel and ToCSharpFront workflow to Standardize resource file usage in Front layer"
---
# Resource File Rules

- Location: Root folder of FrontResources project
- Files: `{ProgramName}FrontResources_msgrsc.resx` (English), `{ProgramName}FrontResources_msgrsc.id.resx` (Indonesian)
- Use `R_FrontUtility.R_GetError(typeof(Resources_Dummy_Class), pcErrorId)`
- Never hardcode messages
