---
trigger: model_decision
description: "Use in SolutionManager workflow for Standardized error handling for solution operations"
---

# Error Handling

- **MUST** provide meaningful messages for all errors  
- **MUST** suggest actionable fixes  
- **MUST** validate solution integrity before success  
- **NEVER** continue with corrupted state  
- **NEVER** ignore syntax or reference errors