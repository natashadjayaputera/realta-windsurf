#!/usr/bin/env pwsh

<#
.SYNOPSIS
    Converts all .cs files to .vb files in chunks_cs directory structure.

.DESCRIPTION
    This script finds all .cs files in chunks_cs/{ProgramName} directories and renames them to .vb.
    It operates recursively through the entire chunks_cs directory structure.

.EXAMPLE
    .\cs-to-vb.ps1
    Converts all .cs files to .vb files

.NOTES
    Author: AI Assistant
    Version: 1.0
    Date: $(Get-Date -Format 'yyyy-MM-dd')
#>

# Get the root directory of the script
$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$ChunksCsDir = Join-Path $ScriptRoot "chunks_cs"

# Check if chunks_cs directory exists
if (-not (Test-Path $ChunksCsDir)) {
    Write-Error "chunks_cs directory not found at: $ChunksCsDir"
    exit 1
}

Write-Host "Searching for .cs files in: $ChunksCsDir" -ForegroundColor Green

# Convert .cs files to .vb files
Write-Host "Converting .cs files to .vb files..." -ForegroundColor Yellow

$CsFiles = Get-ChildItem -Path $ChunksCsDir -Filter "*.cs" -Recurse -File

if ($CsFiles.Count -eq 0) {
    Write-Host "No .cs files found to convert." -ForegroundColor Yellow
    exit 0
}

Write-Host "Found $($CsFiles.Count) .cs files to convert:" -ForegroundColor Cyan

foreach ($File in $CsFiles) {
    $NewName = [System.IO.Path]::ChangeExtension($File.FullName, ".vb")
    
    # Check if target file already exists
    if (Test-Path $NewName) {
        Write-Warning "Target file already exists, skipping: $($File.Name)"
        continue
    }
    
    try {
        Rename-Item -Path $File.FullName -NewName $NewName -ErrorAction Stop
        Write-Host "  Renamed: $($File.Name) -> $(Split-Path $NewName -Leaf)" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to rename $($File.Name): $($_.Exception.Message)"
    }
}

Write-Host "Conversion completed!" -ForegroundColor Green
