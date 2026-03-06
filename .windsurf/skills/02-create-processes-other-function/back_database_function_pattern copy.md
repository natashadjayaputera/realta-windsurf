---
name: back_database_function_pattern
description: "Database query execution pattern for Back projects"
---
# Database Function Pattern

```csharp
//CATEGORY: {category}
public async Task<{ProcessName}ResultDTO> {ProcessName}({ProcessName}ParameterDTO poParam)
{
    string lcFunction = nameof(ProcessName);
    using var activity = _activitySource.StartActivity(lcFunction);
    _logger.LogInfo("START function {ProcessName}", lcFunction);

    var loEx = new R_Exception();
    var loDb = new R_Db();
    {ProcessName}ResultDTO loResult = new();

    try
    {
        using DbConnection loConn = await loDb.GetConnectionAsync();

        loResult.{STORED_PROCEDURE_NAME}Result = await {STORED_PROCEDURE_NAME}(poParam.{STORED_PROCEDURE_NAME}Parameter, loConn); // if save_to is used, assign the result to the variable
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
    _logger.LogInfo("END function {ProcessName}", lcFunction);
    return loResult;
}
```

Rules:
* Adding parameters to DbCommand must use `loDb.R_AddCommandParameter`
* Log query and parameters before execution
* Catch exceptions in `R_Exception` and throw
* Never use `using` for var loDb = new R_Db()
* Always use `using` for var loConn = await loDb.GetConnectionAsync()