---
name: create-common-project
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
3.1 Copy `chunks_cs/{ProgramName}/**/DTO` to `{ProgramName}Common/DTOs`

## Phase 4: Convert DTOs from VB.NET to C#
4.1 Read common_types_mapping as a reference to convert VB.NET types to C# types.
4.2 All DTOs must be created with namespace `{ProgramName}Common.DTOs`.
4.3 Convert each DTO from VB.NET `{ProgramName}Back` & `{ProgramName}Common` Project to C# Common Project.
4.4 Remove `R_DTOBase` from all DTOs.
4.5 Remove all decoration attributes from all DTOs.

## Phase 5: Convert Enums from VB.NET to C#
5.1 All enums is in namespace `{ProgramName}Common.Enums`.
5.2 Convert each enum from VB.NET Back & Common Project to C# Common Project.

## Phase 6: Build and Bug Fix (REPEAT UNTIL NO ERRORS AND WARNINGS)
6.1 Build {ProgramName}Common project and create a list of all error codes and warnings.
6.2 Ask for approval of the fixes (NON-NEGOTIABLE). 
6.3 If approved, apply the fixes, and repeat step 5.1 until there are no errors and warnings.
6.4 If not approved, ask for changes and repeat step 5.2.

