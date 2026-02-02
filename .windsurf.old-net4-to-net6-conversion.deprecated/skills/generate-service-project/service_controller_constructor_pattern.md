---
name: service_controller_constructor_pattern
description: "Controller constructor pattern with logger and activity initialization"
---

# Controller Constructor Pattern

```csharp
// MUST FOLLOW EXACTLY
namespace {ProgramName}Service
{
    [ApiController]
    [Route("api/[controller]/[action]")]
    public class {ProgramName}Controller : ControllerBase, I{ProgramName}
    {
        private readonly Logger{ProgramName} _logger;
        private readonly ActivitySource _activitySource;

        public {ProgramName}Controller(ILogger<{ProgramName}Controller> logger)
        {
            Logger{ProgramName}.R_InitializeLogger(logger);
            _logger = Logger{ProgramName}.R_GetInstanceLogger();
            _activitySource = {ProgramName}Activity.R_InitializeAndGetActivitySource(nameof({ProgramName}Controller));
        }
    }
}
```

Rules:
- Always initialize logger using `R_InitializeLogger`
- Always get singleton instance via `R_GetInstanceLogger`
- Initialize activity source with controller name