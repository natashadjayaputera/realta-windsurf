# VB Code Reducer

A C# console tool to reduce VB.NET code by:
1. Joining string concatenation operators (`" & `) across multiple lines into single lines
2. Removing unnecessary empty lines while preserving logical code structure
3. Removing comment lines (lines starting with `'`)
4. Reducing multiple consecutive empty lines to just one
5. Reducing multiple consecutive spaces to single spaces
6. **NEW**: Splitting reduced files into chunks of 100 lines each

## Features

- **String Concatenation Joining**: Automatically detects and joins multi-line string concatenations
- **Smart Empty Line Removal**: Removes excessive empty lines while preserving logical code blocks
- **Comment Removal**: Removes all comment lines starting with single quotes
- **Empty Line Normalization**: Reduces multiple consecutive empty lines to just one
- **Space Normalization**: Reduces multiple consecutive spaces to single spaces while preserving indentation
- **File Splitting**: Splits reduced files into chunks of 100 lines each for easier processing
- **Backup Creation**: Automatically creates a backup of the original file
- **Statistics**: Shows the number of lines reduced and percentage reduction

## Usage

### Basic Usage
```bash
dotnet run -- "path\to\your\vbfile.vb"
```

### With File Splitting
```bash
dotnet run -- "path\to\your\vbfile.vb" --split
```

## Examples

### String Concatenation Joining
**Before:**
```vb
lcCmd = String.Format(" SELECT TOP 1 1 " &
                      " FROM FAT_TRANS_HD " &
                      " WHERE CCOMPANY_ID = @CCOMPANY_ID " &
                      " AND CDEPT_CODE = @CDEPT_CODE ")
```

**After:**
```vb
lcCmd = String.Format(" SELECT TOP 1 1  FROM FAT_TRANS_HD  WHERE CCOMPANY_ID = @CCOMPANY_ID  AND CDEPT_CODE = @CDEPT_CODE ")
```

### Space Normalization
**Before:**
```vb
loCmd.CommandText = lcCmd
Common.AddParameter(loCmd, "CCOMPANY_ID",  DbType.String,  poNewEntity.CCOMPANY_ID)
```

**After:**
```vb
loCmd.CommandText = lcCmd
Common.AddParameter(loCmd, "CCOMPANY_ID", DbType.String, poNewEntity.CCOMPANY_ID)
```

### File Splitting
When using the `--split` option, the tool creates chunk files:
- `filename_chunk1.vb` (lines 1-100)
- `filename_chunk2.vb` (lines 101-200)
- `filename_chunk3.vb` (lines 201-300)
- And so on...

## Build

```bash
dotnet build
```

## Safety

- Creates a `.backup` file before modifying the original
- Preserves code functionality and indentation
- Maintains valid VB.NET syntax when joining string concatenations
- Only removes comment lines, preserving inline comments within code
- Preserves leading indentation while normalizing spaces in code content
- Creates numbered chunk files when splitting is enabled
