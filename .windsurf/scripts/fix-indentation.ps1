# Indentation Fix Script
# Executes CsIndentFixer for all C# files in a program

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

$CsIndentFixerProject = "$RootPath\.windsurf\tools\CsIndentFixer\CsIndentFixer.csproj"

if (-not (Test-Path $CsIndentFixerProject)) {
    Write-Error "CsIndentFixer project not found at $CsIndentFixerProject"
    exit 1
}

Write-Host "Starting indentation fixing for Program: $ProgramName"
Write-Host "Using CsIndentFixer project: $CsIndentFixerProject"

try {
    $result = & dotnet run --project $CsIndentFixerProject -- $ProgramName

    if ($LASTEXITCODE -eq 0) {
        Write-Host "Indentation fixing completed successfully for $ProgramName" -ForegroundColor Green
    }
    else {
        Write-Warning "Indentation fixing failed for $ProgramName (Exit code: $LASTEXITCODE)"
        Write-Host "Output: $result"
    }
}
catch {
    Write-Error "Error running indentation fix: $($_.Exception.Message)"
}

Write-Host "Indentation fixing process completed"
