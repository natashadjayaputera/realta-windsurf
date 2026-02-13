# Shared PowerShell Functions
# Common functions used across windsurf scripts

function Find-GitRoot {
    <#
    .SYNOPSIS
    Finds the root directory of the git repository by searching for .git folder.
    
    .DESCRIPTION
    This function starts from the current directory and searches up the directory tree
    until it finds a .git folder, which indicates the root of a git repository.
    
    .RETURN
    Returns the full path to the git repository root directory.
    If no git repository is found, returns the current directory.
    #>
    $currentDir = (Get-Location).Path
    
    while ($null -ne $currentDir) {
        $gitPath = Join-Path $currentDir ".git"
        if (Test-Path $gitPath) {
            return $currentDir
        }
        $currentDir = Split-Path $currentDir -Parent
    }
    
    # If no git repository found, return current directory
    return (Get-Location).Path
}

function Get-CSharpType {
    <#
    .SYNOPSIS
    Converts SQL Server data types to C# types with proper nullability support.
    
    .DESCRIPTION
    This function maps SQL Server data types to their corresponding C# types,
    taking into account whether the field is nullable or not.
    
    .PARAMETER SqlDataType
    The SQL Server data type (e.g., "varchar", "int", "bit", "datetime")
    
    .PARAMETER Nullability
    The nullability value ("NULL" for nullable, "NOT NULL" for non-nullable)
    
    .RETURN
    Returns the corresponding C# type as a string.
    #>
    param(
        [string]$SqlDataType,
        [string]$Nullability
    )
    
    $isNullable = $Nullability -eq "NULL"
    
    switch -Wildcard ($SqlDataType.ToLower()) {
        "varchar*" { 
            if ($isNullable) { return "string?" } else { return "string" }
        }
        "char*" { 
            if ($isNullable) { return "string?" } else { return "string" }
        }
        "nchar*" { 
            if ($isNullable) { return "string?" } else { return "string" }
        }
        "nvarchar*" { 
            if ($isNullable) { return "string?" } else { return "string" }
        }
        "text" { 
            if ($isNullable) { return "string?" } else { return "string" }
        }
        "ntext" { 
            if ($isNullable) { return "string?" } else { return "string" }
        }
        "int" { 
            if ($isNullable) { return "int?" } else { return "int" }
        }
        "bigint" { 
            if ($isNullable) { return "int?" } else { return "int" }
        }
        "smallint" { 
            if ($isNullable) { return "int?" } else { return "int" }
        }
        "tinyint" { 
            if ($isNullable) { return "int?" } else { return "int" }
        }
        "bit" { 
            if ($isNullable) { return "bool?" } else { return "bool" }
        }
        "decimal" { 
            if ($isNullable) { return "decimal?" } else { return "decimal" }
        }
        "numeric" { 
            if ($isNullable) { return "decimal?" } else { return "decimal" }
        }
        "float" { 
            if ($isNullable) { return "double?" } else { return "double" }
        }
        "real" { 
            if ($isNullable) { return "float?" } else { return "float" }
        }
        "money" { 
            if ($isNullable) { return "decimal?" } else { return "decimal" }
        }
        "smallmoney" { 
            if ($isNullable) { return "decimal?" } else { return "decimal" }
        }
        "datetime" { 
            return "DateTime?"  # Always nullable
        }
        "datetime2" { 
            return "DateTime?"  # Always nullable
        }
        "smalldatetime" { 
            return "DateTime?"  # Always nullable
        }
        "date" { 
            return "DateTime?"  # Always nullable
        }
        "time" { 
            return "TimeSpan?"  # Always nullable
        }
        "timestamp" { 
            if ($isNullable) { return "byte[]" } else { return "byte[]" }
        }
        "rowversion" { 
            if ($isNullable) { return "byte[]" } else { return "byte[]" }
        }
        "uniqueidentifier" { 
            if ($isNullable) { return "Guid?" } else { return "Guid" }
        }
        "sql_variant" { 
            if ($isNullable) { return "object?" } else { return "object" }
        }
        "xml" { 
            if ($isNullable) { return "string?" } else { return "string" }
        }
        "varbinary*" { 
            if ($isNullable) { return "byte[]" } else { return "byte[]" }
        }
        "binary*" { 
            if ($isNullable) { return "byte[]" } else { return "byte[]" }
        }
        "image" { 
            if ($isNullable) { return "byte[]" } else { return "byte[]" }
        }
        default { 
            if ($isNullable) { return "object?" } else { return "object" }
        }
    }
}

function Get-PropertyDefaultValue {
    <#
    .SYNOPSIS
    Gets the default value for a C# property based on its type and nullability.
    
    .DESCRIPTION
    This function returns appropriate default values for C# properties,
    such as string.Empty for non-nullable strings.
    
    .PARAMETER CSharpType
    The C# type (e.g., "string", "int?", "DateTime")
    
    .RETURN
    Returns the default value as a string, or empty string if no default needed.
    #>
    param(
        [string]$CSharpType
    )
    
    # For non-nullable strings only (no "?"), return string.Empty
    if ($CSharpType -eq "string") {
        return " = string.Empty;"
    }
    
    # For other types, no default value needed
    return ""
}

