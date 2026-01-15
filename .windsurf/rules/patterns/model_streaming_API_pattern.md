---
trigger: model_decision
description: "Use in ToCSharpModel workflow to Define correct pattern for streaming API methods"
---

# Streaming API Pattern

- MUST follow @streaming_pattern.md
- MUST use `R_APIRequestStreamingObject<T>()`
- MUST assign to `loRtn.Data` (NOT `loRtn`)
- MUST use data type as generic parameter
- MUST have interface method throw `NotImplementedException`