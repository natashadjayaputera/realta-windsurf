---
name: front_resources_csproj
description: "Standard .csproj structure for Front Resources Projects"
---
# Project Structure

- Location: `FRONT/{ProgramName}FrontResources/{ProgramName}FrontResources.csproj`

# Format
```xml
<Project Sdk="Microsoft.NET.Sdk">

  <PropertyGroup>
    <TargetFramework>netstandard2.1</TargetFramework>
    <LangVersion>10.0</LangVersion>
    <Nullable>enable</Nullable>
    <ImplicitUsings>disable</ImplicitUsings>
  </PropertyGroup>

</Project>
```