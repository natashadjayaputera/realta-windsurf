---
name: 11-add-batch-data-manipulation-in-viewmodel
description: A tool to add batch data manipulation in viewmodel classes in model project
---

# Overview 
Add batch data manipulation in viewmodel classes in model project.

# Process
## Phase 1: Batch Implementation in ViewModel Classes
1.1 Execute `{ROOT}/.windsurf/scripts/detect-batch-processes.ps1`:
- ProgramName = {ProgramName}
- RootPath = {ROOT}
Example:
`powershell -ExecutionPolicy Bypass -File "{ROOT}/.windsurf/scripts/detect-batch-processes.ps1" -ProgramName "FAI00110" -RootPath "D:\_Work\AI\realta-windsurf"`
1.2 For each line in `chunks_cs/{ProgramName}/viewmodel_with_batch_list_buffer.txt` file:
- Read `chunks_cs/{ProgramName}/{SubProgramName}/**_R_BatchProcess.cs` and search for `R_NetCoreUtility.R_DeserializeObjectFromByte<List<T>>` and assign T as `{BatchDisplayListDTO}`.
- Read `chunks_cs/{ProgramName}/{SubProgramName}/**_R_BatchProcess.cs` and get the LAST occurance of `RSP_WriteUploadProcessStatus` stored procedure and extract all 6 of the stored procedure arguments, and assign the 4th argument as `{BatchSteps}`.
- Read corresponding `{SubProgramName}Model.cs`, and search for the value of `DEFAULT_SERVICEPOINT_NAME`, and assign it as `{BatchServicePointName}`.
- Read corresponding `ClassDeclaration.txt` and get the name of the ClassName and assign it to `{BatchBackClassName}`.
- Read viewmodel_batch_additional_front_resources and add new resources to the `{SubProgramName}FrontResources_msgrsc.resx` and `{SubProgramName}FrontResources_msgrsc.id.resx` files.   
- `{SubProgramName}ViewModel` must implements `R_IProcessProgressStatus`
- Read viewmodel_batch_class_template and add batch viewmodel template to the `{SubProgramName}ViewModel` class.   
- Read viewmodel_batch_using_statement and add using statement on the top of the `{SubProgramName}ViewModel.cs` file.

## Phase 2: Build and Bug Fix (REPEAT UNTIL NO ERRORS AND WARNINGS)
2.1 Build {ProgramName}Model project and create a list of all error codes and warnings.
2.2 Read and follow common_error_and_fixes and propose fixes based on common_error_and_fixes before applying them. Ask for approval of the fixes (NON-NEGOTIABLE). 
2.3 If approved, apply the fixes, and repeat step 2.1 until there are no errors and warnings.