---
trigger: model_decision
description: "Use in ToCSharpViewModel workflow for Complete pattern for ViewModel streaming list method"
---


# Streaming Method Pattern (ViewModel)

- MUST follow @streaming_pattern.md
- MUST use `R_FrontContext.R_SetStreamingContext()` before calling Model methods.
- MUST assign `loResult.Data` → ObservableCollection of ResultDTO.
- NEVER use parameters in streaming methods
