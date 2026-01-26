---
trigger: always_on
name: report_project_structure
description: "Project structure for Report or Print related files"
---
DO NOT CREATE A NEW PROJECT. Placed in the same Back, Common, Service and Front project as the main project of 

Project Purpose:
- Back Project: Create report related data retrieval functions, NEVER inherit `R_BusinessObjectAsync`
- Common Project: Create report related DTOs, report related functions ARE NOT INCLUDED IN INTERFACE, DO NOT create a Report Interface
- Service Project: Create Report Controller, MUST inherit `R_ReportControllerBase`
- Model Project: NOT USED
- Front Project: Using `R_PrintButton` to print report in `.razor` and called the service immediately in `.razor.cs`