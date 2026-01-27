# FAI00120 Project Structure - Complete Analysis

## Program Information
- **Program Name**: FAI00120
- **Program Type**: I (Inquiry)
- **Module**: FA (Fixed Asset)
- **Description**: Fixed Asset Rapid Discard Inquiry

## Report Functions
No report-related functions found. No ReportCls needed.

## Batch Functions
No batch-related functions found. No BatchCls needed.

## Main Functions

### Non-Business Object Functions (Need dedicated Parameter/Result DTOs)

#### 1. getSystemVariables
- **Purpose**: Get system variables (default transaction dept, soft period)
- **Parameter DTO**: FAI00120GetSystemVariablesParameterDTO
- **Result DTO**: FAI00120GetSystemVariablesResultDTO
- **Properties Used**: CCOMPANY_ID, CUSER_ID

#### 2. getDataGrid
- **Purpose**: Get grid data for rapid discard transactions
- **Parameter DTO**: FAI00120GetDataGridParameterDTO  
- **Result DTO**: FAI00120GetDataGridResultDTO
- **Properties Used**: CCOMPANY_ID, CTRANSACTION_CODE, CDEPT_CODE, CLANG_ID, CFILTER_FR_PERIOD, CFILTER_TO_PERIOD
- **Streaming Pattern**: Yes

#### 3. getCmbTransactionType
- **Purpose**: Get transaction type combo box data
- **Parameter DTO**: FAI00120GetCmbTransactionTypeParameterDTO
- **Result DTO**: FAI00120GetCmbTransactionTypeResultDTO
- **Properties Used**: CCOMPANY_ID
- **Streaming Pattern**: Yes

#### 4. getCmbTransactionMonth
- **Purpose**: Get transaction month combo box data
- **Parameter DTO**: FAI00120GetCmbTransactionMonthParameterDTO
- **Result DTO**: FAI00120GetCmbTransactionMonthResultDTO
- **Properties Used**: CCOMPANY_ID, CSOFT_PERIOD
- **Streaming Pattern**: Yes

#### 5. getSpinTransactionYear
- **Purpose**: Get transaction year spinner data (start/end year)
- **Parameter DTO**: FAI00120GetSpinTransactionYearParameterDTO
- **Result DTO**: FAI00120GetSpinTransactionYearResultDTO
- **Properties Used**: CCOMPANY_ID

#### 6. GetValidateUlDepartment
- **Purpose**: Validate user department access
- **Parameter DTO**: FAI00120GetValidateUlDepartmentParameterDTO
- **Result DTO**: FAI00120GetValidateUlDepartmentResultDTO
- **Properties Used**: CCOMPANY_ID, CDEPT_CODE, CUSER_ID

### Business Object Functions
None found - FAI00120 is an inquiry program with no CRUD operations.

### Context Constants
Based on non-standard properties in ParameterDTOs:
- CTRANSACTION_CODE
- CDEPT_CODE  
- CFILTER_FR_PERIOD
- CFILTER_TO_PERIOD
- CSOFT_PERIOD

### Standard Properties (handled by R_BackGlobalVar)
- CCOMPANY_ID
- CLANG_ID
- CUSER_ID

## DTO Structure Summary

### EntityDTO
- **FAI00120DTO**: Not needed for business object functions (no CRUD)

### StreamingDTO Replacement
- **FAI00120StreamingDTO**: Replace with dedicated ResultDTOs for each function

### Parameter DTOs Needed
1. FAI00120GetSystemVariablesParameterDTO
2. FAI00120GetDataGridParameterDTO
3. FAI00120GetCmbTransactionTypeParameterDTO
4. FAI00120GetCmbTransactionMonthParameterDTO
5. FAI00120GetSpinTransactionYearParameterDTO
6. FAI00120GetValidateUlDepartmentParameterDTO

### Result DTOs Needed
1. FAI00120GetSystemVariablesResultDTO
2. FAI00120GetDataGridResultDTO
3. FAI00120GetCmbTransactionTypeResultDTO
4. FAI00120GetCmbTransactionMonthResultDTO
5. FAI00120GetSpinTransactionYearResultDTO
6. FAI00120GetValidateUlDepartmentResultDTO

## Interface Functions
All 6 functions need to be included in IFAI00120 interface.

## Project Structure
- **Back Project**: FAI00120Back (with FAI00120Cls only)
- **Common Project**: FAI00120Common (with DTOs and Interface)
- **Service Project**: FAI00120Service (with Controller)
- **Model Project**: FAI00120Model (with Service Client)
- **Front Project**: FAI00120Front (with Razor UI)
- **FrontResources Project**: FAI00120FrontResources (with resources)
