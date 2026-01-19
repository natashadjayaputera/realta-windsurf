---
name: common_interface_requirements
description: "Ensure all Common layer interfaces inherit R_IServiceCRUDAsyncBase"
---
# Interface Requirements

- Must inherit: `R_IServiceCRUDAsyncBase<{ProgramName}DTO>`
- All functions returning `List` MUST follow streaming patterns. See `streaming_pattern.md`

# Interface Pattern

```csharp
using System;
using System.Collections.Generic;
using R_CommonFrontBackAPI;
using {ProgramName}Common.DTOs;

public interface I{ProgramName} : R_IServiceCRUDAsyncBase<{ProgramName}DTO>
{
    // Streaming pattern 
    IAsyncEnumerable<{FunctionName}ResultDTO>{FunctionName}()

    // Non-streaming with parameters
    Task<{ProgramName}ResultDTO<{FunctionName}ResultDTO>>{FunctionName}({FunctionName}ParameterDTO poParameter)

    // Non-streaming without parameters
    Task<{ProgramName}ResultDTO<{FunctionName}ResultDTO>>{FunctionName}()
}
```

**CRITICAL:** 
* Must use `R_IServiceCRUDAsyncBase`, not `R_IServiceCRUDBase`
* Functions in interface MUST NOT have `Async` as suffix
