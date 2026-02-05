# Flow
- Requirement: Must recreate RSP Resources project first

- [run-vb-parser] Chunk each classes into list of functions and class signature
- [convert-chunk] Convert each function chunk into .cs file 
- [fix-chunk] High level fix of ClassDeclaration.cs, functions.txt and each function .cs file to follow new standard (add category metadata in each function .cs file)
- [standardized-function-file] Standardized each function .cs file to follow new standard (more complex)
- [create-common-project] Create Common Project 
- [create-common-project] Convert Common directly 
- [create-common-project] Build Common Project 
- [create-additional-files-in-common-project] Add interface 
- [create-additional-files-in-common-project] Build Common Project
- [create-back-project] Create Back Project
- [create-back-project] Create Empty Cls files.
- [create-back-project] Concat and inject into each cls file.
- [create-back-project] Build Back Project.
- [create-service-project] Create Service Project
- [create-service-project] Create Controller
- [create-service-project] Create Report Controller
- [create-service-project] Build Service Project
- [create-model-project] Create Model Project based on Service Project
- [create-model-project] Build Model Project
- [create-viewmodel-classes-in-model-project] Create ViewModel Classes based on Front Project
- [create-viewmodel-classes-in-model-project] Build Model Project
- [add-batch-data-manipulation-in-viewmodel] Add batch data manipulation in viewmodel
- [add-batch-data-manipulation-in-viewmodel] Build Model Project


# Template
## VbParser
dotnet run `
  --project tools\VbParser\VbParser.csproj `
  -- `
  "FAT00100" `
  "Path-To-NET4-Cls\ClsFile.vb"

## Injector
dotnet run `
  --project tools\CsTemplateInjector\CsTemplateInjector.csproj `
  -- `
  "Path-To-NET6-Cls\ClsFile.cs" `
  "chunks_cs\ProgramName\ClassName" 

## CsIndentFixer
dotnet run `
  --project tools\CsIndentFixer\CsIndentFixer.csproj `
  -- `
  "FAM00100"

## VbCodeReducer
dotnet run `
  --project tools\VbCodeReducer\VbCodeReducer.csproj `
  -- `
  "Path-To-VB-File.vb"

### With File Splitting (150 lines per chunk)
dotnet run `
  --project tools\VbCodeReducer\VbCodeReducer.csproj `
  -- `
  "Path-To-VB-File.vb" --split

### Process Entire Directory
dotnet run `
  --project tools\VbCodeReducer\VbCodeReducer.csproj `
  -- `
  "Path-To-Folder"

### Process Directory with Splitting
dotnet run `
  --project tools\VbCodeReducer\VbCodeReducer.csproj `
  -- `
  "Path-To-Folder" --split

### With Debug Mode (creates backups)
dotnet run `
  --project tools\VbCodeReducer\VbCodeReducer.csproj `
  -- `
  "Path-To-Folder" --split --debug

### Features:
- **Automatic detection**: Processes single file or entire directory
- **Chunk size**: 150 lines per chunk
- **Format**: XXXX_FunctionName_01_chunks.vb
- **Debug mode**: Creates .backup files only when --debug is specified
- **Source deletion**: Original files deleted after chunk creation (unless --debug)

## Add Package (IF NEEDED)
dotnet add package Microsoft.CodeAnalysis.VisualBasic --ignore-failed-sources

# Example
dotnet run `
  --project tools\VbParser\VbParser.csproj `
  -- `
  "FAT00100" `
  "net4\FA Smart Client\Development\Back\FAT00100Back\CLS\FAT00100CLS.vb"

dotnet run `
  --project tools\CsTemplateInjector\CsTemplateInjector.csproj `
  -- `
  "FinalClass.cs" `
  "chunks_cs\FAT00100\FAT00100CLS"

dotnet run `
  --project tools\CsIndentFixer\CsIndentFixer.csproj `
  -- `
  "FAM00100" 

dotnet run `
  --project tools\VbCodeReducer\VbCodeReducer.csproj `
  -- `
  "chunks_vb\FAT00100\FAT00100Cls" --split --debug

