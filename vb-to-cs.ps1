#!/usr/bin/env pwsh

<#
.SYNOPSIS
    Converts all .vb files to .cs files in chunks_cs directory structure.

.DESCRIPTION
    This script finds all .vb files in chunks_cs/{ProgramName} directories and renames them to .cs.
    It operates recursively through the entire chunks_cs directory structure.

.EXAMPLE
    .\vb-to-cs.ps1
    Converts all .vb files to .cs files

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

Write-Host "Searching for .vb files in: $ChunksCsDir" -ForegroundColor Green

# Convert .vb files to .cs files
Write-Host "Converting .vb files to .cs files..." -ForegroundColor Yellow

$VbFiles = Get-ChildItem -Path $ChunksCsDir -Filter "*.vb" -Recurse -File

if ($VbFiles.Count -eq 0) {
    Write-Host "No .vb files found to convert." -ForegroundColor Yellow
    exit 0
}

Write-Host "Found $($VbFiles.Count) .vb files to convert:" -ForegroundColor Cyan

foreach ($File in $VbFiles) {
    $NewName = [System.IO.Path]::ChangeExtension($File.FullName, ".cs")
    
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
