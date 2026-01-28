---
name: back_error_retrieval_pattern
description: "Retrieve resource-based error messages in Back projects"
---
# Error Retrieval Pattern
To retrieve error messages from resources, use the following pattern:
```csharp
loEx.Add(R_Utility.R_GetError(typeof({ProgramName}BackResources.Resources_Dummy_Class), "{ERROR_KEY}"));
```

Rules:

* Always use resource keys from VB.NET
* Never hardcode messages
* Use `{ProgramName}BackResources.Resources_Dummy_Class` for namespace resolution
