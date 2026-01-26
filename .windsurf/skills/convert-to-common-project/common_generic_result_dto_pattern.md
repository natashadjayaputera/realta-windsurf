---
name: common_generic_result_dto_pattern
description: "Standard Generic Result DTO pattern for common projects using R_APIResultBaseDTO"
---
# Generic Result DTO Pattern

```csharp
using R_APICommonDTO;

namespace {ProgramName}Common.DTOs;
{
    // Generic Result DTO with data (for functions that return data)
    public class {ProgramName}ResultDTO<T> : R_APIResultBaseDTO
    {
        public T? Data { get; set; }
    }

    // Generic Result DTO without data (for functions that do not return data)
    public class {ProgramName}ResultDTO : R_APIResultBaseDTO
    {
    }
}
```

Rules:

* Must inherit from `R_APIResultBaseDTO`