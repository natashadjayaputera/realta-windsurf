---
name: service_controller_template
description: "Controller template"
---

# Controller Template

```csharp
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using R_BackEnd;
using R_Common;
using R_CommonFrontBackAPI;
using R_CommonFrontBackAPI.Log;
using {ProgramName}Common;
using {ProgramName}Common.DTOs;
using {ProgramName}Back;
using {ProgramName}Back.DTOs;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Threading.Tasks;

namespace {ProgramName}Service
{
    [ApiController]
    [Route("api/[controller]/[action]")]
    public class {SubProgramName}Controller : ControllerBase, I{SubProgramNameProgramName}
    {
        private readonly Logger{ProgramName} _logger;
        private readonly ActivitySource _activitySource;

        public {SubProgramName}Controller(ILogger<{SubProgramName}Controller> logger)
        {
            Logger{ProgramName}.R_InitializeLogger(logger);
            _logger = Logger{ProgramName}.R_GetInstanceLogger();
            _activitySource = {ProgramName}Activity.R_InitializeAndGetActivitySource(nameof({SubProgramName}Controller));
        }

        // IMPORTANT NOTE: Uncomment this if I{SubProgramName} implements R_IServiceCRUDAsyncBase<{SubProgramName}DTO>
        /*
        [HttpPost]
        public async Task<R_ServiceGetRecordResultDTO<{SubProgramName}DTO>> R_ServiceGetRecord(R_ServiceGetRecordParameterDTO<{SubProgramName}DTO> poParameter)
        {
            var lcFunction = nameof(R_ServiceGetRecord);
            using var activity = _activitySource.StartActivity(lcFunction);
            var loEx = new R_Exception();
            var loCls = new {SubProgramName}Cls();
            var loRtn = new R_ServiceGetRecordResultDTO<{SubProgramName}DTO>();

            try
            {
                _logger.LogInfo("Start function {FunctionName} in {0}", lcFunction);
                loRtn.data = await loCls.R_GetRecordAsync(poParameter.Entity);
            }
            catch (Exception ex)
            {
                loEx.Add(ex);
                _logger.LogError(loEx);
            }

            loEx.ThrowExceptionIfErrors();
            return loRtn;
        }

        [HttpPost]
        public async Task<R_ServiceSaveResultDTO<{SubProgramName}DTO>> R_ServiceSave(R_ServiceSaveParameterDTO<{SubProgramName}DTO> poParameter)
        {
            var lcFunction = nameof(R_ServiceSave);
            using var activity = _activitySource.StartActivity(lcFunction);
            var loEx = new R_Exception();
            var loCls = new {SubProgramName}Cls();
            var loRtn = new R_ServiceSaveResultDTO<{SubProgramName}DTO>();

            try
            {
                _logger.LogInfo("Start function {FunctionName} in {0}", lcFunction);
                loRtn.data = await loCls.R_SaveAsync(poParameter.Entity, poParameter.CRUDMode);
            }
            catch (Exception ex)
            {
                loEx.Add(ex);
                _logger.LogError(loEx);
            }

            loEx.ThrowExceptionIfErrors();
            return loRtn;
        }

        [HttpPost]
        public async Task<R_ServiceDeleteResultDTO> R_ServiceDelete(R_ServiceDeleteParameterDTO<{SubProgramName}DTO> poParameter)
        {
            var lcFunction = nameof(R_ServiceDelete);
            using var activity = _activitySource.StartActivity(lcFunction);
            var loEx = new R_Exception();
            var loCls = new {SubProgramName}Cls();
            var loRtn = new R_ServiceDeleteResultDTO();

            try
            {
                _logger.LogInfo("Start function {FunctionName} in {0}", lcFunction);
                await loCls.R_DeleteAsync(poParameter.Entity);
            }
            catch (Exception ex)
            {
                loEx.Add(ex);
                _logger.LogError(loEx);
            }

            loEx.ThrowExceptionIfErrors();
            return loRtn;
        }
        */

        // For each function in I{SubProgramName}, create a function in {SubProgramName}Controller with the following format:
        [HttpPost]
        public async Task<{FunctionReturnType}> {FunctionName}({FunctionParameterType} poParameter)
        {
            var lcFunction = nameof({FunctionName});
            using var activity = _activitySource.StartActivity(lcFunction);
            var loEx = new R_Exception();
            var loCls = new {SubProgramName}Cls();
            var loRtn = new {FunctionReturnType}();

            try
            {
                _logger.LogInfo("Start function {FunctionName} in {0}", lcFunction);
                loRtn.Data = await loCls.{FunctionName}(poParameter);
            }
            catch (Exception ex)
            {
                loEx.Add(ex);
                _logger.LogError(loEx);
            }

            loEx.ThrowExceptionIfErrors();
            return loRtn;
        }
    }
}
```