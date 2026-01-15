---
trigger: model_decision
description: "Use in ToCSharpBack workflow to add Minimal DLL references for Back projects"
---
# DLL References

```xml
<ItemGroup>
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
```