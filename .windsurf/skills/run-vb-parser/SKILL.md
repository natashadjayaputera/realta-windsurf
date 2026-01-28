---
name: run-vb-parser
description: A tool to parse VB.NET (.NET Framework 4) Classes to get class signature and functions chunks.
---

# Overview 
Parse VB.NET (.NET Framework 4) Classes to get class signature and functions chunks.

# Process
## Phase 1: Get all Cls file paths
1.1 From the {ProgramName}Back project folder, find all files with names ending in cls.vb (case-insensitive). Save their relative paths into the realta-windsurf/chunks_vb/{ProgramName}/cls_file_paths.txt file, with one path per line.

## Phase 2: Run VBParser
2.1 For each line in chunks_vb/{ProgramName}/cls_file_paths.txt, execute vbparser.sh, passing:
- ProgramName = {ProgramName}
- PathToNet4Cls = <current line value>