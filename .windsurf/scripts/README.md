# Scripts Directory Documentation

This directory contains PowerShell scripts for automating various tasks in the .NET 4 to .NET 6 conversion process.

## 🚀 Auto-Root Detection

> **Important**: All scripts now automatically detect the repository root from the `.git` folder. You can run scripts from **any directory** within the repository - no RootPath parameter needed!

### Shared Functions
- **Common-Functions.ps1**: Contains shared functionality including `Find-GitRoot()` for automatic repository root detection
- All scripts load this shared functionality automatically

## categorize-functions.ps1
**Purpose:** Categorizes functions based on back_function_categories rules

### Parameters + Example
```powershell
.\categorize-functions.ps1 -ProgramName "FAT00100"
```

### High Level Process
Find subprograms with functions.txt -> Extract function signatures -> Determine category (business-object-overridden-function/batch-function/other-function) -> Add //CATEGORY comments to function files

---

## detect-batch-processes.ps1
**Purpose:** Finds all batch process files and extracts batch parameters

### Parameters + Example
```powershell
.\detect-batch-processes.ps1 -ProgramName "FAT00100"
```

### High Level Process
Search for *_R_BatchProcess.cs files -> Extract SubProgramName from parent folders -> Remove duplicates -> Save to viewmodel_with_batch_list_buffer.txt

---

## discover-interfaces.ps1
**Purpose:** Finds all interfaces in the Common project

### Parameters + Example
```powershell
.\discover-interfaces.ps1 -ProgramName "FAT00100" -SearchFolderCommon "d:\_Work\AI\realta-windsurf\projects\common"
```

### High Level Process
Search Common project for *.cs files -> Find files with "public interface" declarations -> Extract interface names and file paths -> Save to interfaces_list.txt

---

## execute-vb-parser.ps1
**Purpose:** Executes VB Parser for all files listed in cls_file_paths.txt

### Parameters + Example
```powershell
.\execute-vb-parser.ps1 -ProgramName "FAT00100" -SearchFolderBack "d:\_Work\AI\realta-windsurf\projects\back" -OutputFolder "d:\_Work\AI\realta-windsurf\output"
```

### High Level Process
Run find-cls-file.ps1 -> Read cls_file_paths.txt -> Execute VB Parser for each .cls.vb file -> Generate C# chunks in output folder

---

## find-cls-cs-files.ps1
**Purpose:** Finds all files ending with cls.cs in nested folders

### Parameters + Example
```powershell
.\find-cls-cs-files.ps1 -SearchFolder "d:\_Work\AI\realta-windsurf\projects\back" -OutputFolder "d:\_Work\AI\realta-windsurf\output"
```

### High Level Process
Validate search folder exists -> Find all *cls.cs files recursively -> Write file paths to cls_file_paths.txt

---

## find-cls-file.ps1
**Purpose:** Finds all files ending with cls.vb in nested folders

### Parameters + Example
```powershell
.\find-cls-file.ps1 -SearchFolder "d:\_Work\AI\realta-windsurf\projects\back" -OutputFolder "d:\_Work\AI\realta-windsurf\output"
```

### High Level Process
Validate search folder exists -> Find all *cls.vb files recursively -> Write file paths to cls_file_paths.txt

---

## find-dto-files.ps1
**Purpose:** Finds all DTO files in Back and Common projects

### Parameters + Example
```powershell
.\find-dto-files.ps1 -SearchFolderBack "d:\_Work\AI\realta-windsurf\projects\back" -SearchFolderCommon "d:\_Work\AI\realta-windsurf\projects\common" -OutputFolder "d:\_Work\AI\realta-windsurf\output"
```

### High Level Process
Search Back project for DTO folders and *DTO files -> Search Common project for DTO folders and *DTO files -> Combine results and remove duplicates -> Save to dto_files_list.txt

---

## fix-class-declaration.ps1
**Purpose:** Fixes ClassDeclaration.txt files to follow new .NET 6 async standard

### Parameters + Example
```powershell
.\fix-class-declaration.ps1 -ProgramName "FAT00100"
```

### High Level Process
Find all ClassDeclaration.txt files -> Remove namespace and curly braces -> Replace R_BusinessObject<T> with R_BusinessObjectAsync<T> -> Replace R_IBatchProcess with R_IBatchProcessAsync -> Clean up whitespace

---

## fix-indentation.ps1
**Purpose:** Executes CsIndentFixer for all C# files in a program

### Parameters + Example
```powershell
.\fix-indentation.ps1 -ProgramName "FAT00100"
```

### High Level Process
Validate CsIndentFixer project exists -> Run CsIndentFixer tool with ProgramName -> Apply proper indentation to all C# files

---

## inject-functions.ps1
**Purpose:** Finds all .cls.cs files and executes function injector for each

### Parameters + Example
```powershell
.\inject-functions.ps1 -ProgramName "FAT00100" -SearchFolderBack "d:\_Work\AI\realta-windsurf\projects\back" -OutputFolder "d:\_Work\AI\realta-windsurf\output"
```

### High Level Process
Run find-cls-cs-files.ps1 -> Read cls_file_paths.txt -> Execute CsTemplateInjector for each .cls.cs file -> Generate function chunks in output folder
