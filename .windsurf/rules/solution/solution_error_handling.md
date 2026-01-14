---
trigger: glob
description: "Standardized error handling for solution operations"
globs: "*SolutionManager*"
---

# Error Handling

- **MUST** provide meaningful messages for all errors  
- **MUST** suggest actionable fixes  
- **MUST** validate solution integrity before success  
- **NEVER** continue with corrupted state  
- **NEVER** ignore syntax or reference errors