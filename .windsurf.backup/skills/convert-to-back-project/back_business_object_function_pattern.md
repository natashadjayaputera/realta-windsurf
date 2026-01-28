---
name: back_business_object_function_pattern
description: "Back layer business object function pattern"
---

# Back Business Object Function Pattern

The `R_BusinessObjectAsync<{ProgramName}DTO>` base class expects these exact function signatures:

```csharp
protected override async Task R_DeletingAsync({ProgramName}DTO poEntity) {}
protected override async Task<{ProgramName}DTO> R_DisplayAsync({ProgramName}DTO poEntity) {}
protected override async Task R_SavingAsync({ProgramName}DTO poNewEntity, eCRUDMode poCRUDMode) {}
```

## Example
```csharp
protected override async Task R_DeletingAsync(EntityDTO poEntity)
{
    // VB.NET logic
    // OR
    // throw new NotImplementedException();
}

protected override async Task<EntityDTO> R_DisplayAsync(EntityDTO poEntity)
{
    // VB.NET logic
    // OR
    // throw new NotImplementedException();
}

protected override async Task R_SavingAsync(EntityDTO poNewEntity, eCRUDMode poCRUDMode)
{
    // VB.NET logic
    // OR
    // throw new NotImplementedException();
}
```

Rules:
* If VB.NET Back Project does not implement the function, throw `NotImplementedException`
* If VB.NET Back Project implements the function, use the VB.NET logic (must not change the business process)
