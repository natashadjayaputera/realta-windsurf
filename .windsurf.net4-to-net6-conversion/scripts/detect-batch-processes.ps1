# Batch Process Detection Script
# Finds all batch process files and extracts batch parameters

param(
    [Parameter(Mandatory = $true)]
    [string]$ProgramName
)

# Load shared functions
$SharedFunctionsPath = Join-Path (Split-Path $PSScriptRoot -Parent) "scripts\Common-Functions.ps1"
if (Test-Path $SharedFunctionsPath) {
    . $SharedFunctionsPath
}

# Auto-detect root folder from git repository
$RootPath = Find-GitRoot

# Validate RootPath parameter
if (-not (Test-Path $RootPath)) {
    Write-Error "Root path not found: $RootPath"
    Write-Error "Ensure you're running from the repository root or provide the correct path."
    exit 1
}

# Convert to absolute path if relative
$RootPath = Resolve-Path $RootPath | Select-Object -ExpandProperty Path
$ChunksCsPath = "$RootPath\chunks_cs\$ProgramName"
$OutputFile = "$RootPath\chunks_cs\$ProgramName\viewmodel_with_batch_list_buffer.txt"

# Validate paths
if (-not (Test-Path $ChunksCsPath)) {
    Write-Error "Chunks CS path not found: $ChunksCsPath"
    exit 1
}

Write-Host "Starting batch process detection for Program: $ProgramName"
Write-Host "Chunks CS path: $ChunksCsPath"

# Find all files ending with _R_BatchProcess.cs (case-insensitive)
$batchFiles = Get-ChildItem -Path $ChunksCsPath -Recurse -Filter "*_R_BatchProcess.cs" -File | Where-Object { $_.Name -match "_R_BatchProcess\.cs$" }

if ($batchFiles.Count -eq 0) {
    Write-Warning "No batch process files found in $ChunksCsPath"
    exit 0
}

Write-Host "Found $($batchFiles.Count) batch process files"

# Extract SubProgramName from each batch file and save to buffer
$subProgramNames = @()
foreach ($file in $batchFiles) {
    # Extract SubProgramName from the file path (parent folder name)
    $subProgramName = $file.Directory.Name
    
    # Skip if already processed
    if ($subProgramNames -contains $subProgramName) {
        Write-Host "  Skipping duplicate: $subProgramName"
        continue
    }
    
    # Add to list
    $subProgramNames += $subProgramName
    Write-Host "  Found batch process: $subProgramName"
}

# Save SubProgramNames to buffer file
$subProgramNames | Set-Content -Path $OutputFile -Force

Write-Host "Batch process detection completed for $ProgramName"
Write-Host "Results saved to: $OutputFile"
Write-Host "Total SubPrograms with batch processes: $($subProgramNames.Count)"

# Display summary
Write-Host "`nBatch Process Summary:"
$subProgramNames | ForEach-Object {
    Write-Host "  $_" -ForegroundColor Cyan
}
