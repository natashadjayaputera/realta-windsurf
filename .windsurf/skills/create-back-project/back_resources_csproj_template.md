---
name: back_resources_csproj_template
description: "Template for Back Resources Projects .csproj"
---
# Project Structure

- Location: `BACK/{ModuleName}/{ProgramName}BackResources/{ProgramName}BackResources.csproj`

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