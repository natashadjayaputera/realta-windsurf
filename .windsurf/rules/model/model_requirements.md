---
trigger: glob
description: "Specify inheritance and API client usage for Model layer"
globs: "*ToCSharpModel*"
---

# Model Requirements

- Inherit `R_BusinessObjectServiceClientBase<{ProgramName}DTO>, I{ProgramName}`
- Use `R_HTTPClientWrapper` for all API calls