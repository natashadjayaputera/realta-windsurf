param(
    [Parameter(Mandatory=$true)]
    [string]$StoredProcedureName,
    
    [Parameter(Mandatory=$true)]
    [string]$ConnectionString,
    
    [Parameter(Mandatory=$false)]
    [string]$OutputPath = ""
)

function Extract-StoredProcedure-Result {
    param(
        [string]$ProcName,
        [string]$ConnString,
        [string]$OutPath
    )
    
    try {
        Write-Host "Extracting stored procedure result columns..."
        Write-Host "Stored Procedure: $ProcName"

        # Validate connection string format
        $safeConnString = $ConnString -replace '(Password=)[^;]+', '$1***'
        if ($ConnString -match '\\\\') {
            Write-Host ''
            Write-Host 'ERROR: Connection string contains double backslash (\\\\).' -ForegroundColor Red
            Write-Host 'This will cause SQL Server connection issues.' -ForegroundColor Red
            Write-Host ''
            Write-Host 'Expected format: server=hostname\SQLVersion' -ForegroundColor Yellow
            Write-Host "Found format: $safeConnString" -ForegroundColor Yellow
            Write-Host ''
            Write-Host 'Please fix the connection string in to-server.txt and try again.' -ForegroundColor Cyan
            exit 1
        } elseif ($ConnString -match '/') {
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

        Add-Type -AssemblyName "System.Data"

        $connection = New-Object System.Data.SqlClient.SqlConnection $ConnString
        $connection.Open()

        $command = $connection.CreateCommand()
        $command.CommandText = $ProcName
        $command.CommandType = [System.Data.CommandType]::StoredProcedure

        # Auto-detect parameters
        [System.Data.SqlClient.SqlCommandBuilder]::DeriveParameters($command)

        # Assign default values based on SQL type
        foreach ($param in $command.Parameters) {

            if ($param.Direction -ne [System.Data.ParameterDirection]::Input -and
                $param.Direction -ne [System.Data.ParameterDirection]::InputOutput) {
                continue
            }

            switch ($param.SqlDbType) {

                # String types
                "VarChar" { $param.Value = "" }
                "NVarChar" { $param.Value = "" }
                "Char" { $param.Value = "" }
                "NChar" { $param.Value = "" }
                "Text" { $param.Value = "" }
                "NText" { $param.Value = "" }

                # Numeric types
                "Int" { $param.Value = 0 }
                "BigInt" { $param.Value = 0 }
                "SmallInt" { $param.Value = 0 }
                "TinyInt" { $param.Value = 0 }
                "Decimal" { $param.Value = 0 }
                "Numeric" { $param.Value = 0 }
                "Float" { $param.Value = 0 }
                "Real" { $param.Value = 0 }
                "Money" { $param.Value = 0 }
                "SmallMoney" { $param.Value = 0 }

                # Bit
                "Bit" { $param.Value = 0 }

                # Date/time types
                "Date" { $param.Value = [DBNull]::Value }
                "DateTime" { $param.Value = [DBNull]::Value }
                "DateTime2" { $param.Value = [DBNull]::Value }
                "SmallDateTime" { $param.Value = [DBNull]::Value }
                "Time" { $param.Value = [DBNull]::Value }

                # Default fallback
                default { $param.Value = [DBNull]::Value }
            }
        }

        # Execute without retrieving data - only get first result set
        $reader = $command.ExecuteReader(
            [System.Data.CommandBehavior]::SchemaOnly -bor
            [System.Data.CommandBehavior]::KeyInfo -bor
            [System.Data.CommandBehavior]::SingleResult
        )

        $schemaTable = $reader.GetSchemaTable()
        $validColumns = @()
        $seenColumns = @{} # Track seen column names to avoid duplicates

        if ($schemaTable -ne $null -and $schemaTable.Rows.Count -gt 0) {

            foreach ($row in $schemaTable.Rows) {

                $columnName = $row["ColumnName"]
                $dotNetType = $row["DataType"].Name
                $allowNull = if ($row["AllowDBNull"]) { "NULL" } else { "NOT NULL" }

                # Skip duplicate column names
                if ($seenColumns.ContainsKey($columnName)) {
                    continue
                }
                $seenColumns[$columnName] = $true

                # Map .NET types back to SQL types
                $sqlType = switch ($dotNetType) {
                    "String" { "varchar" }
                    "Int32" { "int" }
                    "Int64" { "bigint" }
                    "Int16" { "smallint" }
                    "Byte" { "tinyint" }
                    "Boolean" { "bit" }
                    "Decimal" { "decimal" }
                    "Double" { "float" }
                    "Single" { "real" }
                    "DateTime" { "datetime" }
                    "TimeSpan" { "time" }
                    "Guid" { "uniqueidentifier" }
                    "Byte[]" { "varbinary" }
                    "Object" { "sql_variant" }
                    default { 
                        # Handle specific .NET types that might not be covered above
                        switch ($dotNetType) {
                            "SqlString" { "nvarchar" }
                            "SqlInt32" { "int" }
                            "SqlInt64" { "bigint" }
                            "SqlInt16" { "smallint" }
                            "SqlByte" { "tinyint" }
                            "SqlBoolean" { "bit" }
                            "SqlDecimal" { "decimal" }
                            "SqlDouble" { "float" }
                            "SqlSingle" { "real" }
                            "SqlDateTime" { "datetime" }
                            "SqlGuid" { "uniqueidentifier" }
                            "SqlBinary" { "varbinary" }
                            "SqlMoney" { "money" }
                            "SqlXml" { "xml" }
                            default { "sql_variant" } # Default fallback for unknown types
                        }
                    }
                }

                $length = ""
                if ($row["ColumnSize"]) {
                    $length = $row["ColumnSize"]
                }

                if ($columnName -and $columnName -ne "") {
                    $validColumns += "$columnName,$sqlType,$length,$allowNull"
                }
            }

            Write-Host "Found $($validColumns.Count) result columns"
        }
        else {
            Write-Host "No result set found for stored procedure '$ProcName'" -ForegroundColor Yellow
        }

        $reader.Close()
        $connection.Close()

        # Output handling
        if ($validColumns.Count -gt 0) {

            if ($OutPath -ne "") {

                $outputDir = Split-Path $OutPath -Parent
                if ($outputDir -and -not (Test-Path $outputDir)) {
                    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
                }

                $header = "Column Name,Data Type,Length,Nullability"
                $header, $validColumns | Set-Content -Path $OutPath -Encoding UTF8
            }
            else {
                $header = "Column Name,Data Type,Length,Nullability"
                Write-Output $header
                Write-Output $validColumns
            }
        }
        else {
            if ($OutPath -ne "") {
                Set-Content -Path $OutPath -Value "" -Encoding UTF8
                Write-Host "Empty file created: $OutPath"
            }
        }

        return $validColumns
    }
    catch {
        # Create empty file if output path specified
        if ($OutPath -ne "") {
            # Create directory if it doesn't exist
            $outputDir = Split-Path $OutPath -Parent
            if ($outputDir -and -not (Test-Path $outputDir)) {
                New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
            }
            
            # Create empty file
            Set-Content -Path $OutPath -Value "" -Encoding UTF8
        }
        return @()
    }
}

# Execute
$result = Extract-StoredProcedure-Result `
    -ProcName $StoredProcedureName `
    -ConnString $ConnectionString `
    -OutPath $OutputPath

# Show full path at the very end if file was saved
if ($OutputPath -ne "" -and $result.Count -gt 0) {
    $fullPath = Resolve-Path $OutputPath
    Write-Host "Results saved to: $fullPath"
    Write-Host ""
}
