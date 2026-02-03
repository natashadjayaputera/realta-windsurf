# C# Indentation Fixer

A simple tool to fix indentation in C# files for specific programs in the `chunks_cs` directory.

## Usage

```bash
dotnet run --project tools\CsIndentFixer\CsIndentFixer.csproj -- "FAM00100"
```

## Parameters

- `ProgramName`: The name of the program/module to process (e.g., "FAM00100", "FAB00200")

## What it does

- Scans all `*.cs` files in the specified program directory under `chunks_cs`
- Fixes indentation using 4 spaces per indentation level
- Handles common C# constructs:
  - Opening/closing braces `{` and `}`
  - Square brackets `[` and `]`
  - Case statements
- Preserves empty lines
- Only modifies files that actually need fixing
- Shows available programs if the specified program doesn't exist

## Output

The tool will:
- Show which files were fixed
- Report the total number of files fixed
- Report any errors encountered

## Example output

```
Found 23 C# files in FAM00100 to process...
Fixed: chunks_cs\FAM00100\FAM001000201CLS\0002_R_Display.cs
Fixed: chunks_cs\FAM00100\FAM001000201CLS\0003_R_Saving.cs
...
Completed: 20 files fixed, 0 errors
```

## Error handling

If the specified program doesn't exist, the tool will list all available programs in the `chunks_cs` directory.
