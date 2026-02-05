# Function Injection Script
# Finds all .cls.cs files and executes function injector for each

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
$CsFunctionInjectorProject = "$RootPath\.windsurf\tools\CsTemplateInjector\CsTemplateInjector.csproj"
$FindClsCsScript = "$RootPath\.windsurf\scripts\find-cls-cs-files.ps1"

# Validate paths
if (-not (Test-Path $SearchFolderBack)) {
    Write-Error "Search folder not found: $SearchFolderBack"
    exit 1
}

if (-not (Test-Path $CsFunctionInjectorProject)) {
    Write-Error "CsTemplateInjector project not found: $CsFunctionInjectorProject"
    exit 1
}

Write-Host "Starting function injection for Program: $ProgramName"
Write-Host "Search folder: $SearchFolderBack"

# Use find-cls-cs-files.ps1 to find all cls.cs files
Write-Host "Finding cls.cs files..."
& powershell -ExecutionPolicy Bypass -File $FindClsCsScript -SearchFolder $SearchFolderBack -OutputFolder $OutputFolder

if ($LASTEXITCODE -ne 0) {
    Write-Error "find-cls-cs-files.ps1 failed"
    exit 1
}

# Read the cls file paths
if (-not (Test-Path $ClsFilePathsFile)) {
    Write-Error "cls_file_paths.txt not found at $ClsFilePathsFile"
    exit 1
}

$clsFiles = Get-Content $ClsFilePathsFile

if ($clsFiles.Count -eq 0) {
    Write-Warning "No cls.cs files found in $SearchFolderBack"
    exit 0
}

Write-Host "Found $($clsFiles.Count) cls.cs files"

# Execute function injector for each file
$totalFiles = $clsFiles.Count
$currentFile = 0

foreach ($clsFile in $clsFiles) {
    $currentFile++
    $relativePath = $clsFile.Replace($RootPath, "").Replace("\", "/").TrimStart("/")
    
    Write-Host "Processing file $currentFile/$totalFiles : $relativePath"
    
    try {
        $result = & dotnet run --project $CsFunctionInjectorProject -- $ProgramName $relativePath
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Successfully injected functions: $relativePath" -ForegroundColor Green
        } else {
            Write-Warning "Failed to inject functions: $relativePath (Exit code: $LASTEXITCODE)"
        }
    } catch {
        Write-Error "Error processing $relativePath : $($_.Exception.Message)"
    }
    
    Write-Host "---"
}

Write-Host "Function injection completed for $ProgramName"
