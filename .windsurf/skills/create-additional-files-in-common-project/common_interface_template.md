---
name: common_interface_template
description: "Ensure all Common layer interfaces inherit R_IServiceCRUDAsyncBase"
---
# Interface Pattern

```csharp
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using R_CommonFrontBackAPI;
using {ProgramName}Common.DTOs;

namespace {ProgramName}Common;
{
    public interface I{SubProgramName}
    {
        // Example with parameters
        Task<{ProgramName}ResultDTO<{FunctionReturnType}>>{FunctionName}({FunctionParameterType} poParameter)

        // Example without parameters
        Task<{ProgramName}ResultDTO<{FunctionReturnType}>>{FunctionName}()
    }
}
```

# Rules
- If it is inheriting R_BusinessObject or R_BusinessObjectAsync, inherit R_IServiceCRUDAsyncBase<{SubProgramName}DTO>
- If it is implementing R_IBatchProcess or R_IBatchProcessAsync, do not add `R_BatchProcess` or `R_BatchProcessAsync` function
- Skip override functions
- Skip private or protected functions