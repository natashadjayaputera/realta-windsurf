---
name: 03-fix-chunk
description: A tool to fix C# (.NET 6) Chunk files to follow new standard.
---

# Overview 
Fix C# (.NET 6) Chunk files to follow new standard.

# Process
## Phase 1: Fix `ClassDeclaration.txt`
1.1 Execute `../../scripts/fix-class-declaration.ps1`:
- ProgramName = {ProgramName}

> **Note**: Scripts automatically detect the repository root from the `.git` folder. No RootPath parameter needed.

Example:
`powershell -ExecutionPolicy Bypass -File "../../scripts/fix-class-declaration.ps1" -ProgramName "FAI00110"`

## Phase 2: Categorize `XXXX_FunctionName.cs`
2.1 Execute `../../scripts/categorize-functions.ps1`:
- ProgramName = {ProgramName}
Example:
`powershell -ExecutionPolicy Bypass -File "../../scripts/categorize-functions.ps1" -ProgramName "FAI00110"`

## Phase 3: Fix `XXXX_FunctionName.cs` and update `functions.txt`
3.1 Execute `../../scripts/fix-function-signatures.ps1`:
- ProgramName = {ProgramName}
Example:
`powershell -ExecutionPolicy Bypass -File "../../scripts/fix-function-signatures.ps1" -ProgramName "FAI00110"`

## Phase 4: Fix indentation for all `XXXX_FunctionName.cs`
4.1 Execute `../../scripts/fix-indentation.ps1`:
- ProgramName = {ProgramName}
Example:
`powershell -ExecutionPolicy Bypass -File "../../scripts/fix-indentation.ps1" -ProgramName "FAI00110"`