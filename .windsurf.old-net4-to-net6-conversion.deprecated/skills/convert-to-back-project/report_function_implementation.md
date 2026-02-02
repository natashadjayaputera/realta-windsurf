---
name: report_function_implementation
description: "Defines GetReportData() implementation rules for report-related / {ProgramName}ReportCls in Back Project"
---
# Report Function Implementation

## Class Rules
- Does not inherit `R_BusinessObjectAsync`

## Function Naming
- Function: `GetReportData()` (NON-ASYNC)
- Parameter DTO: `{ProgramName}GetReportDataParameterDTO`
- Result DTO: `{ProgramName}GetReportDataResultDTO`

## Execution
- Synchronous (no async/await)
- Direct database access only (`R_Db`, `SqlExecQuery`)
- Must call `Logger.LogInfo` at start and end of the function
- Include try-catch-finally with `R_Exception`

## Query Rules
- SQL queries and stored procedures must remain unchanged
- Log all queries and parameters before execution

## Patterns
```csharp
// In Back layer only — NOT exposed via Common or Service
public List<{ProgramName}GetReportDataResultDTO> GetReportData({ProgramName}GetReportDataParameterDTO poParameter)
{
    string lcFunction = nameof(GetReportData);
    using var activity = _activitySource.StartActivity(lcFunction);
    _logger.LogInfo("START function {FunctionName}", lcFunction);

    var loEx = new R_Exception();
    var loRtn = new List<{ProgramName}GetReportDataResultDTO>();
    var loDb = new R_Db();

    try
    {
        using DbConnection loConn = loDb.GetConnection();
        using DbCommand loCmd = loDb.GetCommand();

        // Direct database access with stored procedure
        // Log query and parameters before execution
        // No streaming context needed for Report operations
        // Use synchronous database functions (SqlExecQuery, not SqlExecQueryAsync)
    }
    catch (Exception ex)
    {
        loEx.Add(ex);
        _logger.LogError(loEx);
    }
    finally
    {
        if (loDb != null)
            loDb = null;
    }

    loEx.ThrowExceptionIfErrors();
    _logger.LogInfo("END function {FunctionName}", lcFunction);
    return loRtn;
}
```

Critical:
- All function must be synchronous (no async/await)
- All database access must be synchronous (no async/await)