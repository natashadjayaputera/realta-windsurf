---
name: model_nonstreaming_api_pattern
description: "Define correct pattern for non-streaming API methods in Model layer"
---

# Non-Streaming API Pattern

- MUST use `R_APIRequestObject<TResult, TParameter>()`
- MUST assign directly to `loRtn` (NOT `loRtn.Data`)
- MUST use complete ResultDTO type as `TResult`
- MUST use ParameterDTO type as `TParameter`

# Example

## Non-Streaming API with Parameter
```csharp
public async Task<{ProgramName}ResultDTO<{FunctionName}ResultDTO>> {FunctionName}Async({FunctionName}ParameterDTO poParameter)
{
    var loEx = new R_Exception();
    var loRtn = new {ProgramName}ResultDTO<{FunctionName}ResultDTO>();
    try
    {
        R_HTTPClientWrapper.httpClientName = _HttpClientName;
        loRtn = await R_HTTPClientWrapper.R_APIRequestObject<{ProgramName}ResultDTO<{FunctionName}ResultDTO>, {FunctionName}ParameterDTO>(
            _RequestServiceEndPoint,
            nameof(I{ProgramName}.{FunctionName}),
            poParameter,
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

## Non-Streaming API without Parameter
```csharp
public async Task<{ProgramName}ResultDTO<{FunctionName}ResultDTO>> {FunctionName}Async()
{
    var loEx = new R_Exception();
    var loRtn = new {ProgramName}ResultDTO<{FunctionName}ResultDTO>();
    try
    {
        R_HTTPClientWrapper.httpClientName = _HttpClientName;
        loRtn = await R_HTTPClientWrapper.R_APIRequestObject<{ProgramName}ResultDTO<{FunctionName}ResultDTO>>(
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