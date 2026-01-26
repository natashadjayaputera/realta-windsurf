---
name: convert-to-viewmodel-class
description: A tool to convert VB.NET UI forms into C# ViewModels (part of Model project); ensure strict ViewModel conventions and inherit from R_ViewModel<{ProgramName}DTO>. 
---

# Overview
Create `{ProgramName}FrontResources` project and `{ProgramName}ViewModel` classes converted from VB.NET UI code. ViewModels belong in `VMs/` under the Model project

# Process
## High-Level Workflows

Creating `{ProgramName}ViewModel` classes involves 6 phases:

### Phase 1: Plan Generation

1.1 Gather knowledge about the existing projects.
1.1.1 List all VB.NET forms from existing VB.NET `{ProgramName}Front` project.
1.1.2 For each form, list all R_Conductor and R_ConductorGrid.
1.1.3 Each R_Conductor and R_ConductorGrid must have a corresponding ViewModel. Each form must have at least one ViewModel class.
1.1.4 For example, there are 3 .vb page files, 
- form FAM00500 has no R_Conductor or R_ConductorGrid,
- form FAM00510 has 1 R_Conductor,
- form FAM00520 has 2 R_Conductor and 1 R_ConductorGrid. 
The total number of ViewModels is 5, FAM00500ViewModel, FAM00510ViewModel, FAM00521ViewModel, FAM00522ViewModel, FAM00523ViewModel.

1.2 Function list.
1.2.1 List all functions that call service layer from existing VB.NET `{ProgramName}Front` project.
1.2.2 Assign each function to corresponding ViewModel.

1.3 Functions elaboration.
1.3.1 List all patterns and rules referenced by this skill.
1.3.2 For each Function in ViewModel, categorize it into one of the following:
* Business object functions (CRUD functions)
* Validation functions
* Streaming functions for functions that return list of data
* Non-streaming functions for functions that return single data or no data
1.3.3 Each function must not return any value, but assign value to ViewModel properties of `{FunctionName}ResultDTO`.
1.3.3 Each function must accept `{FunctionName}ParameterDTO` as parameter.

1.4 Streaming functions context implementation.
1.4.1 Read `ContextConstants.cs` found in .NET 6 `{ProgramName}Common` project and list all constants.
1.4.2 Assign constants to each streaming function based on the functions `{FunctionName}ParameterDTO`, NEVER include constants that is not available in `ContextConstants.cs`.
1.4.3 Remove all context refering to Standard Properties (e.g. `CCOMPANY_ID`, `CUSER_ID`, `CLANG_ID`)

1.5 If there are any batch processes (R_BatchProcess, R_BatchParameter in VB.NET) found in step 1.1.2, create a separate `{ProgramName}BatchViewModel` implementing `R_IProcessProgressStatus`.

1.6 Read `plan_generation.md` and generate a plan for the `{ProgramName}Model` project.
1.7 Add code preview in the plan.
1.8 Ask for approval of the plan (NON-NEGOTIABLE).
1.10 If approved, save the plan to `/plan/` folder.
1.11 If not approved, ask for changes and repeat step 1.7.

IMPORTANT: Subsequent phases will use the plan generated in this phase.

### Phase 2: Create `{ProgramName}FrontResources` Project
2.1 Read `front_resources_csproj.md` as a template and create `{ProgramName}FrontResources.csproj`.
2.2 Read `front_resource_dummy_class_pattern.md` and create resource dummy class.
2.3 Create resource `{ProgramName}FrontResources_msgrsc.resx` and `{ProgramName}FrontResources_msgrsc.id.resx` files (English and Indonesian).
2.4 Create `{ProgramName}FrontResources_msgrsc.Designer.cs` and `{ProgramName}FrontResources_msgrsc.id.Designer.cs` files.
2.5 Update `{ProgramName}Model.csproj` to reference `{ProgramName}FrontResources.csproj` with format: `<ProjectReference Include="..\{ProgramName}FrontResources\{ProgramName}FrontResources.csproj" />`

### Phase 3: Create `{ProgramName}ViewModel` Classes
3.1 Study the plan generated in Phase 1.
3.2 Read `viewmodel_class_pattern.md` and create viewmodel classes based on the plan.
3.3 Add minimal using statements provided in `viewmodel_using_statement.md` in each viewmodel class.
3.4 Read `viewmodel_crud_functions_pattern.md` and implement CRUD functions, if not used throw `NotImplementedException`.
3.5 Read `viewmodel_validation_functions_pattern.md` and implement validation functions, if any.
3.6 Read `viewmodel_streaming_functions_pattern.md` and implement streaming functions, if any.
3.7 Read `viewmodel_nonstreaming_functions_pattern.md` and implement non-streaming functions, if any.
3.8 Read `viewmodel_resource_retrieval_pattern.md` and follow the pattern to get resource message or error instance.
3.9 Read `viewmodel_violations.md` and make sure no violations exist.

### Phase 4: Create `{ProgramName}BatchViewModel` Classes
4.1 Study the plan generated in Phase 1, if there are no batch processes found, skip this phase.
4.2 Read `batch_viewmodel_pattern.md` and create batch viewmodel classes.

### Phase 5: Validation (IT'S IMPORTANT THAT YOU READ ALL THE FILE AGAIN)
5.1 Validate `{ProgramName}FrontResources.csproj` follows `front_resources_csproj.md`.
5.2 Validate `{ProgramName}ViewModel` classes follow `viewmodel_class_pattern.md`.
5.3 Validate no batch processes found in `{ProgramName}ViewModel` classes.
5.4 Validate `{ProgramName}BatchViewModel` classes follow `batch_viewmodel_pattern.md`.
5.5 Validate all classes does not implement any interface found in `{ProgramName}Common` project.
5.6 Validate all functions accept `{FunctionName}ParameterDTO` as parameter.
5.7 Validate all functions assign value to ViewModel properties of `{FunctionName}ResultDTO`.
5.8 Validate all streaming functions not passing parameters to model layer, and use `R_FrontContext.R_SetStreamingContext` instead.
5.9 Validate all validation functions does not change business logic from existing VB.NET `{ProgramName}Front` project.
5.10 Validate no violations listed in `viewmodel_violations.md` exist.
5.11 MOST IMPORTANTLY, all created files must have namespace, no global namespace.

### Phase 6: Build and Bug Fix
6.1 Build the `{ProgramName}Model` project.
6.2 Give me list of all errors and warnings and proposed fix before fixing them. Ask for approval of the fix.
6.3 If approved, fix the errors and warnings.
6.4 If not approved, ask for changes and repeat step 6.2.
