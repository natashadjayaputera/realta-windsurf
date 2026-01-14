---
trigger: glob
description: "Define HTTP client name convention for Model layer"
globs: "*ToCSharpModel*"
---

# HTTP Client Name Convention

- Most modules: `"R_DefaultServiceUrl{ModuleName}"` (e.g., `"R_DefaultServiceUrlFA"`)
- GS and SA modules only: `"R_DefaultServiceUrl"` (no suffix)