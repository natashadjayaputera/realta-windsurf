---
name: back_class_template
description: "Template for Back Classes in Back Projects"
---

# Format (Non-Negotiable)
```csharp
using System;
using System.Data;
using System.Data.Common;
using System.Threading.Tasks;
using System.Collections.Generic;
using System.Linq;
using R_BackEnd;
using R_Common;
using R_CommonFrontBackAPI;
using {ProgramName}BackResources;
using {ProgramName}Common.DTOs;
using {ProgramName}Back.DTOs;
using System.Transactions;
using System.Diagnostics;

// IMPORTANT: Uncomment these references if there is any a function with category batch-function in `functions.txt`
// using System.Text;
// using R_OpenTelemetry;
// using System.Data.SqlClient;

namespace {ProgramName}Back;
{
    // Class Declaration MUST MATCH `chunks_cs/{ProgramName}/{SubProgramName}CLS/ClassDeclaration.txt`
    public class {SubProgramName}Cls
    {
        private readonly Logger{ProgramName} _logger;
        private readonly ActivitySource _activitySource;

        public {SubProgramName}Cls()
        {
            _logger = Logger{ProgramName}.R_GetInstanceLogger();
            _activitySource = {ProgramName}Activity.R_GetInstanceActivitySource();
        }

        // This line is used to inject functions from `XXXX_FunctionName.cs` files.
        // {INSERT_MERGED_CS_FUNCTION_HERE}
    }
}
```

Rules:
- DO NOT READ ANY `XXXX_FunctionName.cs` because it will be injected later.
- DO NOT ADD ANY FUNCTION IN THE CLASS.