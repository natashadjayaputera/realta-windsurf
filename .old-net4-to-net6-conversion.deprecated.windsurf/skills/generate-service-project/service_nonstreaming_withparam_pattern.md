---
name: service_nonstreaming_withparam_pattern
description: "Non-streaming function pattern with parameters in service layer"
---

# Non-Streaming Function Pattern (With Parameters)

```csharp
[HttpPost]
public async Task<{ProgramName}ResultDTO<{FunctionName}ResultDTO>> {FunctionName}({FunctionName}ParameterDTO poParameter)
{
    var lcFunction = nameof({FunctionName});
    using var activity = _activitySource.StartActivity(lcFunction);
    var loEx = new R_Exception();
    var loCls = new {ProgramName}Cls();
    var loRtn = new {ProgramName}ResultDTO<{FunctionName}ResultDTO>();

    try
    {
        _logger.LogInfo("Start function {FunctionName} in {0}", lcFunction);
        
        // MUST assign all three global variables
        poParameter.CCOMPANY_ID = R_BackGlobalVar.COMPANY_ID;
        poParameter.CLANG_ID = R_BackGlobalVar.CULTURE;
        poParameter.CUSER_ID = R_BackGlobalVar.USER_ID;

        // DO NOT USE R_Utility.R_GetStreamingContext because it is for streaming functions
        
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

Rules:
* Accepts parameter DTO from frontend
* **MUST assign all three global variables using `R_BackGlobalVar` before calling business logic:**
  - `CCOMPANY_ID = R_BackGlobalVar.COMPANY_ID`
  - `CLANG_ID = R_BackGlobalVar.CULTURE`
  - `CUSER_ID = R_BackGlobalVar.USER_ID`
* Handle exceptions via `R_Exception`
* DO NOT USE `R_Utility.R_GetStreamingContext` because it is for streaming functions