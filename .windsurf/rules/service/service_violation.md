---
trigger: model_decision
description: "Use in ToCSharpService workflow for Prohibited patterns and known violations for Service layer"
---

# Violations

- ❌ `IAsyncEnumerable` methods with parameters  
- ❌ Setting `R_BackGlobalVar` manually  
- ❌ Missing `R_BackGlobalVar` usage for IClientHelper data  
- ❌ Putting business logic inside controllers  
- ❌ Wrong route patterns  
- ❌ Calling protected methods (`R_DisplayAsync`, `R_SavingAsync`, etc.) from controllers  
- ❌ Creating redundant parameter DTOs when types already match  