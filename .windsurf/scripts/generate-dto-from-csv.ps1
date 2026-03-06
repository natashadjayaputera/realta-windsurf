param(
    [Parameter(Mandatory=$true)]
    [string]$ProgramName,
    
    [Parameter(Mandatory=$true)]
    [string]$SubProgramNames
)

# Load shared functions
$SharedFunctionsPath = Join-Path (Split-Path $PSScriptRoot -Parent) "scripts\Common-Functions.ps1"
if (Test-Path $SharedFunctionsPath) {
    . $SharedFunctionsPath
}

# Main execution - generate both parameter and result DTOs
try {
    # Aggregate Entity DTOs for business-object-overridden-function
    Write-Host "Aggregating Entity DTOs..." -ForegroundColor Cyan
    $aggregateScriptPath = Join-Path $PSScriptRoot "aggregate-entity-dto.ps1"
    if (Test-Path $aggregateScriptPath) {
        & $aggregateScriptPath -ProgramName $ProgramName -SubProgramNames $SubProgramNames -Category "business-object-overridden-function"
    } else {
        Write-Warning "Aggregate script not found at $aggregateScriptPath"
    }

    # Generate Parameter DTOs
    Write-Host "Generating Parameter DTOs..." -ForegroundColor Cyan
    Invoke-DtoGeneration -ProgramName $ProgramName -SubProgramNames $SubProgramNames -Category "business-object-overridden-function" -DtoType "Parameter"
    Invoke-DtoGeneration -ProgramName $ProgramName -SubProgramNames $SubProgramNames -Category "other-function" -DtoType "Parameter"
    Invoke-DtoGeneration -ProgramName $ProgramName -SubProgramNames $SubProgramNames -Category "batch-function" -DtoType "Parameter"
    Write-Host "Parameter DTO generation completed!" -ForegroundColor Green
    
    Write-Host ""
    
    # Generate Result DTOs
    Write-Host "Generating Result DTOs..." -ForegroundColor Cyan
    Invoke-DtoGeneration -ProgramName $ProgramName -SubProgramNames $SubProgramNames -Category "other-function" -DtoType "Result"
    Write-Host "Result DTO generation completed!" -ForegroundColor Green
    
    Write-Host ""
    Write-Host "All DTO generation completed!" -ForegroundColor Green
}
catch {
    Write-Host "Error generating DTOs: $_" -ForegroundColor Red
}

