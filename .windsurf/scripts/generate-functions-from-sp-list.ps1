param(
    [Parameter(Mandatory=$true)]
    [string]$ProgramName,
    
    [Parameter(Mandatory=$true)]
    [string]$SubProgramName
)

# Import common functions
. "$PSScriptRoot\Common-Functions.ps1"

#region Helper Functions

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
    $gitRoot = Find-GitRoot
    $userParameterDTOPath = Join-Path $gitRoot "partials\$ProgramName\$SubProgramName\common\dto\$($SubProgramName)R_SaveBatchUserParameterDTO.cs"
    
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
                    "string" { "((System.Text.Json.JsonElement?)lo$($prop.Name)?.Value)?.GetString() ?? string.Empty" }
                    "int" { "((System.Text.Json.JsonElement?)lo$($prop.Name)?.Value)?.GetInt32() ?? 0" }
                    "decimal" { "((System.Text.Json.JsonElement?)lo$($prop.Name)?.Value)?.GetDecimal() ?? 0" }
                    "bool" { "((System.Text.Json.JsonElement?)lo$($prop.Name)?.Value)?.GetBoolean() ?? false" }
                    "datetime" { "((System.Text.Json.JsonElement?)lo$($prop.Name)?.Value)?.GetDateTime() ?? DateTime.MinValue" }
                    default { "((System.Text.Json.JsonElement?)lo$($prop.Name)?.Value)?.ToString() ?? string.Empty" }
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

#endregion

