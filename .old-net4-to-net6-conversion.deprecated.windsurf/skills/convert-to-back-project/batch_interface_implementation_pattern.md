---
name: batch_interface_implementation_pattern
description: "R_IBatchProcessAsync Interface implementation pattern for batch processing class in Back Project"
---

# R_IBatchProcess IMPLEMENTATION PATTERN

## Interface Functions
Implement both synchronous and asynchronous functions for batch processing.

```csharp
using System;
using System.Data;
using System.Data.Common;
using System.Threading.Tasks;
using System.Collections.Generic;
using System.Linq;
using R_BackEnd;
using R_Common;
using R_CommonFrontBackAPI;
using {ProgramName}BackResources;
using {ProgramName}Common.DTOs;
using {ProgramName}Back.DTOs;
using System.Transactions;
using System.Diagnostics;
using System.Text;
using R_OpenTelemetry;
using System.Data.SqlClient;

namespace {ProgramName}Back;
{
    public class {ProgramName}BatchCls : R_IBatchProcessAsync
    {
        private readonly ActivitySource _activitySource;

        // BATCH CLASS ONLY - MUST FOLLOW THIS EXACTLY FOR CONSTRUCTOR
        public {ProgramName}BatchCls()
        {
            var loActivity = {ProgramName}Activity.R_GetInstanceActivitySource();
            if (loActivity == null)
            {
                _activitySource = R_LibraryActivity.R_GetInstanceActivitySource();
            }
            else
            {
                _activitySource = loActivity;
            }
        }

        // MUST FOLLOW THIS EXACTLY FOR R_BATCHPROCESSASYNC
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

        private async Task _BatchProcessAsync(R_BatchProcessPar poBatchProcessPar) // Use the same function signature
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

                // Deserialize BigObject, MUST FOLLOW THIS EXACTLY
                var loObject = R_NetCoreUtility.R_DeserializeObjectFromByte<List<{BatchListDisplayDTO}>>(poBatchProcessPar.BigObject);

                // Get All User Parameters, THIS IS ONLY EXAMPLE
                // Equals must use nameof(R_SaveBatchUserParameterDTO.{UserParameterName})
                var loUserParameter1 = poBatchProcessPar.UserParameters.Where(x => x.Key.Equals(nameof(R_SaveBatchUserParameterDTO.{UserParameterName}), StringComparison.InvariantCultureIgnoreCase)).FirstOrDefault().Value ?? string.Empty;
                string lcUserParameter1 = ((System.Text.Json.JsonElement)loUserParameter1).GetString();
                
                // Equals must use nameof(R_SaveBatchUserParameterDTO.{UserParameterName})
                var loUserParameter2 = poBatchProcessPar.UserParameters.Where(x => x.Key.Equals(nameof(R_SaveBatchUserParameterDTO.{UserParameterName}), StringComparison.InvariantCultureIgnoreCase)).FirstOrDefault().Value ?? string.Empty;
                string lcUserParameter2 = ((System.Text.Json.JsonElement)loUserParameter2).GetString();
                
                // ... more user parameters

                // Actual implementation logic
            }

            catch (Exception ex)
            {
                loEx.Add(ex);
            }
            finally
            {
                if (loDb != null) loDb = null;
            }

            if (loEx.Haserror)
            {
                lcQuery = $"INSERT INTO GST_UPLOAD_ERROR_STATUS(CCOMPANY_ID,CUSER_ID,CKEY_GUID,ISEQ_NO,CERROR_MESSAGE)" +
                            $"VALUES " +
                            $"('{poBatchProcessPar.Key.COMPANY_ID}', " +
                            $"'{poBatchProcessPar.Key.USER_ID}', " +
                            $"'{poBatchProcessPar.Key.KEY_GUID}', " +
                            $"-100, " +
                            $"'{loEx.ErrorList[0].ErrDescp}');";

                loDb.SqlExecNonQuery(lcQuery);

                lcQuery = $"EXEC RSP_WriteUploadProcessStatus '{poBatchProcessPar.Key.COMPANY_ID}', " +
                    $"'{poBatchProcessPar.Key.USER_ID}', " +
                    $"'{poBatchProcessPar.Key.KEY_GUID}', " +
                    $"100, '{loEx.ErrorList[0].ErrDescp}', 9";

                loDb.SqlExecNonQuery(lcQuery);
            }
        }
    }
}
```