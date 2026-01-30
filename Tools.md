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
- [build-and-fix-project] Build Back Project.
- [create-service-project] Create Service Project
- [create-service-project] Create Controller
- [create-service-project] Create Report Controller
- [create-service-project] Build Service Project
- [create-model-project] Create Model Project based on Service Project
- [create-model-project] Build Model Project
- Create ViewModel Classes based on Front Project
- Build Model Project


# Template
## VbParser
dotnet run `
  --project tools\VbParser\VbParser.csproj `
  -- `
  "FAB00200" `
  "Path-To-NET4-Cls\ClsFile.vb"

## Injector
dotnet run `
  --project tools\CsTemplateInjector\CsTemplateInjector.csproj `
  -- `
  "Path-To-NET6-Cls\ClsFile.cs" `
  "chunks_cs\ProgramName\ClassName" 

## Add Package (IF NEEDED)
dotnet add package Microsoft.CodeAnalysis.VisualBasic --ignore-failed-sources

# Example
dotnet run `
  --project tools\VbParser\VbParser.csproj `
  -- `
  "FAB00200" `
  "net4\FA Smart Client\Development\Back\FAB00200Back\CLS\FAB00200CLS.vb"

dotnet run `
  --project tools\CsTemplateInjector\CsTemplateInjector.csproj `
  -- `
  "FinalClass.cs" `
  "chunks_cs\FAB00200\FAB00200CLS" 

