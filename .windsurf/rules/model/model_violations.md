---
trigger: glob
description: "List forbidden practices in Model layer"
globs: "*ToCSharpModel*"
---

# Violations

- ❌ Not following Model Pattern from `model_patterns.md`
- ❌ Using `.Data` assignment for non-streaming methods
- ❌ Using inner types instead of complete ResultDTO types
- ❌ Missing 6th parameter for method disambiguation