---
name: common_error_and_fixes
description: "Common error and fixes"
---
# Common Error and Fixes

## Error CS0246: The type or namespace name `{YOUR_SP_NAME}Resources` could not be found

Fix it by add this reference to `{ProgramName}Back.csproj`
```xml
<ItemGroup>
    <ProjectReference Include="..\{ModuleName}_SPR\{YOUR_SP_NAME}Resources\{YOUR_SP_NAME}Resources.csproj" />
</ItemGroup>
```

## Error CS0246: The type or namespace name `{YOUR_SP_NAME}Resources` could not be found (are you missing a using directive or an assembly reference?)

Fix it by:
1. Creating `{YOUR_SP_NAME}Resources` folder in `BACK\{ModuleName}\{ModuleName}_SPR\`.
2. Read `back_resources_csproj.md` as a template and create `{YOUR_SP_NAME}Resources.csproj` file in `{YOUR_SP_NAME}Resources` folder.
3. Read `back_sp_resource_dummy_class_pattern.md` and create resource dummy class.

## Error CS1061: `{ClassName}` does not contain a definition for `{PropertyName}`

Fix it by:
1. Checking if similar property exists in `{ClassName}`
2. If exists, change `{PropertyName}` to the similar property name in `{ClassName}`
3. If not exists, add the property to `{ClassName}`