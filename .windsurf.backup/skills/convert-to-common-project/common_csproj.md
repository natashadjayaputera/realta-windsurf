---
name: common_csproj
description: "Standard .csproj structure for Common projects"
---
# Project Structure

- Location: `COMMON/{ModuleName}/{ProgramName}Common/{ProgramName}Common.csproj`

# Format
```xml
<PropertyGroup>
  <TargetFramework>netstandard2.1</TargetFramework>
  <LangVersion>10.0</LangVersion>
  <Nullable>enable</Nullable>
  <ImplicitUsings>disable</ImplicitUsings>
</PropertyGroup>
<ItemGroup>
  <!-- IMPORTANT: DO NOT CHANGE THE FOLDER DEPTH STRUCTURE -->
  <Reference Include="R_APICommonDTO">
    <HintPath>..\..\..\..\..\SYSTEM\SOURCE\LIBRARY\Back\R_APICommonDTO.dll</HintPath>
  </Reference>
  <Reference Include="R_CommonFrontBackAPI">
    <HintPath>..\..\..\..\..\SYSTEM\SOURCE\LIBRARY\Back\R_CommonFrontBackAPI.dll</HintPath>
  </Reference>
  <!-- IMPORTANT: Uncomment these references if there is any Report DTO -->
  <!-- <Reference Include="BaseHeaderReportCOMMON">
    <HintPath>..\..\..\..\..\SYSTEM\SOURCE\LIBRARY\Front\BaseHeaderReportCOMMON.dll</HintPath>
  </Reference> -->
</ItemGroup>
```