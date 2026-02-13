param(
    [Parameter(Mandatory=$true)]
    [string]$StoredProcedureName,
    
    [Parameter(Mandatory=$true)]
    [string]$ConnectionString,
    
    [Parameter(Mandatory=$false)]
    [string]$OutputPath = ""
)

function Extract-StoredProcedure-Parameter {
    param(
        [string]$ProcName,
        [string]$ConnString,
        [string]$OutPath
    )
    
    try {
        Write-Host "Extracting stored procedure parameters..."
        Write-Host "Stored Procedure: $ProcName"
        
        # Validate connection string format
        $safeConnString = $connString -replace '(Password=)[^;]+', '$1***'
        if ($connString -match '\\\\') {
            Write-Host ''
            Write-Host 'ERROR: Connection string contains double backslash (\\\\).' -ForegroundColor Red
            Write-Host 'This will cause SQL Server connection issues.' -ForegroundColor Red
            Write-Host ''
            Write-Host 'Expected format: server=hostname\SQLVersion' -ForegroundColor Yellow
            Write-Host "Found format: $safeConnString" -ForegroundColor Yellow
            Write-Host ''
            Write-Host 'Please fix the connection string in to-server.txt and try again.' -ForegroundColor Cyan
            exit 1
        } elseif ($connString -match '/') {
            Write-Host ''
            Write-Host 'ERROR: Connection string contains forward slash (/).' -ForegroundColor Red
            Write-Host 'SQL Server requires backslash (\) for named instances.' -ForegroundColor Red
            Write-Host ''
            Write-Host 'Expected format: server=hostname\SQLVersion' -ForegroundColor Yellow
            Write-Host "Found format: $safeConnString" -ForegroundColor Yellow
            Write-Host ''
            Write-Host 'Please fix the connection string in to-server.txt and try again.' -ForegroundColor Cyan
            exit 1
        } 
        
        # Hide password in connection string display
        $safeConnString = $ConnString -replace '(Password=)[^;]+', '$1***'
        Write-Host "Connection String: $safeConnString"
        Write-Host ""
        
        # Parse connection string
        $parts = $ConnString.Split(';')
        $server = ""
        $database = ""
        $user = ""
        $password = ""
        
        foreach ($part in $parts) {
            if ($part.StartsWith("server=")) {
                $server = $part.Substring(7)
            }
            elseif ($part.StartsWith("Initial Catalog=")) {
                $database = $part.Substring(16)
            }
            elseif ($part.StartsWith("User ID=")) {
                $user = $part.Substring(8)
            }
            elseif ($part.StartsWith("Password=")) {
                $password = $part.Substring(9)
            }
        }
        
        # Create SQL query
        $sqlQuery = @"
SELECT 
    p.parameter_name AS [Parameter Name],
    p.data_type AS [Data Type],
    CASE 
        WHEN p.character_maximum_length IS NOT NULL THEN CAST(p.character_maximum_length AS VARCHAR(10))
        WHEN p.numeric_precision IS NOT NULL AND p.numeric_scale IS NOT NULL THEN CAST(p.numeric_precision AS VARCHAR(10)) + ',' + CAST(p.numeric_scale AS VARCHAR(10))
        WHEN p.numeric_precision IS NOT NULL THEN CAST(p.numeric_precision AS VARCHAR(10))
        ELSE NULL
    END AS [Length],
    'NOT NULL' AS [Nullability]
FROM 
    information_schema.parameters p
WHERE 
    p.specific_schema = 'dbo'
    AND p.specific_name = '$ProcName'
ORDER BY 
    p.ordinal_position;
"@
        
        # Create temporary SQL file
        $tempSqlFile = Join-Path $env:TEMP "ExtractSPParams_$(Get-Random).sql"
        $sqlQuery | Out-File -FilePath $tempSqlFile -Encoding UTF8
        
        # Execute sqlcmd and capture output
        $sqlcmdArgs = @(
            "-S", $server,
            "-d", $database,
            "-U", $user,
            "-P", $password,
            "-i", $tempSqlFile,
            "-s", ",",
            "-W",
            "-h", "-1"
        )
        
        $results = & sqlcmd @sqlcmdArgs 2>$null
        $parameters = $results | Where-Object { $_.Trim() -ne "" -and $_ -notmatch "^----" -and $_ -notmatch "\(.*rows affected\)" }
        
        # Remove @ prefix from parameter names
        $parameters = $parameters | ForEach-Object {
            if ($_ -match '^@') {
                return $_.Substring(1)  # Remove the @ prefix
            }
            return $_
        }
        
        # Clean up temp file
        if (Test-Path $tempSqlFile) {
            Remove-Item $tempSqlFile
        }
        
        if ($parameters.Count -gt 0) {
            Write-Host "Found $($parameters.Count) parameters"
            
            # Save to file if output path specified
            if ($OutPath -ne "") {
                # Create directory if it doesn't exist
                $outputDir = Split-Path $OutPath -Parent
                if ($outputDir -and -not (Test-Path $outputDir)) {
                    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
                }
                
                # Save as CSV
                $header = "Parameter Name,Data Type,Length,Nullability"
                $header, $parameters | Set-Content -Path $OutPath -Encoding UTF8
            } else {
                # Display CSV to console if no output file specified
                $header = "Parameter Name,Data Type,Length,Nullability"
                $header
                $parameters
            }
            
            return $parameters
        } else {
            Write-Warning "No parameters found for stored procedure '$ProcName'"
            Write-Host "Please verify:"
            Write-Host "1. The stored procedure exists"
            Write-Host "2. The stored procedure is in the dbo schema"
            Write-Host "3. The connection string is correct"
            return @()
        }
    }
    catch {
        Write-Error "Error extracting parameters: $($_.Exception.Message)"
        Write-Host "Please ensure sqlcmd is installed and accessible in your PATH"
        return @()
    }
}

# Execute the function
$result = Extract-StoredProcedure-Parameter -ProcName $StoredProcedureName -ConnString $ConnectionString -OutPath $OutputPath

# Show full path at the very end if file was saved
if ($OutputPath -ne "" -and $result.Count -gt 0) {
    $fullPath = Resolve-Path $OutputPath
    Write-Host "Parameters saved to: $fullPath"
    Write-Host ""
}