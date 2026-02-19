---
name: 02-generate-partials-from-stored-procedure
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

## Phase 2: Generate Back Functions from sp_list.txt
2.1 Execute `../../scripts/generate-functions-from-sp-list.ps1` for each subprogram:
- ProgramName = {ProgramName}
- SubProgramNames = {SubProgramNames}

Example:
```powershell
powershell -ExecutionPolicy Bypass -File "../../scripts/generate-functions-from-sp-list.ps1" -ProgramName "FAM00100" -SubProgramNames "FAM00100,FAM0010002,FAM001000201,FAM001000202"
```

## Phase 3: Generate Program Resources
3.1 Execute `../../scripts/create-program-resources.ps1`:
- ProgramName = {ProgramName}
- OutputPath = "chunks_cs/resources"

Example:
```powershell
powershell -ExecutionPolicy Bypass -File "../../scripts/create-program-resources.ps1" -ProgramName "FAM00100" -OutputPath "chunks_cs/resources"
```

## Phase 4: Generate Stored Procedure Resources
4.1 Execute `../../scripts/create-sp-resources.ps1`:
- ProgramName = {ProgramName}
- OutputPath = "chunks_cs/spr"

Example:
```powershell
powershell -ExecutionPolicy Bypass -File "../../scripts/create-sp-resources.ps1" -ProgramName "FAM00100" -OutputPath "chunks_cs/spr"
```