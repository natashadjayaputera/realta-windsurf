---
name: viewmodel_function_template
description: "Template for Function in ViewModel Classes in Model Projects"
---

# Format
IMPORTANT: For each function in `functions.txt` with `//CATEGORY: other-function`, decide which function format to use, there are 3 types of function, no-return-type, single-record-return-type, list-return-type :

## 1. no-return-type
If {FunctionName} in I{SubProgramName} has this format: `public async Task {FunctionName}({FunctionParameterType} poParam) //CATEGORY: other-function`


## Example:
Function in `functions.txt`: `public async Task CreateFamSystem(FAM00100DTO poParam)`
Viewmodel Function Signature: `public async Task CreateFamSystemAsync(FAM00100DTO poParameter)`

## Full Format:
```csharp
#region {FunctionName}Async
// Function
public async Task {FunctionName}Async({FunctionParameterType} poParameter)
{
    var loEx = new R_Exception();

    try
    {
        await _model.{FunctionName}Async(poParameter);
    }
    catch (Exception ex)
    {
        loEx.Add(ex);
    }

    loEx.ThrowExceptionIfErrors();
}
#endregion
```


## 2. single-record-return-type
If {FunctionName} in I{SubProgramName} has this format: `public async Task<{FunctionReturnType}> {FunctionName}({FunctionParameterType} poParam);`

## Example:
Function in `functions.txt`: `public async Task<FAM00100DTO> GetPeriodYear(FAM00100DTO poParam)`
Viewmodel Function Signature: `public async Task GetPeriodYearAsync(FAM00100DTO poParameter)`
ViewModel Single Record Property: `public FAM00100DTO? GetPeriodYearRecord { get; set; } = null;`

## Full Format:
```csharp
#region {FunctionName}Async
// Property
public {FunctionReturnType}? {FunctionName}Record { get; set; } = null;

// Function
public async Task {FunctionName}Async({FunctionParameterType} poParameter)
{
    var loEx = new R_Exception();

    try
    {
        var loResult = await _model.{FunctionName}Async(poParameter);

        {FunctionName}Record = loResult.Data; //MUST assign the `loResult.Data`
    }
    catch (Exception ex)
    {
        loEx.Add(ex);
    }

    loEx.ThrowExceptionIfErrors();
}
#endregion
```

public async Task<List<FAM00100StreamDTO>> GetPeriodMonth(FAM00100DTO poParam) //CATEGORY: other-function

## 3. list-return-type
If {FunctionName} in I{SubProgramName} has this format: `public async Task<List<{FunctionReturnType}>> {FunctionName}({FunctionParameterType} poParam)`

## Example:
Function in `functions.txt`: `public async Task<List<FAM00100StreamDTO>> GetPeriodMonth(FAM00100DTO poParam)`
Viewmodel Function Signature: `public async Task GetPeriodMonthAsync(FAM00100DTO poParameter)`
ViewModel List Property: `public List<FAM00100StreamDTO> GetPeriodMonthList { get; set; } = new List<FAM00100StreamDTO>();`
ViewModel Single Record Property: `public FAM00100StreamDTO? GetPeriodMonthRecord { get; set; } = null;`

## Full Format:
```csharp
#region {FunctionName}Async
// Property
public List<{FunctionReturnType}> {FunctionName}List { get; set; } = new List<{FunctionReturnType}>();
public {FunctionReturnType}? {FunctionName}Record { get; set; } = null;

// Function
public async Task {FunctionName}Async({FunctionParameterType} poParameter)
{
    var loEx = new R_Exception();

    try
    {
        var loResult = await _model.{FunctionName}Async(poParameter);

        {FunctionName}List = loResult.Data ?? new List<{FunctionReturnType}>(); 
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

# Rules
- MUST ASSIGN `loResult.Data` not just `loResult`