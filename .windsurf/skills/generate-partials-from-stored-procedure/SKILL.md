---
name: generate-partials-from-stored-procedure
description: A tool to generate partials from stored procedure data for common, back, service, and model projects.
---

# Overview 
Generate partials from stored procedure data for common, back, service, and model projects.

# Process
## Phase 1: Generate Common DTOs from stored procedure data
1.1 Execute `../../scripts/generate-dto-from-csv.ps1`:
- ProgramName = {ProgramName}
- SubProgramNames = {SubProgramNames}

Example:
`powershell -ExecutionPolicy Bypass -File "../../scripts/generate-dto-from-csv.ps1" -ProgramName "FAM00100" -SubProgramNames "FAM00100,FAM0010002,FAM001000201,FAM001000202"`