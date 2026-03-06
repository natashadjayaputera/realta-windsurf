---
name: back_business_object_overridden_function_pattern
description: "Back Project Business Object Overridden Function Pattern"
---
# Back Business Object Overridden Function Pattern

Change the function signature to use this pattern exactly, please note that the function name has `Async` suffix:

```csharp
protected override async Task R_DeletingAsync({SubProgramName}DTO poEntity) {}
protected override async Task<{SubProgramName}DTO> R_DisplayAsync({SubProgramName}DTO poEntity) {}
protected override async Task R_SavingAsync({SubProgramName}DTO poNewEntity, eCRUDMode poCRUDMode) {}
```