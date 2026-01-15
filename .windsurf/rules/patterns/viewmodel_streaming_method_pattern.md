---
trigger: glob
description: "Complete pattern for ViewModel streaming list method"
globs: "*ToCSharpViewModel*"
---


# Streaming Method Pattern (ViewModel)

- MUST follow @streaming_pattern.md
- MUST use `R_FrontContext.R_SetStreamingContext()` before calling Model methods.
- MUST assign `loResult.Data` → ObservableCollection of ResultDTO.
- NEVER use parameters in streaming methods
