---
trigger: always_on
name: streaming_pattern
description: "Streaming pattern in ViewModel, Model, Service and Back Layers (MUST FOLLOW EXACTLY)"
---

# STREAMING PATTERN

## Overview

This document defines the streaming pattern flow across all layers. Data flows from **ViewModel → Model → Service/Controller → Back**. Each layer has specific responsibilities and rules that MUST be followed exactly.

---

## 1. ViewModel Layer (Model Project for ViewModel)

### Rules
- Use `R_FrontContext.R_SetStreamingContext(ContextConstants.Key, value)` to set streaming context
- Set streaming context per property
- Call model's `{FunctionName}Async()` function, not `{FunctionName}()`.
 
### ✅ Correct Implementation

```csharp
private {ProgramName}Model _model = new {ProgramName}Model();

public ObservableCollection<{FunctionName}ResultDTO> {FunctionName}List { get; set; } = new ObservableCollection<{FunctionName}ResultDTO>();
public {FunctionName}ResultDTO? {FunctionName}Record { get; set; }

public async Task {FunctionName}Async({FunctionName}ParameterDTO poParameter)
{
    var loEx = new R_Exception();
    try
    {
        R_FrontContext.R_SetStreamingContext(ContextConstants.CDEPT_CODE, poParameter.CDEPT_CODE);
        R_FrontContext.R_SetStreamingContext(ContextConstants.CTRANSACTION_CODE, poParameter.CTRANSACTION_CODE);
        
        var loResult = await _model.{FunctionName}Async();
        
        {FunctionName}List = new ObservableCollection<{FunctionName}ResultDTO>(loResult.Data ?? new());
        {FunctionName}Record = {FunctionName}List.FirstOrDefault();
    }
    catch (Exception ex)
    {
        loEx.Add(ex);
    }
    loEx.ThrowExceptionIfErrors();
}
```

---

## 2. Model Layer (Model Project for Model)

### Rules
- **Interface compliance function**: `{FunctionName}()` (returns `IAsyncEnumerable<{FunctionName}ResultDTO>`)
- **Actual implementation function**: `{FunctionName}Async()` (returns `Task<ResultDTO<List<{FunctionName}ResultDTO>>>`)
- Use `R_HTTPClientWrapper.R_APIRequestStreamingObject<{FunctionName}ResultDTO>()` for API calls
- Interface compliance function should throw `NotImplementedException()`

### ✅ Correct Implementation

```csharp
// Interface
public IAsyncEnumerable<{FunctionName}ResultDTO> {FunctionName}()
{
    throw new NotImplementedException();
}

// Implementation
public async Task<{ProgramName}ResultDTO<List<{FunctionName}ResultDTO>>> {FunctionName}Async()
{
    var loEx = new R_Exception();
    var loRtn = new {ProgramName}ResultDTO<List<{FunctionName}ResultDTO>>();
    try
    {
        R_HTTPClientWrapper.httpClientName = _HttpClientName;
        loRtn.Data = await R_HTTPClientWrapper.R_APIRequestStreamingObject<{FunctionName}ResultDTO>(
            _RequestServiceEndPoint,
            nameof(I{ProgramName}.{FunctionName}),
            _ModuleName,
            true,
            true);
    }
    catch (Exception ex)
    {
        loEx.Add(ex);
    }
    loEx.ThrowExceptionIfErrors();
    return loRtn;
}
```

---

## 3. Service/Controller Layer (Service Project)

### Rules
- **DO NOT CONFUSE THIS WITH BACK PROJECT**
- Must create `{FunctionName}ParameterDTO` inside the function to be passed to Back Project.
- Use `R_BackGlobalVar` to populate standard properties parameters.
- Use `R_Utility.R_GetStreamingContext<Type>(ContextConstants.Key)` populate non-standard properties parameters.
- Return `IAsyncEnumerable<{FunctionName}ResultDTO>` and use `yield return` for each item
- All parameters are assigned here and passed to Back Project

### ✅ Correct Implementation

```csharp
[HttpPost]
public async IAsyncEnumerable<{FunctionName}ResultDTO> {FunctionName}()
{
    var lcFunction = nameof({FunctionName});
    using var activity = _activitySource.StartActivity(lcFunction);
    var loEx = new R_Exception();
    var loCls = new {ProgramName}Cls();
    List<{FunctionName}ResultDTO> loResult = new();

    try
    {
        var loParam = new {ProgramName}{FunctionName}ParameterDTO
        {
            CCOMPANY_ID = R_BackGlobalVar.COMPANY_ID,
            CUSER_ID = R_BackGlobalVar.USER_ID,
            CLANG_ID = R_BackGlobalVar.CULTURE,
            CDEPT_CODE = R_Utility.R_GetStreamingContext<string>(ContextConstants.CDEPT_CODE) ?? string.Empty,
            CTRANSACTION_CODE = R_Utility.R_GetStreamingContext<string>(ContextConstants.CTRANSACTION_CODE) ?? string.Empty
        };

        loResult = await loCls.{FunctionName}(loParam);
    }
    catch (Exception ex)
    {
        loEx.Add(ex);
        _logger.LogError(loEx);
    }

    loEx.ThrowExceptionIfErrors();
    foreach (var loItem in loResult)
        yield return loItem;
}
```

---

## 4. Back Layer (`*Cls.cs` in Back Project)

### Rules
- NEVER call `R_BackGlobalVar`
- NEVER call `R_Utility.R_GetStreamingContext()`
- All parameters are already assigned in Controller - receive them via function parameter
- Execute database query and return `List<{FunctionName}ResultDTO>`

### ✅ Correct Implementation

```csharp
[HttpPost]
public async Task<List<{FunctionName}ResultDTO>> {FunctionName}({FunctionName}ParameterDTO poParam)
{
    string lcFunction = nameof(FunctionNameAsync);
    using var activity = _activitySource.StartActivity(lcFunction);
    _logger.LogInfo("START function {FunctionName}", lcFunction);

    var loEx = new R_Exception();
    var loDb = new R_Db();
    List<{FunctionName}ResultDTO> loResult = new();

    try
    {
        using DbConnection loConn = await loDb.GetConnectionAsync();
        using DbCommand loCmd = loDb.GetCommand();
        loCmd.Parameters.Clear();

        loCmd.CommandText = "SELECT ... FROM ... WHERE ... = @Param";
        loDb.R_AddCommandParameter(loCmd, "@Param", DbType.String, 500, poParam.Value);

        var loDbParams = loCmd.Parameters.Cast<DbParameter>()
            .Where(x => x != null && x.ParameterName.StartsWith("@"))
            .ToDictionary(x => x.ParameterName, x => x.Value);

        _logger.LogDebug("{@ObjectQuery} {@Parameter}", loCmd.CommandText, loDbParams);

        var loDataTable = await loDb.SqlExecQueryAsync(loConn, loCmd, false);
        loResult = R_Utility.R_ConvertTo<{FunctionName}ResultDTO>(loDataTable).ToList();
    }
    catch (Exception ex)
    {
        loEx.Add(ex);
        _logger.LogError(loEx);
    }
    finally
    {
        if (loDb != null) loDb = null;
    }

    loEx.ThrowExceptionIfErrors();
    _logger.LogInfo("END function {FunctionName}", lcFunction);
    return loResult;
}
```

---

## Benefits

* **Consistent** - Same pattern across all layers
* **Scalable** - Handles large datasets efficiently
* **Maintainable** - Clear separation of concerns
* **Memory-efficient** - Streaming reduces memory footprint