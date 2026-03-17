---
name: iasyncenumerable_controller_pattern
description: "Pattern for converting List implementation to IAsyncEnumerable implementation in C# controllers"
---

## Conversion Requirements

**NEED TO CONVERT from List implementation to IAsyncEnumerable implementation:**

1. **Change return type** from `Task<{ProgramName}ResultDTO<List<{FunctionReturnType}>>>` to `IAsyncEnumerable<{FunctionReturnType}>`
2. **Remove async Task wrapper** - use direct `IAsyncEnumerable<{FunctionReturnType}>` return
3. **Implement streaming** using `await foreach` with `yield return`
4. **Handle parameters** by extracting from streaming context if needed
5. **Maintain error handling** and logging patterns

## Before (List Implementation)

```csharp
public async Task<{ProgramName}ResultDTO<List<{SubProgramName}{FunctionName}ResultDTO>>> {FunctionName}({SubProgramName}{FunctionName}ParameterDTO poParameter)
{
    var lcFunction = nameof({FunctionName});
    using var activity = _activitySource.StartActivity(lcFunction);
    var loEx = new R_Exception();
    var loCls = new {SubProgramName}Cls();
    var loRtn = new {ProgramName}ResultDTO<List<{SubProgramName}{FunctionName}ResultDTO>>();

    try
    {
        _logger.LogInfo("Start function {FunctionName} in {0}", lcFunction);
        loRtn.Data = await loCls.{FunctionName}(poParameter);
    }
    catch (Exception ex)
    {
        loEx.Add(ex);
        _logger.LogError(loEx);
    }

    loEx.ThrowExceptionIfErrors();
    return loRtn;
}

```

## After (IAsyncEnumerable Implementation)

```csharp

public async IAsyncEnumerable<{SubProgramName}{FunctionName}ResultDTO> {FunctionName}()
{
    var lcFunction = nameof({FunctionName});
    using var activity = _activitySource.StartActivity(lcFunction);
    var loEx = new R_Exception();
    var loCls = new {SubProgramName}Cls();
    var loResult = new List<{SubProgramName}{FunctionName}ResultDTO>();

    try
    {
        {SubProgramName}{FunctionName}ParameterDTO loParameter = new {SubProgramName}{FunctionName}ParameterDTO();
        loParameter.{STRING_PROPERTY_1} = R_Utility.R_GetStreamingContext<string>(ContextConstants.{SubProgramName}_{STRING_PROPERTY_1}) ?? string.Empty;
        loParameter.{BOOL_PROPERTY_1} = R_Utility.R_GetStreamingContext<bool>(ContextConstants.{SubProgramName}_{BOOL_PROPERTY_1}) ?? false;
        loParameter.{INT_PROPERTY_1} = R_Utility.R_GetStreamingContext<int>(ContextConstants.{SubProgramName}_{INT_PROPERTY_1}) ?? 0;
        loParameter.{DATETIME_PROPERTY_1} = R_Utility.R_GetStreamingContext<DateTime>(ContextConstants.{SubProgramName}_{DATETIME_PROPERTY_1}) ?? 0;
        // ... add more properties as needed

        _logger.LogInfo("Start function {FunctionName} in {0}", lcFunction);
        loResult = await loCls.{FunctionName}(loParameter);
    }
    catch (Exception ex)
    {
        loEx.Add(ex);
        _logger.LogError(loEx);
    }

    loEx.ThrowExceptionIfErrors();
    foreach (var item in loResult)
    {
        yield return item;
    }
}
```
