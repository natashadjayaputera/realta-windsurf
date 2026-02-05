# VB.NET Code Reducer

A tool to reduce and optimize VB.NET code by removing unnecessary elements and optionally splitting large files into manageable chunks.

## Usage

```bash
# Process single file
dotnet run --project .windsurf/tools/VbCodeReducer/VbCodeReducer.csproj -- "path/to/file.vb"

# Process single file with splitting
dotnet run --project .windsurf/tools/VbCodeReducer/VbCodeReducer.csproj -- "path/to/file.vb" --split

# Process entire directory
dotnet run --project .windsurf/tools/VbCodeReducer/VbCodeReducer.csproj -- "path/to/folder"

# Process directory with splitting and debug mode
dotnet run --project .windsurf/tools/VbCodeReducer/VbCodeReducer.csproj -- "path/to/folder" --split --debug
```

## Parameters

- `path`: Path to a VB.NET file (.vb) or directory containing VB.NET files
- `--split`: (Optional) Split files into chunks of ~1000 lines each
- `--debug`: (Optional) Create backup files before processing

## What it does

### Code Reduction Process
1. **Removes consecutive empty lines** - Reduces multiple empty lines to single empty line
2. **Removes comments** - Strips out all comment lines from the code
3. **Preserves code structure** - Maintains functional integrity while reducing size

### File Splitting (with `--split`)
- Splits large VB.NET files into chunks of approximately 1000 lines
- Creates files with naming pattern: `OriginalName_01_chunks.vb`, `OriginalName_02_chunks.vb`, etc.
- Preserves line numbering and code structure within each chunk

### Debug Mode (with `--debug`)
- Creates backup files with `.backup` extension before processing
- Useful for testing and recovery if issues occur

## Output

### Without Splitting
- **In-place modification**: Original files are modified directly
- **Reduced file size**: Typically 20-40% size reduction depending on comment density
- **Preserved functionality**: All code logic remains intact

### With Splitting
- **Multiple chunk files**: Large files split into manageable pieces
- **Line range information**: Each chunk shows the line numbers it contains
- **Original file preserved**: Original file remains unchanged when splitting

## Example Output

```
Processing file: C:\project\LargeClass.vb
Original size: 2,847 lines
Reduced size: 1,723 lines (60.5% of original)
Saved: C:\project\LargeClass.vb

Splitting file into chunks of 1000 lines...
  Created: LargeClass_01_chunks.vb (lines 1-1000)
  Created: LargeClass_02_chunks.vb (lines 1001-2000)
  Created: LargeClass_03_chunks.vb (lines 2001-2847)
Total chunks created: 3
```

## Use Cases

### 1. **Code Analysis**
- Reduce file size for faster processing by other tools
- Remove noise (comments) for focused code analysis

### 2. **File Management**
- Split large VB.NET class files into manageable chunks
- Create smaller files for easier code review and editing

### 3. **Pre-processing**
- Prepare code for migration or conversion processes
- Clean up code before automated transformations

## Features

### Code Reduction
- **Smart comment removal**: Only removes actual comment lines, preserves string literals
- **Empty line optimization**: Maintains code readability while reducing whitespace
- **UTF-8 support**: Handles Unicode characters and international text

### File Splitting
- **Configurable chunk size**: Default 1000 lines, easily adjustable
- **Preserved line numbering**: Easy to trace back to original file locations
- **Safe naming**: Clear naming convention for chunk files

### Error Handling
- **Graceful failure**: Continues processing other files if one fails
- **Detailed reporting**: Shows success/failure statistics
- **Backup protection**: Debug mode prevents data loss

## Requirements

- .NET 6.0 SDK or later
- VB.NET files (.vb extension)
- Read/write permissions for target files/directories

## Error Handling

- **File not found**: Clear error message if path doesn't exist
- **Permission errors**: Reports access issues
- **Invalid files**: Skips non-.vb files in directory mode
- **Processing errors**: Continues with other files, reports summary

## Safety Features

- **Backup mode**: `--debug` flag creates `.backup` files
- **Non-destructive splitting**: Original files preserved when splitting
- **Validation**: Checks file existence and permissions before processing
- **Rollback capability**: Can restore from backups if needed

## Integration

This tool is commonly used in the VB.NET to C# conversion workflow:
1. **Pre-processing**: Reduce and clean VB.NET files
2. **Splitting**: Create manageable chunks for parsing
3. **Parsing**: Feed chunks to VbParser for function extraction

## Performance

- **Fast processing**: Handles large files efficiently
- **Memory conscious**: Processes files line by line for large files
- **Batch capable**: Can process entire directories automatically
