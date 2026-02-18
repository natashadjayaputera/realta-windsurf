# Copy Folders with Duplicate Check Script
# Copies all folders and files from searchFolder to outputFolder
# Checks for duplicates at the last depth and reports them without stopping

param(
    [Parameter(Mandatory=$true)]
    [string]$SearchFolder,
    
    [Parameter(Mandatory=$true)]
    [string]$OutputFolder
)

# Import common functions
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$commonFunctionsPath = Join-Path $scriptDir "Common-Functions.ps1"

if (Test-Path $commonFunctionsPath) {
    . $commonFunctionsPath
}

function Copy-FoldersWithDuplicateCheck {
    param(
        [string]$SearchFolder,
        [string]$OutputFolder
    )
    
    # Find git root and resolve relative paths
    $gitRoot = Find-GitRoot
    $resolvedSearchFolder = Join-Path $gitRoot $SearchFolder
    $resolvedOutputFolder = $OutputFolder
    
    Write-Host "Starting folder copy operation"
    Write-Host "Git Root: $gitRoot"
    Write-Host "Source: $SearchFolder -> $resolvedSearchFolder"
    Write-Host "Destination: $OutputFolder -> $resolvedOutputFolder"
    
    # Validate source folder exists
    if (-not (Test-Path $resolvedSearchFolder)) {
        Write-Error "Source folder not found: $resolvedSearchFolder"
        return
    }
    
    # Create output folder if it doesn't exist
    try {
        if (-not (Test-Path $resolvedOutputFolder)) {
            New-Item -ItemType Directory -Path $resolvedOutputFolder -Force -ErrorAction Stop | Out-Null
            Write-Host "Created destination folder: $resolvedOutputFolder"
        }
    }
    catch {
        Write-Error "Error creating destination folder: $($_.Exception.Message)"
        return
    }
    
    # Get all .csproj folders recursively (not just top-level folders)
    try {
        $csprojFiles = Get-ChildItem -Path $resolvedSearchFolder -Recurse -Filter "*.csproj" -ErrorAction Stop
        $csprojFolders = $csprojFiles | ForEach-Object { Split-Path $_.FullName -Parent } | Sort-Object -Unique
    }
    catch {
        Write-Error "Error reading .csproj files from source folder: $($_.Exception.Message)"
        return
    }
    
    if ($csprojFolders.Count -eq 0) {
        Write-Warning "No .csproj files found in source directory: $resolvedSearchFolder"
        return
    }
    
    Write-Host "Found $($csprojFolders.Count) .csproj folders to process"
    
    $copiedCount = 0
    $duplicateCount = 0
    $errorCount = 0
    $duplicates = @()
    
    foreach ($csprojFolder in $csprojFolders) {
        $folderName = Split-Path $csprojFolder -Leaf
        
        # Calculate relative path from search folder
        $relativePath = $csprojFolder.Replace($resolvedSearchFolder, "").TrimStart('\', '/')
        
        # If relative path is empty (csproj folder is the same as search folder), use folder name
        if ([string]::IsNullOrEmpty($relativePath)) {
            $relativePath = $folderName
        }
        
        $destinationPath = Join-Path $resolvedOutputFolder $relativePath
        
        Write-Host "Processing .csproj folder: $folderName"
        Write-Host "Source: $relativePath -> Destination: $destinationPath"
        
        # Check if destination folder already exists (duplicate check)
        if (Test-Path $destinationPath) {
            Write-Warning "Duplicate found: $folderName (already exists at destination)"
            $duplicates += $relativePath
            $duplicateCount++
            continue
        }
        
        # Copy the .csproj folder
        try {
            # Ensure parent directory exists before copying
            $parentDir = Split-Path $destinationPath -Parent
            if (-not (Test-Path $parentDir)) {
                New-Item -ItemType Directory -Path $parentDir -Force -ErrorAction Stop | Out-Null
                Write-Host "Created parent directory: $parentDir"
            }
            
            Copy-Item -Path $csprojFolder -Destination $destinationPath -Recurse -Force -ErrorAction Stop
            Write-Host "Successfully copied: $folderName"
            $copiedCount++
        }
        catch {
            Write-Error "Error copying folder $folderName : $($_.Exception.Message)"
            $errorCount++
        }
    }
    
    # Summary report
    Write-Host "`n=== Copy Operation Summary ==="
    Write-Host "Total .csproj folders processed: $($csprojFolders.Count)"
    Write-Host "Successfully copied: $copiedCount"
    Write-Host "Duplicates found: $duplicateCount"
    Write-Host "Errors encountered: $errorCount"
    
    if ($duplicates.Count -gt 0) {
        Write-Host "`nDuplicate .csproj folders (not copied):"
        foreach ($duplicate in $duplicates) {
            Write-Host "  - $duplicate"
        }
    }
    
    if ($errorCount -gt 0) {
        Write-Host "`nSome folders encountered errors during copy. Please review the error messages above."
    }
    
    if ($copiedCount -gt 0) {
        Write-Host "`nCopy operation completed successfully for $copiedCount folder(s)."
    } else {
        Write-Host "`nNo folders were copied."
    }
}

# Main execution
try {
    Copy-FoldersWithDuplicateCheck -SearchFolder $SearchFolder -OutputFolder $OutputFolder
}
catch {
    Write-Error "Error during copy operation: $($_.Exception.Message)"
    exit 1
}
