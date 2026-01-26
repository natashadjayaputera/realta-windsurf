---
name: batch_interface_implementation_pattern
description: "R_IBatchProcessAsync Interface implementation pattern for batch processing class in Back Project"
---

# R_IBatchProcess IMPLEMENTATION PATTERN

## Interface Functions
Implement both synchronous and asynchronous functions for batch processing.

```csharp
using R_OpenTelemetry;

namespace {ProgramName}Back;
{
    public class {ProgramName}BatchCls : R_IBatchProcessAsync
    {
        private readonly ActivitySource _activitySource;
        private Logger{ProgramName} _logger;

        // MUST FOLLOW THIS EXACTLY FOR CONSTRUCTOR
        public {ProgramName}BatchCls()
        {
            _logger = Logger{ProgramName}.R_GetInstanceLogger();
            _activitySource = R_LibraryActivity.R_GetInstanceActivitySource();
        }

        // MUST FOLLOW THIS EXACTLY FOR R_BATCHPROCESSASYNC
        public async Task R_BatchProcessAsync(R_BatchProcessPar poBatchProcessPar)
        {
            using Activity activity = _activitySource.StartActivity("R_BatchProcessAsync");
            R_Exception loException = new R_Exception();
            var loDb = new R_Db();

            try
            {
                _logger.LogInfo("Test Connection");
                if (loDb.R_TestConnection() == false)
                {
                    loException.Add("01", "Database Connection Failed");
                    goto EndBlock;
                }
                _logger.LogInfo("Start Batch");
                _ = _BatchProcessAsync(poBatchProcessPar); // IMPORTANT: Fire and forget
                _logger.LogInfo("End Batch");
            }
            catch (Exception ex)
            {
                loException.Add(ex);
            }
            finally
            {
                if (loDb != null)
                {
                    loDb = null;
                }
            }

            loException.ThrowExceptionIfErrors();
        }

        private async Task _BatchProcessAsync(R_BatchProcessPar poBatchProcessPar) // Use the same function signature
        {
            // Actual implementation logic
        }
    }
}
```