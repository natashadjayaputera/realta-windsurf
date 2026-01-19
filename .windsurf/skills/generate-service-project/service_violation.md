---
name: service_violation
description: "Prohibited patterns and known violations for Service layer"
---

# Violations

- `IAsyncEnumerable` methods with parameters  
- Assigning value to `R_BackGlobalVar`, `R_BackGlobalVar` is get only property.
- Putting business logic inside controllers  
- Wrong route patterns  
- Calling protected methods (`R_DisplayAsync`, `R_SavingAsync`, etc.) from controllers  
- Creating redundant parameter DTOs