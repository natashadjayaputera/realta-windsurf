---
trigger: model_decision
description: "Use in ToCSharpBack workflow to enforce {ProgramName}Back project structure for business logic, logging, and resources"
---
# Project Structure
## Back Project
- Location: `BACK/{module}/{ProgramName}Back/`
- Target: `net6.0`
- Purpose: Business logic and logging.

## Back Resource Project
- Location: `BACK/{module}/{ProgramName}BackResources/`
- Target: `netstandard2.1`
- Purpose: Contains `.resx` message files, designer class, and dummy resource class 