---
name: 00-create-stored-procedure-resource
description: A tool to extract stored procedure resources from .txt files into formatted resource files.
---

# Overview
Extract stored procedure resources from .txt files into formatted resource files.

## Phase 1: Create stored procedure resources
1.1 All `.txt` files you can find inside {StoredProcedureResourceFolder} are stored procedure resources.
1.2 For each stored procedure resources found in {StoredProcedureResourceFolder} check `sp_list.txt` to see if it exists in the list. If it does exist, convert the stored procedure resource to the format defined in `{ROOT}/partials/README.md` and place it in the appropriate folder structure.
- Must have `module_name` as the first line in the file
- Separator must use `|`
- Resource key must not change (it's in 0-9A-Za-z format)
- Remove empty line
- All lines must be converted
1.3 If stored procedure resource file is not found inside {StoredProcedureResourceFolder}, skip it.

