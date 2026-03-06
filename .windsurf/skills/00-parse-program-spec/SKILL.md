---
name: 00-parse-program-spec
description: A tool to parse program specification files (.md) into (.YAML format).
---

# Overview
Parse program specification files (.md) into (.YAML format).

# Process
## Phase 1: Parse program specification
1.1 Read {ProgramSpecFile} and convert it into .YAML format, following patterns.yaml file and put it inside `{ROOT}/partials/{ProgramName}/` folder with filename `{ProgramName}.yaml`.

## Phase 2: Complete information
2.1 Read `{ROOT}/partials/{ProgramName}/{ProgramName}.yaml` and assign categories for each processes.

Each process should have categories:
1. business-object-overridden-function
   1. if process has `start_update_process` and `end_update_process`, it is a business-object-overridden-function
   2. if process has `start_delete_process` and `end_delete_process`, it is a business-object-overridden-function
   3. if process has `start_display_process` and `end_display_process`, it is a business-object-overridden-function
2. batch-function
   1. if process has start_batch_process and end_batch_process, it is a batch-function
3. initialization
   1. all process which name is 'INITIAL_PROCESS'
4. other-function
   1. every function that is not assigned to other categories

2.2 Assign `sub_program_id` for each tabs. First tab should have `sub_program_id` = {ProgramName}. Each subsequent tab should have `sub_program_id` = {ProgramName} + 1.

2.3 Make sure all conditions following the patterns

Example:
```yaml
conditions:
   operator: and
   conditions:
         operator: equals
         field:
            source: selected_row
            variable: VAR_JOURNAL_LIST
            column: CSTATUS
         value: "10"
         operator: equals
         field: VAR_GSM_TRANSACTION_CODE.LAPPROVAL_FLAG
         value: true
   true: Enabled
   false: Disabled
```

List of operators:
- equals
- not_equals
- greater_than
- less_than
- greater_or_equal
- less_or_equal
- is_empty
- is_not_empty
- in
- not_in
- is_error
- and
- or
- not
- group

