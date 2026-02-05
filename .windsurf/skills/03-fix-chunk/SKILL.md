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
- RootPath = {ROOT}
Example:
`powershell -ExecutionPolicy Bypass -File "../../scripts/fix-class-declaration.ps1" -ProgramName "FAI00110" -RootPath "D:\_Work\AI\realta-windsurf"`

## Phase 2: Fix `XXXX_FunctionName.cs` and update `functions.txt`
2.1 Execute `../../scripts/categorize-functions.ps1`:
- ProgramName = {ProgramName}
- RootPath = {ROOT}
Example:
`powershell -ExecutionPolicy Bypass -File "../../scripts/categorize-functions.ps1" -ProgramName "FAI00110" -RootPath "D:\_Work\AI\realta-windsurf"`
2.2 New Standard:
- Change all function signature to use `async` keyword.
- Add `Task<{FunctionReturnType}>` to return type.
- Function name stay the same (do not add `async` suffix).
- Remove `#region` and `#endregion` that is outside of the function.
2.3 From `chunks_cs/{ProgramName}/{SubProgramName}`, edit each `XXXX_FunctionName.cs` to follow new standard.
2.4 Update `functions.txt` based on the changes in `XXXX_FunctionName.cs`. Add `//CATEGORY: {CategoryName from back_function_categories}` to the right side of the function signature in `functions.txt`.

## Phase 3: Fix indentation for all `XXXX_FunctionName.cs`
3.1 Execute `../../scripts/fix-indentation.ps1`:
- ProgramName = {ProgramName}
- RootPath = {ROOT}
Example:
`powershell -ExecutionPolicy Bypass -File "../../scripts/fix-indentation.ps1" -ProgramName "FAI00110" -RootPath "D:\_Work\AI\realta-windsurf"`