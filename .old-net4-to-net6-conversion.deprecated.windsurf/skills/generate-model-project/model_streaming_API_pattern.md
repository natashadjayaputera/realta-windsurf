---
name: model_streaming_API_pattern
description: "Define correct pattern for streaming API methods in Model layer"
---

# Streaming API Pattern

- MUST follow `streaming_pattern.md`
- MUST use `R_APIRequestStreamingObject<T>()`
- MUST assign to `loRtn.Data` (NOT `loRtn`)
- MUST use data type as generic parameter
- MUST have interface method throw `NotImplementedException`

# Example
```csharp
// Not used — interface compliance only
public IAsyncEnumerable<{FunctionName}ResultDTO> {FunctionName}()
{
    throw new NotImplementedException();
}

// This is actual logic to get the data from API
public async Task<{ProgramName}ResultDTO<List<{FunctionName}ResultDTO>>> {FunctionName}Async()
{
    var loEx = new R_Exception();
    var loRtn = new {ProgramName}ResultDTO<List<{FunctionName}ResultDTO>>();
    try
    {
        R_HTTPClientWrapper.httpClientName = _HttpClientName;
        loRtn.Data = await R_HTTPClientWrapper.R_APIRequestStreamingObject<{FunctionName}ResultDTO>(
            _RequestServiceEndPoint,
            nameof(I{ProgramName}.{FunctionName}),
            _ModuleName,
            true,
            true);
    }
    catch (Exception ex)
    {
        loEx.Add(ex);
    }
    loEx.ThrowExceptionIfErrors();
    return loRtn;
}
```