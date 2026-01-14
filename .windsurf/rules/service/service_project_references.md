---
trigger: glob
description: "Defines inter-project references for {ProgramName}Service layer"
globs: "*ToCSharpService*"
---

# Project References

```xml
<ItemGroup>
  <ProjectReference Include="..\..\..\BACK\{module}\{ProgramName}Back\{ProgramName}Back.csproj" />
  <ProjectReference Include="..\..\..\COMMON\{module}\{ProgramName}Common\{ProgramName}Common.csproj" />
</ItemGroup>
```