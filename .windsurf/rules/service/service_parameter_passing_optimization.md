---
trigger: model_decision
description: "Use in ToCSharpService workflow for Optimized parameter passing strategy for controllers"
---

# Parameter Passing Optimization

- When controller and business logic share the same DTO → **pass directly**  
  (no need to create new instances)

- **Streaming methods:** use  
  `R_Utility.R_GetStreamingContext()`  
  to obtain parameters instead of method arguments

- **Non-streaming methods:**  
  must use specific `ParameterDTO` in both interface and implementation

- Do not create redundant DTOs when unnecessary