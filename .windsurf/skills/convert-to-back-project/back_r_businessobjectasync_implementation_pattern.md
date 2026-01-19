---
name: back_r_businessobjectasync_implementation_pattern
description: "Override functions implementation for R_BusinessObjectAsync in Back projects"
alwaysApply: false
globs: "*ToCSharpBack*"
---
# R_BusinessObjectAsync Implementation Pattern

Important: This pattern must be implemented for all functions in R_BusinessObjectAsync. If it's not implemented in VB.NET back project, throw `NotImplementedException`.

```csharp
protected override async Task R_DeletingAsync(EntityDTO poEntity)
{
    throw new NotImplementedException();
}

protected override async Task<EntityDTO> R_DisplayAsync(EntityDTO poEntity)
{
    throw new NotImplementedException();
}

protected override async Task R_SavingAsync(EntityDTO poNewEntity, eCRUDMode poCRUDMode)
{
    throw new NotImplementedException();
}
```

Rules:

* Must throw `NotImplementedException`
* Do NOT return `Task.CompletedTask`
* Indicates unsupported operation
