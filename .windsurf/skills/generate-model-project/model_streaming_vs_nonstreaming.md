---
name: model_streaming_vs_nonstreaming
description: "Clarify differences between streaming and non-streaming API patterns in Model layer"
---

# Streaming vs Non-Streaming Differences

### Non-Streaming
- Use `R_APIRequestObject<TResult, TParameter>()`
- Returns **full ResultDTO**
- Assignment: `loRtn = await R_HTTPClientWrapper.R_APIRequestObject<...>()`
- ❌ Do NOT use `.Data`

### Streaming
- Use `R_APIRequestStreamingObject<T>()`
- Returns **data only**
- Assignment: `loRtn.Data = await R_HTTPClientWrapper.R_APIRequestStreamingObject<...>()`