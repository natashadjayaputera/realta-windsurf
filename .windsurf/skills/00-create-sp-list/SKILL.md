---
name: 00-create-sp-list
description: A tool to extract program specification files (.YAML) into sp_list.txt.
---

# Overview
Extract information from (.YAML) file into sp_list.txt.

## Phase 1: Extract information
1.1 Seperate `{ROOT}/partials/{ProgramName}/{ProgramName}.yaml` into different file based on `sub_program_id` into `{ROOT}/partials/{ProgramName}/{ProgramName}_{sub_program_id}.yaml`.
1.2 Extract each `process_id` from `{ROOT}/partials/{ProgramName}/{ProgramName}_{sub_program_id}.yaml` and get the list of `run_stored_procedure.name` and save it into `sp_list.txt`. Please follow folder structure and `sp_list.txt` file format defined in `{ROOT}/partials/README.md` (this is non-negotiable).
1.3 All stored procedure created in `sp_list.txt` should be marked as `other-function` 