#region Parameter Processing Functions

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
    $gitRoot = Find-GitRoot
    $csvPath = switch ($Category) {
        "business-object-overridden-function" { Join-Path $gitRoot "partials\$ProgramName\$SubProgramName\stored-procedure\parameters\business-object-overridden-function\Entity.csv" }
        "batch-function" { Join-Path $gitRoot "partials\$ProgramName\$SubProgramName\stored-procedure\parameters\batch-function\$($StoredProcedureName).csv" }
        "other-function" { Join-Path $gitRoot "partials\$ProgramName\$SubProgramName\stored-procedure\parameters\other-function\$($StoredProcedureName).csv" }
        default { Join-Path $gitRoot "partials\$ProgramName\$SubProgramName\stored-procedure\parameters\other-function\$($StoredProcedureName).csv" }
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

#endregion

#region Function Generation - Business Object Overridden Functions

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

    $hasSpResource = Test-HasResourceFile -StoredProcedureName $StoredProcedureName -ProgramName $ProgramName -SubProgramName $SubProgramName
    
    # Build execution block based on function type
    $executionBlock = switch ($FunctionName) {
        "R_DisplayAsync" {
            @"
            var loDataTable = await loDb.SqlExecQueryAsync(loConn, loCmd, false);
            loResult = R_Utility.R_ConvertTo<$SubProgramName`DTO>(loDataTable).FirstOrDefault();
"@
        }
        default {
            @"
            await loDb.SqlExecNonQueryAsync(loConn, loCmd);
"@
        }
    }

    $initBlock = switch ($FunctionName) {
        "R_DisplayAsync" { @"
    var loEx = new R_Exception();
    var loDb = new R_Db();
    $SubProgramName`DTO? loResult = null;
"@ }
        default {  @"
    var loEx = new R_Exception();
    var loDb = new R_Db();
"@ }
    }

    $returnStatement = switch ($FunctionName) {
        "R_DisplayAsync" { @"
    loEx.ThrowExceptionIfErrors();
    _logger.LogInfo("END function {$FunctionName}", lcFunction);

    return loResult ?? new $SubProgramName`DTO();
"@ }
        default {  @"
    loEx.ThrowExceptionIfErrors();
    _logger.LogInfo("END function {$FunctionName}", lcFunction);
"@  }
    }
    
    # Add resource file handling if needed
    $resourceHandling = ""
    if ($hasSpResource) {
        $resourceHandling = @"
        R_ExternalException.R_SP_Init_Exception(loConn);

        try
        {
$executionBlock
        }
        catch (Exception ex)
        {
            loEx.Add(ex);
        }

        loEx.Add(R_ExternalException.R_SP_Get_Exception(loConn));
"@
    } else {
        $resourceHandling = $executionBlock
    }
    
    $functionContent = @"
//CATEGORY: business-object-overridden-function
$functionSignature
{
    string lcFunction = nameof($FunctionName);
    using var activity = _activitySource.StartActivity(lcFunction);
    _logger.LogInfo("START function {$FunctionName}", lcFunction);

$initBlock

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
$resourceHandling
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

$returnStatement
}
"@
    
    return $functionContent
}

#endregion

#region Function Generation - Batch

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
    string lcFunction = nameof(R_BatchProcessAsync);
    using var activity = _activitySource.StartActivity(lcFunction);
    R_Exception loEx = new R_Exception();
    var loDb = new R_Db();

    try
    {
        if (loDb.R_TestConnection() == false)
        {
            loEx.Add("","Connection to database failed");
            goto EndBlock;
        }
        _ = _BatchProcessAsync(poBatchProcessPar); // IMPORTANT: Fire and forget
    }
    catch (Exception ex)
    {
        loEx.Add(ex);
    }
    finally
    {
        if (loDb != null)
        {
            loDb = null;
        }
    }

EndBlock:
    loEx.ThrowExceptionIfErrors();
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
            var loObject = R_NetCoreUtility.R_DeserializeObjectFromByte<List<${SubProgramName}BatchListDisplayDTO>>(poBatchProcessPar.BigObject);

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

#endregion

#region Function Generation - Other

function Generate-OtherFunction {
    param(
        [string]$StoredProcedureName,
        [string]$ProgramName,
        [string]$SubProgramName,
        [string]$ReturnTypeIndicator
    )
    
    # Use stored procedure name as function name
    $functionName = $StoredProcedureName
    
    # Check for existing DTOs
    $gitRoot = Find-GitRoot
    $dtoPath = Join-Path $gitRoot "partials\$ProgramName\$SubProgramName\common\dto"
    $parameterDTO = "$($SubProgramName)$($StoredProcedureName)ParameterDTO.cs"
    $resultDTO = "$($SubProgramName)$($StoredProcedureName)ResultDTO.cs"
    
    $hasParameterDTO = Test-Path (Join-Path $dtoPath $parameterDTO)
    $hasResultDTO = Test-Path (Join-Path $dtoPath $resultDTO)
    
    # Build function signature based on available DTOs and return type indicator
    $parameterPart = if ($hasParameterDTO) { "$($SubProgramName)$($StoredProcedureName)ParameterDTO poParam" } else { "" }
    
    # Determine return type based on ReturnTypeIndicator and DTO availability
    if ($hasResultDTO) {
        $resultDTOType = "$($SubProgramName)$($StoredProcedureName)ResultDTO"
        if ($ReturnTypeIndicator -eq "list") {
            $returnType = "List<$resultDTOType>"
        } elseif ($ReturnTypeIndicator -eq "single") {
            $returnType = $resultDTOType
        } else {
            # Default to single result if not specified
            $returnType = $resultDTOType
        }
        $returnPart = "<$returnType>"
    } else {
        # If no ResultDTO found, return Task (no return value)
        $returnPart = ""
    }
    
    # Build function signature with conditional parameters and return type
    $functionSignature = "public async Task$returnPart $functionName($parameterPart)"
    
    $functionContent = @"
//CATEGORY: other-function
$functionSignature
{
    string lcFunction = nameof($functionName);
    using var activity = _activitySource.StartActivity(lcFunction);
    _logger.LogInfo("START function {$functionName}", lcFunction);

    var loEx = new R_Exception();
    var loDb = new R_Db();
$(
    if ($hasResultDTO) {
        "    $returnType`? loResult = null;"
    } else {
        ""
    }
)

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
        if ($ReturnTypeIndicator -eq "list") {
            "        var loDataTable = await loDb.SqlExecQueryAsync(loConn, loCmd, false);
        loResult = R_Utility.R_ConvertTo<$resultDTOType>(loDataTable).ToList();"
        } else {
            "        var loDataTable = await loDb.SqlExecQueryAsync(loConn, loCmd, false);
        loResult = R_Utility.R_ConvertTo<$resultDTOType>(loDataTable).FirstOrDefault();"
        }
    } else {
        "        // Execute stored procedure without return value
        await loDb.SqlExecNonQueryAsync(loConn, loCmd);"
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
$(
    if ($hasResultDTO) {
        if ($ReturnTypeIndicator -eq "list") {
            "    return loResult ?? new List<$resultDTOType>();"
        } else {
            "    return loResult ?? new $resultDTOType();"
        }
    } else {
        "    return;"
    }
)
}
"@
    
    return $functionContent
}

#endregion

#region Resource File Functions

function Test-HasResourceFile {
    param(
        [string]$StoredProcedureName,
        [string]$ProgramName,
        [string]$SubProgramName
    )
    
    $gitRoot = Find-GitRoot
    $resourcePath = Join-Path $gitRoot "partials\$ProgramName\$SubProgramName\stored-procedure\resources"
    $resourceFile = Join-Path $resourcePath "$($StoredProcedureName).txt"
    
    return Test-Path $resourceFile
}

function New-AdditionalPropertiesFile {
    param(
        [string]$ProgramName,
        [string]$SubProgramName
    )
    
    $gitRoot = Find-GitRoot
    $resourcePath = Join-Path $gitRoot "partials\$ProgramName\$SubProgramName\stored-procedure\resources"
    $chunksPath = Join-Path $gitRoot "chunks_cs\$ProgramName\$SubProgramName"
    
    if (-not (Test-Path $resourcePath)) {
        Write-Warning "Resources path not found: $resourcePath"
        return
    }
    
    # Get all .txt files in resources folder
    $resourceFiles = Get-ChildItem -Path $resourcePath -Filter "*.txt" -File
    
    if ($resourceFiles.Count -eq 0) {
        Write-Host "No resource files found in $resourcePath"
        return
    }
    
    $additionalPropertiesContent = @()
    
    foreach ($resourceFile in $resourceFiles) {
        $spName = $resourceFile.BaseName
        $className = "$($spName)Resources.Resources_Dummy_Class"
        $fieldName = "_$spName"
        
        $additionalPropertiesContent += "private $className $fieldName = new();"
    }
    
    if ($additionalPropertiesContent.Count -gt 0) {
        $additionalPropertiesContent += ""  # Add empty line at the end
        
        $filePath = Join-Path $chunksPath "0000_AdditionalProperties.cs"
        $additionalPropertiesContent | Out-File -FilePath $filePath -Encoding UTF8 -Force
        Write-Host "Generated: $filePath"
    }
}

#endregion

#region Main Execution
$gitRoot = Find-GitRoot
$spListPath = Join-Path $gitRoot "partials\$ProgramName\$SubProgramName\stored-procedure\sp_list.txt"
$chunksPath = Join-Path $gitRoot "chunks_cs\$ProgramName\$SubProgramName"

# Track categories for class declaration
$hasBusinessObjectFunctions = $false
$hasBatchFunctions = $false

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

# Initialize sequence counter
$sequenceCounter = 1

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
    
    # Track categories for class declaration
    if ($category -eq "business-object-overridden-function") {
        $hasBusinessObjectFunctions = $true
    }
    if ($category -eq "batch-function") {
        $hasBatchFunctions = $true
    }
    
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
            Generate-OtherFunction -StoredProcedureName $storedProcedureName -ProgramName $ProgramName -SubProgramName $SubProgramName -ReturnTypeIndicator $functionName
        }
        default {
            Write-Warning "Unknown category: $category for $storedProcedureName"
            continue
        }
    }
    
    if ($functionContent) {
        # Generate filename with sequence number
        $sequenceNumber = "{0:D4}" -f $sequenceCounter
        $fileName = switch ($category) {
            "business-object-overridden-function" { "$($sequenceNumber)_$($functionName).cs" }
            "batch-function" { "$($sequenceNumber)_R_BatchProcessAsync.cs" }
            "other-function" { "$($sequenceNumber)_$($storedProcedureName).cs" }
            default { "$($sequenceNumber)_$($storedProcedureName).cs" }
        }
        
        $filePath = Join-Path $chunksPath $fileName
        $functionContent | Out-File -FilePath $filePath -Encoding UTF8 -Force
        Write-Host "Generated: $filePath"
        
        # Increment sequence counter
        $sequenceCounter++
        
        # Add only function signature and category to functions list (single line format)
        $functionSignature = switch ($category) {
            "business-object-overridden-function" {
                $signature = switch ($functionName) {
                    "R_DisplayAsync" { "protected override async Task<$SubProgramName`DTO> R_DisplayAsync($SubProgramName`DTO poEntity)" }
                    "R_SavingAsync" { "protected override async Task R_SavingAsync($SubProgramName`DTO poNewEntity, eCRUDMode poCRUDMode)" }
                    "R_DeletingAsync" { "protected override async Task R_DeletingAsync($SubProgramName`DTO poEntity)" }
                    default { "protected override async Task $functionName($SubProgramName`DTO poEntity)" }
                }
                "$signature //CATEGORY: $category"
            }
            "batch-function" { "public async Task R_BatchProcessAsync(R_BatchProcessPar poBatchProcessPar) //CATEGORY: $category" }
            "other-function" { 
                # Check for existing DTOs
                $gitRoot = Find-GitRoot
                $dtoPath = Join-Path $gitRoot "partials\$ProgramName\$SubProgramName\common\dto"
                $parameterDTO = "$($SubProgramName)$($storedProcedureName)ParameterDTO.cs"
                $resultDTO = "$($SubProgramName)$($storedProcedureName)ResultDTO.cs"
                
                $hasParameterDTO = Test-Path (Join-Path $dtoPath $parameterDTO)
                $hasResultDTO = Test-Path (Join-Path $dtoPath $resultDTO)
                
                # Build function signature based on available DTOs and return type indicator
                $parameterPart = if ($hasParameterDTO) { "$($SubProgramName)$($storedProcedureName)ParameterDTO poParam" } else { "" }
                
                # Determine return type based on functionName and DTO availability
                if ($hasResultDTO) {
                    $resultDTOType = "$($SubProgramName)$($storedProcedureName)ResultDTO"
                    if ($functionName -eq "list") {
                        $returnType = "List<$resultDTOType>"
                    } elseif ($functionName -eq "single") {
                        $returnType = $resultDTOType
                    } else {
                        # Default to single result if not specified
                        $returnType = $resultDTOType
                    }
                    "public async Task<$returnType> $storedProcedureName($parameterPart) //CATEGORY: $category"
                } else {
                    # If no ResultDTO found, return Task (no return value)
                    "public async Task $storedProcedureName($parameterPart) //CATEGORY: $category"
                }
            }
            default { "public async Task $storedProcedureName(object poParam) //CATEGORY: $category" }
        }
        
        $functionsList += $functionSignature
    }
}

