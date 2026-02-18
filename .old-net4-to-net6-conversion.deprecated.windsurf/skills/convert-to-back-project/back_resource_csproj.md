---
name: back_resource_csproj
description: "Standard .csproj structure for Back Resource Projects"
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