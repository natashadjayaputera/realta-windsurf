---
name: back_streaming_function_pattern
description: "Streaming function pattern for Back Project"
---

# Streaming Function Pattern (Must Follow Exactly, see `streaming_pattern.md`)

```csharp
public async Task<List<{FunctionName}ResultDTO>> {FunctionName}({FunctionName}ParameterDTO poParam)
{
    string lcFunction = nameof({FunctionName});
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

## Verification Checklist

Before completing any streaming controller function:
- [ ] Must always create ParameterDTO
- [ ] Always return `Task<List<{FunctionName}ResultDTO>>`, never use `IAsyncEnumerable<{FunctionName}ResultDTO>`
- [ ] Never use `R_BackGlobalVar`
- [ ] Never retrieve via `R_Utility.R_GetStreamingContext<Type>(ContextConstants.Key)`