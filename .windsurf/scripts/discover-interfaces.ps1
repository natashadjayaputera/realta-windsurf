# Interface Discovery Script
# Finds all interfaces in the Common project

param(
    [Parameter(Mandatory = $true)]
    [string]$ProgramName,
    
    [Parameter(Mandatory = $true)]
    [string]$SearchFolderCommon
)

# Load shared functions
$SharedFunctionsPath = Join-Path (Split-Path $PSScriptRoot -Parent) "scripts\Common-Functions.ps1"
if (Test-Path $SharedFunctionsPath) {
    . $SharedFunctionsPath
}

# Auto-detect root folder from git repository
$RootPath = Find-GitRoot

$OutputFile = "$RootPath\chunks_cs\$ProgramName\interfaces_list.txt"

# Validate paths
if (-not (Test-Path $SearchFolderCommon)) {
    Write-Error "Common project path not found: $SearchFolderCommon"
    exit 1
}

Write-Host "Starting interface discovery for Program: $ProgramName"
Write-Host "Common project path: $SearchFolderCommon"

# Find all interface files (*.cs) that contain "interface" keyword
$interfaceFiles = Get-ChildItem -Path $SearchFolderCommon -Recurse -Filter "*.cs" -File | Where-Object {
    $content = Get-Content $_.FullName -Raw
    $content -match "\binterface\b" -and $content -match "public\s+interface"
}

if ($interfaceFiles.Count -eq 0) {
    Write-Warning "No interfaces found in $SearchFolderCommon"
    exit 0
}

Write-Host "Found $($interfaceFiles.Count) interface files"

# Extract interface names and save to file
$interfaces = @()
foreach ($file in $interfaceFiles) {
    $content = Get-Content $file.FullName -Raw
    
    # Find public interface declarations
    $interfaceMatches = [regex]::Matches($content, "public\s+interface\s+(\w+)")
    
    foreach ($match in $interfaceMatches) {
        $interfaceName = $match.Groups[1].Value
        $relativePath = $file.FullName.Replace($SearchFolderCommon, "").Replace("\", "/").TrimStart("/")
        
        $interfaces += [PSCustomObject]@{
            Name     = $interfaceName
            FilePath = $relativePath
            FullName = $file.FullName
        }
        
        Write-Host "  Found interface: $interfaceName in $relativePath"
    }
}

# Save interfaces list to file
$interfaces | ForEach-Object { "$($_.Name)|$($_.FilePath)" } | Set-Content -Path $OutputFile -Force

Write-Host "Interface discovery completed for $ProgramName"
Write-Host "Results saved to: $OutputFile"
Write-Host "Total interfaces found: $($interfaces.Count)"

# Display summary
Write-Host "`nInterface Summary:"
$interfaces | ForEach-Object {
    Write-Host "  $($_.Name) - $($_.FilePath)" -ForegroundColor Cyan
}
