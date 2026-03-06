---
name: back_activity_template
description: "Template for activity using R_ActivitySourceBase in Back Projects"
---
# Format (Non-Negotiable)
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