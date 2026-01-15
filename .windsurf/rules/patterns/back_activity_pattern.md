---
trigger: model_decision
description: "Use in ToCSharpBack workflow to Standard activity pattern for Back projects using R_ActivitySourceBase"
---
# Activity Pattern

```csharp
using R_OpenTelemetry;

public class {ProgramName}Activity : R_ActivitySourceBase
{
    // Empty - base class provides all functionality
}
```

Rules:

* Must inherit from `R_ActivitySourceBase`
* Use `_activitySource.StartActivity("MethodName")` in all async methods