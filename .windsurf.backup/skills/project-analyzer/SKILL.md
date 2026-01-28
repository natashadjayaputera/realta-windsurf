---
name: project-analyzer
description: A tool to analyze VB.NET (.NET Framework 4) Project structure as a basis for project conversion.
---

# Overview 
Analyze VB.NET (.NET Framework 4) Project structure as a basis for project conversion.

# Process
## High-Level Workflows

Analyzing VB.NET (.NET Framework 4) Project structure involves 4 phases:

### Phase 1: Get All Report Related Functions and Classes
1.1 Read ONLY `{ProgramName}Back` and `{ProgramName}Common` projects to get all report related functions and classes (NO .rpt files). 
1.2 To get all report related functions and class:
- The function name contains `Report` or `Print`
- The function is located inside a region related to reporting or printing
1.3 Identify ALL classes found (e.g., `FAB00200Cls`, `FAB00201Cls`, `FAB00202Cls`) and extract their actual ProgramNames:
   - Main Program: `FAB00200Cls` → ProgramName = `FAB00200`
   - Sub Programs: `FAB00201Cls` → ProgramName = `FAB00201`, ParentProgramName = `FAB00200`
   - Sub Programs: `FAB00202Cls` → ProgramName = `FAB00202`, ParentProgramName = `FAB00200`
1.4 For each identified class with report functions, add `{ActualProgramName}ReportCls.cs` in .NET 6 `{ParentProgramName}Back` project, DO NOT create a separate project.
1.5 Define `{FunctionName}ParameterDTO` and `{FunctionName}ResultDTO` for each function, using the actual ProgramName from the class.
1.6 Create a file named `{ParentProgramName}_project_structure_report.md` in `/project-structure/` listing all report classes and their functions with actual ProgramNames.

### Phase 2: Get All Batch Related Functions and Classes
2.1 Read ONLY `{ProgramName}Back` and `{ProgramName}Common` projects to get all batch related functions and classes.
2.2 To get all batch related functions and class:
- The function name contains `Batch` or `Bulk`
- The function uses `R_BulkInsert`
- The function uses `R_BatchProcess`
2.3 Identify ALL classes found (e.g., `FAB00200Cls`, `FAB00201Cls`, `FAB00202Cls`) and extract their actual ProgramNames:
   - Main Program: `FAB00200Cls` → ProgramName = `FAB00200`
   - Sub Programs: `FAB00201Cls` → ProgramName = `FAB00201`, ParentProgramName = `FAB00200`
   - Sub Programs: `FAB00202Cls` → ProgramName = `FAB00202`, ParentProgramName = `FAB00200`
2.4 For each identified class with batch functions, add `{ActualProgramName}BatchCls.cs` in .NET 6 `{ParentProgramName}Back` project, DO NOT create a separate project.
2.5 Define `{FunctionName}ParameterDTO` and `{FunctionName}ResultDTO` for each function, using the actual ProgramName from the class.
2.6 Create a file named `{ParentProgramName}_project_structure_batch.md` in `/project-structure/` listing all batch classes and their functions with actual ProgramNames.

### Phase 3: Get Non Report and Batch Related Functions and Classes
3.1 Read `{ProgramName}Back` and `{ProgramName}Common` projects to get all remaining functions and classes that are not mentioned in phase 1 and 2. 
3.2 Identify ALL classes found (e.g., `FAB00200Cls`, `FAB00201Cls`, `FAB00202Cls`) and extract their actual ProgramNames:
   - Main Program: `FAB00200Cls` → ProgramName = `FAB00200`
   - Sub Programs: `FAB00201Cls` → ProgramName = `FAB00201`, ParentProgramName = `FAB00200`
   - Sub Programs: `FAB00202Cls` → ProgramName = `FAB00202`, ParentProgramName = `FAB00200`
3.3 For business object overridden functions in each Back class, create a single EntityDTO for all functions as `{ActualProgramName}DTO`.
3.4 For functions that are not business object overridden functions, define `{FunctionName}ParameterDTO` and `{FunctionName}ResultDTO` for each function using the actual ProgramName from the class (IMPORTANT!!).
3.5 If a function uses `StreamDTO`, replace it with dedicated `{FunctionName}ParameterDTO` and `{FunctionName}ResultDTO` using the actual ProgramName (IMPORTANT!!).
3.6 Create a file named `{ParentProgramName}_project_structure_main.md` in `/project-structure/` listing all main classes and their functions with actual ProgramNames.

### Phase 4: Compilation
4.1 All files created in phase 1, 2, and 3 must be copied (NO CHANGES) into `{ParentProgramName}_project_structure.md` in `/project-structure/`.
4.2 After compilation, delete all files created in phase 1, 2, and 3.

# Class Identification Logic

## ProgramName Extraction Rules
When analyzing VB.NET classes, extract ProgramNames using these rules:

1. **ParentProgramName**: Use the ProgramName provided in the prompt (e.g., `FAB00200`)
2. **Main Program Identification**: 
   - The class matching the provided ProgramName (e.g., `FAB00200Cls`) is the main program
   - ParentProgramName = provided ProgramName
3. **Sub Program Identification**:
   - All other classes found (e.g., `FAB00201Cls`, `FAB00202Cls`, `FAB00202001Cls`) are sub-programs
   - Extract their actual ProgramName from class name
   - ParentProgramName = provided ProgramName from prompt
4. **Output Format**:
   ```
   Provided ProgramName: FAB00200 → ParentProgramName: FAB00200
   Class: FAB00200Cls → ProgramName: FAB00200, ParentProgramName: FAB00200 (Main)
   Class: FAB00201Cls → ProgramName: FAB00201, ParentProgramName: FAB00200 (Sub)
   Class: FAB00202Cls → ProgramName: FAB00202, ParentProgramName: FAB00200 (Sub)
   ```

## File Naming Convention
- All output files use `{ParentProgramName}` (main program) as prefix
- Individual classes use their `{ActualProgramName}` in the class file names
- DTOs use `{ActualProgramName}` for their specific program