---
name: report_rules_and_violations
description: "Defines all enforcement and violation rules for report-related files"
alwaysApply: false
---
# Report Rules

✅ Required:
- Report functions must not be part of any interface
- Each Report operation must have its own **ReportCls** class
- Constructor includes Logger and ActivitySource setup
- Report functions are **synchronous**
- Separate result DTOs (non-streaming)

❌ Violations:
- ❌ Adding Report functions to Common or Service interfaces
- ❌ Modifying stored procedure names or parameters
- ❌ Using async/await for Report operations
- ❌ Using StreamDTO for Report results
- ❌ Placing Report functions inside the main business class
- ❌ Missing Logger or ActivitySource initialization