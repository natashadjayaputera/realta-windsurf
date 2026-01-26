---
name: project-analyzer
description: A tool to analyze VB.NET (.NET Framework 4) Project structure as a basis for project conversion.
---

# Overview 
Analyze VB.NET (.NET Framework 4) Project structure as a basis for project conversion.

# Process
## High-Level Workflows

Analyzing VB.NET (.NET Framework 4) Project structure involves 4 phases:

### Phase 1: Get All Report Related Functions and Class
1.1 Read ONLY `{ProgramName}Back` and `{ProgramName}Common` projects to get all report related functions and classes (NO .rpt files).
1.2 To get all report related functions and class:
- The function name contains `Report` or `Print`
- The function is located inside a region related to reporting or printing
1.3 If found, add `{ProgramName}ReportCls.cs` in .NET 6 `{ProgramName}Back` project, DO NOT create a seperate project.
1.4 Define `{FunctionName}ParameterDTO` and `{FunctionName}ResultDTO` for each function.
1.5 Create a file named `{ProgramName}_project_structure_report.md` in `/project-structure/`.

### Phase 2: Get All Batch Related Functions and Class
2.1 Read ONLY `{ProgramName}Back` and `{ProgramName}Common` projects to get all batch related functions and classes.
2.2 To get all batch related functions and class:
- The function name contains `Batch` or `Bulk`
- The function uses `R_BulkInsert`
- The function uses `R_BatchProcess`
2.3 If found, add `{ProgramName}BatchCls.cs` in .NET 6 `{ProgramName}Back` project, DO NOT create a seperate project.
2.4 Define `{FunctionName}ParameterDTO` and `{FunctionName}ResultDTO` for each function.
2.5 Create a file named `{ProgramName}_project_structure_batch.md` in `/project-structure/`.

### Phase 3: Get Non Report and Batch Related Functions and Class
3.1 Read `{ProgramName}Back` and `{ProgramName}Common` projects to get all remaining functions and class that is not mentioned in phase 1 and 2.
3.2 For business object overridden functions in Back class, create a single EntityDTO for all functions as `{ProgramName}DTO`.
3.3 For functions that are not business object overridden functions, define `{FunctionName}ParameterDTO` and `{FunctionName}ResultDTO` for each function (IMPORTANT!!).
3.4 If a function uses `StreamDTO`, replace it with dedicated `{FunctionName}ParameterDTO` and `{FunctionName}ResultDTO` (IMPORTANT!!).
3.5 Create a file named `{ProgramName}_project_structure_main.md` in `/project-structure/`.

### Phase 4: Compilation
4.1 All files created in phase 1, 2, and 3 must be copied (NO CHANGES) into `{ProgramName}_project_structure.md` in `/project-structure/`.
4.2 After compilation, delete all files created in phase 1, 2, and 3.