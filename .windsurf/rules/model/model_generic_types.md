---
trigger: model_decision
description: "Use in ToCSharpModel workflow to specify generic type usage in Model layer methods"
---

# Generic Type Rules

- **TResult**: Complete ResultDTO type (e.g., `FAM00100ResultDTO<int>`)
- **TParameter**: ParameterDTO type (e.g., `FAM00100CheckDataParameterDTO`)
- NEVER use inner data types as generic parameters