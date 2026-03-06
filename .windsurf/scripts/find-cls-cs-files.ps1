# Find CLS CS Files Script
# Finds all files ending with cls.cs (case-insensitive) in nested folders

param(
    [Parameter(Mandatory = $true)]
    [string]$SearchFolder,
    [Parameter(Mandatory = $true)]
    [string]$OutputFolder
)

# Validate search folder exists
if (-not (Test-Path $SearchFolder)) {
    Write-Error "Search folder does not exist: $SearchFolder"
    exit 1
}

# Validate and create output folder if it doesn't exist
if (-not (Test-Path $OutputFolder)) {
    New-Item -ItemType Directory -Path $OutputFolder -Force | Out-Null
}

# Find all files ending with cls.cs (case-insensitive) in nested folders, skipping bin and obj folders
$clsFiles = Get-ChildItem -Path $SearchFolder -Recurse -Filter "*cls.cs" -File | 
Where-Object { $_.Name -match "cls\.cs$" -and $_.FullName -notmatch "\\bin\\|\\obj\\" }

# Output file path
$outputFile = Join-Path $OutputFolder "cls_file_paths.txt"

# Write results to file
$clsFiles | ForEach-Object { $_.FullName } | Set-Content -Path $outputFile

Write-Host "Found $($clsFiles.Count) cls.cs files"
Write-Host "Results saved to: $outputFile"
