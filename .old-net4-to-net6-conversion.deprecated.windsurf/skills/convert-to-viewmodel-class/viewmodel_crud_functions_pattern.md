---
name: viewmodel_crud_functions_pattern
description: "Standard CRUD pattern for ViewModel functions"
---
# CRUD Pattern
Each CRUD function follows this template:
```csharp
private readonly {ProgramName}Model _model = new {ProgramName}Model();
public {ProgramName}DTO CurrentRecord { get; set; } = new {ProgramName}DTO();

public async Task GetRecordAsync({ProgramName}DTO poEntity)
{
    var loEx = new R_Exception();
    try
    {
        var loResult = await _model.R_ServiceGetRecordAsync(poEntity);
        CurrentRecord = loResult; // Store in separate property, DO NOT return value or use Data property
    }
    catch (Exception ex) 
    {
        loEx.Add(ex);
    }
    loEx.ThrowExceptionIfErrors();
}

public async Task SaveRecordAsync(FAM00100DTO poEntity, eCRUDMode peCRUDMode)
{
    var loEx = new R_Exception();
    try
    {
        var loResult = await _model.R_ServiceSaveAsync(poEntity, peCRUDMode);
        CurrentRecord = loResult; // Store in separate property, DO NOT return value or use Data property
    }
    catch (Exception ex) 
    {
        loEx.Add(ex);
    }
    loEx.ThrowExceptionIfErrors();
}

public async Task DeleteRecordAsync(FAM00100DTO poEntity)
{
    var loEx = new R_Exception();
    try
    {
        await _model.R_ServiceDeleteAsync(poEntity);
    }
    catch (Exception ex) 
    {
        loEx.Add(ex);
    }
    loEx.ThrowExceptionIfErrors();
}
```