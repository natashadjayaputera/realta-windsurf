---
name: back_database_function_pattern
description: "Database query execution pattern for Back projects"
---
# Database Function Pattern

```csharp
public async Task<{FunctionName}ResultDTO> {FunctionName}({FunctionName}ParameterDTO poParam)
{
    string lcFunction = nameof(FunctionNameAsync);
    using var activity = _activitySource.StartActivity(lcFunction);
    _logger.LogInfo("START function {FunctionName}", lcFunction);

    var loEx = new R_Exception();
    var loDb = new R_Db();
    {FunctionName}ResultDTO loResult = new();

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
        loResult = R_Utility.R_ConvertTo<{FunctionName}ResultDTO>(loDataTable).FirstOrDefault();
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

Rules:
* Adding parameters to DbCommand must use `loDb.R_AddCommandParameter`
* Log query and parameters before execution
* Always clear command parameters
* Use `R_Utility.R_ConvertTo` for result conversion
* Catch exceptions in `R_Exception` and throw
* Never use `using` for var loDb = new R_Db()
* Always use `using` for var loConn = await loDb.GetConnectionAsync()
* Always use `using` for var loCmd = loDb.GetCommand()