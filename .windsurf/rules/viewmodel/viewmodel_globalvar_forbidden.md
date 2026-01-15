---
trigger: model_decision
description: "Use in ToCSharpViewModel workflow for Disallow usage of R_FrontGlobalVar and R_BackGlobalVar in ViewModels"
---
# R_FrontGlobalVar Forbidden

- NEVER use `R_BackGlobalVar.*` or `R_FrontGlobalVar.*` in ViewModels.
- Values must come from parameters, not globals.  

❌ Example (violation):
```csharp
poEntity.CCOMPANY_ID = R_BackGlobalVar.COMPANY_ID;
poEntity.CCOMPANY_ID = R_FrontGlobalVar.COMPANY_ID;
```