# Write functions.txt
if ($functionsList.Count -gt 0) {
    $functionsList | Out-File -FilePath (Join-Path $chunksPath "functions.txt") -Encoding UTF8 -Force
    Write-Host "Generated: functions.txt"
}

# Generate ClassDeclaration.txt based on categories found
$classDeclaration = @()
if ($hasBusinessObjectFunctions -and $hasBatchFunctions) {
    $classDeclaration += "public class $($SubProgramName)CLS : R_BusinessObjectAsync<$($SubProgramName)DTO>, R_IBatchProcessAsync"
} elseif ($hasBusinessObjectFunctions) {
    $classDeclaration += "public class $($SubProgramName)CLS : R_BusinessObjectAsync<$($SubProgramName)DTO>"
} elseif ($hasBatchFunctions) {
    $classDeclaration += "public class $($SubProgramName)CLS : R_IBatchProcessAsync"
} else {
    $classDeclaration += "public class $($SubProgramName)CLS"
}

if ($classDeclaration.Count -gt 0) {
    $classDeclaration | Out-File -FilePath (Join-Path $chunksPath "ClassDeclaration.txt") -Encoding UTF8 -Force
    Write-Host "Generated: ClassDeclaration.txt"
}

# Generate AdditionalProperties.cs based on resource files
New-AdditionalPropertiesFile -ProgramName $ProgramName -SubProgramName $SubProgramName

Write-Host "Function generation completed for $ProgramName\$SubProgramName"

#endregion