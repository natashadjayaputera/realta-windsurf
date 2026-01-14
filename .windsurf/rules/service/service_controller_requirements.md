---
trigger: glob
description: "Controller inheritance, attributes, and route patterns for Service layer"
globs: "*ToCSharpService*"
---

# Controller Requirements

- Must inherit from:  
  `ControllerBase, I{ProgramName}`
- All methods decorated with `[HttpPost]`
- Route pattern: `[Route("api/[controller]/[action]")]`
- Logger and Activity must be initialized in constructor