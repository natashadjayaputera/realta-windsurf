---
name: back_logger_pattern
description: "Standard logger pattern for Back projects using R_NetCoreLoggerBase"
---
# Logger Pattern

```csharp
using R_CommonFrontBackAPI.Log;

public class Logger{ProgramName} : R_NetCoreLoggerBase<Logger{ProgramName}>
{
    // Empty - base class provides all functionality
}
```

Rules:

* Must inherit from `R_NetCoreLoggerBase<T>`
* No custom implementation in derived class
* Use `_logger.LogInfo`, `_logger.LogDebug`, `_logger.LogError` for all logging
