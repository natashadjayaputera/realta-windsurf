---
name: viewmodel_batch_class_template
description: "Template for Batch data manipulation ViewModel implementation in Model Project"
---

# BATCH DATA MANIPULATION PATTERN
## Implementation Template

```csharp
#region BATCH DATA MANIPULATION
public Action<DataSet>? ShowErrorAction { get; set; }
public Action? StateChangeAction { get; set; }
public Action? ShowSuccessAction { get; set; }
public string Message { get; set; } = string.Empty;
public int Percentage { get; set; }
public ObservableCollection<{BatchListDisplayDTO}>  { get; set; } = new ObservableCollection<{BatchListDisplayDTO}>();

public int SumValid { get; set; }
public int SumInvalid { get; set; }
public int SumList { get; set; }
public bool VisibleError { get; set; }

// Private fields to store COMPANY_ID and USER_ID for multi-language error retrieval
private string _companyId = string.Empty;
private string _userId = string.Empty;

// IMPORTANT: uncomment this section if data list comes from uploading an excel file
/*
#region EXCEL BASED (OPTIONAL)
public bool IsFileSelected { get; set; }
public long MaximumFileSize => 5 * 1024 * 1024; // 5MB
public byte[] FileByte { get; set;}
public bool IsErrorEmptyFile { get; set; }
public List<{BatchListExcelDTO}> UploadList { get; set; } = new List<{BatchListExcelDTO}>();
#endregion
*/

// IMPORTANT: UNCOMMENT THIS if {BatchListDisplayDTO} has bool LSELECTED
/*
private List<{BatchListDisplayDTO}> GetSelectedData({BatchListDisplayDTO} poList)
{
    R_Exception loEx = new R_Exception();
    List<{BatchListDisplayDTO}> loTemp = new List<{BatchListDisplayDTO}>();

    try
    {
        int no = 1;
        foreach (var item in poList)
        {
            if (item.LSELECTED == true)
            {
                item.INO = no;
                no++;
                loTemp.Add(item);
            }
        }

        if (loTemp.Count == 0) 
        {
            loEx.Add(R_FrontUtility.R_GetError(typeof(Resources_Dummy_Class), "{EmptySelectedListErrorResourceKeys}"))
        }
    }
    catch (Exception ex)
    {
        loEx.Add(ex);
    }
    loEx.ThrowExceptionIfErrors();

    return loTemp;
}
*/

public async Task R_SaveBatchAsync({SubProgramName}R_SaveBatchParameterDTO poParameter)
{
    R_Exception loEx = new R_Exception();
    R_BatchParameter loBatchPar;
    R_ProcessAndUploadClient loCls;
    string lcGuid = "";
    List<{BatchListDTO}> loBigObject;
    var loUserParam = new List<R_KeyValue>();
    int liStep = {BatchSteps}; 

    try
    {
        // Validate and filter data
        if (poParameter.Data == null)
        {
            loEx.Add(new Exception("Data cannot be null"));
            loEx.ThrowExceptionIfErrors();
            return;
        }

        // IMPORTANT: UNCOMMENT THIS if {BatchListDisplayDTO} has bool LSELECTED
        //poParameter.Data = GetSelectedData(poParameter.Data);

        SumList = poParameter.Data.Count;

        // Store company and user ID for error retrieval with multi-language support
        _companyId = poParameter.CCOMPANY_ID;
        _userId = poParameter.CUSER_ID;

        // Set custom UserParameters from poParameter.UserParameters
        // Example:
        loUserParam.Add(new R_KeyValue { Key = nameof({SubProgramName}R_SaveBatchUserParameterDTO.{UserParameterName1}), Value = poParameter.UserParameters.UserParam1 });
        loUserParam.Add(new R_KeyValue { Key = nameof({SubProgramName}R_SaveBatchUserParameterDTO.{UserParameterName2}), Value = poParameter.UserParameters.UserParam2 });
        loUserParam.Add(new R_KeyValue { Key = nameof({SubProgramName}R_SaveBatchUserParameterDTO.{UserParameterName3}), Value = poParameter.UserParameters.UserParam3 });
        // ... add all other custom parameters from poParameter.UserParameters

        loCls = new R_ProcessAndUploadClient(
            pcModuleName: "{ModuleName}",
            plSendWithContext: true,
            plSendWithToken: true,
            pcHttpClientName: "{BatchServicePointName}",
            poProcessProgressStatus: this);

        //Check Data
        if (poParameter.Data.Count == 0)
            return;

        loBigObject = poParameter.Data.ToList();

        //prepare Batch Parameter
        loBatchPar = new R_BatchParameter();

        loBatchPar.COMPANY_ID = poParameter.CCOMPANY_ID;  // Set from DTO
        loBatchPar.USER_ID = poParameter.CUSER_ID;        // Set from DTO
        loBatchPar.ClassName = "{ProgramName}Back.{BatchBackClassName}";
        loBatchPar.UserParameters = loUserParam;          // Custom parameters only
        loBatchPar.BigObject = loBigObject;

        lcGuid = await loCls.R_BatchProcess<List<{BatchListDTO}>>(loBatchPar, liStep);
    }
    catch (Exception ex)
    {
        loEx.Add(ex);
    }

    loEx.ThrowExceptionIfErrors();
}

/// <summary>
/// Called when batch process completes
/// </summary>
public async Task ProcessComplete(string pcKeyGuid, eProcessResultMode poProcessResultMode)
{
    R_APIException loException = new R_APIException();

    try
    {
        if (poProcessResultMode == eProcessResultMode.Success)
        {
            Message = string.Format(R_FrontUtility.R_GetMessage(typeof({ProgramName}FrontResources.Resources_Dummy_Class), "VMM001"), pcKeyGuid);
            VisibleError = false;
            ShowSuccessAction?.Invoke();
        }
        else if (poProcessResultMode == eProcessResultMode.Fail)
        {
            Message = string.Format(R_FrontUtility.R_GetMessage(typeof({ProgramName}FrontResources.Resources_Dummy_Class), "VMM002"), pcKeyGuid);
            await ServiceGetError(pcKeyGuid);
            VisibleError = true;
        }
    }
    catch (Exception ex)
    {
        loException.add(ex);
    }

    StateChangeAction?.Invoke();
    loException.ThrowExceptionIfErrors();
}

/// <summary>
/// Called when batch process encounters an error
/// </summary>
public Task ProcessError(string pcKeyGuid, R_APIException poException)
{
    Message = string.Format(R_FrontUtility.R_GetMessage(typeof({ProgramName}FrontResources.Resources_Dummy_Class), "VMM003"), pcKeyGuid);
    VisibleError = true;
    if (poException?.ErrorList != null)
    {
        var loDataSet = new DataSet();
        var loDataTable = loDataSet.Tables.Add("ErrorTable");
        loDataTable.Columns.Add("ErrorMessage", typeof(string));

        foreach (var loError in poException.ErrorList)
        {
            loDataTable.Rows.Add(loError.ErrDescp);
        }

        ShowErrorAction?.Invoke(loDataSet);
    }
    StateChangeAction?.Invoke();
    return Task.CompletedTask;
}

/// <summary>
/// Called to report progress during batch processing
/// </summary>
public Task ReportProgress(int pnProgress, string pcStatus)
{
    Percentage = pnProgress;
    Message = string.Format(R_FrontUtility.R_GetMessage(typeof({ProgramName}FrontResources.Resources_Dummy_Class), "VMM004"), pnProgress, pcStatus);
    StateChangeAction?.Invoke();
    return Task.CompletedTask;
}

/// <summary>
/// Get error details from batch process with multi-language support
/// </summary>
private async Task ServiceGetError(string pcKeyGuid)
{
    R_APIException loException = new R_APIException();

    List<R_ErrorStatusReturn>? loResultData = null;
    R_GetErrorWithMultiLanguageParameter loParameterData;
    R_ProcessAndUploadClient loCls;

    try
    {
        // Add Parameter
        loParameterData = new R_GetErrorWithMultiLanguageParameter()
        {
            COMPANY_ID = _companyId,
            USER_ID = _userId,
            KEY_GUID = pcKeyGuid,
            RESOURCE_NAME = "{ProgramName}BackResources"
        };

        loCls = new R_ProcessAndUploadClient(pcModuleName: "{ModuleName}",
            plSendWithContext: true,
            plSendWithToken: true,
            pcHttpClientName: "R_DefaultServiceUrl");

        // Get error result
        loResultData = await loCls.R_GetStreamErrorProcess(loParameterData);

        // Reset counters
        SumValid = 0;
        SumInvalid = 0;

        // Update display list with error messages
        .ToList().ForEach(x =>
        {
            if (loResultData.Any(y => y.SeqNo == x.SeqNo))  // Use x.SeqNo or x.No depending on DTO property name
            {
                x.Notes = loResultData.Where(y => y.SeqNo == x.SeqNo).FirstOrDefault()?.ErrorMessage ?? string.Empty;
                x.Valid = "N";
                SumInvalid++;
            }
            else
            {
                x.Valid = "Y";
                SumValid++;
            }
        });

        // Handle unhandled errors (SeqNo < 0)
        if (loResultData.Any(x => x.SeqNo < 0))
        {
            var loUnhandleEx = loResultData.Where(x => x.SeqNo < 0).Select(x => new R_BlazorFrontEnd.Exceptions.R_Error(x.SeqNo.ToString(), x.ErrorMessage)).ToList();
            var loEx = new R_Exception();
            loUnhandleEx.ForEach(x => loEx.Add(x));

            loException = R_FrontUtility.R_ConvertToAPIException(loEx);
        }
    }
    catch (Exception ex)
    {
        loException.add(ex);
    }

    loException.ThrowExceptionIfErrors();
}
#endregion
```

## Checklist
- [ ] Custom parameters are accessed via `poParameter.UserParameters.{PropertyName}` in `R_SaveBatchAsync`
- [ ] Store `CCOMPANY_ID` and `CUSER_ID` from `poParameter` as private fields `_companyId` and `_userId` for multi-language error retrieval
- [ ] `ServiceGetError` MUST return `Task` (not `Task<List<R_ErrorStatusReturn>>`) - return value is never used
- [ ] Use `R_FrontUtility.R_GetMessage` for all user-facing messages in `ProcessComplete`, `ProcessError`, and `ReportProgress`
- [ ] Use correct property name for sequence matching in `ServiceGetError` (e.g., `x.SeqNo` or `x.No` depending on DTO)