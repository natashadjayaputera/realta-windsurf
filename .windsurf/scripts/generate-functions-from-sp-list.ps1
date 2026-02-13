param(
    [Parameter(Mandatory=$true)]
    [string]$ProgramName,
    
    [Parameter(Mandatory=$true)]
    [string]$SubProgramName
)

# Import common functions
. "$PSScriptRoot\Common-Functions.ps1"

function Get-DbParameterMapping {
    param(
        [string]$DataType
    )
    
    switch ($DataType.ToLower()) {
        "varchar" { return "DbType.String" }
        "nvarchar" { return "DbType.String" }
        "char" { return "DbType.String" }
        "nchar" { return "DbType.String" }
        "text" { return "DbType.String" }
        "ntext" { return "DbType.String" }
        "int" { return "DbType.Int32" }
        "integer" { return "DbType.Int32" }
        "smallint" { return "DbType.Int16" }
        "tinyint" { return "DbType.Byte" }
        "bigint" { return "DbType.Int64" }
        "decimal" { return "DbType.Decimal" }
        "numeric" { return "DbType.Decimal" }
        "float" { return "DbType.Double" }
        "real" { return "DbType.Single" }
        "bit" { return "DbType.Boolean" }
        "boolean" { return "DbType.Boolean" }
        "datetime" { return "DbType.DateTime" }
        "date" { return "DbType.Date" }
        "time" { return "DbType.Time" }
        "smalldatetime" { return "DbType.DateTime" }
        default { return "DbType.String" }
    }
}

function Get-ParameterAccessExpression {
    param(
        [string]$DataType,
        [string]$ParameterName,
        [string]$ParamVariableName
    )
    
    $cleanParamName = $ParameterName -replace "@", ""
    
    switch ($DataType.ToLower()) {
        { $_ -in @("varchar", "nvarchar", "char", "nchar", "text", "ntext") } { return "$ParamVariableName.$cleanParamName" }
        { $_ -in @("int", "integer", "smallint", "tinyint", "bigint") } { return "$ParamVariableName.$cleanParamName" }
        { $_ -in @("decimal", "numeric", "float", "real") } { return "$ParamVariableName.$cleanParamName" }
        { $_ -in @("bit", "boolean") } { return "$ParamVariableName.$cleanParamName" }
        { $_ -in @("datetime", "date", "time", "smalldatetime") } { return "$ParamVariableName.$cleanParamName" }
        default { return "$ParamVariableName.$cleanParamName" }
    }
}

function Get-UserParameterLines {
    param(
        [string]$ProgramName,
        [string]$SubProgramName
    )
    
    $userParameterLines = @()
    $userParameterDTOPath = "partials\$ProgramName\$SubProgramName\common\dto\$($SubProgramName)R_SaveBatchUserParameterDTO.cs"
    
    if (Test-Path $userParameterDTOPath) {
        $dtoContent = Get-Content $userParameterDTOPath
        $properties = @()
        
        foreach ($line in $dtoContent) {
            if ($line -match "^\s*public\s+(\w+)\s+(\w+)\s*\{") {
                $propertyType = $matches[1]
                $propertyName = $matches[2]
                $properties += @{ Type = $propertyType; Name = $propertyName }
            }
        }
        
        if ($properties.Count -gt 0) {
            $userParameterLines += "            #region User Parameters"
            $userParameterLines += "            // x.Key.Equals must use nameof($($SubProgramName)R_SaveBatchUserParameterDTO.{UserParameterName})"
            
            foreach ($prop in $properties) {
                $userParameterLines += "            var lo$($prop.Name) = poBatchProcessPar.UserParameters.Where(x => x.Key.Equals(nameof($($SubProgramName)R_SaveBatchUserParameterDTO.$($prop.Name)), StringComparison.InvariantCultureIgnoreCase)).FirstOrDefault();"
            }
            
            $userParameterLines += ""
            
            foreach ($prop in $properties) {
                $accessExpression = switch ($prop.Type.ToLower()) {
                    "string" { "((System.Text.Json.JsonElement)lo$($prop.Name).Value).GetString()" }
                    "int" { "((System.Text.Json.JsonElement)lo$($prop.Name).Value).GetInt32()" }
                    "decimal" { "((System.Text.Json.JsonElement)lo$($prop.Name).Value).GetDecimal()" }
                    "bool" { "((System.Text.Json.JsonElement)lo$($prop.Name).Value).GetBoolean()" }
                    "datetime" { "((System.Text.Json.JsonElement)lo$($prop.Name).Value).GetDateTime()" }
                    default { "((System.Text.Json.JsonElement)lo$($prop.Name).Value).ToString()" }
                }
                
                $userParameterLines += "            $($prop.Type.ToLower()) $($prop.Name) = $accessExpression;"
            }
            
            $userParameterLines += "            #endregion"
        }
    } else {
        $userParameterLines += "            #region User Parameters"
        $userParameterLines += "            // TODO: Add user parameters manually - UserParameter DTO not found at $userParameterDTOPath"
        $userParameterLines += "            // Example: var loCCOMPANY_ID = poBatchProcessPar.UserParameters.Where(x => x.Key.Equals(nameof($($SubProgramName)R_SaveBatchUserParameterDTO.CCOMPANY_ID), StringComparison.InvariantCultureIgnoreCase)).FirstOrDefault();"
        $userParameterLines += "            #endregion"
    }
    
    return $userParameterLines -join "`r`n"
}

