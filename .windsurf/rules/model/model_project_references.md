---
trigger: model_decision
description: "Use in ToCSharpModel workflow to Standard project references for Model layer"
---

# Project References

```xml
<ItemGroup>
  <ProjectReference Include="..\..\COMMON\{module}\{ProgramName}Common\{ProgramName}Common.csproj" />
  <ProjectReference Include="..\{ProgramName}FrontResources\{ProgramName}FrontResources.csproj" />
</ItemGroup>
```