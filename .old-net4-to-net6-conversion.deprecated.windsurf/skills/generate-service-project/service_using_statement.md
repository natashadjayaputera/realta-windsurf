---
name: service_using_statement
description: "Minimal using statements required for {ProgramName}Service layer"
---

# Minimal Using Statements

```csharp
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using R_BackEnd;
using R_Common;
using R_CommonFrontBackAPI;
using R_CommonFrontBackAPI.Log;
using {ProgramName}Common;
using {ProgramName}Common.DTOs;
using {ProgramName}Back;
using {ProgramName}Back.DTOs;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Threading.Tasks;
```