function Invoke-DtoGeneration {
    <#
    .SYNOPSIS
    Generates DTOs from CSV files for a specific DTO type (Parameter or Result).
    
    .DESCRIPTION
    This function processes CSV files in stored-procedure directories and generates
    corresponding C# DTO classes based on the DTO type specified.
    
    .PARAMETER ProgramName
    The main program name (e.g., "HDM00100")
    
    .PARAMETER SubProgramNames
    Array of subprogram names (e.g., "HDM00100")

    .PARAMETER Category
    The category of DTO to generate ("business-object-overridden-function", "other-function", "batch-function")
    
    .PARAMETER DtoType
    The type of DTO to generate ("Parameter" or "Result")
    
    .PARAMETER RootPath
    The root path of the project (optional, will auto-detect if not provided)
    #>
    param(
        [string]$ProgramName,
        [string]$SubProgramNames,
        [string]$Category,
        [string]$DtoType,
        [string]$RootPath = $null
    )
    
    # Auto-detect root folder if not provided
    if (-not $RootPath) {
        $RootPath = Find-GitRoot
    }
    
    # Split comma-separated names
    $subPrograms = $SubProgramNames -split ',' | ForEach-Object { $_.Trim() }
    
    function Get-PropertyName {
        param([string]$ParameterName)
        
        # Remove @ prefix but keep exact case
        $name = $ParameterName -replace '^@', ''
        
        return $name
    }
    
    function Generate-DtoClass {
        param(
            [string]$CsvPath,
            [string]$ProgramName,
            [string]$SubProgramName,
            [string]$OutputDir,
            [string]$DtoType
        )
        
        if (-not (Test-Path $CsvPath)) {
            Write-Error "CSV file not found: $CsvPath"
            return
        }
        
        # Get stored procedure name from filename
        $spName = [System.IO.Path]::GetFileNameWithoutExtension($CsvPath)
        
        # Read CSV content using simple parsing
        $csvContent = Get-Content $CsvPath
        $parameters = @()
        
        # Skip header and empty lines
        for ($i = 1; $i -lt $csvContent.Count; $i++) {
            $line = $csvContent[$i].Trim()
            if ([string]::IsNullOrWhiteSpace($line)) { continue }
            
            # Simple split by comma and take parts
            $parts = $line -split ','
            if ($parts.Count -ge 4) {
                # Create clear variables for each column
                $parameterName = $parts[0].Trim()
                $dataType = $parts[1].Trim()
                $length = $parts[2].Trim()
                $nullability = $parts[-1].Trim()  # Take last value for nullability
                
                $paramInfo = @{
                    ParameterName = $parameterName
                    DataType = $dataType
                    Nullability = $nullability
                }
                $parameters += $paramInfo
            }
        }
        
        # Generate C# class
        $className = if ($Category -eq "business-object-overridden-function") { "${SubProgramName}DTO" } else { "${SubProgramName}${spName}${DtoType}DTO" } 
        $namespace = "${ProgramName}Common.DTOs"
        
        $classContent = @"
using System;

namespace $namespace
{
    public class $className
    {
"@ + "`n"
        
        foreach ($param in $parameters) {
            $propertyName = Get-PropertyName -ParameterName $param.ParameterName
            $csharpType = Get-CSharpType -SqlDataType $param.DataType -Nullability $param.Nullability
            $defaultValue = Get-PropertyDefaultValue -CSharpType $csharpType
            
            $classContent += "        public $csharpType $propertyName { get; set; }$defaultValue`n"
        }
        
        $classContent += @"
    }
}
"@
        
        # Create output directory if it doesn't exist
        if (-not (Test-Path $OutputDir)) {
            New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
        }
        
        # Write to file
        $outputFile = Join-Path $OutputDir "$className.cs"
        $classContent | Out-File -FilePath $outputFile -Encoding UTF8
        
        Write-Host "Generated: $outputFile"
    }
    
    foreach ($SubProgramName in $subPrograms) {
        # Construct path to subprogram directory
        $subProgramRootPath = Join-Path $RootPath "partials\$ProgramName\$SubProgramName"
        $subProgramPath = Join-Path $subProgramRootPath "stored-procedure\$($DtoType.ToLower())s\$Category"
        
        if (-not (Test-Path $subProgramPath)) {
            Write-Warning "SubProgram directory not found: $subProgramPath"
            continue
        }
        
        # Find all CSV files in the directory
        $csvFiles = Get-ChildItem -Path $subProgramPath -Filter "*.csv" -File
        
        if ($csvFiles.Count -eq 0) {
            Write-Warning "No CSV files found in: $subProgramPath"
            continue
        }
        
        # Create output directory for this subprogram
        $outputDir = Join-Path $subProgramRootPath "common\dto"
        
        foreach ($csvFile in $csvFiles) {
            # Check if file is empty (only header or completely empty)
            $content = Get-Content $csvFile.FullName
            $hasData = $false
            
            for ($i = 1; $i -lt $content.Count; $i++) {
                if ($content[$i].Trim() -ne "" -and $content[$i].Trim() -notmatch "^#") {
                    $hasData = $true
                    break
                }
            }
            
            if (-not $hasData) {
                Write-Host "Skipping empty file: $($csvFile.Name)" -ForegroundColor Yellow
                continue
            }
            
            Write-Host "Processing: $($csvFile.Name)"
            Generate-DtoClass -CsvPath $csvFile.FullName -ProgramName $ProgramName -SubProgramName $SubProgramName -OutputDir $outputDir -DtoType $DtoType
        }
    }
}
