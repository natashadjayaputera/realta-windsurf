---
name: back_activity_pattern
description: "Standard activity pattern for Back projects using R_ActivitySourceBase"
---
# Activity Pattern

```csharp
using R_OpenTelemetry;

namespace {ProgramName}Back.DTOs
{
    public class {ProgramName}Activity : R_ActivitySourceBase
    {
        // Empty - base class provides all functionality
    }
}
```

Rules:

* Must inherit from `R_ActivitySourceBase`
* Use `_activitySource.StartActivity("FunctionName")` in all async functions