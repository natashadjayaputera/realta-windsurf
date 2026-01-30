---
name: service_csproj_template
description: "Template for Service Projects .csproj"
---
# Project Structure
- Location: `SERVICE/{ModuleName}/{ProgramName}Service/{ProgramName}Service.csproj`

# Format
```xml
<Project Sdk="Microsoft.NET.Sdk">

  <PropertyGroup>
    <TargetFramework>net6.0</TargetFramework>
    <LangVersion>10.0</LangVersion>
    <Nullable>enable</Nullable>
    <ImplicitUsings>disable</ImplicitUsings>
  </PropertyGroup>

  <ItemGroup>
    <FrameworkReference Include="Microsoft.AspNetCore.App" />
  </ItemGroup>
  
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
    <!-- IMPORTANT: Uncomment these references if there is any Report Controller -->
    <!-- <Reference Include="R_ReportFastReportBack">
      <HintPath>..\..\..\..\..\SYSTEM\SOURCE\LIBRARY\Back\R_ReportFastReportBack.dll</HintPath>
    </Reference>
    <Reference Include="R_Cache">
      <HintPath>..\..\..\..\..\SYSTEM\SOURCE\LIBRARY\Back\R_Cache.dll</HintPath>
    </Reference>
    <Reference Include="BaseHeaderReportCOMMON">
      <HintPath>..\..\..\..\..\SYSTEM\SOURCE\LIBRARY\Front\BaseHeaderReportCOMMON.dll</HintPath> 
    </Reference>-->
  </ItemGroup>

  <ItemGroup>
    <ProjectReference Include="..\..\..\BACK\{ModuleName}\{ProgramName}Back\{ProgramName}Back.csproj" />
    <ProjectReference Include="..\..\..\COMMON\{ModuleName}\{ProgramName}Common\{ProgramName}Common.csproj" />
  </ItemGroup>
</Project>
```