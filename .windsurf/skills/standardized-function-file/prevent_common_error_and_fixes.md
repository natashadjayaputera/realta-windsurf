---
name: prevent_common_error_and_fixes
description: "Prevent common error and fixes"
---
# Common Error and Fixes

## Error 1: `SqlExecNonQueryAsync` wrong parameters order

If loCmd is a string, do nothing.
If loCmd is a DbCommand, fix it by changing the order of parameters.
```csharp   
SqlExecNonQueryAsync(loCmd, loConn, false) => SqlExecNonQueryAsync(loConn, loCmd, false)
```

## Error 2: using (SqlClient.SqlConnection) casting as parameter in R_BulkInsertAsync

Fix it by removing `SqlClient` from `SqlClient.SqlConnection`.
```csharp
await loDb.R_BulkInsertAsync<{DataDTO}>((SqlClient.SqlConnection)loConn, "#YOUR_TEMP_TABLE_NAME", loObjects); => await loDb.R_BulkInsertAsync<{DataDTO}>((SqlConnection)loConn, "#YOUR_TEMP_TABLE_NAME", loObjects);
```

## Error 3: using `string.Right` syntax

Fix it by using [^N] syntax
```csharp
string.Right(10) => string[^10]
```

## Error 4: `R_Utility.R_ConvertTo<{TargetDTO}>(loDataTable)` returns `IList<{TargetDTO}>`

Fix it by adding .ToList()
```csharp
R_Utility.R_ConvertTo<{TargetDTO}>(loDataTable) => R_Utility.R_ConvertTo<{TargetDTO}>(loDataTable).ToList()
```