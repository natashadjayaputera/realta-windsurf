---
trigger: always_on
name: core_viewmodel_front_validation_rule
description: "ViewModel-Front validation function rules and pattern"
---
# Validation Rules

- All validation occurs in ViewModel.  
- Code-behind `*.razor.cs` function call the ViewModel validation function
- No inline validation in Razor event handlers
- Return `R_Exception`.  
- Use `R_FrontUtility.R_GetError()` for messages.  

## ViewModel Validation Patterns
```csharp
public R_Exception {ValidateFunctionName}({ProgramName}DTO poEntity)
{
    var loEx = new R_Exception();
    if (string.IsNullOrWhiteSpace(poEntity.CTAX_CATEGORY_CODE))
        loEx.Add(R_FrontUtility.R_GetError(typeof({ProgramName}FrontResources.Resources_Dummy_Class), "PS001"));
    // if multiple validations
    if (string.IsNullOrWhiteSpace(poEntity.CTAX_TYPE))
    {
        loEx.Add(R_FrontUtility.R_GetError(typeof({ProgramName}FrontResources.Resources_Dummy_Class), "PS002"));
    }
    return loEx;
}
```

## Front Validation Patterns
```csharp
private void R_Validation(R_ValidationEventArgs eventArgs)
{
    var loEx = new R_Exception();

    try
    {
        var loData = R_FrontUtility.ConvertObjectToObject<{ProgramName}DTO>(eventArgs.Data) ?? new();

        // Use ViewModel validation
        var loValidationEx = _{ProgramName}ViewModel.{ValidateFunctionName}(loData);
        loEx.Add(loValidationEx);
    }
    catch (Exception ex)
    {
        loEx.Add(ex);
    }

    loEx.ThrowExceptionIfErrors();
}

```