function Get-CommandParameterLines {
    param(
        [string]$StoredProcedureName,
        [string]$ProgramName,
        [string]$SubProgramName,
        [string]$Category,
        [string]$FunctionName
    )
    
    $parameterLines = @()
    
    # Determine CSV path based on category
    $csvPath = switch ($Category) {
        "business-object-overridden-function" { "partials\$ProgramName\$SubProgramName\stored-procedure\parameters\business-object-overridden-function\Entity.csv" }
        "batch-function" { "partials\$ProgramName\$SubProgramName\stored-procedure\parameters\batch-function\$($StoredProcedureName).csv" }
        "other-function" { "partials\$ProgramName\$SubProgramName\stored-procedure\parameters\other-function\$($StoredProcedureName).csv" }
        default { "partials\$ProgramName\$SubProgramName\stored-procedure\parameters\other-function\$($StoredProcedureName).csv" }
    }
    
    if (Test-Path $csvPath) {
        $csvContent = Import-Csv -Path $csvPath
        $paramVariableName = switch ($Category) {
            "business-object-overridden-function" { 
                if ($FunctionName -eq "R_SavingAsync") { "poNewEntity" } else { "poEntity" }
            }
            default { "poParam" }
        }
        
        # Determine column names based on category
        $paramNameColumn = if ($Category -eq "business-object-overridden-function") { "Name" } else { "Parameter Name" }
        
        foreach ($row in $csvContent) {
            if ($row.$paramNameColumn -and $row."Data Type") {
                $paramName = $row.$paramNameColumn
                $dataType = $row."Data Type"
                $length = if ($row."Length" -and $row."Length" -ne "") { $row."Length" } else { "50" }
                $dbType = Get-DbParameterMapping -DataType $dataType
                $accessExpression = Get-ParameterAccessExpression -DataType $dataType -ParameterName $paramName -ParamVariableName $paramVariableName
                
                $parameterLines += "        loDb.R_AddCommandParameter(loCmd, ""$paramName"", $dbType, $length, $accessExpression);"
            }
        }
    } else {
        # Add comment if no CSV found
        $paramVariableName = switch ($Category) {
            "business-object-overridden-function" { 
                if ($FunctionName -eq "R_SavingAsync") { "poNewEntity" } else { "poEntity" }
            }
            default { "poParam" }
        }
        $parameterLines += "        // TODO: Add parameters manually - CSV file not found at $csvPath"
        $parameterLines += "        // Example: loDb.R_AddCommandParameter(loCmd, ""@CCOMPANY_ID"", DbType.String, 20, $paramVariableName.CCOMPANY_ID);"
    }
    
    return $parameterLines -join "`r`n"
}

function Generate-BusinessObjectOverriddenFunctionNotImplemented {
    param(
        [string]$StoredProcedureName,
        [string]$FunctionName,
        [string]$ProgramName,
        [string]$SubProgramName
    )
    
    # Determine function signature based on function name
    $functionSignature = switch ($FunctionName) {
        "R_DisplayAsync" { "protected override async Task<$SubProgramName`DTO> R_DisplayAsync($SubProgramName`DTO poEntity)" }
        "R_SavingAsync" { "protected override async Task R_SavingAsync($SubProgramName`DTO poNewEntity, eCRUDMode poCRUDMode)" }
        "R_DeletingAsync" { "protected override async Task R_DeletingAsync($SubProgramName`DTO poEntity)" }
        default { "protected override async Task $FunctionName($SubProgramName`DTO poEntity)" }
    }
    
    $functionContent = @"
//CATEGORY: business-object-overridden-function
$functionSignature
{
    throw new NotImplementedException();
}
"@
    
    return $functionContent
}

