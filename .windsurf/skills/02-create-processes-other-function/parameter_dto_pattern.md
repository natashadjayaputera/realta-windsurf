---
name: parameter_dto_pattern
description: "Parameter DTO pattern for Back projects"
---
# Parameter DTO Pattern

```csharp
using System;
using System.Collections.Generic;
using System.Text;

public class {SubProgramName}{ProcessName}ParameterDTO
{
    public {SubProgramName}{STORED_PROCEDURE_NAME}ParameterDTO {SP_NAME}Parameter { get; set; }
}
```