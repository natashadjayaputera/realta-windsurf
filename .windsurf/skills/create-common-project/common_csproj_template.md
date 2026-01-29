---
name: common_csproj_template
description: "Template for Common Projects .csproj"
---
# Project Structure
- Location: `COMMON/{ModuleName}/{ProgramName}Common/{ProgramName}Common.csproj`

# Format
```xml
<PropertyGroup>
  <TargetFramework>netstandard2.1</TargetFramework>
  <LangVersion>10.0</LangVersion>
  <Nullable>enable</Nullable>
  <ImplicitUsings>enable</ImplicitUsings>
</PropertyGroup>

<ItemGroup>
  <Reference Include="R_APICommonDTO">
    <HintPath>..\..\..\..\..\SYSTEM\SOURCE\LIBRARY\Back\R_APICommonDTO.dll</HintPath>
  </Reference>
  <Reference Include="R_CommonFrontBackAPI">
    <HintPath>..\..\..\..\..\SYSTEM\SOURCE\LIBRARY\Back\R_CommonFrontBackAPI.dll</HintPath>
  </Reference>
  <Reference Include="BaseHeaderReportCOMMON">
    <HintPath>..\..\..\..\..\SYSTEM\SOURCE\LIBRARY\Common\BaseHeaderReportCOMMON.dll</HintPath>
  </Reference>
</ItemGroup>
```