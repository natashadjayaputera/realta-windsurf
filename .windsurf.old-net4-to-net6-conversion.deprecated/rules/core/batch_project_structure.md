---
trigger: always_on
name: batch_project_structure
description: "Project structure for batch or bulk related files"
---
DO NOT CREATE A NEW PROJECT. Placed in the same Back, Common, Model and Front project as the main project of 

Project Purpose:
- Back Project: Perform batch related process to database, MUST implement `R_IBatchProcessAsync`
- Common Project: Create batch related DTOs, NOT INCLUDED IN INTERFACE, DO NOT create a Batch Interface
- Service Project: NOT USED
- Model Project: Perform data manipulation to be processed in batch process, accept `R_SaveBatchParameterDTO`, call BatchCls directly
- Front Project: batch related UI 