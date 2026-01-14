---
trigger: glob
description: "Standard project references for Model layer"
globs: "*ToCSharpModel*"
---

# Project References

```xml
<ItemGroup>
  <ProjectReference Include="..\..\COMMON\{module}\{ProgramName}Common\{ProgramName}Common.csproj" />
  <ProjectReference Include="..\{ProgramName}FrontResources\{ProgramName}FrontResources.csproj" />
</ItemGroup>
```