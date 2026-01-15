---
trigger: model_decision
description: "Use in SolutionManager workflow for project reference insertion pattern for API and BlazorMenu"
---

# Project Reference Patterns

### Backend API Project
```xml
<ProjectReference Include="..\..\..\SERVICE\FA\{ProgramName}Service\{ProgramName}Service.csproj" />
````

### BlazorMenu Frontend

```xml
<ProjectReference Include="..\..\..\..\BS Program\SOURCE\FRONT\{ProgramName}Front\{ProgramName}Front.csproj" />
```

### Assembly Registration

```csharp
typeof({ProgramName}Front.{ProgramName}).Assembly
```