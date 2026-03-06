---
name: 06-create-service-project
description: A tool to create a .NET 6 service project based on interface files in Common Project
---

# Overview 
Create a .NET 6 service project based on interface files in Common Project

# Process
## Phase 1: Create {ProgramName}Service Project
1.1 Read service_csproj_template (just assume there is no report controller) as a template and create `{ProgramName}Service.csproj`. 

## Phase 2: Create all Controllers
2.1 Execute `../../scripts/discover-interfaces.ps1`:
- ProgramName = {ProgramName}
- SearchFolderCommon = the location of C# (.NET 6) {ProgramName}Common Project
Example:
`powershell -ExecutionPolicy Bypass -File "../../scripts/discover-interfaces.ps1" -ProgramName "FAI00110" -SearchFolderCommon "D:\_Work\AI\realta-windsurf\net6\RSF\BIMASAKTI_11\1.00\PROGRAM\BS Program\SOURCE\COMMON\FAI00110Common"`
2.2 For each interface found, read service_controller_template and create controller.

## Phase 3: Create Report Controller
3.1 For each item in ReportSubProgram, read report_controller_template and create report controller.

## Phase 4: Build and Bug Fix (REPEAT UNTIL NO ERRORS AND WARNINGS)
4.1 Build {ProgramName}Service project and create a list of all error codes and warnings.
4.2 Read and follow common_error_and_fixes and propose fixes based on common_error_and_fixes before applying them. Ask for approval of the fixes (NON-NEGOTIABLE). 
4.3 If approved, apply the fixes, and repeat step 4.1 until there are no errors and warnings.
4.4 If not approved, ask for changes and repeat step 4.2.

