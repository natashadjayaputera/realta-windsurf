# VB Parser Execution Script
# Executes VB Parser for all files listed in cls_file_paths.txt

param(
    [Parameter(Mandatory=$true)]
    [string]$ProgramName,
    
    [Parameter(Mandatory=$true)]
    [string]$RootPath = (Get-Location).Path,
    
    [Parameter(Mandatory=$true)]
    [string]$SearchFolderBack,
    
    [Parameter(Mandatory=$true)]
    [string]$OutputFolder
)

$ClsFilePathsFile = "$OutputFolder\cls_file_paths.txt"
$VbParserProject = "$RootPath\.windsurf\tools\VbParser\VbParser.csproj"
$FindClsScript = "$RootPath\.windsurf\skills\01-run-vb-parser\find-cls-file.ps1"

# Always run find-cls-file.ps1 first
Write-Host "Running find-cls-file.ps1 first..."
& powershell -ExecutionPolicy Bypass -File $FindClsScript -SearchFolder $SearchFolderBack -OutputFolder $OutputFolder

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
        $result = & dotnet run --project $VbParserProject -- $ProgramName $filePath
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Successfully processed: $filePath" -ForegroundColor Green
        } else {
            Write-Warning "Failed to process: $filePath (Exit code: $LASTEXITCODE)"
        }
    } catch {
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
} else {
    Write-Warning "Output folder not found: $OutputFolder"
}
