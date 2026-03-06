---
name: result_dto_pattern
description: "Result DTO pattern for Back projects"
---
# Result DTO Pattern

```csharp
using System;
using System.Collections.Generic;
using System.Text;

public class {SubProgramName}{ProcessName}ResultDTO
{
    public {SubProgramName}{STORED_PROCEDURE_NAME}ResultDTO {STORED_PROCEDURE_NAME}Result { get; set; } // Single Record
    public List<{SubProgramName}{STORED_PROCEDURE_NAME}ResultDTO> {STORED_PROCEDURE_NAME}Result { get; set; } // List of Records
}
```