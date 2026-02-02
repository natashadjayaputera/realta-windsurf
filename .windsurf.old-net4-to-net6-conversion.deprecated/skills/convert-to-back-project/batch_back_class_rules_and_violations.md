---
name: batch_back_class_rules_and_violations
description: "Rules for batch processing class in Back Project"
---
# CLASS RULES

## Implementation Rules
- `R_IBatchProcessAsync` must be implemented in each batch class in Back Project. See `batch_interface_implementation_pattern.md`
- Class must initialize `Logger` and `ActivitySource`
- Batch functions should be contained **only** in the batch class
- Do not include batch related process in interface (`I{ProgramName}`) and in controller

## Violations
- Adding batch related process in interface
- Adding batch related process in controller
- Modifying stored procedure names or parameters
- Implementing batch logic in main business class
- Missing Logger or ActivitySource initialization