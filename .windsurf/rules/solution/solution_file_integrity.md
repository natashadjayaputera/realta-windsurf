---
trigger: model_decision
description: "Use in SolutionManager workflow for Maintain correct and complete .sln file structure"
---

# Solution File Integrity

- **MUST** preserve valid solution file syntax  
- **MUST** update:  
  - Project definitions  
  - Build configurations  
  - Nested mappings  
- **NEVER** corrupt `.sln` file  
- **NEVER** leave incomplete project entries