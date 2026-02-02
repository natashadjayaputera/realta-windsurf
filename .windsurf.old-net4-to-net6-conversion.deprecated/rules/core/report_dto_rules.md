---
trigger: always_on
name: report_dto_rules
description: "Defines parameter and result DTO rules for for report-related / {ProgramName}ReportCls in Common Project"
---
# DTO Rules for Report Operations

## Parameter DTOs
- Create **dedicated parameter DTOs** for Report functions
- Must include all parameters required by the report
- Follow the same naming convention as standard DTOs
  - Example: `{ProgramName}GetReportDataParameterDTO`

## Result DTOs
- Each Report function must have its own **non-shared** result DTO
- Name format: `{ProgramName}GetReportDataResultDTO`
- ❌ Do not use StreamDTO for Report results