---
name: generate-model-project
description: A tool to generate .NET6 model projects based on existing Service project interfaces. Produces service-layer client implementations targeting netstandard2.1.
---

# Overview
Generate C# (.NET 6) `{ProgramName}Model` project, which provides service-layer client classes based on the existing Service project and Common interfaces. The Model layer targets `netstandard2.1` and is designed for ViewModel layer consumption.  

# Process
## High-Level Workflows

Creating `{ProgramName}Model` project involves 5 phases:

### Phase 1: Plan Generation

1.1 Gather knowledge about the existing projects.
1.1.1 List all interfaces in `{ProgramName}Common` project.
1.1.2 Read `{ProgramName}Service` project and list all classes and functions.

1.2 Read `model_class_pattern.md` and create model class for each interface found in `{ProgramName}Common` project.
1.2.1 Implement all functions for `I{ProgramName}` interface based on `model_streaming_API_pattern.md`, `model_nonstreaming_api_pattern.md`, and `model_streaming_vs_nonstreaming.md`.
1.2.2 Do NOT implement business object functions, it is already implemented by `R_BusinessObjectServiceClientBase<{ProgramName}DTO>`.

1.3 Read `plan_generation.md` and generate a plan for the `{ProgramName}Model` project.
1.4 Add code preview in the plan for every pattern used.
1.5 Ask for approval of the plan (NON-NEGOTIABLE).
1.6 If approved, save the plan to `/plan/` folder.
1.7 If not approved, ask for changes and repeat step 1.5.

IMPORTANT: Subsequent phases will use the plan generated in this phase.

### Phase 2: Create `{ProgramName}Model` Project
2.1 Read `model_csproj.md` as a template and create `{ProgramName}Model.csproj`.

### Phase 3: Create `{ProgramName}Model` Classes
3.1 Study the plan generated in Phase 1.
3.2 Read `model_class_pattern.md` and create model class for each interface found in `{ProgramName}Common` project with constructor pattern.
3.3 Add minimal using statements provided in `model_using_statement.md`.
3.4 Read `model_streaming_API_pattern.md`, `model_nonstreaming_api_pattern.md`, and `model_streaming_vs_nonstreaming.md` and assign the appropriate pattern for each function to implement `I{ProgramName}` interface. 
3.5 Do NOT implement business object functions, it is already implemented by `R_BusinessObjectServiceClientBase<{ProgramName}DTO>`.

### Phase 4: Validation
4.1 Validate `{ProgramName}Model` project follows `model_csproj.md`.
4.2 Validate `{ProgramName}Model` classes follow `model_class_pattern.md`.
4.3 Validate all classes use minimal using statements provided in `model_using_statement.md`.
4.4 Validate all functions follow at least one of the patterns in `model_streaming_API_pattern.md`, `model_nonstreaming_api_pattern.md`, and `model_streaming_vs_nonstreaming.md`.
4.5 MOST IMPORTANTLY, all created files must have namespace, no global namespace.

### Phase 5: Build and Bug Fix
5.1 Build the `{ProgramName}Model` project.
5.2 Give me list of all errors and warnings and proposed fix before fixing them. Ask for approval of the fix.
5.3 If approved, fix the errors and warnings.
5.4 If not approved, ask for changes and repeat step 5.2.
