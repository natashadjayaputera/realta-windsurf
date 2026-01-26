---
name: back_violations
description: "Forbidden practices in Back projects"
---
# Violations
- ❌ Logger/Activity in Common
- ❌ Custom Logger/Activity implementations
- ❌ Missing query logging
- ❌ Missing START/END logging
- ❌ Hardcoded error messages
- ❌ Manual connection disposal
- ❌ Report or batch functions in main class
- ❌ Interface functions mismatch
- ❌ Missing R_*Async override
- ❌ Inventing new resource keys
- ❌ Changing validation error codes from VB.NET
- ❌ Streaming function returns `IAsyncEnumerable<{FunctionName}ResultDTO>` instead of `Task<List<{FunctionName}ResultDTO>>`