---
trigger: model_decision
description: "Use in ToCSharpService workflow for Minimal using statements required for {ProgramName}Service layer"
---

# Minimal Using Statements

```csharp
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using R_BackEnd;
using R_Common;
using R_CommonFrontBackAPI;
using {ProgramName}Common;
using {ProgramName}Common.DTOs;
using {ProgramName}Back;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Threading.Tasks;
```