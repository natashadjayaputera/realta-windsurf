param(
    [Parameter(Mandatory = $true)]
    [string]$SearchFolderBack,
    
    [Parameter(Mandatory = $true)]
    [string]$SearchFolderCommon,
    
    [Parameter(Mandatory = $true)]
    [string]$OutputFolder
)

# Check if search paths exist
if (-not (Test-Path $SearchFolderBack)) {
    Write-Host "Error: Back search path '$SearchFolderBack' does not exist." -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $SearchFolderCommon)) {
    Write-Host "Error: Common search path '$SearchFolderCommon' does not exist." -ForegroundColor Red
    exit 1
}

# Create output directory if it doesn't exist
if (-not (Test-Path $OutputFolder)) {
    New-Item -ItemType Directory -Path $OutputFolder -Force | Out-Null
}

Write-Host "Searching Back project in: $SearchFolderBack" -ForegroundColor Green
Write-Host "Searching Common project in: $SearchFolderCommon" -ForegroundColor Green
Write-Host "Output: $OutputFolder" -ForegroundColor Green

# Find files in Back project
$filesInDtoFoldersBack = Get-ChildItem -Path $SearchFolderBack -Recurse -Directory | 
Where-Object { $_.Name -ieq "DTO" -and $_.FullName -notmatch "\\bin\\|\\obj\\" } | 
ForEach-Object { 
    Get-ChildItem -Path $_.FullName -File -ErrorAction SilentlyContinue | 
    Select-Object -ExpandProperty FullName
} | Where-Object { $_ -ne $null -and $_ -notmatch "\\bin\\|\\obj\\" }

$filesEndingWithDtoBack = Get-ChildItem -Path $SearchFolderBack -Recurse -File | 
Where-Object { $_.BaseName -ilike "*DTO" -and $_.FullName -notmatch "\\bin\\|\\obj\\" } | 
Select-Object -ExpandProperty FullName

# Find files in Common project
$filesInDtoFoldersCommon = Get-ChildItem -Path $SearchFolderCommon -Recurse -Directory | 
Where-Object { $_.Name -ieq "DTO" -and $_.FullName -notmatch "\\bin\\|\\obj\\" } | 
ForEach-Object { 
    Get-ChildItem -Path $_.FullName -File -ErrorAction SilentlyContinue | 
    Select-Object -ExpandProperty FullName
} | Where-Object { $_ -ne $null -and $_ -notmatch "\\bin\\|\\obj\\" }

$filesEndingWithDtoCommon = Get-ChildItem -Path $SearchFolderCommon -Recurse -File | 
Where-Object { $_.BaseName -ilike "*DTO" -and $_.FullName -notmatch "\\bin\\|\\obj\\" } | 
Select-Object -ExpandProperty FullName

# Combine all files and remove duplicates
$allFiles = @($filesInDtoFoldersBack) + @($filesEndingWithDtoBack) + @($filesInDtoFoldersCommon) + @($filesEndingWithDtoCommon)
$uniqueFiles = $allFiles | Sort-Object -Unique

# Display results
Write-Host "Found $($uniqueFiles.Count) files:" -ForegroundColor Yellow
$uniqueFiles | ForEach-Object { Write-Host $_ }

# Save to output directory if files found
if ($uniqueFiles.Count -gt 0) {
    $outputFile = Join-Path $OutputFolder "dto_files_list.txt"
    $uniqueFiles | Out-File -FilePath $outputFile -Encoding UTF8
    Write-Host "Saved to: $outputFile" -ForegroundColor Green
}
else {
    Write-Host "No DTO files found." -ForegroundColor Gray
}
