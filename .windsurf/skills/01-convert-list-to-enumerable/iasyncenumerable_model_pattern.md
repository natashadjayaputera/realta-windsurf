---
name: iasyncenumerable_model_pattern
description: "Pattern for converting List implementation to IAsyncEnumerable implementation in C# models"
---

## Conversion Requirements

**NEED TO CONVERT from List implementation to IAsyncEnumerable implementation:**

1. **Change return type from actual interface implementation** from `Task<{ProgramName}ResultDTO<List<{FunctionReturnType}>>>` to `IAsyncEnumerable<{FunctionReturnType}>`
2. **Remove async Task wrapper** - use direct `IAsyncEnumerable<{FunctionReturnType}>` return
3. **Remove parameters** from method signature
4. **Change API call** from `R_APIRequestObject` to `R_APIRequestStreamingObject`
5. **Maintain error handling** patterns
6. **Change return variable assignment** - from `loRtn = await R_HTTPClientWrapper.R_APIRequestObject<...>` to `loRtn.Data = await R_HTTPClientWrapper.R_APIRequestStreamingObject<...>`

## Before (List Implementation)

```csharp
#region {FunctionName}
public Task<{ProgramName}ResultDTO<List<{SubProgramName}{FunctionName}ResultDTO>>> {FunctionName}({SubProgramName}{FunctionName}ParameterDTO poParameter)
{
    throw new NotImplementedException();
}

// This is the format for actual function implementation:
public async Task<{ProgramName}ResultDTO<List<{SubProgramName}{FunctionName}ResultDTO>>> {FunctionName}Async({SubProgramName}{FunctionName}ParameterDTO poParameter)
{
    var loEx = new R_Exception();
    var loRtn = new {ProgramName}ResultDTO<List<{SubProgramName}{FunctionName}ResultDTO>>();
    try
    {
        R_HTTPClientWrapper.httpClientName = _HttpClientName;
        
        // If the function has parameter, use the following format:
        loRtn = await R_HTTPClientWrapper.R_APIRequestObject<{ProgramName}ResultDTO<List<{SubProgramName}{FunctionName}ResultDTO>>, {SubProgramName}{FunctionName}ParameterDTO>(
            _RequestServiceEndPoint,
            nameof(I{SubProgramName}.{FunctionName}),
            poParameter,
            _ModuleName,
            true,
            true);

        // If the function has no parameter, use the following format:
        // loRtn = await R_HTTPClientWrapper.R_APIRequestObject<{ProgramName}ResultDTO<List<{SubProgramName}{FunctionName}ResultDTO>>>(
        //     _RequestServiceEndPoint,
        //     nameof(I{SubProgramName}.{FunctionName}),
        //     _ModuleName,
        //     true,
        //     true);
    }
    catch (Exception ex)
    {
        loEx.Add(ex);
    }
    loEx.ThrowExceptionIfErrors();
    return loRtn;
}
#endregion
```

## After (IAsyncEnumerable Implementation)

```csharp
#region {FunctionName}
public IAsyncEnumerable<{SubProgramName}{FunctionName}ResultDTO> {FunctionName}()
{
    throw new NotImplementedException();
}

// This is the format for actual function implementation:
public async Task<{ProgramName}ResultDTO<List<{SubProgramName}{FunctionName}ResultDTO>>> {FunctionName}Async()
{
    var loEx = new R_Exception();
    var loRtn = new {ProgramName}ResultDTO<List<{SubProgramName}{FunctionName}ResultDTO>>();
    try
    {
        R_HTTPClientWrapper.httpClientName = _HttpClientName;
        
        // If the function has parameter, use the following format:
        loRtn.Data = await R_HTTPClientWrapper.R_APIRequestStreamingObject<{SubProgramName}{FunctionName}ResultDTO>(
            _RequestServiceEndPoint,
            nameof(I{SubProgramName}.{FunctionName}),
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
#endregion
```




