---
name: viewmodel_validation_functions_pattern
description: "Standard validation pattern for ViewModel functions"
---
# Validation Functions Pattern
## Implementation
```csharp
public void Validation({ProgramName}DTO poEntity)
{
    var loEx = new R_Exception();

    try
    {
        var loData = poEntity;

        if (string.IsNullOrWhiteSpace(loData.CRATETYPE_CODE))
            loEx.Add(R_FrontUtility.R_GetError(typeof(SAM00100FrontResources.Resources_Dummy_Class), "_err001_RateType"));

        if (loData.CRATETYPE_CODE.Length > 4)
            loEx.Add(R_FrontUtility.R_GetError(typeof(SAM00100FrontResources.Resources_Dummy_Class), "_err002_RateType"));

        if (string.IsNullOrWhiteSpace(loData.CRATETYPE_DESCRIPTION))
            loEx.Add(R_FrontUtility.R_GetError(typeof(SAM00100FrontResources.Resources_Dummy_Class), "_err003_RateType"));

        if (loData.CRATETYPE_DESCRIPTION.Length > 30)
            loEx.Add(R_FrontUtility.R_GetError(typeof(SAM00100FrontResources.Resources_Dummy_Class), "_err004_RateType"));
    }
    catch (Exception ex)
    {
        loEx.Add(ex);
    }

    loEx.ThrowExceptionIfErrors();
}
```