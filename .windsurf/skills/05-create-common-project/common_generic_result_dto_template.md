---
name: common_generic_result_dto_template
description: "Generic Result DTO template for Common Project using R_APIResultBaseDTO"
---
# Location
- Location: `COMMON/{ProgramName}/{ProgramName}Common/DTOs/{ProgramName}ResultDTO.cs`

# Generic Result DTO Template
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

# Rules:
* Must inherit from `R_APIResultBaseDTO`