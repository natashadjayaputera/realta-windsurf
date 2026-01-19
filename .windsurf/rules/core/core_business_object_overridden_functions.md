---
trigger: model_decision
description: "List of business object overridden functions"
---
# Business Object Overridden Functions

Business object overridden functions are functions that:
1. Use the `override` keyword
2. Start with `R_` prefix (e.g., `R_Saving`, `R_Deleting`, `R_Display`, `R_ServiceGetRecord`, `R_ServiceDelete`, `R_ServiceSave`)

These functions are part of the base class implementation pattern and should have a single EntityDTO (`{ProgramName}DTO`) rather than having individual parameter/result DTOs.

## Common Examples
- `R_Saving` 
- `R_Deleting`
- `R_Display`