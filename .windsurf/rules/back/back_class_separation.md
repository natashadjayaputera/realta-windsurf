---
trigger: model_decision
description: "Use in ToCSharpBack workflow to Separate main, report, and batch classes in Back project"
---
# Class Separation

- `{ProgramName}Cls.cs` → Main business logic (inherits `R_BusinessObjectAsync`)
- `{ProgramName}ReportCls.cs` → Report operations only (standalone), see @report_method_implementation.md
- `{ProgramName}BatchCls.cs` → Batch operations only (standalone), see @batch_interface_implementation_pattern.md