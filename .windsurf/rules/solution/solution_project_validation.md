---
trigger: model_decision
description: "Use in SolutionManager workflow for Program Module validation before loading solution projects"
---

# Program Module Validation

- **MUST** validate ProgramModule before loading projects  
- **MUST** map ProgramModule to correct solution and API project  
- **NEVER** load projects without confirming module structure  
- **NEVER** assume module mapping without verification