---
name: create-additional-files-in-common-project
description: A tool to create additional files in .NET6 common project based on .NET4 common projects.
---

# Overview 
Create additional files in .NET6 common project based on .NET4 common projects.

# Process
## Phase 1: Extract `ClassDeclaration.cs` file
1.1 From `chunks_cs/{ProgramName}/{SubProgramName}CLS`, read `ClassDeclaration.cs`.
1.2 Decide if it is inheriting R_BusinessObject
1.3 Decide if it is implementing R_IBatchProcess

## Phase 2: Create Interface for {SubProgramName}
2.1 From `chunks_cs/{ProgramName}/{SubProgramName}CLS`, read `functions.txt`.
2.2 Read common_interface_template as a template and based on `functions.txt`, create `I{SubProgramName}.cs` in `{ProgramName}Common` Project root folder.

## Phase 3: Build and Bug Fix
3.1 Build {ProgramName}Common project.
3.2 Provide a list of all errors and warnings with proposed fixes before applying them. 
3.3 Ask for approval of the fixes (NON-NEGOTIABLE).
3.4 If approved, apply the fixes.
3.5 If not approved, ask for changes and repeat step 3.2.