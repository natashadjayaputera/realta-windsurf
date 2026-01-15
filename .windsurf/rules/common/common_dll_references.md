---
trigger: model_decision
description: "Use in ToCSharpCommon workflow to Minimal DLL references for Common projects"
---
# DLL References

```xml
<ItemGroup>
  <Reference Include="R_APICommonDTO">
    <HintPath>..\..\..\..\..\SYSTEM\SOURCE\LIBRARY\Back\R_APICommonDTO.dll</HintPath>
  </Reference>
  <Reference Include="R_CommonFrontBackAPI">
    <HintPath>..\..\..\..\..\SYSTEM\SOURCE\LIBRARY\Back\R_CommonFrontBackAPI.dll</HintPath>
  </Reference>
</ItemGroup>