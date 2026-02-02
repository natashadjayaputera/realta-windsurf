---
name: viewmodel_class_pattern
description: "Define class structure and base usage in ViewModel layer"
---

# ViewModel Class Pattern

```csharp
namespace {ProgramName}Model.VMs
{
    public class {PageName}ViewModel : R_ViewModel<{ProgramName}DTO>
    {
        private readonly {ProgramName}Model _model = new {ProgramName}Model();

        // No constructor (IMPORTANT)
        
        // List of properties

        // List of functions
    }
}
```

# Rules
- Must inherit from `R_ViewModel<{ProgramName}DTO>`
- Must have a private readonly field of type `{ProgramName}Model`
- Never redeclare `Data` property manually
- No constructor (IMPORTANT)!