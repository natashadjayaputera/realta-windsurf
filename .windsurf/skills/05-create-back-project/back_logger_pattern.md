---
name: back_logger_template
description: "Template for logger using R_NetCoreLoggerBase in Back Projects"
---
# Format (Non-Negotiable)
```csharp
using R_CommonFrontBackAPI.Log;

namespace {ProgramName}Back.DTOs    
{
    public class Logger{ProgramName} : R_NetCoreLoggerBase<Logger{ProgramName}>
    {
        // Empty - base class provides all functionality
    }
}
```