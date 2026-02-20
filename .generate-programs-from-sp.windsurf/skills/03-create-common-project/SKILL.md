---
name: 03-create-common-project
description: A tool to create a .NET 6 common project based on .NET4 common projects.
---

# Overview 
Create a .NET 6 common project based on .NET4 common projects.

# Process
## Phase 1: Create {ProgramName}Common Project
1.1 Read common_csproj_template as a template and create `{ProgramName}Common.csproj`.

## Phase 2: Create Generic Result DTO
2.1 Read common_generic_result_dto_template as a template and create `{ProgramName}ResultDTO.cs`.

## Phase 3: Add Additional DTO
3.1 Execute `copy {SearchFolder} {OutputFolder}` for each SubProgramName 
- SearchFolder = `partials/{ProgramName}/{SubProgramName}/common/dto`
- OutputFolder = C# (.NET 6) location (Common Folder) + {ModuleName} + '{ProgramName}Common/DTOs'
Example:
`copy "D:\_Work\AI\realta-windsurf\partials\HDM00100\HDM00100\common\dto\*.cs" "D:\_Work\AI\realta-windsurf\net6\RSF\BIMASAKTI_11\1.00\PROGRAM\BS Program\SOURCE\COMMON\HD\HDM00100Common\DTOs\"`

## Phase 4: Build and Bug Fix (REPEAT UNTIL NO ERRORS AND WARNINGS)
4.1 Build {ProgramName}Common project and create a list of all error codes and warnings.
4.2 Ask for approval of the fixes (NON-NEGOTIABLE). 
4.3 If approved, apply the fixes, and repeat step 5.1 until there are no errors and warnings.
4.4 If not approved, ask for changes and repeat step 5.2.

