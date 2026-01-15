---
trigger: model_decision
description: "Use in ToCSharpCommon workflow to Checklist for {ProgramName}Common project migration"
---
# {ProgramName}Common

- [ ] All DTOs moved to Common project
- [ ] All enums consolidated here
- [ ] Interface `I{ProgramName}` using `R_IServiceCRUDAsyncBase`
- [ ] Each Interface has Entity DTO (`{ProgramName}DTO`)
- [ ] Parameter DTOs created
- [ ] Result DTOs created
- [ ] Parameter DTOs and Result DTOs is not inheriting from Entity DTOs
- [ ] Generic Result DTO created
- [ ] No business logic in Common