---
name: 01-run-vb-parser
description: A tool to parse VB.NET (.NET Framework 4) Classes to get class signature and functions chunks.
---

# Overview 
Parse VB.NET (.NET Framework 4) Classes to get class signature and functions chunks.

# Process
## Phase 1: Run VBParser
1.1 Execute `../../scripts/execute-vb-parser.ps1`:
- ProgramName = {ProgramName}
- SearchFolderBack = the location of {ProgramName}Back Project
- OutputFolder = `{ROOT}/chunks_vb/{ProgramName}/`

Example:
`powershell -ExecutionPolicy Bypass -File "../../scripts/execute-vb-parser.ps1" -ProgramName "FAI00110" -SearchFolderBack "D:\_Work\AI\realta-windsurf\net4\FA Smart Client\Development\FAI00110" -OutputFolder "D:\_Work\AI\realta-windsurf\chunks_vb\FAI00110"`