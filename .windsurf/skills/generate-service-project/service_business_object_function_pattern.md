---
name: service_business_object_function_pattern
description: "Service layer business object function pattern"
---

# Service Business Object Function Pattern

The `R_IServiceCRUDAsyncBase<{ProgramName}DTO>` interface expects these exact function signatures:

```csharp
Task<R_ServiceGetRecordResultDTO<{ProgramName}DTO>> R_ServiceGetRecord(R_ServiceGetRecordParameterDTO<{ProgramName}DTO> poParameter);
Task<R_ServiceSaveResultDTO<{ProgramName}DTO>> R_ServiceSave(R_ServiceSaveParameterDTO<{ProgramName}DTO> poParameter);
Task<R_ServiceDeleteResultDTO> R_ServiceDelete(R_ServiceDeleteParameterDTO<{ProgramName}DTO> poParameter);
```

## Example
```csharp
[HttpPost]
public async Task<R_ServiceGetRecordResultDTO<{ProgramName}DTO>> R_ServiceGetRecord(R_ServiceGetRecordParameterDTO<{ProgramName}DTO> poParameter)
{
    var lcFunction = nameof(R_ServiceGetRecord);
    using var activity = _activitySource.StartActivity(lcFunction);
    var loEx = new R_Exception();
    var loCls = new {ProgramName}Cls();
    var loRtn = new R_ServiceGetRecordResultDTO<{ProgramName}DTO>();

    try
    {
        _logger.LogInfo("Start function {FunctionName} in {0}", lcFunction);
        
        // MUST assign all three global variables using R_BackGlobalVar before calling business logic
        poParameter.Entity.CCOMPANY_ID = R_BackGlobalVar.COMPANY_ID;
        poParameter.Entity.CLANG_ID = R_BackGlobalVar.CULTURE;
        poParameter.Entity.CUSER_ID = R_BackGlobalVar.USER_ID;

        // DO NOT USE R_Utility.R_GetStreamingContext because it is for streaming functions
        
        // Do not use loRtn.Data, use loRtn.data
        loRtn.data = await loCls.R_GetRecordAsync(poParameter.Entity);
    }
    catch (Exception ex)
    {
        loEx.Add(ex);
        _logger.LogError(loEx);
    }

    loEx.ThrowExceptionIfErrors();
    return loRtn;
}

[HttpPost]
public async Task<R_ServiceSaveResultDTO<{ProgramName}DTO>> R_ServiceSave(R_ServiceSaveParameterDTO<{ProgramName}DTO> poParameter)
{
    var lcFunction = nameof(R_ServiceSave);
    using var activity = _activitySource.StartActivity(lcFunction);
    var loEx = new R_Exception();
    var loCls = new {ProgramName}Cls();
    var loRtn = new R_ServiceSaveResultDTO<{ProgramName}DTO>();

    try
    {
        _logger.LogInfo("Start function {FunctionName} in {0}", lcFunction);
        
        // MUST assign all three global variables using R_BackGlobalVar before calling business logic
        poParameter.Entity.CCOMPANY_ID = R_BackGlobalVar.COMPANY_ID;
        poParameter.Entity.CLANG_ID = R_BackGlobalVar.CULTURE;
        poParameter.Entity.CUSER_ID = R_BackGlobalVar.USER_ID;

        // DO NOT USE R_Utility.R_GetStreamingContext because it is for streaming functions
        
        // Do not use loRtn.Data, use loRtn.data
        loRtn.data = await loCls.R_SaveAsync(poParameter.Entity, poParameter.CRUDMode);
    }
    catch (Exception ex)
    {
        loEx.Add(ex);
        _logger.LogError(loEx);
    }

    loEx.ThrowExceptionIfErrors();
    return loRtn;
}

[HttpPost]
public async Task<R_ServiceDeleteResultDTO> R_ServiceDelete(R_ServiceDeleteParameterDTO<{ProgramName}DTO> poParameter)
{
    var lcFunction = nameof(R_ServiceDelete);
    using var activity = _activitySource.StartActivity(lcFunction);
    var loEx = new R_Exception();
    var loCls = new {ProgramName}Cls();
    var loRtn = new R_ServiceDeleteResultDTO();

    try
    {
        _logger.LogInfo("Start function {FunctionName} in {0}", lcFunction);
        
        // MUST assign all three global variables using R_BackGlobalVar before calling business logic
        poParameter.Entity.CCOMPANY_ID = R_BackGlobalVar.COMPANY_ID;
        poParameter.Entity.CLANG_ID = R_BackGlobalVar.CULTURE;
        poParameter.Entity.CUSER_ID = R_BackGlobalVar.USER_ID;

        // DO NOT USE R_Utility.R_GetStreamingContext because it is for streaming functions
        
        await loCls.R_DeleteAsync(poParameter.Entity);
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