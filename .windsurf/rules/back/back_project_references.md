---
trigger: model_decision
description: "Use in ToCSharpBack workflow to add Project references for Back projects"
---
# Project References

```xml
<ItemGroup>
  <ProjectReference Include="..\..\..\COMMON\{module}\{ProgramName}Common\{ProgramName}Common.csproj" />
  <ProjectReference Include="..\{ProgramName}BackResources\{ProgramName}BackResources.csproj" />
</ItemGroup>
```