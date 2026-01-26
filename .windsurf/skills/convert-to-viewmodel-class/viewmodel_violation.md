---
name: viewmodel_violation
description: "Prohibited patterns and known violations for ViewModel layer"
---

# Violations

- Create constructor for ViewModels.
- Use `R_BackGlobalVar.*` 
- Use `R_FrontGlobalVar.*` 
- Use `IClientHelper`
- Pass parameters to model streaming functions, use streaming context instead.
- Return streaming functions from ViewModels instead of populating properties.
- Return CRUD functions from ViewModels instead of populating properties.
- Orphaned properties that are not used in the ViewModels.
- Create single ViewModel for multiple R_Conductor or R_ConductorGrid on same page.
- Validation logic, if any, returns R_Exception.
- Hardcoded error messages instead of resource-based messages.
- Create helper for resource retrieval. Just use `R_FrontUtility.R_GetError` and `R_FrontUtility.R_GetMessage` directly.
- Missing CRUD functions (even if not used, just throw NotImplementedException()).
