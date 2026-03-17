---
name: 01-convert-list-to-enumerable
description: A tool to convert Async List to IAsyncEnumerable in C# code.
---

# Overview 
Convert Async List to IAsyncEnumerable in C# code.

# Process
## Phase 1: Update Interface
1.1 Read `I{SubProgramName}.cs` in C# (.NET 6) location (Common Folder).
1.2 Find `{FunctionName}` method.
1.3 Update return type from `Task<{ProgramName}ResultDTO<List<{FunctionReturnType}>>>` to `IAsyncEnumerable<{FunctionReturnType}>`.
1.4 Save the name of the parameter DTO as `{FunctionParameterDTO}`.
1.5 Remove parameter from method signature.

## Phase 2: Create `ContextConstants.cs`
2.1 Read `DTOs/{FunctionParameterDTO}.cs` in C# (.NET 6) location (Common Folder).
2.2 Get all the properties from the DTO and add them as constants to `ContextConstants.cs` in `{ProgramName}Common` folder using the pattern defined in `context_constant_pattern.md`.

## Phase 3: Update Controller
3.1 Read `{SubProgramName}Controller.cs` in C# (.NET 6) location (Back Folder).
3.2 Find `{FunctionName}` method.
3.3 Update return type from `Task<{ProgramName}ResultDTO<List<{FunctionReturnType}>>>` to `IAsyncEnumerable<{FunctionReturnType}>`.
3.4 Update the method implementation as defined in `iasyncenumerable_controller_pattern.md`.
3.5 Make sure all properties from `{FunctionParameterDTO}` are properly mapped from streaming context.
3.6 Remove parameter from method signature.

## Phase 4: Update Model
4.1 Read `{SubProgramName}Model.cs` in C# (.NET 6) location (Model Folder).
4.2 Find `{FunctionName}` method.
4.3 Update the method implementation as defined in `iasyncenumerable_model_pattern.md`.
4.4 Remove parameter from method signature.
4.5 Remove other api call implementation comments

## Phase 5: Update ViewModel
5.1 Read `VMs/{SubProgramName}ViewModel.cs` in C# (.NET 6) location (Model Folder).
5.2 Find `{FunctionName}` method.
5.3 Update the method implementation as defined in `iasyncenumerable_viewmodel_pattern.md`.
5.4 Make sure all properties from `{FunctionParameterDTO}` are properly set to streaming context.

## Phase 6: Build and Bug Fix (REPEAT UNTIL NO ERRORS)
6.1 Build {ProgramName}Common project, {ProgramName}Service project, and {ProgramName}Model project (in that order), and create a list of all error codes and warnings.
6.2 Ask for approval of the fixes (NON-NEGOTIABLE). 
6.3 If approved, apply the fixes, and repeat step 5.1 until there are no errors.
6.4 If not approved, ask for changes and repeat step 5.2.
