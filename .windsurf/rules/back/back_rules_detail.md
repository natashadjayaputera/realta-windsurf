---
trigger: model_decision
description: "Use in ToCSharpBack workflow to Detailed rules for Back layer business logic and logging"
---
# Business Logic & Logging Rules

- MUST use `GetError()` for all errors
- MUST never modify SQL/SP names
- MUST log method start/end
- MUST separate report/batch methods into dedicated classes
- MUST preserve exact VB.NET business logic
- MUST implement R_*Async override (throw `NotImplementedException`)
- MUST follow back_patterns.md for implementation details
- MUST follow class seperation rules. See @back_class_separation.md