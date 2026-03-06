---
name: 02-create-processes-other-function
description: A tool to create processes function blocks from .YAML files.
---

# Overview 
Create processes function blocks from .YAML files.

# Process
## Phase 1: Create Parameter DTO
1.1 Read each file in `{ROOT}/chunks_cs/{ProgramName}/{SubProgramName}/processes/` and process file that is `category: other-function` and `category: initialization`.
1.2 Read parameter_dto_pattern
1.3 If no `run_stored_procedure` found, do NOT create parameter DTO.
1.4 For each `run_stored_procedure` found, include it inside the Parameter DTO.
1.5 Create a Parameter DTO for each file in `{ROOT}/chunks_cs/{ProgramName}/{SubProgramName}/dtos/`.
1.6 The DTO should be named `{SubProgramName}{ProcessName}ParameterDTO`.
1.7 The DTO should contain all the `run_stored_procedure` as separate properties

## Phase 2: Create Result DTO
2.1 Read each file in `{ROOT}/chunks_cs/{ProgramName}/{SubProgramName}/processes/` and process file that is `category: other-function` and `category: initialization`.
2.2 Read result_dto_pattern
2.3 If no `save_to` field found, do NOT create result DTO.
2.4 For each `run_stored_procedure` that has `save_to` field, include it inside the Result DTO.
2.5 Create a Result DTO for each file in `{ROOT}/chunks_cs/{ProgramName}/{SubProgramName}/dtos/`.
2.6 The DTO should be named `{SubProgramName}{ProcessName}ResultDTO`.
2.7 The DTO should contain all the `save_to` fields as separate properties. 
2.8 Please check whether it returns a single record or a list of records based on `{ROOT}/partials/{ProgramName}/{SubProgramName}/stored-procedure/sp_list.txt`.

## Phase 3: Create Process Function Block
3.1 Read each file in `{ROOT}/chunks_cs/{ProgramName}/{SubProgramName}/processes/` and process file that is `category: other-function` and `category: initialization`.
3.2 Read back_database_function_pattern as pattern to create Process Function Block.
3.3 Create a Process Function Block for each file in `{ROOT}/chunks_cs/{ProgramName}/{SubProgramName}/processes/`.
3.4 The Process Function Block should be named `{XXXX}_{ProcessName}.cs` where `{XXXX}` is the sequential number with leading zeros (e.g. `0001`, `0002`, etc.).
3.5 The Process Function Block should contain all the logic extracted from the file.

## Phase 4: Update `functions.txt`
4.1 Every function created in Phase 3 should be added to `{ROOT}/chunks_cs/{ProgramName}/{SubProgramName}/functions.txt`.