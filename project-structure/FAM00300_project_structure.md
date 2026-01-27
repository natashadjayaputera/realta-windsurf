# FAM00300 Project Structure Analysis

## Program Information
- **ProgramName**: FAM00300
- **ModuleName**: FA  
- **Program Type**: Master (M)
- **Description**: Fixed Asset Tax Category Management

## Project Components

### 1. Report Functions
Found 1 report-related function:

#### getPrintSelectedRangeData Function
- **Location**: FAM00300CLS.vb (line 297-341)
- **Purpose**: Print selected range data for tax categories
- **Stored Procedure**: RSP_FAM00300
- **Parameters**: CCOMPANY_ID, CFROM_TAX_CAT, CTO_TAX_CAT, NSORT_BY, CLANG_ID
- **Returns**: List(Of FAM00300StreamDTO)
- **Implementation**: Add to FAM00300ReportCls.cs in Back project

### 2. Batch Functions
No batch-related functions found.

### 3. Main Functions

#### Business Object Overridden Functions (use FAM00300DTO)
1. **R_Deleting** (line 13-51) - Delete tax category record
2. **R_Display** (line 53-108) - Display tax category details with tax type description
3. **R_Saving** (line 110-240) - Save tax category (Add/Edit) with validations

#### Non-Business Object Functions
1. **getGridFixedAssetTaxCategory** (line 243-295) - Get grid data, uses StreamDTO (needs replacement)

## DTOs Structure

### EntityDTO (for Business Object Functions)
```csharp
public class FAM00300DTO
{
    // Standard Properties
    public string CCOMPANY_ID { get; set; } = string.Empty;
    public string CLANG_ID { get; set; } = string.Empty;
    
    // Report Parameters  
    public string CFROM_TAX_CAT { get; set; } = string.Empty;
    public string CTO_TAX_CAT { get; set; } = string.Empty;
    public byte NSORT_BY { get; set; }
    
    // Entity Properties
    public string CTAX_CATEGORY_CODE { get; set; } = string.Empty;
    public string CTAX_CATEGORY_DESC { get; set; } = string.Empty;
    public string CTAX_TYPE { get; set; } = string.Empty;
    public string CTAX_TYPE_DESC { get; set; } = string.Empty;
    public string CCREATE_BY { get; set; } = string.Empty;
    public DateTime DCREATE_DATE { get; set; }
    public string CUPDATE_BY { get; set; } = string.Empty;
    public DateTime DUPDATE_DATE { get; set; }
}
```

### Function-Specific DTOs

#### FAM00300GetGridFixedAssetTaxCategoryParameterDTO
```csharp
public class FAM00300GetGridFixedAssetTaxCategoryParameterDTO
{
    public string CCOMPANY_ID { get; set; } = string.Empty;
    public string CLANG_ID { get; set; } = string.Empty;
}
```

#### FAM00300GetGridFixedAssetTaxCategoryResultDTO
```csharp
public class FAM00300GetGridFixedAssetTaxCategoryResultDTO
{
    public string CTAX_CATEGORY_CODE { get; set; } = string.Empty;
    public string CTAX_CATEGORY_DESC { get; set; } = string.Empty;
    public string CTAX_TYPE { get; set; } = string.Empty;
    public string CTAX_TYPE_DESC { get; set; } = string.Empty;
    public string CCREATE_BY { get; set; } = string.Empty;
    public DateTime DCREATE_DATE { get; set; }
    public string CUPDATE_BY { get; set; } = string.Empty;
    public DateTime DUPDATE_DATE { get; set; }
}
```

#### FAM00300GetPrintSelectedRangeDataParameterDTO
```csharp
public class FAM00300GetPrintSelectedRangeDataParameterDTO
{
    public string CCOMPANY_ID { get; set; } = string.Empty;
    public string CFROM_TAX_CAT { get; set; } = string.Empty;
    public string CTO_TAX_CAT { get; set; } = string.Empty;
    public byte NSORT_BY { get; set; }
    public string CLANG_ID { get; set; } = string.Empty;
}
```

#### FAM00300GetPrintSelectedRangeDataResultDTO
```csharp
public class FAM00300GetPrintSelectedRangeDataResultDTO
{
    public string CTAX_CATEGORY_CODE { get; set; } = string.Empty;
    public string CTAX_CATEGORY_DESC { get; set; } = string.Empty;
    public string CTAX_TYPE { get; set; } = string.Empty;
    public string CTAX_TYPE_DESC { get; set; } = string.Empty;
    public string CCREATE_BY { get; set; } = string.Empty;
    public DateTime DCREATE_DATE { get; set; }
    public string CUPDATE_BY { get; set; } = string.Empty;
    public DateTime DUPDATE_DATE { get; set; }
}
```

## Interface Structure

### IFAM00300 Interface
```csharp
public interface IFAM00300
{
    // Business Object Functions
    Task<R_ServiceGetRecordResultDTO<FAM00300DTO>> R_ServiceGetRecord(R_ServiceGetRecordParameterDTO<FAM00300DTO> poParameter);
    Task<R_ServiceSaveResultDTO<FAM00300DTO>> R_ServiceSave(R_ServiceSaveParameterDTO<FAM00300DTO> poParameter);
    Task<R_ServiceDeleteResultDTO<FAM00300DTO>> R_ServiceDelete(R_ServiceDeleteParameterDTO<FAM00300DTO> poParameter);
    
    // Non-Business Object Functions  
    IAsyncEnumerable<FAM00300GetGridFixedAssetTaxCategoryResultDTO> getGridFixedAssetTaxCategory();
}
```

## Validation Rules
- **PS001**: Tax category code already exists (Add mode)
- **PS002**: Tax type already exists (Add/Edit mode)

## Database Operations
- **Table**: FAM_TAX_CATEGORY
- **Lookup**: RFT_GET_GSB_CODE_INFO for tax type descriptions
- **Stored Procedure**: RSP_FAM00300 for report printing

## Implementation Requirements
1. Replace FAM00300StreamDTO with dedicated ResultDTOs
2. Create FAM00300ReportCls.cs for report functionality
3. Implement streaming pattern for grid function
4. Maintain all business logic and validations
5. Preserve error handling patterns
