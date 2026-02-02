---
name: viewmodel_resource_retrieval_pattern
description: "ViewModel Resource Retrieval Pattern, never hardcode messages."
---
# Resource Retrieval Pattern

## Normal Message Retrieval
```csharp
var lcString = R_FrontUtility.R_GetMessage(
    typeof({ProgramName}FrontResources.Resources_Dummy_Class),
    "{ResourceKey}"
);
```

## Error Retrieval
```csharp
loEx.Add(R_FrontUtility.R_GetError(
    typeof({ProgramName}FrontResources.Resources_Dummy_Class),
    "{ResourceKey}"
));
```