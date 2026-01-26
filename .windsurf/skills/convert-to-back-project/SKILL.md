---
name: convert-to-back-project
description: A tool to convert .NET4 back projects to .NET6 back projects, preserving business logic.
---

# Overview 
Convert VB.NET (.NET Framework 4) Back Projects into C# (.NET 6) `{ProgramName}Back` project preserving DB and stored procedure names, implementing logger/activity patterns in Back, and following the database access and error/resource patterns.

# Process
## High-Level Workflows

Creating `{ProgramName}Back` project involves 9 phases:

### Phase 1: Plan Generation

1.1 Gather knowledge about the existing projects.
1.1.1 Read project structure in `{ROOT}/project-structure/{ProgramName}_project_structure.md`, THIS IS THE ABSOLUTE TRUTH.
1.1.2 Read `back_class_seperation.md` and categorize each function explicitly into one of the following:
* Back class (split into business object overridden functions and non-business object overridden functions, read `core_business_object_overridden_functions.md` for more details)
* Batch class
* Report class
1.1.3 List all DTOs in the `{ProgramName}Common` project.
1.1.4 Adjust the Back function list to match available DTOs in `{ProgramName}Common`, replace `StreamDTO` with dedicated `{FunctionName}ParameterDTO` and `{FunctionName}ResultDTO`.

1.2 Assign rules and patterns to each class and functions.
1.2.1 List all patterns and rules referenced by this skill.
1.2.2 For each function category (Back, Batch, Report), explicitly list which rules and patterns apply.

1.3 Define implementation requirements.
1.3.1 For each function, MUST explicitly state:
* Target class and project (Back, Batch, or Report)
* Applied rules and patterns
* Required constraints (DTO usage, async rules, logging, DB access, etc.)
* Code preview

1.5 Read `plan_generation.md` and generate a plan for the `{ProgramName}Back` project.
1.6 Add code preview in the plan for every pattern used.
1.7 Ask for approval of the plan (NON-NEGOTIABLE).
1.8 If approved, save the plan to `/plan/` folder.
1.9 If not approved, ask for changes and repeat step 1.5.

IMPORTANT: Subsequent phases will use the plan generated in this phase.

### Phase 2: Create `{ProgramName}BackResources` Project 
2.1 Read `back_resources_csproj.md` as a template and create `{ProgramName}BackResources.csproj`.
2.2 Read `back_resource_dummy_class_pattern.md` and create resource dummy class.
2.3 Create resource `{ProgramName}BackResources_msgrsc.resx` and `{ProgramName}BackResources_msgrsc.id.resx` files (English and Indonesian).
2.4 Create `{ProgramName}BackResources_msgrsc.Designer.cs` file.

### Phase 3: Create `{ProgramName}Back` Project
3.1 Read `back_csproj.md` as a template and create `{ProgramName}Back.csproj`.

### Phase 4: Create Logger and Activity
4.1 Read `back_logger_pattern.md` and create logger classes.
4.2 Read `back_activity_pattern.md` and create activity classes.

### Phase 5: Convert existing VB.NET Back Project
5.1 Study the plan generated in Phase 1.
5.2 Create classes (Back Class only) based on the plan. Batch and report classes are excluded and handled in later phases.
5.3 Add minimal using statements provided in `back_using_statements.md`.
5.4 Read `back_class_separation.md` and follow the rules.
5.5 Read `back_cls_constructor_pattern.md` and create constructor for Back Class following the pattern.
5.6 Back Class must not implement `I{ProgramName}` found in `{ProgramName}Common` project.
5.7 Read `back_business_object_function_pattern.md` to convert all business object overridden functions, preserving all business logic, DB and stored procedure names.
5.8 Read `back_streaming_function_pattern.md` to convert streaming functions, preserving all business logic, DB and stored procedure names.
5.9 Read `back_database_function_pattern.md` and make sure all functions follow the pattern, preserving all business logic, DB and stored procedure names.
5.10 Read `back_error_retrieval_pattern.md` to and make sure all functions implement error retrieval functions.
5.11 All functions must be implemented in `async Task`.

### Phase 6: Convert existing VB.NET Batch Functions
6.1 If there are no batch functions in step 4.3.1, skip this phase.
6.2 For step 6.3 to 6.6, you are allowed to modify `{ProgramName}Common` project to follow the rules.
6.3 Follow batch project structure rules in `batch_project_structure.md`.
6.4 Follow batch related DTO rules in `batch_related_dto.md`.
6.5 Convert existing VB.NET Batch Functions found in step 4.3.1 into C# (.NET 6) following `batch_*.md`. Create related DTOs in `{ProgramName}Common` project if required based on  `batch_related_dto.md`.
6.6 Follow batch rules and violations in `batch_back_class_rules_and_violations.md`.

### Phase 7: Convert existing VB.NET Report Functions
7.1 If there are no report functions in step 4.3.1, skip this phase.
7.2 For step 7.3 to 7.6, you are allowed to modify `{ProgramName}Common` project to follow the rules.
7.3 Follow report project structure rules in `report_project_structure.md`.
7.4 Follow report related DTO rules in `report_dto_rules.md`.
7.5 Convert existing VB.NET Report Functions (DATA RETRIEVAL FUNCTION ONLY, NO PRINTING FUNCTION) found in step 4.3.1 into C# (.NET 6) following `report_*.md`. Create related DTOs in `{ProgramName}Common` project if required based on `report_dto_rules.md`.
7.6 Follow report rules and violations in `report_rules_and_violations.md`.

### Phase 8: Validation (IT'S IMPORTANT THAT YOU READ ALL THE FILE AGAIN)
8.1 Validate `{ProgramName}Back.csproj` follows `back_csproj.md`.
8.2 Validate resource dummy class follows `back_resource_dummy_class_pattern.md`.
8.3 Validate `{ProgramName}BackResources.csproj` follows `back_resources_csproj.md`.
8.4 Validate all functions use corresponding `{FunctionName}ParameterDTO` and `{FunctionName}ResultDTO`.
8.5 Validate all functions follow the logger/activity patterns in Back following `back_cls_constructor_pattern.md` NOT for batch or report related classes.
8.6 Validate all functions follow the database access patterns in `back_database_function_pattern.md`.
8.7 Validate all functions follow the error/resource patterns in `back_error_retrieval_pattern.md`.
8.8 Validate all functions follow the R_BusinessObjectAsync implementation pattern in `back_business_object_function_pattern.md`.
8.9 Validate no violations listed in `back_violations.md` exist.
8.10 Validate all Back Classes use minimal using statements provided in `back_using_statements.md`.
8.11 Validate all functions does not implement any interface found in `{ProgramName}Common` project.
8.12 Validate batch and report functions are not implemented in back class, they are implemented in their own class.
8.13 Validate Back classes do not directly access `R_BackGlobalVar` or `R_Utility.R_GetStreamingContext`. These values must be passed via `{FunctionName}ParameterDTO`.
8.14 Validate SQL and stored procedure names are preserved (even if buggy).
8.15 MOST IMPORTANTLY, all created files must have namespace, no global namespace.

### Phase 9: Build and Bug Fix
9.1 Build the `{ProgramName}Back` project.
9.2 Give me list of all errors and warnings and proposed fix before fixing them. Ask for approval of the fix.
9.3 If approved, fix the errors and warnings.
9.4 If not approved, ask for changes and repeat step 9.2.