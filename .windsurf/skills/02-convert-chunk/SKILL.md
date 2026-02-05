---
name: 02-convert-chunk
description: A tool to convert VB.NET (.NET Framework 4) Chunk files into C# (.NET 6) Chunk files.
---

# Overview 
Convert VB.NET (.NET Framework 4) Chunk files into C# (.NET 6) Chunk files.

# Process
## Phase 1: Convert `ClassDeclaration.txt` to `ClassDeclaration.txt`
1.1 From `chunks_vb/{ProgramName}/{SubProgramName}CLS`, convert `ClassDeclaration.txt` (class declaration in VB.NET) to `ClassDeclaration.txt` (class declaration in C#) and save it to `chunks_cs/{ProgramName}/{SubProgramName}CLS`.
1.2 Must add `public` keyword to the class declaration.
1.3 Remove any `{` or `}` from the class declaration.

## Phase 2: Convert `functions.txt` to `functions.txt`
2.1 From `chunks_vb/{ProgramName}/{SubProgramName}CLS`, convert `functions.txt` (list of functions signature in VB.NET) to `functions.txt` (list of functions signature in C#) and save it to `chunks_cs/{ProgramName}/{SubProgramName}CLS`.

## Phase 3: Convert `XXXX_FunctionName.vb` to `XXXX_FunctionName.cs`
3.1 Rules to convert:
- Convert manually (do not use or create any script)
- Do not change any logic even if it's buggy (NON-NEGOTIABLE)
- Do not add any improvement or enhancement (NON-NEGOTIABLE)
- Remove comments
- Do not change any variable name
3.2 Following the rules from 3.1, convert each `*.vb` to `*.cs` and save it to `chunks_cs/{ProgramName}/{SubProgramName}CLS`.