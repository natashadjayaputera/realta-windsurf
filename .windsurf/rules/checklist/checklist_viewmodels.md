---
trigger: model_decision
description: "Use in ToCSharpViewModel and ToCSharpFrontworkflow to Checklist for ViewModels in {ProgramName} project"
---
# ViewModels

- [ ] All ViewModels in `{ProgramName}Model/VMs/` folder
- [ ] All methods accepting parameters (no R_FrontGlobalVar usage)
- [ ] List methods using `R_FrontContext.R_SetStreamingContext()` pattern
- [ ] Error handling with `R_Exception`
- [ ] Logging where appropriate
- [ ] Public properties using PascalCase (no underscore prefix)
- [ ] Private fields using `_snakeCase` (no type prefix)