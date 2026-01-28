---
name: back_error_retrieval_pattern
description: "Retrieve resource-based error messages in Back projects"
---
# Error Retrieval Pattern

```csharp
private R_Error GetError(string pcErrorId)
{
    try
    {
        return R_Utility.R_GetError(typeof(Resources_Dummy_Class), pcErrorId);
    }
    catch (Exception)
    {
        throw;
    }
}
```

Rules:

* Always use resource keys from VB.NET
* Never hardcode messages
* Use `Resources_Dummy_Class` for namespace resolution
