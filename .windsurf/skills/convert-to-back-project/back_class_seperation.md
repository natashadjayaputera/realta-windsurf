---
name: back_class_seperation
description: "How to separate main, report, and batch classes in Common and Back project"
---

# Class Separation

- `{ProgramName}Cls.cs` → Main business logic (inherits)
- `{ProgramName}ReportCls.cs` → Report operations only (standalone)
- `{ProgramName}BatchCls.cs` → Batch operations only (standalone)

IMPORTANT: PLEASE SEPERATE THE CLASSES AND FOLLOW THE RULES MENTIONED IN THIS FILE.

# How to seperate
1. Report Class ({ProgramName}ReportCls.cs)
    - Move a function to this class if any of the following applies:
        - The function name contains `Report` or `Print`
        - The function is located inside a region related to reporting or printing
    - The function’s responsibility is report generation, formatting, or printing only
    - This class must be standalone and must follow `report_project_structure.md` and `report_function_implementation.md`

2. Batch Class ({ProgramName}BatchCls.cs)
    - Move a function to this class if any of the following applies:
        - The function name contains `Batch` or `Bulk`
        - The function uses `R_BulkInsert`
        - The function uses `R_BatchProcess`
    - The function’s responsibility is batch or bulk processing only
    - This class must be standalone and must follow `batch_project_structure.md` and `batch_interface_implementation_pattern.md`

3. Main Class ({ProgramName}Cls.cs)
    - Contains all remaining business logic
    - Must inherit from `R_BusinessObjectAsync`
    - Must not contain report or batch logic

CRITICAL:
- It's critical that you follow all the rules mentioned above.
