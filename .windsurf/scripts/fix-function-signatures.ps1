# Fix Function Signatures Script
# Updates function signatures to use async/Task and synchronizes functions.txt

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

Write-Host "Starting function signature fixing for Program: $ProgramName"
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
    
    # Read functions.txt to get current signatures
    $functionsTxtPath = "$($subProgramDir.FullName)\functions.txt"
    $functionsContent = Get-Content -Path $functionsTxtPath -Raw
    $functionLines = $functionsContent -split "`r`n|`r|`n"
    
    # Find all function .cs files (excluding ClassDeclaration.txt)
    $functionFiles = Get-ChildItem -Path $subProgramDir.FullName -Filter "*.cs" -File | 
    Where-Object { $_.Name -ne "ClassDeclaration.txt" -and $_.Name -match "^\d{4}_" }
    
    Write-Host "  Found $($functionFiles.Count) function files"
    
    # Dictionary to store updated signatures
    $updatedSignatures = @{}
    
    foreach ($functionFile in $functionFiles) {
        $filePath = $functionFile.FullName
        Write-Host "    Found file: $($functionFile.Name)" -ForegroundColor Magenta
        
        try {
            $content = Get-Content -Path $filePath -Raw
            $originalContent = $content
            
            # Extract current function signature by looping through lines
            $lines = $content -split "`r`n|`r|`n"
            $foundSignature = $false
            
            foreach ($line in $lines) {
                if ($line -match '\s*(public|private|protected|internal|static|virtual|abstract|sealed)\s+(override\s+)?(static\s+)?(virtual\s+)?(abstract\s+)?(sealed\s+)?((?:async\s+)?)([^\s{}]+(?:<[^>]+>)?)\s+(\w+)\s*\([^)]*\)') {
                    $accessModifier = $matches[1]
                    $override = $matches[2]
                    $static = $matches[3]
                    $virtual = $matches[4]
                    $abstract = $matches[5]
                    $sealed = $matches[6]
                    $currentAsync = $matches[7].Trim()
                    $returnType = $matches[8]
                    $functionName = $matches[9]
                    # Extract the full signature including parameters by finding the end of the parameters
                    $paramEndIndex = $line.IndexOf(')') + 1
                    $fullSignature = $line.Substring(0, $paramEndIndex)
                    
                    Write-Host "    Processing: $functionName"
                    Write-Host "      Found signature: $fullSignature" -ForegroundColor Yellow
                    $foundSignature = $true
                    break
                }
            }
            
            if (-not $foundSignature) {
                Write-Host "      No signature match found in file" -ForegroundColor Red
                Write-Host "      Content preview: $($content.Substring(0, [Math]::Min(200, $content.Length)))..." -ForegroundColor Red
                continue
            }
            
            # Skip if already async
            if ($currentAsync -eq "async") {
                Write-Host "      Already async, skipping: $functionName" -ForegroundColor Cyan
                # Store current signature for functions.txt
                $updatedSignatures[$functionName] = $fullSignature
                continue
            }
            
            # Build new signature
            $newReturnType = $returnType
            $newAsync = "async "
            
            # Handle return type conversion
            if ($returnType -eq "void") {
                $newReturnType = "Task"
            }
            elseif ($returnType -notmatch "^Task") {
                if ($returnType -match "<") {
                    # Already has generic type, wrap with Task
                    $newReturnType = "Task<$returnType>"
                }
                else {
                    $newReturnType = "Task<$returnType>"
                }
            }
            
            # Remove #region and #endregion outside function
            $content = $content -replace '(?s)^#region.*?$(?=\r?\n(?:public|private|protected))', ''
            $content = $content -replace '(?s)^#endregion.*?$(?=\r?\n(?:public|private|protected))', ''
            
            # Extract parameters from original signature
            $parameters = ""
            if ($fullSignature -match '\(([^)]*)\)') {
                $parameters = $matches[0]  # This captures the entire parameter list including parentheses
            }
            
            # Update function signature with all keywords preserved
            $otherModifiers = ""
            if ($static) { $otherModifiers += $static.Trim() + " " }
            if ($virtual) { $otherModifiers += $virtual.Trim() + " " }
            if ($abstract) { $otherModifiers += $abstract.Trim() + " " }
            if ($sealed) { $otherModifiers += $sealed.Trim() + " " }
            $overrideModifier = if ($override) { $override.Trim() + " " } else { "" }
            $newSignature = "$accessModifier $otherModifiers$overrideModifier$newAsync$newReturnType $functionName$parameters"
            $content = $content -replace [regex]::Escape($fullSignature), $newSignature
            
            # Store updated signature for functions.txt
            $updatedSignatures[$functionName] = $newSignature
            
            # Write updated file if changed
            if ($content -ne $originalContent) {
                Set-Content -Path $filePath -Value $content -NoNewline
                Write-Host "      Updated signature: $functionName" -ForegroundColor Green
            }
            else {
                Write-Host "      No changes needed for: $functionName"
            }
        }
        catch {
            Write-Error "Error processing $($functionFile.FullName): $($_.Exception.Message)"
        }
    }
    
    # Update functions.txt with new signatures
    Write-Host "  Updating functions.txt with new signatures"
    $updatedLines = @()
    
    foreach ($line in $functionLines) {
        if ($line.Trim() -eq "" -or $line.StartsWith("#")) {
            # Keep empty lines and comments as-is
            $updatedLines += $line
        }
        else {
            # This is a function line, try to update signature
            $functionSignature = $line.Trim()
            Write-Host "    Processing line: '$functionSignature'" -ForegroundColor Magenta
            # Extract function name from signature
            if ($functionSignature -match '(public|private|protected)\s+(?:override\s+)?(?:async\s+)?[^\s]+\s+(?:\w+(?:<[^>]+>)?\s+)?(\w+)\s*(?:\([^)]*\))?\s*(?://CATEGORY:.*)?$') {
                $functionName = $matches[2]
                Write-Host "    Extracted function name: '$functionName'" -ForegroundColor Green
                
                if ($updatedSignatures.ContainsKey($functionName)) {
                    $newSignature = $updatedSignatures[$functionName]
                    # Check if signature actually needs updating
                    $cleanCurrentSignature = $functionSignature -replace '\s*//CATEGORY:.*$', ''
                    Write-Host "      Comparing:" -ForegroundColor Cyan
                    Write-Host "        Current in functions.txt: '$cleanCurrentSignature'" -ForegroundColor Cyan
                    Write-Host "        From .cs file: '$newSignature'" -ForegroundColor Cyan
                    if ($cleanCurrentSignature.Trim() -ne $newSignature.Trim()) {
                        # Preserve existing category if it exists
                        if ($functionSignature -match '//CATEGORY:') {
                            if ($functionSignature -match '//CATEGORY:\s*(.+)$') {
                                $category = $matches[1]
                                $updatedLines += "$newSignature //CATEGORY: $category"
                            }
                            else {
                                $updatedLines += $newSignature
                            }
                        }
                        else {
                            $updatedLines += $newSignature
                        }
                        Write-Host "    Updated signature in functions.txt: $functionName" -ForegroundColor Green
                    }
                    else {
                        # No change needed, keep original line
                        $updatedLines += $line
                        Write-Host "    Signature already matches: $functionName" -ForegroundColor Cyan
                    }
                }
                else {
                    # Function not found in processed files, keep as-is
                    $updatedLines += $line
                    Write-Host "    No updated signature found for: $functionName" -ForegroundColor Yellow
                }
            }
            else {
                # Regex failed to extract function name
                Write-Host "    Failed to extract function name from: '$functionSignature'" -ForegroundColor Red
                $updatedLines += $line
            }
        }
    }
    
    # Write updated functions.txt
    $updatedContent = $updatedLines -join "`r`n"
    Set-Content -Path $functionsTxtPath -Value $updatedContent -NoNewline
    Write-Host "  Updated functions.txt" -ForegroundColor Green
}

Write-Host "Function signature fixing process completed for Program: $ProgramName"
