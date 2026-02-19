---
name: 05-create-back-project
description: A tool to create a .NET 6 back project
---

# Overview 
Create a .NET 6 back project

# Process
## Phase 1: Copy `{ProgramName}BackResources` Project 
1.1 Execute `../../scripts/copy-folders-with-duplicate-check.ps1`:
- SearchFolder = `chunks_cs/resources/{ProgramName}BackResources`
- OutputFolder = C# (.NET 6) location (Back Folder) + {ModuleName} + '{ProgramName}BackResources'
Example:
`powershell -ExecutionPolicy Bypass -File "../../scripts/copy-folders-with-duplicate-check.ps1" -SearchFolder "chunks_cs/resources/FAI00110BackResources" -OutputFolder "D:/_Work/AI/realta-windsurf/net6/RSF/BIMASAKTI_11/1.00/PROGRAM/BS Program/SOURCE/BACK/FA"`
1.2 Execute `../../scripts/copy-folders-with-duplicate-check.ps1`:
- SearchFolder = `chunks_cs/spr`
- OutputFolder = C# (.NET 6) location (Back Folder)
Example:
`powershell -ExecutionPolicy Bypass -File "../../scripts/copy-folders-with-duplicate-check.ps1" -SearchFolder "chunks_cs/spr" -OutputFolder "D:/_Work/AI/realta-windsurf/net6/RSF/BIMASAKTI_11/1.00/PROGRAM/BS Program/SOURCE/BACK"`

## Phase 2: Create {ProgramName}Back Project
2.1 Read back_csproj_template and read all `functions.txt` as a template and create `{ProgramName}Back.csproj`.

## Phase 3: Create Logger and Activity
3.1 Read back_logger_template and create logger class.
3.2 Read back_activity_template and create activity class.

## Phase 4: Create Back Classes
4.1 Get all `ClassDeclaration.txt` files in `chunks_cs/{ProgramName}/`.
4.2 For each `ClassDeclaration.txt` file, read corresponding `functions.txt` in the same folder, read back_class_template and create back class, DO NOT READ ANY `XXXX_FunctionName.cs` because it will be injected later. DO NOT ADD ANY FUNCTION IN THE CLASS.

## Phase 5: Fix indentation for all `XXXX_FunctionName.cs`
5.1 Execute `../../scripts/fix-indentation.ps1`:
- ProgramName = {ProgramName}
Example:
`powershell -ExecutionPolicy Bypass -File "../../scripts/fix-indentation.ps1" -ProgramName "FAI00110"`

## Phase 6: Inject Functions
6.1 Execute `../../scripts/inject-functions.ps1`:
- ProgramName = {ProgramName}
- SearchFolderBack = the location of C# (.NET 6) {ProgramName}Back Project
- OutputFolder = `{ROOT}/chunks_cs/{ProgramName}/`
Example:
`powershell -ExecutionPolicy Bypass -File "../../scripts/inject-functions.ps1" -ProgramName "FAI00110" -SearchFolderBack "D:/_Work/AI/realta-windsurf/net6/RSF/BIMASAKTI_11/1.00/PROGRAM/BS Program/SOURCE/BACK/FAI00110Back" -OutputFolder "D:/_Work/AI/realta-windsurf/chunks_cs/FAI00110"`

## Phase 7: Build and Bug Fix (REPEAT UNTIL NO ERRORS AND WARNINGS)
7.1 Build `{ProgramName}Back` project and create a list of all error codes and warnings.
7.2 Read and follow common_error_and_fixes and propose fixes based on common_error_and_fixes before applying them. Ask for approval of the fixes (NON-NEGOTIABLE). 
7.3 If approved, apply the fixes, and repeat step 7.1 until there are no errors and warnings.
7.4 If not approved, ask for changes and repeat step 6.2.

