---
name: service_streaming_pattern
description: "Streaming function pattern in service layer"
---

# Streaming Function Pattern

- MUST follow `streaming_pattern.md`
- MUST create a parameter DTO inside the function to be passed to the Back business logic
- MUST populate properties in the parameter DTO using `R_Utility.R_GetStreamingContext` to retrieve non standard property parameters
- MUST populate properties in the parameter DTO using `R_BackGlobalVar` to retrieve standard property parameters 
- Streaming functions NEVER use parameters

# Critical Rules for ParameterDTO Population

## MUST populate ALL properties in ParameterDTO:

1. **Standard Property Parameters (ALWAYS include these three):**
   ```csharp
   CCOMPANY_ID = R_BackGlobalVar.COMPANY_ID,
   CLANG_ID = R_BackGlobalVar.CULTURE,
   CUSER_ID = R_BackGlobalVar.USER_ID
   ```

2. **Non-Standard Property Parameters (retrieve from streaming context):**
   ```csharp
   ISTART_YEAR = R_Utility.R_GetStreamingContext<int>(ContextConstants.ISTART_YEAR),
   CYEAR = R_Utility.R_GetStreamingContext<string>(ContextConstants.CYEAR) ?? string.Empty,
   LFLAGPERIOD = R_Utility.R_GetStreamingContext<bool>(ContextConstants.LFLAGPERIOD)
   ```

## FORBIDDEN:
- Omitting CLANG_ID or CUSER_ID
- Not retrieving custom parameters from streaming context

# Example: Complete Streaming Function

```csharp
[HttpPost]
public async IAsyncEnumerable<{FunctionName}ResultDTO> {FunctionName}()
{
    var lcFunction = nameof({FunctionName});
    using var activity = _activitySource.StartActivity(lcFunction);
    var loEx = new R_Exception();
    List<{FunctionName}ResultDTO> loResult = new();

    try
    {
        var loCls = new {ProgramName}Cls();
        
        var loParam = new {FunctionName}ParameterDTO
        {
            CCOMPANY_ID = R_BackGlobalVar.COMPANY_ID,
            CLANG_ID = R_BackGlobalVar.CULTURE,
            CUSER_ID = R_BackGlobalVar.USER_ID,
            CYEAR = R_Utility.R_GetStreamingContext<string>(ContextConstants.CYEAR) ?? string.Empty,
            LFLAGPERIOD = R_Utility.R_GetStreamingContext<bool>(ContextConstants.LFLAGPERIOD)
        };

        _logger.LogInfo("Start function {FunctionName} in {0}", lcFunction);
        loResult = await loCls.{FunctionName}Async(loParam);
    }
    catch (Exception ex)
    {
        loEx.Add(ex);
        _logger.LogError(loEx);
    }

    loEx.ThrowExceptionIfErrors();
    foreach (var loItem in loResult)
    {
        yield return loItem;
    }
}
```

## Verification Checklist

Before completing any streaming controller function:
- [ ] CCOMPANY_ID from R_BackGlobalVar.COMPANY_ID
- [ ] CLANG_ID from R_BackGlobalVar.CULTURE  
- [ ] CUSER_ID from R_BackGlobalVar.USER_ID
- [ ] All other {FunctionName}ParameterDTO properties from R_Utility.R_GetStreamingContext
- [ ] Corresponding ContextConstants defined for custom parameters
