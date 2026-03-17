---
name: iasyncenumerable_viewmodel_pattern.md
description: "Pattern for converting List implementation to IAsyncEnumerable implementation in C# models"
---

## Conversion Requirements

**NEED TO CONVERT from List implementation to IAsyncEnumerable implementation:**

1. **Set streaming context** using `R_FrontContext.R_SetStreamingContext` before calling the model method
2. **Change property type** from `List<T>` to `ObservableCollection<T>` for proper UI binding
3. **Remove parameter from model call** - the model method call becomes parameterless since streaming context handles parameters
4. **Wrap result in ObservableCollection constructor** to ensure proper collection initialization
5. **Maintain error handling** patterns
6. **Keep FirstOrDefault logic** for setting the Record property

## Before (List Implementation)

```csharp
#region {FunctionName}Async
// Property
public List<{SubProgramName}{FunctionName}ResultDTO> {FunctionName}List { get; set; } = new List<{SubProgramName}{FunctionName}ResultDTO>();
public {SubProgramName}{FunctionName}ResultDTO? {FunctionName}Record { get; set; } = null;

// Function
public async Task {FunctionName}Async({SubProgramName}{FunctionName}ParameterDTO poParameter)
{
    var loEx = new R_Exception();

    try
    {
        var loResult = await _model.{FunctionName}Async(poParameter);

        {FunctionName}List = loResult.Data ?? new List<{SubProgramName}{FunctionName}ResultDTO>(); 
        {FunctionName}Record = {FunctionName}List.FirstOrDefault();
    }
    catch (Exception ex)
    {
        loEx.Add(ex);
    }

    loEx.ThrowExceptionIfErrors();
}
#endregion
```

## After (IAsyncEnumerable Implementation)

```csharp
#region {FunctionName}Async
// Property
public ObservableCollection<{SubProgramName}{FunctionName}ResultDTO> {FunctionName}List { get; set; } = new ObservableCollection<{SubProgramName}{FunctionName}ResultDTO>();
public {SubProgramName}{FunctionName}ResultDTO? {FunctionName}Record { get; set; } = null;

// Function
public async Task {FunctionName}Async({SubProgramName}{FunctionName}ParameterDTO poParameter)
{
    var loEx = new R_Exception();

    try
    {
        R_FrontContext.R_SetStreamingContext(ContextConstants.{SubProgramName}_{STRING_PROPERTY_1}, poParameter.{STRING_PROPERTY_1});
        R_FrontContext.R_SetStreamingContext(ContextConstants.{SubProgramName}_{BOOL_PROPERTY_1}, poParameter.{BOOL_PROPERTY_1});
        R_FrontContext.R_SetStreamingContext(ContextConstants.{SubProgramName}_{INT_PROPERTY_1}, poParameter.{INT_PROPERTY_1});
        R_FrontContext.R_SetStreamingContext(ContextConstants.{SubProgramName}_{DATETIME_PROPERTY_1}, poParameter.{DATETIME_PROPERTY_1});

        var loResult = await _model.{FunctionName}Async();

        {FunctionName}List = new ObservableCollection<{SubProgramName}{FunctionName}ResultDTO>(loResult.Data ?? new List<{SubProgramName}{FunctionName}ResultDTO>());
        {FunctionName}Record = {FunctionName}List.FirstOrDefault();
    }
    catch (Exception ex)
    {
        loEx.Add(ex);
    }

    loEx.ThrowExceptionIfErrors();
}
#endregion
```




