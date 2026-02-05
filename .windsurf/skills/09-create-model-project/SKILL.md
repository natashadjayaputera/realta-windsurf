---
name: 09-create-model-project
description: A tool to create a .NET 6 model project
---

# Overview 
Create a .NET 6 model project.

# Process
## Phase 1: Create {ProgramName}Model Project
1.1 Read model_csproj_template as a template and create `{ProgramName}Model.csproj`.

## Phase 2: Create all Class Models
2.1 Execute `../../scripts/discover-interfaces.ps1`:
- ProgramName = {ProgramName}
- RootPath = {ROOT}
- SearchFolderCommon = the location of {ProgramName}Common Project
Example:
`powershell -ExecutionPolicy Bypass -File "../../scripts/discover-interfaces.ps1" -ProgramName "FAI00110" -RootPath "D:\_Work\AI\realta-windsurf" -SearchFolderCommon "D:\_Work\AI\realta-windsurf\net6\RSF\BIMASAKTI_11\1.00\PROGRAM\BS Program\SOURCE\COMMON\FAI00110Common"`
2.2 For each interface found, read model_class_template and create model class.

## Phase 3: Build and Bug Fix (REPEAT UNTIL NO ERRORS AND WARNINGS)
3.1 Build {ProgramName}Model project and create a list of all error codes and warnings.
3.2 Read and follow common_error_and_fixes and propose fixes based on common_error_and_fixes before applying them. Ask for approval of the fixes (NON-NEGOTIABLE). 
3.3 If approved, apply the fixes, and repeat step 3.1 until there are no errors and warnings.
3.4 If not approved, ask for changes and repeat step 3.2.