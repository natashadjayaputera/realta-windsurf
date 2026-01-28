---
name: model_csproj
description: "Standard .csproj structure for Model Projects"
---
# Project Structure

- Location: `FRONT/{ProgramName}Model/{ProgramName}Model.csproj`

# Format
```xml
<Project Sdk="Microsoft.NET.Sdk">

  <PropertyGroup>
    <TargetFramework>netstandard2.1</TargetFramework>
    <LangVersion>10.0</LangVersion>
    <Nullable>enable</Nullable>
    <ImplicitUsings>disable</ImplicitUsings>
  </PropertyGroup>

  <ItemGroup>
    <!-- IMPORTANT: DO NOT CHANGE THE FOLDER DEPTH STRUCTURE -->
    <Reference Include="R_APIClient">
        <HintPath>..\..\..\..\SYSTEM\SOURCE\LIBRARY\Front\R_APIClient.dll</HintPath>
    </Reference>
    <Reference Include="R_APICommonDTO">
        <HintPath>..\..\..\..\SYSTEM\SOURCE\LIBRARY\Front\R_APICommonDTO.dll</HintPath>
    </Reference>
    <Reference Include="R_BusinessObjectFront">
        <HintPath>..\..\..\..\SYSTEM\SOURCE\LIBRARY\Front\R_BusinessObjectFront.dll</HintPath>
    </Reference>
    <Reference Include="R_CommonFrontBackAPI">
        <HintPath>..\..\..\..\SYSTEM\SOURCE\LIBRARY\Front\R_CommonFrontBackAPI.dll</HintPath>
    </Reference>
    <Reference Include="R_ContextFrontEnd">
        <HintPath>..\..\..\..\SYSTEM\SOURCE\LIBRARY\Front\R_ContextFrontEnd.dll</HintPath>
    </Reference>
    <Reference Include="R_BlazorFrontEnd">
        <HintPath>..\..\..\..\SYSTEM\SOURCE\LIBRARY\Front\R_BlazorFrontEnd.dll</HintPath>
    </Reference>
    <Reference Include="R_ProcessAndUploadFront">
        <HintPath>..\..\..\..\SYSTEM\SOURCE\LIBRARY\Front\R_ProcessAndUploadFront.dll</HintPath>
    </Reference>
    <Reference Include="R_BlazorFrontEnd.Excel">
        <HintPath>..\..\..\SYSTEM\SOURCE\LIBRARY\Front\R_BlazorFrontEnd.Excel.dll</HintPath>
    </Reference>
  </ItemGroup>

  <ItemGroup>
    <ProjectReference Include="..\..\COMMON\{module}\{ProgramName}Common\{ProgramName}Common.csproj" />
  </ItemGroup>

</Project>
```