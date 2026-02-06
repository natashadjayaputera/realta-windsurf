# VB Parser Execution Script
# Executes VB Parser for all files listed in cls_file_paths.txt

param(
    [Parameter(Mandatory = $true)]
    [string]$ProgramName,
    
    [Parameter(Mandatory = $true)]
    [string]$SearchFolderBack,
    
    [Parameter(Mandatory = $true)]
    [string]$OutputFolder
)

# Load shared functions
$SharedFunctionsPath = Join-Path (Split-Path $PSScriptRoot -Parent) "scripts\Common-Functions.ps1"
if (Test-Path $SharedFunctionsPath) {
    . $SharedFunctionsPath
}

# Auto-detect root folder from git repository
$RootPath = Find-GitRoot

$ClsFilePathsFile = "$OutputFolder\cls_file_paths.txt"
$VbParserProject = "$RootPath\.windsurf\tools\VbParser\VbParser.csproj"
$FindClsScript = "$RootPath\.windsurf\scripts\find-cls-file.ps1"

# Always run find-cls-file.ps1 first
Write-Host "Running find-cls-file.ps1 first..."
try {
    & powershell -ExecutionPolicy Bypass -File $FindClsScript -SearchFolder $SearchFolderBack -OutputFolder $OutputFolder
}
catch {
    Write-Error "Failed to execute find-cls-file.ps1. Ensure PowerShell execution policy allows script execution."
    Write-Error "You may need to run: Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser"
    exit 1
}

if ($LASTEXITCODE -ne 0) {
    Write-Error "find-cls-file.ps1 failed"
    exit 1
}

if (-not (Test-Path $ClsFilePathsFile)) {
    Write-Error "cls_file_paths.txt not found at $ClsFilePathsFile"
    exit 1
}

if (-not (Test-Path $VbParserProject)) {
    Write-Error "VB Parser project not found at $VbParserProject"
    exit 1
}

Write-Host "Starting VB Parser execution for Program: $ProgramName"
Write-Host "Reading file paths from: $ClsFilePathsFile"

$filePaths = Get-Content $ClsFilePathsFile
$totalFiles = $filePaths.Count
$currentFile = 0

foreach ($filePath in $filePaths) {
    $currentFile++
    Write-Host "Processing file $currentFile/$totalFiles : $filePath"
    
    try {
        & dotnet run --project $VbParserProject -- $ProgramName $filePath
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Successfully processed: $filePath" -ForegroundColor Green
        }
        else {
            Write-Warning "Failed to process: $filePath (Exit code: $LASTEXITCODE)"
        }
    }
    catch {
        Write-Error "Error processing $filePath : $($_.Exception.Message)"
    }
    
    Write-Host "---"
}

Write-Host "VB Parser execution completed for $ProgramName"

# Display output folder contents
Write-Host "Output folder contents:"
if (Test-Path $OutputFolder) {
    Get-ChildItem $OutputFolder -Recurse | ForEach-Object {
        Write-Host "  $($_.FullName.Replace($OutputFolder, ''))" -ForegroundColor Cyan
    }
}
else {
    Write-Warning "Output folder not found: $OutputFolder"
}
