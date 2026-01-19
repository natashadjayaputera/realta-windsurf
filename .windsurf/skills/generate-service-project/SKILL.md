---
name: generate-service-project
description: A tool to generate .NET6 service projects.
---

# Overview
Create C# (.NET 6) `{ProgramName}Service` project (controllers / API layer) and generate `{ProgramName}Controller` that implements Common interfaces and delegates to Back business logic. 

# Process
## High-Level Workflows

Creating `{ProgramName}Service` project involves 9 phases:

### Phase 1: Plan Generation

1.1 Gather knowledge about the existing projects.
1.1.1 List all interfaces in `{ProgramName}Common` project.
1.1.2 Read `{ProgramName}Back` project and list all classes and functions.

1.2 Read `service_controller_requirements.md` and create controller class for each interface found in `{ProgramName}Common` project.
1.2.1 Implement all functions for `R_IServiceCRUDAsyncBase<{ProgramName}DTO>` interface based on `service_business_object_function_pattern.md` (R_ServiceGetRecord, R_ServiceSave, R_ServiceDelete).
1.2.2 Implement all functions for `I{ProgramName}` interface based on `service_streaming_pattern.md`, `service_nonstreaming_withparam_pattern.md`, and `service_nonstreaming_withoutparam_pattern.md`.

1.3 Assign rules and patterns to each controller and functions.
1.3.1 List all patterns and rules referenced by this skill.
1.3.2 For each controller, explicitly list which rules and patterns apply.

1.4 Define implementation requirements.
1.4.1 For each controller, explicitly state:
* Applied rules and patterns
* R_BackGlobalVar properties to be used
* R_Utility.R_GetStreamingContext to be used
* Back project functions to be called

1.5 Read `plan_generation.md` and generate a plan for the `{ProgramName}Service` project.
1.6 Add code preview in the plan.
1.7 Ask for approval of the plan (NON-NEGOTIABLE).
1.8 If approved, save the plan to `/plan/` folder.
1.9 If not approved, ask for changes and repeat step 1.5.

IMPORTANT: Subsequent phases will use the plan generated in this phase.

### Phase 2: Create `{ProgramName}Service` Project
2.1 Read `service_csproj.md` as a template and create `{ProgramName}Service.csproj`.

### Phase 3: Create `{ProgramName}Controller`
3.1 Study the plan generated in Phase 1.
3.2 Read `service_controller_requirements.md` and create `{ProgramName}Controller` for each interface found in `{ProgramName}Common` project.
3.3 Add minimal using statements provided in `service_using_statement.md`.
3.4 Read `service_controller_constructor_pattern.md` and implement constructor pattern.
3.5 Read `service_business_object_function_pattern` and create functions to implement `R_IServiceCRUDAsyncBase<{ProgramName}DTO>` (R_ServiceGetRecord, R_ServiceSave, R_ServiceDelete).
3.6 Read `service_streaming_pattern.md`, `service_nonstreaming_withparam_pattern.md`, and `service_nonstreaming_withoutparam_pattern.md` and assign the appropriate pattern for each function to implement `I{ProgramName}` interface. 

### Phase 4: Validation
4.1 Validate `{ProgramName}Service.csproj` follows `service_csproj.md`.
4.2 Validate `{ProgramName}Controller` follows `service_controller_requirements.md`.
4.3 Validate all controllers use minimal using statements provided in `service_using_statement.md`.
4.4 Validate all functions follow at least one of the patterns in `service_business_object_function_pattern.md`, `service_streaming_pattern.md`, `service_nonstreaming_withparam_pattern.md`, and `service_nonstreaming_withoutparam_pattern.md`.
4.5 Validate no violations listed in `service_violation.md` exist.

### Phase 5: Build and Bug Fix
5.1 Build the `{ProgramName}Service` project.
5.2 Give me list of all errors and warnings and proposed fix before fixing them. Ask for approval of the fix.
5.3 If approved, fix the errors and warnings.
5.4 If not approved, ask for changes and repeat step 5.2.

