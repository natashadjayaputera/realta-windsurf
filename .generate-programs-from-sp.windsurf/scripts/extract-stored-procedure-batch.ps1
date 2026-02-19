param(
    [Parameter(Mandatory=$true)]
    [string]$ProgramName,

    [Parameter(Mandatory=$true)]
    [string]$SubProgramNames
)

# Load shared functions
$SharedFunctionsPath = Join-Path (Split-Path $PSScriptRoot -Parent) "scripts\Common-Functions.ps1"
if (Test-Path $SharedFunctionsPath) {
    . $SharedFunctionsPath
}

# Auto-detect root folder from git repository
$RootPath = Find-GitRoot

# Split comma-separated names
$subPrograms = $SubProgramNames -split ',' | ForEach-Object { $_.Trim() }

# Read connection string
$configPath = Join-Path $RootPath 'partials-config.txt'
if (-not (Test-Path $configPath)) {
    Write-Host ''
    Write-Host 'ERROR: Configuration file not found.' -ForegroundColor Red
    Write-Host "Expected file: $configPath" -ForegroundColor Red
    Write-Host ''
    Write-Host 'Please create the file with the following format:' -ForegroundColor Yellow
    Write-Host 'db_server: sql server' -ForegroundColor Cyan
    Write-Host 'connection_string: server=hostname\SQL2016;Initial Catalog=database;User ID=user;Password=password' -ForegroundColor Cyan
    Write-Host ''
    Write-Host 'Example:' -ForegroundColor Yellow
    Write-Host 'db_server: sql server' -ForegroundColor Cyan
    Write-Host 'connection_string: server=172.16.0.62\SQL2016;Initial Catalog=BIMASAKTI_11_BSI;User ID=sa;Password=S4-r5fdbsvr1#' -ForegroundColor Cyan
    exit 1
}

$config = Get-Content $configPath
$connLine = $config | Where-Object { $_ -match 'connection_string:' }

if (-not $connLine) {
    Write-Host ''
    Write-Host 'ERROR: Connection string not found in configuration file.' -ForegroundColor Red
    Write-Host "Expected line starting with: connection_string:" -ForegroundColor Red
    Write-Host ''
    Write-Host 'Please add the connection string line to your file:' -ForegroundColor Yellow
    Write-Host 'db_server: sql server' -ForegroundColor Cyan
    Write-Host 'connection_string: server=hostname\SQL2016;Initial Catalog=database;User ID=user;Password=password' -ForegroundColor Cyan
    Write-Host ''
    Write-Host 'Example:' -ForegroundColor Yellow
    Write-Host 'db_server: sql server' -ForegroundColor Cyan
    Write-Host 'connection_string: server=172.16.0.62\SQL2016;Initial Catalog=BIMASAKTI_11_BSI;User ID=sa;Password=S4-r5fdbsvr1#' -ForegroundColor Cyan
    exit 1
}

$connString = $connLine.Split(':')[1].Trim()

# Validate connection string format
Write-Host "Validating connection string format..."
# Hide password in connection string display for validation
$safeConnString = $connString -replace '(Password=)[^;]+', '$1***'
if ($connString -match '\\\\') {
    Write-Host ''
    Write-Host 'ERROR: Connection string contains double backslash (\\\\).' -ForegroundColor Red
    Write-Host 'This will cause SQL Server connection issues.' -ForegroundColor Red
    Write-Host ''
    Write-Host 'Expected format: server=hostname\SQLVersion' -ForegroundColor Yellow
    Write-Host "Found format: $safeConnString" -ForegroundColor Yellow
    Write-Host ''
    Write-Host 'Please fix the connection string in to-server.txt and try again.' -ForegroundColor Cyan
    exit 1
} elseif ($connString -match '/') {
    Write-Host ''
    Write-Host 'ERROR: Connection string contains forward slash (/).' -ForegroundColor Red
    Write-Host 'SQL Server requires backslash (\) for named instances.' -ForegroundColor Red
    Write-Host ''
    Write-Host 'Expected format: server=hostname\SQLVersion' -ForegroundColor Yellow
    Write-Host "Found format: $safeConnString" -ForegroundColor Yellow
    Write-Host ''
    Write-Host 'Please fix the connection string in to-server.txt and try again.' -ForegroundColor Cyan
    exit 1
} 

foreach ($subProgram in $subPrograms) {
    # Set folders
    $programFolder = Join-Path $RootPath "partials\$ProgramName\$subProgram\stored-procedure"
    $paramsFolder = Join-Path $programFolder "parameters"
    $resultsFolder = Join-Path $programFolder "results"

    # Create folders
    if (!(Test-Path $programFolder)) { New-Item -ItemType Directory -Path $programFolder -Force }
    if (!(Test-Path $paramsFolder)) { New-Item -ItemType Directory -Path $paramsFolder -Force }
    if (!(Test-Path $resultsFolder)) { New-Item -ItemType Directory -Path $resultsFolder -Force }

    # Get script paths
    $paramScript = Join-Path $PSScriptRoot 'extract-stored-procedure-parameter.ps1'
    $resultScript = Join-Path $PSScriptRoot 'extract-stored-procedure-result.ps1'

    # Get stored procedures from sp_list.txt file
    $spListFile = Join-Path $programFolder "sp_list.txt"
    
    if (-not (Test-Path $spListFile)) {
        Write-Warning "Stored procedure list file not found: $spListFile"
        continue
    }
    
    # Read procedure names from the list file
    $procedures = Get-Content $spListFile | Where-Object { $_.Trim() -ne "" } | ForEach-Object { $_.Trim() }

    if ($procedures.Count -eq 0) {
        Write-Warning "No stored procedures found in $spListFile"
        continue
    }

    Write-Host "Found $($procedures.Count) stored procedures in $subProgram"
    Write-Host "Procedures: $($procedures -join ', ')"
    Write-Host ""

    # Process each procedure
    $count = 1
    $total = $procedures.Count
    foreach ($proc in $procedures) {
        $procName = $proc.Split('|')[0]
        $procCategory = $proc.Split('|')[1]
        Write-Host ""
        $title = $subProgram + " " + "[$count/$total]"
        Write-Host $title -ForegroundColor Green
        $separator = "=" * ($procName.Length + 12)
        Write-Host $separator
        Write-Host "Processing: $procName"
        Write-Host $separator

        # Extract parameters
        $paramFile = Join-Path $paramsFolder "$procCategory/$procName.csv"
        & $paramScript -StoredProcedureName $procName -ConnectionString $connString -OutputPath $paramFile
        
        # Extract results
        $resultFile = Join-Path $resultsFolder "$procCategory/$procName.csv"
        & $resultScript -StoredProcedureName $procName -ConnectionString $connString -OutputPath $resultFile
        
        Write-Host $separator
        $count++
    }
}

Write-Host 'Done extract-stored-procedure-batch.ps1'
