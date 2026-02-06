# Categorize Functions Script
# Determines function categories based on back_function_categories rules

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

$ChunksCsPath = "$RootPath\chunks_cs\$ProgramName"

if (-not (Test-Path $ChunksCsPath)) {
    Write-Error "Chunks_cs folder not found for Program: $ProgramName at $ChunksCsPath"
    exit 1
}

Write-Host "Starting function categorization for Program: $ProgramName"
Write-Host "Searching in: $ChunksCsPath"

# Find all subdirectories containing function files
$subProgramDirs = Get-ChildItem -Path $ChunksCsPath -Directory | Where-Object { 
    Test-Path "$($_.FullName)\functions.txt" 
}

if ($subProgramDirs.Count -eq 0) {
    Write-Warning "No subprograms with functions.txt found for Program: $ProgramName"
    exit 0
}

Write-Host "Found $($subProgramDirs.Count) subprograms to process"

foreach ($subProgramDir in $subProgramDirs) {
    $subProgramName = $subProgramDir.Name
    Write-Host "Processing subprogram: $subProgramName"
    
    # Read functions.txt to get function list
    $functionsTxtPath = "$($subProgramDir.FullName)\functions.txt"
    $functionsContent = Get-Content -Path $functionsTxtPath -Raw
    $functionLines = $functionsContent -split "`r`n|`r|`n"
    
    # Create a dictionary to store function categories
    $functionCategories = @{}
    
    # Find all function .cs files (excluding ClassDeclaration.txt)
    $functionFiles = Get-ChildItem -Path $subProgramDir.FullName -Filter "*.cs" -File | 
    Where-Object { $_.Name -ne "ClassDeclaration.txt" -and $_.Name -match "^\d{4}_" }
    
    Write-Host "  Found $($functionFiles.Count) function files"
    
    foreach ($functionFile in $functionFiles) {
        $filePath = $functionFile.FullName
        
        try {
            $content = Get-Content -Path $filePath -Raw
            
            # Extract function signature to determine category
            $functionSignature = ""
            if ($content -match '(public|private|protected)\s+.*?(\w+)\s*\([^)]*\)') {
                $functionSignature = $matches[0]
            }
            
            # Determine category based on back_function_categories rules
            $category = "other-function"  # default
            
            if ($functionSignature -match 'protected\s+override' -and $functionSignature -match 'R_\w+') {
                $category = "business-object-overridden-function"
            }
            elseif ($functionSignature -match 'R_BatchProcess(Async)?\s*\(') {
                $category = "batch-function"
            }
            
            Write-Host "    $($functionFile.Name): $category"
            
            # Add category comment at the top if not already present
            if (-not $content.StartsWith("//CATEGORY:")) {
                $content = "//CATEGORY: $category`n" + $content
                Set-Content -Path $filePath -Value $content -NoNewline
                Write-Host "      Added category comment" -ForegroundColor Green
            }
            else {
                Write-Host "      Category comment already exists"
            }
            
            # Store function name and category for functions.txt update
            if ($functionSignature -match '(public|private|protected)\s+.*?(\w+)\s*\([^)]*\)') {
                $functionName = $matches[2]
                $functionCategories[$functionName] = $category
            }
        }
        catch {
            Write-Error "Error processing $($functionFile.FullName): $($_.Exception.Message)"
        }
    }
    
    # Update functions.txt with categories
    Write-Host "  Updating functions.txt with categories"
    $updatedLines = @()
    
    foreach ($line in $functionLines) {
        if ($line.Trim() -eq "" -or $line.StartsWith("#")) {
            # Keep empty lines and comments as-is
            $updatedLines += $line
        }
        else {
            # This is a function line, try to add category
            $functionSignature = $line.Trim()
            # Extract function name from signature
            if ($functionSignature -match '(public|private|protected)\s+.*?(\w+)\s*\([^)]*\)') {
                $functionName = $matches[2]
                # Check if category already exists
                if ($functionSignature -match '//CATEGORY:') {
                    # Category already exists, keep as-is
                    $updatedLines += $line
                    Write-Host "    Category already exists for: $functionName" -ForegroundColor Cyan
                }
                elseif ($functionCategories.ContainsKey($functionName)) {
                    $category = $functionCategories[$functionName]
                    $updatedLines += "$line //CATEGORY: $category"
                    Write-Host "    Updated: $functionName -> $category" -ForegroundColor Green
                }
                else {
                    # Function not found in processed files, keep as-is
                    $updatedLines += $line
                    Write-Host "    No category found for: $functionName" -ForegroundColor Yellow
                }
            }
            else {
                # Not a valid function signature, keep as-is
                $updatedLines += $line
            }
        }
    }
    
    # Write updated functions.txt
    $updatedContent = $updatedLines -join "`r`n"
    Set-Content -Path $functionsTxtPath -Value $updatedContent -NoNewline
    Write-Host "  Updated functions.txt" -ForegroundColor Green
}

Write-Host "Function categorization process completed for Program: $ProgramName"
