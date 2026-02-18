---
name: front_resource_csproj_template
description: "Template for Back Resources Projects .csproj"
---
# Project Structure

- Location: `FRONT/{ProgramName}FrontResources/{ProgramName}FrontResources.csproj` (Please not that it is directly inside FRONT folder, not inside a Subfolder of {ModuleName})

# Format
```xml
<Project Sdk="Microsoft.NET.Sdk">

  <PropertyGroup>
    <TargetFramework>netstandard2.1</TargetFramework>
    <LangVersion>10.0</LangVersion>
    <Nullable>enable</Nullable>
    <ImplicitUsings>enable</ImplicitUsings>
  </PropertyGroup>

</Project>
```