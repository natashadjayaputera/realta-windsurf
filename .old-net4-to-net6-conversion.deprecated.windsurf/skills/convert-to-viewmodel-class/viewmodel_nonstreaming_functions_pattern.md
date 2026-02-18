---
name: viewmodel_nonstreaming_functions_pattern
description: "Standard non-streaming pattern for ViewModel functions"
---
# Non-Streaming Functions Pattern
## Context 
```csharp
public class {FunctionName}ParameterDTO
{
    public string CCOMPANY_ID { get; set; } = string.Empty;
    public string CLANG_ID { get; set; } = string.Empty;
    public string CUSER_ID { get; set; } = string.Empty;
    public string CCURRENCY_CODE { get; set; } = string.Empty; 
}
```

## Implementation
### Non-Streaming Functions With Parameters
```csharp
private readonly {ProgramName}Model _model = new {ProgramName}Model();

// Property
public {FunctionName}ResultDTO {FunctionName}Record { get; set; } = new {FunctionName}ResultDTO();

// Function
public async Task {FunctionName}Async({FunctionName}ParameterDTO poParameter)
{
    var loEx = new R_Exception();

    try
    {
        var loResult = await _model.{FunctionName}Async(poParameter);

        {FunctionName}Record = loResult;
    }
    catch (Exception ex)
    {
        loEx.Add(ex);
    }

    loEx.ThrowExceptionIfErrors();
}
```

### Non-Streaming Functions Without Parameters
```csharp
private readonly {ProgramName}Model _model = new {ProgramName}Model();

// Property
public {FunctionName}ResultDTO {FunctionName}Record { get; set; } = new {FunctionName}ResultDTO();

// Function
public async Task {FunctionName}Async()
{
    var loEx = new R_Exception();

    try
    {
        var loResult = await _model.{FunctionName}Async();

        {FunctionName}Record = loResult;
    }
    catch (Exception ex)
    {
        loEx.Add(ex);
    }

    loEx.ThrowExceptionIfErrors();
}
```

