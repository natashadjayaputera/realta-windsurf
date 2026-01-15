---
trigger: model_decision
description: "Use in ToCSharpModel workflow to Define correct pattern for non-streaming API methods"
---

# Non-Streaming API Pattern

- MUST use `R_APIRequestObject<TResult, TParameter>()`
- MUST assign directly to `loRtn` (NOT `loRtn.Data`)
- MUST use complete ResultDTO type as `TResult`
- MUST use ParameterDTO type as `TParameter`