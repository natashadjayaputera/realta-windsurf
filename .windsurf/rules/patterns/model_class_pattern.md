---
trigger: model_decision
description: "Use in ToCSharpModel workflow to define class structure and base usage in Model layer"
---

# Model Class Pattern

```csharp
public class {ProgramName}Model : R_BusinessObjectServiceClientBase<{ProgramName}DTO>, I{ProgramName}
{
    private const string DEFAULT_HTTP_NAME = "R_DefaultServiceUrl{ModuleName}";
    private const string DEFAULT_SERVICEPOINT_NAME = "api/{ProgramName}";
    private const string DEFAULT_MODULE = "{ModuleName}";

    public {ProgramName}Model()
        : base(DEFAULT_HTTP_NAME, DEFAULT_SERVICEPOINT_NAME, DEFAULT_MODULE, true, true)
    {
    }
}
```