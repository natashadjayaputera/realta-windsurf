---
trigger: model_decision
description: "Use in ToCSharpViewModel and ToCSharpFront workflow to Prohibit lookup and description logic in ViewModels"
---
# Lookup Rule

- No lookup or description properties (e.g., CurrencyName, DepartmentDesc) in ViewModels
- No lookup data retrieval logic in ViewModels
- All lookup handling must be done in Razor layer only  
