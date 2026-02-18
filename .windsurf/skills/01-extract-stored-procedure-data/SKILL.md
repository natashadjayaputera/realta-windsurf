---
name: 01-extract-stored-procedure-data
description: A tool to extract stored procedure data from SQL Server to get parameter and result information, data types, lengths, nullability.
---

# Overview 
Extract stored procedure data from SQL Server including parameters and result sets.

# Process
## Phase 1: Extract stored procedure data
1.1 Execute `../../scripts/extract-stored-procedure-batch.ps1`:
- ProgramName = {ProgramName}
- SubProgramNames = {SubProgramNames}

Example:
`powershell -ExecutionPolicy Bypass -File "../../scripts/extract-stored-procedure-batch.ps1" -ProgramName "FAM00100" -SubProgramNames "FAM00100,FAM0010002,FAM001000201,FAM001000202"`