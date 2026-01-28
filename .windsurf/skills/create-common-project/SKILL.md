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

## Phase 3: Convert DTOs from VB.NET to C#
3.1 Read common_types_mapping as a reference to convert VB.NET types to C# types.
3.2 All DTOs is in namespace `{ProgramName}Common.DTOs`.
3.3 Convert each DTO from VB.NET Back & Common Project to C# Common Project.
3.4 Remove `R_DTOBase` from all DTOs.
3.5 Remove all decoration attributes from all DTOs.

## Phase 4: Convert Enums from VB.NET to C#
4.1 All enums is in namespace `{ProgramName}Common.Enums`.
4.2 Convert each enum from VB.NET Back & Common Project to C# Common Project.

## Phase 5: Build and Bug Fix
5.1 Build {ProgramName}Common project.
5.2 Provide a list of all errors and warnings with proposed fixes before applying them. 
5.3 Ask for approval of the fixes (NON-NEGOTIABLE).
5.4 If approved, apply the fixes.
5.5 If not approved, ask for changes and repeat step 5.2.

