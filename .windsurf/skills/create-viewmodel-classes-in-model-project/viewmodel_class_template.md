---
name: viewmodel_class_template
description: "Template for ViewModel Classes in Model Projects"
---

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
    // If it is implementing `R_IServiceCRUDAsyncBase`, {SubProgramName}ViewModel MUST INHERITS R_ViewModel<{SubProgramName}DTO>
    public class {SubProgramName}ViewModel
    {
        private readonly {SubProgramName}Model _model = new {SubProgramName}Model();

        // No constructor (IMPORTANT)
        
        // IMPORTANT NOTE: Uncomment this if it is implementing `R_IServiceCRUDAsyncBase`
        /*
        #region Business Object Functions
        public {SubProgramName}DTO {SubProgramName}Record { get; set; } = new {SubProgramName}DTO();

        public async Task GetRecordAsync({SubProgramName}DTO poEntity)
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

        public async Task SaveRecordAsync({SubProgramName}DTO poEntity, eCRUDMode peCRUDMode)
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

        // For each function in I{SubProgramName}, create a function in {SubProgramName}ViewModel with the following format:
        // If {FunctionName} returns is list of data follow this format:
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

                {FunctionName}List = loResult.Data;
                {FunctionName}Record = loResult.Data?.FirstOrDefault();
            }
            catch (Exception ex)
            {
                loEx.Add(ex);
            }

            loEx.ThrowExceptionIfErrors();
        }
        #endregion

        // If {FunctionName} returns is single record follow this format:
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

                {FunctionName}Record = loResult.Data;
            }
            catch (Exception ex)
            {
                loEx.Add(ex);
            }

            loEx.ThrowExceptionIfErrors();
        }
        #endregion
    }
}
```

# Rules
- Must have a private readonly field of type `{ProgramName}Model`
- Never redeclare `Data` property manually
- No constructor (IMPORTANT)!
- Skip override functions
- Skip private or protected functions
- Skip private or protected functions