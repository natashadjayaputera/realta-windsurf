param(
    [Parameter(Mandatory=$true)]
    [string]$ProgramName,
    
    [Parameter(Mandatory=$true)]
    [string]$SubProgramNames,
    
    [Parameter(Mandatory=$false)]
    [string]$Category = "business-object-overridden-function"
)

# Load shared functions
$SharedFunctionsPath = Join-Path (Split-Path $PSScriptRoot -Parent) "scripts\Common-Functions.ps1"
if (Test-Path $SharedFunctionsPath) {
    . $SharedFunctionsPath
}

# Auto-detect root folder from git repository
$RootPath = Find-GitRoot

# Split comma-separated names
$subPrograms = $SubProgramNames -split ',' | ForEach-Object { $_.Trim() }

function Aggregate-EntityDto {
    param(
        [string]$ProgramName,
        [string]$SubProgramName,
        [string]$Category,
        [string]$RootPath
    )
    
    # Set paths
    $programFolder = Join-Path $RootPath "partials\$ProgramName\$SubProgramName"
    $paramsFolder = Join-Path $programFolder "stored-procedure\parameters\$Category"
    $resultsFolder = Join-Path $programFolder "stored-procedure\results\$Category"
    
    # Single output file in parameters folder
    $outputFile = Join-Path $paramsFolder "Entity.csv"
    $allEntries = @()
    $seenEntries = @{} # Track duplicates by name
    
    Write-Host "Aggregating parameters and results for $SubProgramName..." -ForegroundColor Cyan
    
    # Aggregate parameters
    Write-Host "Processing parameters..." -ForegroundColor Yellow
    if (Test-Path $paramsFolder) {
        $paramFiles = Get-ChildItem -Path $paramsFolder -Filter "*.csv" -File | Where-Object { $_.Name -ne "Entity.csv" }
        
        foreach ($paramFile in $paramFiles) {
            Write-Host "Processing parameter file: $($paramFile.Name)" -ForegroundColor Gray
            
            # Read CSV content
            $csvContent = Get-Content $paramFile.FullName
            
            # Skip header and empty lines
            for ($i = 1; $i -lt $csvContent.Count; $i++) {
                $line = $csvContent[$i].Trim()
                if ([string]::IsNullOrWhiteSpace($line)) { continue }
                
                # Parse parameter line
                $parts = $line -split ','
                if ($parts.Count -ge 4) {
                    $paramName = $parts[0].Trim()
                    
                    # Skip duplicates
                    if ($seenEntries.ContainsKey($paramName)) {
                        continue
                    }
                    $seenEntries[$paramName] = $true
                    
                    $allEntries += $line
                }
            }
        }
    }
    
    # Aggregate results
    Write-Host "Processing results..." -ForegroundColor Yellow
    if (Test-Path $resultsFolder) {
        $resultFiles = Get-ChildItem -Path $resultsFolder -Filter "*.csv" -File | Where-Object { $_.Name -ne "Entity.csv" }
        
        foreach ($resultFile in $resultFiles) {
            Write-Host "Processing result file: $($resultFile.Name)" -ForegroundColor Gray
            
            # Read CSV content
            $csvContent = Get-Content $resultFile.FullName
            
            # Skip header and empty lines
            for ($i = 1; $i -lt $csvContent.Count; $i++) {
                $line = $csvContent[$i].Trim()
                if ([string]::IsNullOrWhiteSpace($line)) { continue }
                
                # Parse result line
                $parts = $line -split ','
                if ($parts.Count -ge 4) {
                    $columnName = $parts[0].Trim()
                    
                    # Skip duplicates
                    if ($seenEntries.ContainsKey($columnName)) {
                        continue
                    }
                    $seenEntries[$columnName] = $true
                    
                    $allEntries += $line
                }
            }
        }
    }
    
    # Write aggregated data to single Entity.csv file in parameters folder
    if ($allEntries.Count -gt 0) {
        $header = "Name,Data Type,Length,Nullability"
        $header, $allEntries | Set-Content -Path $outputFile -Encoding UTF8
        Write-Host "Generated aggregated Entity file: $outputFile" -ForegroundColor Green
        Write-Host "Total entries: $($allEntries.Count)" -ForegroundColor Green
    } else {
        Write-Host "No data found for aggregation in $SubProgramName" -ForegroundColor Yellow
    }
    
    # Clean up individual files after successful aggregation
    if ($allEntries.Count -gt 0) {
        Write-Host "Cleaning up individual files..." -ForegroundColor Yellow
        
        # Delete individual parameter files except Entity.csv
        if (Test-Path $paramsFolder) {
            $paramFilesToDelete = Get-ChildItem -Path $paramsFolder -Filter "*.csv" -File | Where-Object { $_.Name -ne "Entity.csv" }
            foreach ($file in $paramFilesToDelete) {
                Remove-Item $file.FullName -Force
                Write-Host "Deleted: $paramsFolder\$($file.Name)" -ForegroundColor Gray
            }
        }
        
        # Delete all result files (since Entity.csv is in params folder)
        if (Test-Path $resultsFolder) {
            $resultFilesToDelete = Get-ChildItem -Path $resultsFolder -Filter "*.csv" -File
            foreach ($file in $resultFilesToDelete) {
                Remove-Item $file.FullName -Force
                Write-Host "Deleted: $resultsFolder\$($file.Name)" -ForegroundColor Gray
            }
        }
        
        Write-Host "Cleanup completed!" -ForegroundColor Green
    }
}

# Main execution
try {
    foreach ($subProgram in $subPrograms) {
        Write-Host "Processing subprogram: $subProgram" -ForegroundColor Magenta
        Write-Host "================================" -ForegroundColor Magenta
        
        Aggregate-EntityDto -ProgramName $ProgramName -SubProgramName $subProgram -Category $Category -RootPath $RootPath
        
        Write-Host ""
    }
    
    Write-Host "All entity DTO aggregation completed!" -ForegroundColor Green
}
catch {
    Write-Error "Error aggregating entity DTOs: $_" -ForegroundColor Red
}
