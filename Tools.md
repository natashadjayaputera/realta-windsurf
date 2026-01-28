# Flow
- [run-vb-parser] Chunk each classes into list of functions and class signature
- Convert each function chunk into .cs file (add info about type of function)
- Fix each .cs file to follow new template and or standard
- [create-common-project] Create Common Project 
- [create-common-project] Convert Common directly 
- [create-common-project] Build Common Project 
- [create-additional-files-in-common-project] Add interface 
- [create-additional-files-in-common-project] Build Common Project
- Create Back Project
- Create Cls files.
- Concat and inject into each cls file.
- Build Back Project.
- Create Service Project
- Read function signature .txt
- Build Service Project
- Create Model Project based on Service Project
- Build Model Project
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

