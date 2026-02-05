---
name: 04-standardized-function-file
description: A tool to fix C# (.NET 6) Function Chunk files to follow more complex new standard.
---

# Overview 
Fix C# (.NET 6) Function Chunk files to follow more complex new standard.

# Process

IMPORTANT: Please continue to fix the function chunk files until all function chunk files are standardized.

## Phase 1: Fix `XXXX_FunctionName.cs` with `business-object-overridden-function` category 
1.1 Load and interpret:
- back_business_object_overridden_function_pattern
- back_database_function_pattern
- back_error_retrieval_pattern
- prevent_common_error_and_fixes
- back_additional_properties_recognizer

1.2 For each file in:
chunks_cs/{ProgramName}/{SubProgramName}CLS

If file contains:
//CATEGORY: business-object-overridden-function

Then:
- Modify function signature according to back_business_object_overridden_function_pattern
- If function has no implementation, `throw new NotImplementedException();`
- Update database access using back_database_function_pattern
- Update error retrieval using back_error_retrieval_pattern
- Fix common errors using prevent_common_error_and_fixes
- Recognize additional properties using back_additional_properties_recognizer
- Immediately append the new function signature to functions.txt

1.3 If category is not present or category is not `business-object-overridden-function`, skip file.

## Phase 2: Fix `XXXX_FunctionName.cs` with `batch-function` category 
2.1 Load and interpret:
- back_batch_function_pattern
- prevent_common_error_and_fixes
- back_additional_properties_recognizer

2.2 For each file in:
chunks_cs/{ProgramName}/{SubProgramName}CLS

If file contains:
//CATEGORY: batch-function

Then:
- Change old implementation to follow back_batch_function_pattern, make sure User Parameter use `nameof({SubProgramName}R_SaveBatchUserParameterDTO.{UserParameterName}` as key
- Add Standard Batch DTO following back_batch_function_pattern
- Fix common errors using prevent_common_error_and_fixes
- Recognize additional properties using back_additional_properties_recognizer
- Immediately append the new function signature to functions.txt

2.3 If category is not present or category is not `batch-function`, skip file.

## Phase 3: Fix `XXXX_FunctionName.cs` with `other-function` category 
3.1 Load and interpret:
- back_database_function_pattern
- back_error_retrieval_pattern
- prevent_common_error_and_fixes
- back_additional_properties_recognizer

3.2 For each file in:
chunks_cs/{ProgramName}/{SubProgramName}CLS

If file contains:
//CATEGORY: other-function

Then:
- DO NOT MODIFY FUNCTION SIGNATURE (NON-NEGOTIABLE)
- Update database access using back_database_function_pattern
- Update error retrieval using back_error_retrieval_pattern
- Fix common errors using prevent_common_error_and_fixes
- Recognize additional properties using back_additional_properties_recognizer
- Immediately append the new function signature to functions.txt

3.3 If category is not present or category is not `other-function`, skip file.