param(
    [Parameter(Mandatory=$true)]
    [string]$SearchFolder,
    [Parameter(Mandatory=$true)]
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

# Find all files ending with cls.vb (case-insensitive) in nested folders
$clsFiles = Get-ChildItem -Path $SearchFolder -Recurse -Filter "*cls.vb" -File | Where-Object { $_.Name -match "cls\.vb$" }

# Output file path
$outputFile = Join-Path $OutputFolder "cls_file_paths.txt"

# Write results to file
$clsFiles | ForEach-Object { $_.FullName } | Set-Content -Path $outputFile

Write-Host "Found $($clsFiles.Count) cls.vb files"
Write-Host "Results saved to: $outputFile"
