---
name: back_csproj_template
description: "Template for Back Projects .csproj"
---
# Project Structure

- Location: `BACK/{ModuleName}/{ProgramName}Back/{ProgramName}Back.csproj`

# Format
```xml
<Project Sdk="Microsoft.NET.Sdk">

  <PropertyGroup>
    <TargetFramework>net6.0</TargetFramework>
    <LangVersion>10.0</LangVersion>
    <Nullable>enable</Nullable>
    <ImplicitUsings>enable</ImplicitUsings>
  </PropertyGroup>

  <!-- IMPORTANT: Uncomment these references if there is any a function with category batch-function in `functions.txt` -->
  <!-- <ItemGroup>
    <PackageReference Include="System.Data.SqlClient" Version="4.8.6" />
  </ItemGroup> -->

  <ItemGroup>
    <!-- IMPORTANT: DO NOT CHANGE THE FOLDER DEPTH STRUCTURE -->
    <Reference Include="R_APIBackEnd">
      <HintPath>..\..\..\..\..\SYSTEM\SOURCE\LIBRARY\Back\R_APIBackEnd.dll</HintPath>
    </Reference>
    <Reference Include="R_APICommon">
      <HintPath>..\..\..\..\..\SYSTEM\SOURCE\LIBRARY\Back\R_APICommon.dll</HintPath>
    </Reference>
    <Reference Include="R_APICommonDTO">
      <HintPath>..\..\..\..\..\SYSTEM\SOURCE\LIBRARY\Back\R_APICommonDTO.dll</HintPath>
    </Reference>
    <Reference Include="R_CommonFrontBackAPI">
      <HintPath>..\..\..\..\..\SYSTEM\SOURCE\LIBRARY\Back\R_CommonFrontBackAPI.dll</HintPath>
    </Reference>
    <Reference Include="R_OpenTelemetry">
      <HintPath>..\..\..\..\..\SYSTEM\SOURCE\LIBRARY\Back\R_OpenTelemetry.dll</HintPath>
    </Reference>
  </ItemGroup>

  <ItemGroup>
    <ProjectReference Include="..\..\..\COMMON\{ModuleName}\{ProgramName}Common\{ProgramName}Common.csproj" />
    <ProjectReference Include="..\{ProgramName}BackResources\{ProgramName}BackResources.csproj" />
  </ItemGroup>

</Project>
```