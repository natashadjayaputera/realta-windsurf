---
name: service_nonstreaming_noparam_pattern
description: "Non-streaming function pattern without parameters in service layer"
---

# Non-Streaming Function Pattern (Without Parameters)

```csharp
[HttpPost]
public async Task<{ProgramName}ResultDTO<{FunctionName}ResultDTO>> {FunctionName}()
{
    var lcFunction = nameof({FunctionName});
    using var activity = _activitySource.StartActivity(lcFunction);
    var loEx = new R_Exception();
    var loCls = new {ProgramName}Cls();
    var loRtn = new {ProgramName}ResultDTO<{FunctionName}ResultDTO>();

    try
    {
        _logger.LogInfo("Start function {FunctionName} in {0}", lcFunction);
        var loParam = new {FunctionName}ParameterDTO
        {
            CCOMPANY_ID = R_BackGlobalVar.COMPANY_ID,
            CLANG_ID = R_BackGlobalVar.CULTURE,
            CUSER_ID = R_BackGlobalVar.USER_ID
        };

        // DO NOT USE R_Utility.R_GetStreamingContext because it is for streaming functions

        loRtn.Data = await loCls.{FunctionName}(loParam);
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

Rules:
* Used when all parameters are global variables
* Create DTO internally
* **MUST assign all three global variables:**
  - `CCOMPANY_ID = R_BackGlobalVar.COMPANY_ID`
  - `CLANG_ID = R_BackGlobalVar.CULTURE`
  - `CUSER_ID = R_BackGlobalVar.USER_ID`
* DO NOT USE `R_Utility.R_GetStreamingContext` because it is for streaming functions