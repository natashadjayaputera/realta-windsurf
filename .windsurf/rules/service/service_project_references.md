---
trigger: model_decision
description: "Use in ToCSharpService workflow for Defines inter-project references for {ProgramName}Service layer"
---

# Project References

```xml
<ItemGroup>
  <ProjectReference Include="..\..\..\BACK\{module}\{ProgramName}Back\{ProgramName}Back.csproj" />
  <ProjectReference Include="..\..\..\COMMON\{module}\{ProgramName}Common\{ProgramName}Common.csproj" />
</ItemGroup>
```