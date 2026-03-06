---
name: viewmodel_class_template
description: "Template for ViewModel Classes in Model Projects"
---
# Location

- Location: `FRONT/{ProgramName}Model/VMs/{SubProgramName}ViewModel.cs`

# ViewModel Class Pattern

```csharp
using R_BlazorFrontEnd;
using R_BlazorFrontEnd.Exceptions;
using R_BlazorFrontEnd.Helpers;
using R_CommonFrontBackAPI;
using R_ContextFrontEnd;
using {ProgramName}Common;
using {ProgramName}Common.DTOs;
using {ProgramName}FrontResources;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using System.Linq;
using System;
using System.Collections.Generic;

namespace {ProgramName}Model.VMs
{
    public class {SubProgramName}ViewModel
    {
        private readonly {SubProgramName}Model _model = new {SubProgramName}Model();

        // No constructor (IMPORTANT)
        
        // IMPORTANT NOTE: Uncomment this if it is inheriting `R_BusinessObjectAsync`
        /*
        #region Business Object Functions
        public {SubProgramName}DTO CurrentRecord { get; set; } = new {SubProgramName}DTO();

        public async Task GetRecordAsync({SubProgramName}DTO poEntity)
        {
            var loEx = new R_Exception();
            try
            {
                var loResult = await _model.R_ServiceGetRecordAsync(poEntity);
                CurrentRecord = loResult;
            }
            catch (Exception ex) 
            {
                loEx.Add(ex);
            }
            loEx.ThrowExceptionIfErrors();
        }

        public async Task SaveRecordAsync({SubProgramName}DTO poEntity, eCRUDMode peCRUDMode)
        {
            var loEx = new R_Exception();
            try
            {
                var loResult = await _model.R_ServiceSaveAsync(poEntity, peCRUDMode);
                CurrentRecord = loResult;
            }
            catch (Exception ex) 
            {
                loEx.Add(ex);
            }
            loEx.ThrowExceptionIfErrors();
        }

        public async Task DeleteRecordAsync({SubProgramName}DTO poEntity)
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
        #endregion
        */
    }
}
```

# Rules
- Remove `cls` (case-sensitive) from ViewModel Class Name and ViewModel File Name
- Must have a private readonly field of type `{ProgramName}Model`
- Never redeclare `Data` property manually
- No constructor (IMPORTANT)!
- Skip override functions
- Skip private or protected functions
- Skip private or protected functions