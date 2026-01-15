---
trigger: model_decision
description: "Use in ToCSharpModel workflow to Specify inheritance and API client usage for Model layer"
---

# Model Requirements

- Inherit `R_BusinessObjectServiceClientBase<{ProgramName}DTO>, I{ProgramName}`
- Use `R_HTTPClientWrapper` for all API calls