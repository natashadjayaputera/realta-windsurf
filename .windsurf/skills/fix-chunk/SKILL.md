---
name: fix-chunk
description: A tool to fix C# (.NET 6) Chunk files to follow new standard.
---

# Overview 
Fix C# (.NET 6) Chunk files to follow new standard.

# Process
## Phase 1: Fix `ClassDeclaration.cs`
1.1 New Standard:
- Do not add namespace.
- Class name is in CamelCase, but {SubProgramName} is in ALL CAPS.
- Replace `R_BusinessObject<T>` with `R_BusinessObjectAsync<T>`, if any.
- Replace `R_IBatchProcess` with `R_IBatchProcessAsync`, if any.
1.2 From `chunks_cs/{ProgramName}/{SubProgramName}CLS`, edit `ClassDeclaration.cs` to follow new standard.


## Phase 2: Fix `functions.txt`
2.1 New Standard:
- Change all function signature to use `async` keyword.
- Add `Task<{FunctionReturnType}>` to return type.
- Function name stay the same (do not add `async` suffix).
2.2 From `chunks_cs/{ProgramName}/{SubProgramName}CLS`, edit `functions.txt` to follow new standard.


## Phase 3: Fix `XXXX_FunctionName.cs`
3.1 New Standard:
- Change all function signature to use `async` keyword.
- Add `Task<{FunctionReturnType}>` to return type.
- Function name stay the same (do not add `async` suffix).
- Read back_function_categories and add `//CATEGORY: {Category}` to the top of the file.
3.2 From `chunks_cs/{ProgramName}/{SubProgramName}CLS`, edit each `XXXX_FunctionName.cs` to follow new standard.