function Generate-BusinessObjectOverriddenFunction {
    param(
        [string]$StoredProcedureName,
        [string]$FunctionName,
        [string]$ProgramName,
        [string]$SubProgramName
    )
    
    # Determine function signature based on function name
    $functionSignature = switch ($FunctionName) {
        "R_DisplayAsync" { "protected override async Task<$SubProgramName`DTO> R_DisplayAsync($SubProgramName`DTO poEntity)" }
        "R_SavingAsync" { "protected override async Task R_SavingAsync($SubProgramName`DTO poNewEntity, eCRUDMode poCRUDMode)" }
        "R_DeletingAsync" { "protected override async Task R_DeletingAsync($SubProgramName`DTO poEntity)" }
        default { "protected override async Task $FunctionName($SubProgramName`DTO poEntity)" }
    }
    
    $functionContent = @"
//CATEGORY: business-object-overridden-function
$functionSignature
{
    string lcFunction = nameof($FunctionName);
    using var activity = _activitySource.StartActivity(lcFunction);
    _logger.LogInfo("START function {$FunctionName}", lcFunction);

    var loEx = new R_Exception();
    var loDb = new R_Db();

    try
    {
        using DbConnection loConn = await loDb.GetConnectionAsync();
        using DbCommand loCmd = loDb.GetCommand();
        loCmd.Parameters.Clear();

        loCmd.CommandText = "$StoredProcedureName";
        loCmd.CommandType = CommandType.StoredProcedure;

$(Get-CommandParameterLines -StoredProcedureName $StoredProcedureName -ProgramName $ProgramName -SubProgramName $SubProgramName -Category "business-object-overridden-function" -FunctionName $FunctionName)

        var loDbParams = loCmd.Parameters.Cast<DbParameter>()
            .Where(x => x != null && x.ParameterName.StartsWith("@"))
            .ToDictionary(x => x.ParameterName, x => x.Value);

        _logger.LogDebug("{@ObjectQuery} {@Parameter}", loCmd.CommandText, loDbParams);

        // Execute stored procedure based on function type
$(
    switch ($FunctionName) {
        "R_DisplayAsync" {
            "        var loDataTable = await loDb.SqlExecQueryAsync(loConn, loCmd, false);
        var loResult = R_Utility.R_ConvertTo<$ProgramName`DTO>(loDataTable).FirstOrDefault();
        loEx.ThrowExceptionIfErrors();
        _logger.LogInfo(""END function {$FunctionName}"", lcFunction);
        return loResult;"
        }
        default {
            "        await loDb.SqlExecNonQueryAsync(loConn, loCmd);
        loEx.ThrowExceptionIfErrors();
        _logger.LogInfo(""END function {$FunctionName}"", lcFunction);"
        }
    }
)

        throw new NotImplementedException();
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
    _logger.LogInfo("END function {$FunctionName}", lcFunction);
}
"@
    
    return $functionContent
}

function Generate-BatchFunction {
    param(
        [string]$StoredProcedureName,
        [string]$ProgramName,
        [string]$SubProgramName
    )
    
    $functionContent = @"
//CATEGORY: batch-function
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

EndBlock:
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
            var loObject = R_NetCoreUtility.R_DeserializeObjectFromByte<List<{${SubProgramName}BatchListDisplayDTO}>>(poBatchProcessPar.BigObject);

$(Get-UserParameterLines -ProgramName $ProgramName -SubProgramName $SubProgramName)

            R_ExternalException.R_SP_Init_Exception(loConn);

            // REPLACE THIS WITH ACTUAL IMPLEMENTATION LOGIC OF OLD R_BatchProcess / R_BatchProcessAsync

            loEx.Add(R_ExternalException.R_SP_Get_Exception(loConn));

            transactionScope.Complete();
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
"@
    
    return $functionContent
}

function Generate-OtherFunction {
    param(
        [string]$StoredProcedureName,
        [string]$ProgramName,
        [string]$SubProgramName
    )
    
    # Use stored procedure name as function name
    $functionName = $StoredProcedureName
    
    # Check for existing DTOs
    $dtoPath = "partials\$ProgramName\$SubProgramName\common\dto"
    $parameterDTO = "$($SubProgramName)$($StoredProcedureName)ParameterDTO.cs"
    $resultDTO = "$($SubProgramName)$($StoredProcedureName)ResultDTO.cs"
    
    $hasParameterDTO = Test-Path (Join-Path $dtoPath $parameterDTO)
    $hasResultDTO = Test-Path (Join-Path $dtoPath $resultDTO)
    
    # Build function signature based on available DTOs
    $parameterType = if ($hasParameterDTO) { "$($SubProgramName)$($StoredProcedureName)ParameterDTO" } else { "object" }
    $returnType = if ($hasResultDTO) { "$($SubProgramName)$($StoredProcedureName)ResultDTO" } else { "object" }
    
    $functionContent = @"
//CATEGORY: other-function
public async Task<$returnType> $functionName($parameterType poParam)
{
    string lcFunction = nameof($functionName);
    using var activity = _activitySource.StartActivity(lcFunction);
    _logger.LogInfo("START function {$functionName}", lcFunction);

    var loEx = new R_Exception();
    var loDb = new R_Db();
    $returnType loResult = new();

    try
    {
        using DbConnection loConn = await loDb.GetConnectionAsync();
        using DbCommand loCmd = loDb.GetCommand();
        loCmd.Parameters.Clear();

        loCmd.CommandText = "$StoredProcedureName";
        loCmd.CommandType = CommandType.StoredProcedure;

$(Get-CommandParameterLines -StoredProcedureName $StoredProcedureName -ProgramName $ProgramName -SubProgramName $SubProgramName -Category "other-function" -FunctionName $functionName)

        var loDbParams = loCmd.Parameters.Cast<DbParameter>()
            .Where(x => x != null && x.ParameterName.StartsWith("@"))
            .ToDictionary(x => x.ParameterName, x => x.Value);

        _logger.LogDebug("{@ObjectQuery} {@Parameter}", loCmd.CommandText, loDbParams);

$(
    if ($hasResultDTO) {
        "        var loDataTable = await loDb.SqlExecQueryAsync(loConn, loCmd, false);
        loResult = R_Utility.R_ConvertTo<$returnType>(loDataTable).FirstOrDefault();"
    } else {
        "        // Execute query and convert to result manually since no ResultDTO found
        var loDataTable = await loDb.SqlExecQueryAsync(loConn, loCmd, false);
        // TODO: Convert loDataTable to appropriate result type"
    }
)
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
    _logger.LogInfo("END function {$functionName}", lcFunction);
    return loResult;
}
"@
    
    return $functionContent
}

# Main execution
$spListPath = "partials\$ProgramName\$SubProgramName\stored-procedure\sp_list.txt"
$chunksPath = "chunks_cs\$ProgramName\$SubProgramName"

if (-not (Test-Path $spListPath)) {
    Write-Error "sp_list.txt not found at $spListPath"
    exit 1
}

# Create chunks directory if it doesn't exist
if (-not (Test-Path $chunksPath)) {
    New-Item -ItemType Directory -Path $chunksPath -Force
}

# Read and process sp_list.txt
$spListContent = Get-Content $spListPath
$functionsList = @()

foreach ($line in $spListContent) {
    if ([string]::IsNullOrWhiteSpace($line) -or $line.StartsWith("#")) {
        continue
    }
    
    $parts = $line -split '\|'
    if ($parts.Count -lt 2) {
        Write-Warning "Invalid line format: $line"
        continue
    }
    
    $storedProcedureName = $parts[0].Trim()
    $category = $parts[1].Trim()
    $functionName = if ($parts.Count -gt 2) { $parts[2].Trim() } else { $null }
    $implementationFlag = if ($parts.Count -gt 3) { $parts[3].Trim() } else { $null }
    
    Write-Host "Processing: $storedProcedureName | $category | $functionName | $implementationFlag"
    
    $functionContent = switch ($category) {
        "business-object-overridden-function" {
            if ([string]::IsNullOrWhiteSpace($functionName)) {
                Write-Warning "Function name required for business-object-overridden-function category: $storedProcedureName"
                continue
            }
            if ($implementationFlag -eq "NOT_IMPLEMENTED") {
                Generate-BusinessObjectOverriddenFunctionNotImplemented -StoredProcedureName $storedProcedureName -FunctionName $functionName -ProgramName $ProgramName -SubProgramName $SubProgramName
            } else {
                Generate-BusinessObjectOverriddenFunction -StoredProcedureName $storedProcedureName -FunctionName $functionName -ProgramName $ProgramName -SubProgramName $SubProgramName
            }
        }
        "batch-function" {
            Generate-BatchFunction -StoredProcedureName $storedProcedureName -ProgramName $ProgramName -SubProgramName $SubProgramName
        }
        "other-function" {
            Generate-OtherFunction -StoredProcedureName $storedProcedureName -ProgramName $ProgramName -SubProgramName $SubProgramName
        }
        default {
            Write-Warning "Unknown category: $category for $storedProcedureName"
            continue
        }
    }
    
    if ($functionContent) {
        # Generate filename
        $fileName = switch ($category) {
            "business-object-overridden-function" { "$($functionName).cs" }
            "batch-function" { "R_BatchProcess.cs" }
            "other-function" { "$($storedProcedureName).cs" }
            default { "$($storedProcedureName).cs" }
        }
        
        $filePath = Join-Path $chunksPath $fileName
        $functionContent | Out-File -FilePath $filePath -Encoding UTF8 -Force
        Write-Host "Generated: $filePath"
        
        # Add to functions list
        $functionsList += $functionContent
    }
}

# Write functions.txt
if ($functionsList.Count -gt 0) {
    $functionsList | Out-File -FilePath (Join-Path $chunksPath "functions.txt") -Encoding UTF8 -Force
    Write-Host "Generated: functions.txt"
}

Write-Host "Function generation completed for $ProgramName\$SubProgramName"
