param(
    [Parameter(Mandatory=$true)]
    [string]$ProgramName,
    
    [Parameter(Mandatory=$true)]
    [string]$SubProgramName
)

# Load shared functions
$SharedFunctionsPath = Join-Path (Split-Path $PSScriptRoot -Parent) "scripts\Common-Functions.ps1"
if (Test-Path $SharedFunctionsPath) {
    . $SharedFunctionsPath
}

# Auto-detect root folder from git repository
$RootPath = Find-GitRoot

function Generate-BatchDto {
    param(
        [string]$ProgramName,
        [string]$SubProgramName,
        [string]$RootPath
    )
    
    # Generate the batch DTO content
    $namespace = "${ProgramName}Common.DTOs"
    $className = "${SubProgramName}R_SaveBatchParameterDTO"
    
    $classContent = @"
using System;
using System.Collections.Generic;

namespace $namespace
{
    public class $className
    {
        public string CCOMPANY_ID { get; set; } = string.Empty;
        public string CUSER_ID { get; set; } = string.Empty;
        public ${SubProgramName}R_SaveBatchUserParameterDTO UserParameters { get; set; } = new ${SubProgramName}R_SaveBatchUserParameterDTO();
        //public List<{${SubProgramName}BatchListDisplayDTO}>? Data { get; set; }
    }
}
"@
    
    # Set output path
    $outputPath = Join-Path $RootPath "partials\$ProgramName\$SubProgramName\common\dto\${className}.cs"
    
    # Create directory if it doesn't exist
    $outputDir = Split-Path $outputPath -Parent
    if ($outputDir -and -not (Test-Path $outputDir)) {
        New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
    }
    
    # Save the file
    $classContent | Set-Content -Path $outputPath -Encoding UTF8
    
    Write-Host "Generated batch DTO: $outputPath" -ForegroundColor Green
    
    return $outputPath
}

# Main execution
try {
    Write-Host "Generating batch DTO for $SubProgramName..." -ForegroundColor Cyan
    Write-Host "================================" -ForegroundColor Cyan
    
    $outputFile = Generate-BatchDto -ProgramName $ProgramName -SubProgramName $SubProgramName -RootPath $RootPath
    
    Write-Host ""
    Write-Host "Batch DTO generation completed!" -ForegroundColor Green
}
catch {
    Write-Host "Error generating batch DTO: $_" -ForegroundColor Red
}
