---
name: model_class_pattern
description: "Define class structure and base usage in Model layer"
---

# Model Class Pattern

```csharp
namespace {ProgramName}Model;
{
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
}
```

# HTTP Client Name Convention

- Most modules: `"R_DefaultServiceUrl{ModuleName}"` (e.g., `"R_DefaultServiceUrlFA"`)
- GS and SA modules only: `"R_DefaultServiceUrl"` (no ModuleName suffix)