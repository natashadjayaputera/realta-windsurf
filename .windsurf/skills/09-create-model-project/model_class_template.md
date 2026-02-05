---
name: model_class_template
description: "Template for Model Classes in Model Projects"
---

# Model Class Pattern

```csharp
using R_APIClient;
using R_BlazorFrontEnd.Exceptions;
using R_BusinessObjectFront;
using {ProgramName}Common;
using {ProgramName}Common.DTOs;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace {ProgramName}Model;
{
    public class {SubProgramName}Model : R_BusinessObjectServiceClientBase<{SubProgramName}DTO>, I{SubProgramName}
    {
        private const string DEFAULT_HTTP_NAME = "R_DefaultServiceUrl{ModuleName}";
        private const string DEFAULT_SERVICEPOINT_NAME = "api/{SubProgramName}";
        private const string DEFAULT_MODULE = "{ModuleName}";

        public {SubProgramName}Model()
            : base(DEFAULT_HTTP_NAME, DEFAULT_SERVICEPOINT_NAME, DEFAULT_MODULE, true, true)
        {
        }

        // IMPORTANT RULE: DO NOT IMPLEMENT BUSINESS OBJECT FUNCTIONS from R_IServiceCRUDAsyncBase<{SubProgramName}DTO>, IT IS ALREADY IMPLEMENTED BY R_BUSINESSOBJECTSERVICECLIENTBASE<{SubProgramName}DTO>.

        // For each function in I{SubProgramName}, create an interface compliance function and actual function implementation in {SubProgramName}Model with the following format:
        // This is the format for interface compliance function:
        #region {FunctionName}
        public Task<{ProgramName}ResultDTO<{FunctionReturnType}>> {FunctionName}({FunctionParameterType} poParameter)
        {
            throw new NotImplementedException();
        }

        // This is the format for actual function implementation:
        public async Task<{ProgramName}ResultDTO<{FunctionReturnType}>> {FunctionName}Async({FunctionParameterType} poParameter)
        {
            var loEx = new R_Exception();
            var loRtn = new {ProgramName}ResultDTO<{FunctionReturnType}>();
            try
            {
                R_HTTPClientWrapper.httpClientName = _HttpClientName;
                
                // If the function has parameter, use the following format:
                loRtn = await R_HTTPClientWrapper.R_APIRequestObject<{ProgramName}ResultDTO<{FunctionReturnType}>, {FunctionParameterType}>(
                    _RequestServiceEndPoint,
                    nameof(I{ProgramName}.{FunctionName}),
                    poParameter,
                    _ModuleName,
                    true,
                    true);

                // If the function has no parameter, use the following format:
                loRtn = await R_HTTPClientWrapper.R_APIRequestObject<{ProgramName}ResultDTO<{FunctionReturnType}>>(
                    _RequestServiceEndPoint,
                    nameof(I{ProgramName}.{FunctionName}),
                    _ModuleName,
                    true,
                    true);
            }
            catch (Exception ex)
            {
                loEx.Add(ex);
            }
            loEx.ThrowExceptionIfErrors();
            return loRtn;
        #endregion
        }
    }
}
```

# HTTP Client Name Convention

- Most modules: `"R_DefaultServiceUrl{ModuleName}"` (e.g., `"R_DefaultServiceUrlFA"`)
- GS and SA modules only: `"R_DefaultServiceUrl"` (no ModuleName suffix)