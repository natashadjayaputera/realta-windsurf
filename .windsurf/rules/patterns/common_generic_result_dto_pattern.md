---
trigger: model_decision
description: "Use in ToCSharpCommon workflow to Standard Generic Result DTO pattern for common projects using R_APIResultBaseDTO"
---
# Activity Pattern

```csharp
using R_APICommonDTO;

public class FAI00130ResultDTO<T> : R_APIResultBaseDTO
{
    public T? Data { get; set; }
}
```

Rules:

* Must inherit from `R_APIResultBaseDTO`