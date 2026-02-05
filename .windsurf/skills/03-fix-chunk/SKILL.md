---
name: 03-fix-chunk
description: A tool to fix C# (.NET 6) Chunk files to follow new standard.
---

# Overview 
Fix C# (.NET 6) Chunk files to follow new standard.

# Process
## Phase 1: Fix `ClassDeclaration.txt`
1.1 New Standard:
- Do not add namespace.
- Class name is in CamelCase, but {SubProgramName} is in ALL CAPS.
- Replace `R_BusinessObject<T>` with `R_BusinessObjectAsync<T>`, if any (DO NOT ADD IF IT'S NOT THERE).
- Replace `R_IBatchProcess` with `R_IBatchProcessAsync`, if any (DO NOT ADD IF IT'S NOT THERE).
- Do not add curly braces `{` or `}`
1.2 From `chunks_cs/{ProgramName}/{SubProgramName}CLS`, edit `ClassDeclaration.txt` to follow new standard.

## Phase 2: Fix `XXXX_FunctionName.cs` and update `functions.txt`
2.1 New Standard:
- Read back_function_categories and add `//CATEGORY: {CategoryName from back_function_categories}` to the top of the `XXXX_FunctionName.cs` file (NON-NEGOTIABLE).
- Change all function signature to use `async` keyword.
- Add `Task<{FunctionReturnType}>` to return type.
- Function name stay the same (do not add `async` suffix).
- Remove `#region` and `#endregion` that is outside of the function.
2.2 From `chunks_cs/{ProgramName}/{SubProgramName}CLS`, edit each `XXXX_FunctionName.cs` to follow new standard.
2.3 Update `functions.txt` based on the changes in `XXXX_FunctionName.cs`. Add `//CATEGORY: {CategoryName from back_function_categories}` to the right side of the function signature in `functions.txt`.

## Phase 3: Fix indentation for all `XXXX_FunctionName.cs`
3.1 Execute the script inside fix-indentation.sh, passing:
- ProgramName = {ProgramName}