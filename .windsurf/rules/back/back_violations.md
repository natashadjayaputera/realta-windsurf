---
trigger: model_decision
description: "Use in ToCSharpBack workflow to Forbidden practices in Back projects"
---
# Violations
- ❌ Logger/Activity in Common
- ❌ Custom Logger/Activity implementations
- ❌ Missing query logging
- ❌ Missing START/END logging
- ❌ Hardcoded error messages
- ❌ Manual connection disposal
- ❌ Report or batch methods in main class
- ❌ Interface methods mismatch
- ❌ Missing R_*Async override
- ❌ Inventing new resource keys
- ❌ Changing validation error codes from VB.NET