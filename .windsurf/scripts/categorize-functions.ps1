# Categorize Functions Script
# Determines function categories based on back_function_categories rules

param(
    [Parameter(Mandatory = $true)]
    [string]$ProgramName,

    [Parameter(Mandatory = $true)]
    [string]$RootPath = (Get-Location).Path
)

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
        }
        catch {
            Write-Error "Error processing $($functionFile.FullName): $($_.Exception.Message)"
        }
    }
}

Write-Host "Function categorization process completed for Program: $ProgramName"
