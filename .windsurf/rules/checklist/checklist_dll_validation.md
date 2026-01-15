---
trigger: model_decision
description: "Use in ValidationAndBuild workflow to Checklist for verifying DLL references for each project"
---
# DLL REFERENCE VALIDATION

- [ ] All R_* libraries use `<Reference Include="LibraryName">` with `<HintPath>`
- [ ] NO PackageReference entries for R_* libraries
- [ ] HintPath points to correct SYSTEM\SOURCE\LIBRARY directory
- [ ] Back libraries point to `LIBRARY\Back\` folder
- [ ] Front libraries point to `LIBRARY\Front\` folder
- [ ] Menu libraries point to `LIBRARY\Menu\` folder
- [ ] Relative path depth matches project location
