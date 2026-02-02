---
name: convert-to-common-project
description: A tool that reads .NET4 back projects and common projects and generates a .NET 6 common project based on those projects, consisting of DTOs, Enums and Interfaces, no business logic.
---

# Overview

Convert VB.NET (.NET Framework 4) Back and Common Projects into C# (.NET 6) `{ProgramName}Common` project. **No business logic** in Common — only DTOs, enums, interfaces, and constants.

# Process

## High-Level Workflows

Creating `{ProgramName}Common` project involves 8 phases:

### Phase 1: Plan Generation

1.1 Read project structure in `{ROOT}/project-structure/{ProgramName}_project_structure.md`, THIS IS THE ABSOLUTE TRUTH.

1.2 Read rules:
- `core_business_object_overridden_functions.md`
- `common_dto_design.md`
- `common_interface_requirements.md`
- `common_context_constants.md`

1.3 Read `common_interface_requirements.md` and explicitly list interfaces based on the project structure in step 1.1.
1.3.1 Each Main Back Class will have its own interface.
1.3.2 No Batch or Report related interfaces.
1.3.3 All functions must be included except business object overridden functions, batch and report functions.
1.3.4 All functions that return List must use streaming pattern (IMPORTANT!!).

1.4 Read `common_context_constants.md` and explicitly list all properties that will be included in `ContextConstants.cs` based on the project structure in step 1.1. Remove any required standard properties (already handled in `R_BackGlobalVar`).

1.5 Read `plan_generation.md` and generate a plan for the `{ProgramName}Common` project.
1.6 Add code preview in the plan for every pattern used.
1.7 Ask for approval of the plan (NON-NEGOTIABLE).
1.8 If approved, save the plan to `/plan/` folder.
1.9 If not approved, ask for changes and repeat step 1.5.

IMPORTANT: Subsequent phases will use the plan generated in this phase.

### Phase 2: Create `{ProgramName}Common` Project

2.1 Read `common_csproj.md` as a template and create `{ProgramName}Common.csproj`.

### Phase 3: Create Generic Result DTO

3.1 Read `common_generic_result_dto_pattern.md` and create `{ProgramName}ResultDTO.cs`.

### Phase 4: Create DTOs

4.1 Create a single `{ProgramName}DTO` for all business object overridden functions in Back class.
4.2 For each non-business object overridden function, create `{FunctionName}ParameterDTO` and `{FunctionName}ResultDTO`.
4.3 Do not use `StreamDTO`. Any usage must be replaced with dedicated `{FunctionName}ParameterDTO` and `{FunctionName}ResultDTO`.

### Phase 5: Create Interfaces for Service Contracts

5.1 Read `common_interface_requirements.md`.
5.2 For each Back class, create an interface that inherits or implements `R_IServiceCRUDAsyncBase<{ProgramName}DTO>` and uses its own dedicated EntityDTO.
5.3 Interface functions MUST NOT have `Async` as suffix.

### Phase 6: Create Context Constants

6.1 Read `common_context_constants.md` and create `ContextConstants.cs`.

### Phase 7: Validation (IT'S IMPORTANT THAT YOU READ ALL THE FILE AGAIN)

7.1 Validate `{ProgramName}Common.csproj` follows the structure in `common_csproj.md`.
7.2 Validate all functions have corresponding `{FunctionName}ParameterDTO` and `{FunctionName}ResultDTO`.
7.3 Validate Generic Result DTO follows `common_generic_result_dto_pattern.md`.
7.4 Validate interfaces follow `common_interface_requirements.md`.
7.5 Validate all VB.NET DTOs and related types are converted to C# 10 with nullable enabled, excluding `StreamDTO`.
7.6 Delete `StreamDTO` from `{ProgramName}Common` project.
7.7 Ensure all created files follow `common_dto_design.md`.
7.8 Ensure no violations listed in `common_dto_violations.md` exist.
7.9 MOST IMPORTANTLY, all created files must have namespace, no global namespace.

### Phase 8: Build and Bug Fix

8.1 Build `{ProgramName}Common` project.
8.2 Provide a list of all errors and warnings with proposed fixes before applying them. Ask for approval.
8.3 If approved, apply the fixes.
8.4 If not approved, ask for changes and repeat step 8.2.
