---
name: back_batch_function_pattern
description: "Batch function pattern for batch processing class in Back Project"
---

# BATCH FUNCTION PATTERN

## Batch Function
Implement both public and private functions for batch processing, please note that the function name must be `R_BatchProcessAsync` and the private function name must be `_BatchProcessAsync`.

```csharp
// MUST FOLLOW PUBLIC FUNCTION EXACTLY
public async Task R_BatchProcessAsync(R_BatchProcessPar poBatchProcessPar)
{
    using Activity activity = _activitySource.StartActivity("R_BatchProcessAsync");
    R_Exception loException = new R_Exception();
    var loDb = new R_Db();

    try
    {
        if (loDb.R_TestConnection() == false)
        {
            loException.Add("","Connection to database failed");
            goto EndBlock;
        }
        _ = _BatchProcessAsync(poBatchProcessPar); // IMPORTANT: Fire and forget
    }
    catch (Exception ex)
    {
        loException.Add(ex);
    }
    finally
    {
        if (loDb != null)
        {
            loDb = null;
        }
    }

    loException.ThrowExceptionIfErrors();
}

// Actual implementation of old R_BatchProcess / R_BatchProcessAsync is now in private function
private async Task _BatchProcessAsync(R_BatchProcessPar poBatchProcessPar) 
{
    string lcFunction = nameof(_BatchProcessAsync);
    using var activity = _activitySource.StartActivity(lcFunction);

    var loEx = new R_Exception();
    var loDb = new R_Db();

    try
    {
        using var loConn = await loDb.GetConnectionAsync();
        using var loCmd = loDb.GetCommand();
        
        using var transactionScope = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);
        {
            // Deserialize BigObject, MUST FOLLOW THIS EXACTLY
            var loObject = R_NetCoreUtility.R_DeserializeObjectFromByte<List<{BatchListDisplayDTO}>>(poBatchProcessPar.BigObject);

            // Get all user parameters with this format:
            #region User Parameters
            // x.Key.Equals must use nameof({SubProgramName}R_SaveBatchUserParameterDTO.{UserParameterName})
            // poBatchProcessPar.UserParameters.Where(x => x.Key.Equals("CCOMPANY_ID", StringComparison.InvariantCultureIgnoreCase)) => poBatchProcessPar.UserParameters.Where(x => x.Key.Equals(nameof({SubProgramName}R_SaveBatchUserParameterDTO.CCOMPANY_ID), StringComparison.InvariantCultureIgnoreCase)).FirstOrDefault();
            var loUserParameter1 = poBatchProcessPar.UserParameters.Where(x => x.Key.Equals(nameof({SubProgramName}R_SaveBatchUserParameterDTO.{UserParameterName}), StringComparison.InvariantCultureIgnoreCase)).FirstOrDefault();
            
            // if {UserParameterName} of type string, use GetString()
            string lcUserParameter1 = ((System.Text.Json.JsonElement)loUserParameter1.Value).GetString();
            // if {UserParameterName} of type bool, use GetBoolean()
            bool lbUserParameter1 = ((System.Text.Json.JsonElement)loUserParameter1.Value).GetBoolean();
            // if {UserParameterName} of type int, use GetInt32()
            int liUserParameter1 = ((System.Text.Json.JsonElement)loUserParameter1.Value).GetInt32();
            // if {UserParameterName} of type decimal, use GetDecimal()
            decimal ldUserParameter1 = ((System.Text.Json.JsonElement)loUserParameter1.Value).GetDecimal();
            // if {UserParameterName} of type DateTime, use GetDateTime()
            DateTime ldUserParameter1 = ((System.Text.Json.JsonElement)loUserParameter1.Value).GetDateTime();
            // if {UserParameterName} of type Array of T, use GetArray()
            var loUserParameter1Array = ((System.Text.Json.JsonElement)loUserParameter1.Value).EnumerateArray().Select(x => x.{GetT()}).ToArray();

            // ... more user parameters
            #endregion

            // PLEASE NOTE: ALL `SqlExec*` and `R_BulkInsert*` MUST USE `await` AND `Async` SUFFIX

            // Initialize external exception handling (ONLY USED IF STORED PROCEDURE IS USED)
            R_ExternalException.R_SP_Init_Exception(loConn);

            // REPLACE THIS WITH ACTUAL IMPLEMENTATION LOGIC OF OLD R_BatchProcess / R_BatchProcessAsync

            // Get any stored procedure exceptions (ONLY USED IF STORED PROCEDURE IS USED)
            loEx.Add(R_ExternalException.R_SP_Get_Exception(loConn));

            transScope.Complete();
        }
    }
    catch (Exception ex)
    {
        loEx.Add(ex);
    }
    finally
    {
        // For unhandled exception
        if (loEx.Haserror)
        {
            var lcQuery = "INSERT INTO GST_UPLOAD_ERROR_STATUS (CCOMPANY_ID, CUSER_ID, CKEY_GUID, ISEQ_NO, CERROR_MESSAGE) ";
            lcQuery += $"VALUES ('{poBatchProcessPar.Key.COMPANY_ID}', '{poBatchProcessPar.Key.USER_ID}', '{poBatchProcessPar.Key.KEY_GUID}', -1, '{loEx.ErrorList[0].ErrDescp}')";
            await loDb.SqlExecNonQueryAsync(lcQuery);

            lcQuery = $"EXEC RSP_WriteUploadProcessStatus '{poBatchProcessPar.Key.COMPANY_ID}', " +
                $"'{poBatchProcessPar.Key.USER_ID}', " +
                $"'{poBatchProcessPar.Key.KEY_GUID}', " +
                $"100, '{loEx.ErrorList[0].ErrDescp}', 9";
            await loDb.SqlExecNonQueryAsync(lcQuery);
        }

        if (loDb != null) loDb = null;
    }
}
```

## Batch DTOs
Create `chunks_cs/{ProgramName}/{SubProgramName}CLS/DTO/{SubProgramName}R_SaveBatchUserParameterDTO.cs` with content:
### {SubProgramName}R_SaveBatchUserParameterDTO Structure
```csharp
namespace {ProgramName}Common.DTOs;

// DTO name MUST be {SubProgramName}R_SaveBatchUserParameterDTO
public class {SubProgramName}R_SaveBatchUserParameterDTO
{
    // Add ALL custom parameters listed in `#region User Parameters`
    public string VAR_CRECID { get; set; } = string.Empty;
    public bool LJRNGRP_MODE { get; set; } 
    public bool LDEPT_MODE { get; set; } 
}
```

Create `chunks_cs/{ProgramName}/{SubProgramName}CLS/DTO/{SubProgramName}R_SaveBatchParameterDTO.cs` with content:
### {SubProgramName}R_SaveBatchParameterDTO Structure
```csharp
using System.Collections.Generic;

namespace {ProgramName}Common.DTOs;

// DTO name MUST be {SubProgramName}R_SaveBatchParameterDTO
public class {SubProgramName}R_SaveBatchParameterDTO
{
    public string CCOMPANY_ID { get; set; } = string.Empty;
    public string CUSER_ID { get; set; } = string.Empty;
    public {SubProgramName}R_SaveBatchUserParameterDTO UserParameters { get; set; } = new {SubProgramName}R_SaveBatchUserParameterDTO();
    public List<{BatchListDisplayDTO}>? Data { get; set; }
}
```
