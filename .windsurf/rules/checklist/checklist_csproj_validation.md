---
trigger: model_decision
description: "Use in ValidationAndBuild workflow to Checklist for validating all .csproj files before build"
---
# .CSPROJ VALIDATION

- [ ] Verify all projects have correct `PropertyGroup` settings
- [ ] Confirm TargetFramework, LangVersion, Nullable, ImplicitUsings
- [ ] Check Service project has correct FrameworkReference
- [ ] Status box for each project (✓ VERIFIED)
