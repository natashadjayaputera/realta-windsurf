---
trigger: model_decision
description: "Use in ToCSharpViewModel workflow for Use R_FrontUtility.R_GetError for all error messages"
---
# Resource Error Pattern

Never hardcode messages. Use resources:

```csharp
loEx.Add(R_FrontUtility.R_GetError(
    typeof({ProgramName}FrontResources.Resources_Dummy_Class),
    "ERR_INVALID_CODE"
));
```