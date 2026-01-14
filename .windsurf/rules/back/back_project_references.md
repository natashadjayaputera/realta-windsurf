---
trigger: glob
description: "Project references for Back projects"
globs: "*ToCSharpBack*"
---
# Project References

```xml
<ItemGroup>
  <ProjectReference Include="..\..\..\COMMON\{module}\{ProgramName}Common\{ProgramName}Common.csproj" />
  <ProjectReference Include="..\{ProgramName}BackResources\{ProgramName}BackResources.csproj" />
</ItemGroup>
```