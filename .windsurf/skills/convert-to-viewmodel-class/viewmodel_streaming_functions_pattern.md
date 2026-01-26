---
name: viewmodel_streaming_functions_pattern
description: "Standard streaming pattern for ViewModel functions"
---
# Streaming Functions Pattern
## Context 
```csharp
public class {FunctionName}ParameterDTO
{
    public string CCOMPANY_ID { get; set; } = string.Empty;
    public string CLANG_ID { get; set; } = string.Empty;
    public string CUSER_ID { get; set; } = string.Empty;
    public string CCURRENCY_CODE { get; set; } = string.Empty; // Example of non-standard property parameter
}

public static class ContextConstants
{
    public const string CCURRENCY_CODE = "{ProgramName}_CCURRENCY_CODE";
}
```

## Implementation
```csharp
private readonly {ProgramName}Model _model = new {ProgramName}Model();

// Properties.
public ObservableCollection<{FunctionName}ResultDTO> {FunctionName}List { get; set; } = new ObservableCollection<{FunctionName}ResultDTO>();
public {FunctionName}ResultDTO? {FunctionName}Record { get; set; }

// Function
public async Task {FunctionName}Async({FunctionName}ParameterDTO poParameter)
{
    var loEx = new R_Exception();

    try
    {
        R_FrontContext.R_SetStreamingContext(ContextConstants.CCURRENCY_CODE, poParameter.CCURRENCY_CODE); 

        var loResult = await _model.{FunctionName}Async();

        {FunctionName}List = new ObservableCollection<{FunctionName}ResultDTO>(loResult.Data ?? new List<{FunctionName}ResultDTO>());
        {FunctionName}Record = {FunctionName}List.FirstOrDefault();
    }
    catch (Exception ex)
    {
        loEx.Add(ex);
    }

    loEx.ThrowExceptionIfErrors();
}
```

Rules:
- Must create `{FunctionName}List` and `{FunctionName}Record` properties
- All function that return list must use `ObservableCollection`
- Use `R_FrontContext.R_SetStreamingContext(ContextConstants.Key, value)` to set streaming context
- Set streaming context per property
- Call model's `{FunctionName}Async()` function, not `{FunctionName}()`.

For more details, see `streaming_pattern.md`