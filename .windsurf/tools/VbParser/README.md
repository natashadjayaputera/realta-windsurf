# VB.NET Parser

A tool to parse VB.NET class files and extract individual functions/methods into separate chunk files.

## Usage

```bash
dotnet run --project .windsurf\tools\VbParser\VbParser.csproj -- "FAB00200" "Path-To-NET4-Cls\ClsFile.vb"
```

## Parameters

- `ProgramName`: The name of the program/module (e.g., "FAB00200")
- `file.vb`: Path to the VB.NET class file to parse

## What it does

- Parses VB.NET class files using Roslyn syntax analysis
- Extracts individual functions, subs, and constructors
- Creates separate chunk files for each method
- Generates a class signature file
- Creates a functions manifest file

## Output Structure

The tool creates the following structure in `chunks_vb`:
```
chunks_vb/
├── ProgramName/
│   └── ClassName/
│       ├── ClassDeclaration.txt      # Class signature only
│       ├── 0001_FunctionName.vb      # Individual functions
│       ├── 0002_OtherFunction.vb
│       └── functions.txt             # List of all function signatures
```

## Files Generated

- **ClassDeclaration.txt**: Contains only the class declaration (inherits, implements)
- **Function chunks**: Numbered files (0001_, 0002_, etc.) containing individual methods
- **functions.txt**: Manifest file with all function signatures

## Extracted Elements

- Subs and functions
- Constructors (Sub New)
- Class signatures with inheritance and implementation details

## Example output

```
Class: FAB00200CLS
Created 15 VB chunks.
Output: chunks_vb\FAB00200\FAB00200CLS
Signatures: chunks_vb\FAB00200\FAB00200CLS\functions.txt
```

## Requirements

- VB.NET class file with valid syntax
- Microsoft.CodeAnalysis.VisualBasic package (included in project)
