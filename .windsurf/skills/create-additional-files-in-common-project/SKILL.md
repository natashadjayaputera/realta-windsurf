---
name: create-additional-files-in-common-project
description: A tool to create additional files in .NET6 common project.
---

# Overview 
Create additional files in .NET6 common project.

# Process
## Phase 1: Iterate SubProgram Folders
1.1 Loop through each `{SubProgramName}CLS` folder inside `chunks_cs/{ProgramName}`.
1.2 For each `{SubProgramName}CLS`, execute Phase 2 – Phase 3.

## Phase 2: Extract `ClassDeclaration.txt` file
2.1 From `chunks_cs/{ProgramName}/{SubProgramName}CLS`, read `ClassDeclaration.txt`.
2.2 Decide if it is inheriting R_BusinessObject or R_BusinessObjectAsync
2.3 Decide if it is implementing R_IBatchProcess or R_IBatchProcessAsync

## Phase 3: Create Interface for {SubProgramName}
3.1 From `chunks_cs/{ProgramName}/{SubProgramName}CLS`, read `functions.txt`.
3.2 Read common_interface_template as a template and based on `functions.txt`, create `I{SubProgramName}.cs` in `{ProgramName}Common` Project root folder.

## Phase 4: Build and Bug Fix (REPEAT UNTIL NO ERRORS AND WARNINGS)
4.1 Build {ProgramName}Common project and create a list of all error codes and warnings.
4.2 Ask for approval of the fixes (NON-NEGOTIABLE). 
4.3 If approved, apply the fixes, and repeat step 4.1 until there are no errors and warnings.
4.4 If not approved, ask for changes and repeat step 4.2.