---
trigger: always_on
name: build_commands
description: "Commands used to build the projects and get all errors"
---
# Build Project Commands
`dotnet build {CSPROJ_FILE_LOCATION} 2>&1 | Select-String "error CS"`