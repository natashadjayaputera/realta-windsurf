---
name: create-viewmodel-classes-in-model-project
description: A tool to create viewmodel classes in model project
---

# Overview 
Create viewmodel classes in model project.

# Process
## Phase 1: Create `{ProgramName}FrontResources` Project 
1.1 Read front_resource_csproj_template as a template and create `{ProgramName}FrontResources.csproj`.
1.2 Read front_resources_dummy_class_template and create resource dummy class.
1.3 Create resource `{ProgramName}FrontResources_msgrsc.resx` and `{ProgramName}FrontResources_msgrsc.id.resx` files (English and Indonesian) based on VB.NET `{ProgramName}FrontResources` Project.
1.4 Create `{ProgramName}FrontResources_msgrsc.Designer.cs` file based on VB.NET `{ProgramName}FrontResources` Project.
1.5 Update `{ProgramName}Model.csproj` to reference `{ProgramName}FrontResources.csproj` with format: `<ProjectReference Include="..\{ProgramName}FrontResources\{ProgramName}FrontResources.csproj" />`

## Phase 2: Create `{SubProgramName}ViewModel` Classes
2.1 From the `{ProgramName}Common` project, read each `I{SubProgramName}` interface files.
2.2 Decide if it is implementing `R_IServiceCRUDAsyncBase`
2.3 Read viewmodel_class_template and create viewmodel class based on the decision in step 2.2.

## Phase 3: Build and Bug Fix (REPEAT UNTIL NO ERRORS AND WARNINGS)
3.1 Build {ProgramName}Model project and create a list of all error codes and warnings.
3.2 Read and follow common_error_and_fixes and propose fixes based on common_error_and_fixes before applying them. Ask for approval of the fixes (NON-NEGOTIABLE). 
3.3 If approved, apply the fixes, and repeat step 3.1 until there are no errors and warnings.
3.4 If not approved, ask for changes and repeat step 3.2.