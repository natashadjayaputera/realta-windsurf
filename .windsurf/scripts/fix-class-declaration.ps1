# Fix ClassDeclaration Script
# Fixes ClassDeclaration.txt files to follow new .NET 6 async standard

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

Write-Host "Starting ClassDeclaration fixing for Program: $ProgramName"
Write-Host "Searching in: $ChunksCsPath"

# Find all ClassDeclaration.txt files in subdirectories
$classDeclarationFiles = Get-ChildItem -Path $ChunksCsPath -Recurse -Filter "ClassDeclaration.txt" -File

if ($classDeclarationFiles.Count -eq 0) {
    Write-Warning "No ClassDeclaration.txt files found for Program: $ProgramName"
    exit 0
}

Write-Host "Found $($classDeclarationFiles.Count) ClassDeclaration.txt files"

foreach ($file in $classDeclarationFiles) {
    $filePath = $file.FullName
    $subProgramName = $file.Directory.Name
    
    Write-Host "Processing: $subProgramName\$($file.Name)"
    
    try {
        $content = Get-Content -Path $filePath -Raw
        $originalContent = $content
        
        # 1. Remove namespace if present
        $content = $content -replace 'namespace\s+.*?\{', ''
        $content = $content -replace '\}', ''
        
        # 2. Replace R_BusinessObject<T> with R_BusinessObjectAsync<T> if present
        $content = $content -replace 'R_BusinessObject<([^>]+)>', 'R_BusinessObjectAsync<$1>'
        
        # 3. Replace R_IBatchProcess with R_IBatchProcessAsync if present
        $content = $content -replace 'R_IBatchProcess(?!Async)', 'R_IBatchProcessAsync'
        
        # 4. Remove curly braces
        $content = $content -replace '\{', ''
        $content = $content -replace '\}', ''
        
        # 5. Clean up extra whitespace and newlines
        $content = $content -replace '\s*\n\s*\n', "`n`n"
        $content = $content.Trim()
        
        # Only write file if content changed
        if ($content -ne $originalContent) {
            Set-Content -Path $filePath -Value $content -NoNewline
            Write-Host "  Updated: $subProgramName\ClassDeclaration.txt" -ForegroundColor Green
        }
        else {
            Write-Host "  No changes needed: $subProgramName\ClassDeclaration.txt"
        }
    }
    catch {
        Write-Error "Error processing $($file.FullName): $($_.Exception.Message)"
    }
}

Write-Host "ClassDeclaration fixing process completed for Program: $ProgramName"
