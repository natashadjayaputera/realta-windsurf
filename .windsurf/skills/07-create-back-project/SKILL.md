---
name: 07-create-back-project
description: A tool to create a .NET 6 back project
---

# Overview 
Create a .NET 6 back project

# Process
## Phase 1: Create `{ProgramName}BackResources` Project 
1.1 Read back_resource_csproj_template as a template and create `{ProgramName}BackResources.csproj`.
1.2 Read back_resources_dummy_class_template and create resource dummy class.
1.3 Create resource `{ProgramName}BackResources_msgrsc.resx` and `{ProgramName}BackResources_msgrsc.id.resx` files (English and Indonesian) based on VB.NET `{ProgramName}BackResources` Project.
1.4 Create `{ProgramName}BackResources_msgrsc.Designer.cs` file based on VB.NET `{ProgramName}BackResources` Project.

## Phase 2: Create {ProgramName}Back Project
2.1 Read back_csproj_template and read all `functions.txt` as a template and create `{ProgramName}Back.csproj`.

## Phase 3: Create Logger and Activity
3.1 Read back_logger_template and create logger class.
3.2 Read back_activity_template and create activity class.

## Phase 4: Create Back Classes
4.1 Get all `ClassDeclaration.txt` files in `chunks_cs/{ProgramName}/`.
4.2 For each `ClassDeclaration.txt` file, read corresponding `functions.txt` in the same folder, read back_class_template and create back class, DO NOT READ ANY `XXXX_FunctionName.cs` because it will be injected later. DO NOT ADD ANY FUNCTION IN THE CLASS.

## Phase 5: Inject Functions
5.1 Execute `{ROOT}/.windsurf/scripts/inject-functions.ps1`:
- ProgramName = {ProgramName}
- RootPath = {ROOT}
- SearchFolderBack = the location of {ProgramName}Back Project
- OutputFolder = `{ROOT}/chunks_cs/{ProgramName}/`
Example:
`powershell -ExecutionPolicy Bypass -File "{ROOT}/.windsurf/scripts/inject-functions.ps1" -ProgramName "FAI00110" -RootPath "D:\_Work\AI\realta-windsurf" -SearchFolderBack "D:\_Work\AI\realta-windsurf\net6\RSF\BIMASAKTI_11\1.00\PROGRAM\BS Program\SOURCE\BACK\FAI00110Back" -OutputFolder "D:\_Work\AI\realta-windsurf\chunks_cs\FAI00110"`

## Phase 6: Build and Bug Fix (REPEAT UNTIL NO ERRORS AND WARNINGS)
6.1 Build `{ProgramName}Back` project and create a list of all error codes and warnings.
6.2 Read and follow common_error_and_fixes and propose fixes based on common_error_and_fixes before applying them. Ask for approval of the fixes (NON-NEGOTIABLE). 
6.3 If approved, apply the fixes, and repeat step 6.1 until there are no errors and warnings.
6.4 If not approved, ask for changes and repeat step 6.2.

