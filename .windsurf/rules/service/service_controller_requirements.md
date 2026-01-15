---
trigger: model_decision
description: "Use in ToCSharpService workflow for Controller inheritance, attributes, and route patterns for Service layer"
---

# Controller Requirements

- Must inherit from:  
  `ControllerBase, I{ProgramName}`
- All methods decorated with `[HttpPost]`
- Route pattern: `[Route("api/[controller]/[action]")]`
- Logger and Activity must be initialized in constructor