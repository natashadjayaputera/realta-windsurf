# Post-Skill Review Checklist for Windsurf

## Overview

Quick checklist to verify each skill executed successfully and everything works properly.

---

## General Prerequisites (Before Any Skill)

### Environment Setup
- [ ] Source VB.NET code accessible in `net4/` directory
- [ ] Target directory structure exists in `net6/`
- [ ] Windsurf skills available in `.windsurf/skills/`

---

## 1. 01-run-vb-parser

**Prerequisites**: VB.NET Back project exists

**What to Review**:
- [ ] Script executed without errors
- [ ] Output folder `{ROOT}/chunks_vb/{ProgramName}/` created
- [ ] Class signatures and function chunks generated

---

## 2. 02-convert-chunk

**Prerequisites**: 01-run-vb-parser completed

**What to Review**:
- [ ] VB.NET chunks converted to C#
- [ ] ClassDeclaration.txt has `public` keyword, no braces
- [ ] functions.txt converted to C# signatures
- [ ] All .vb files converted to .cs
- [ ] **Critical**: No logic changes, SQL queries unchanged, comments removed

---

## 3. 03-fix-chunk

**Prerequisites**: 02-convert-chunk completed

**What to Review**:
- [ ] All 4 scripts executed successfully:
  - fix-class-declaration.ps1
  - categorize-functions.ps1  
  - fix-function-signatures.ps1
  - fix-indentation.ps1
- [ ] Function signatures standardized
- [ ] Indentation consistent

---

## 4. 04-standardized-function-file

**Prerequisites**: 03-fix-chunk completed

**What to Review**:
- [ ] Functions processed by category:
  - business-object-overridden-function
  - batch-function  
  - other-function
- [ ] **Critical**: SQL queries unchanged in all categories
- [ ] functions.txt updated with new signatures
- [ ] Patterns applied correctly for each category

---

## 5. 05-create-common-project

**Prerequisites**: 04-standardized-function-file completed

**What to Review**:
- [ ] {ProgramName}Common.csproj created
- [ ] DTOs converted to C# with proper namespace
- [ ] Enums converted with proper namespace
- [ ] R_DTOBase and attributes removed from DTOs
- [ ] Project builds with no errors

---

## 6. 06-create-additional-files-in-common-project

**Prerequisites**: 05-create-common-project completed

**What to Review**:
- [ ] Interfaces created for all subprograms
- [ ] Interfaces inherit from correct base classes
- [ ] Interface methods match functions.txt
- [ ] Project builds with no errors

---

## 7. 07-create-back-project

**Prerequisites**: 06-create-additional-files-in-common-project completed

**What to Review**:
- [ ] {ProgramName}Back.csproj created
- [ ] {ProgramName}BackResources.csproj created
- [ ] Resource files created (.resx, .id.resx, Designer.cs)
- [ ] Logger and Activity classes created
- [ ] Functions injected into classes
- [ ] **Critical**: SQL queries unchanged from original
- [ ] Project builds with no errors

---

## 8. 08-create-service-project

**Prerequisites**: 07-create-back-project completed

**What to Review**:
- [ ] {ProgramName}Service.csproj created
- [ ] Controllers created for all interfaces
- [ ] Report controllers created if needed
- [ ] Controllers implement interfaces correctly
- [ ] Project builds with no errors

---

## 9. 09-create-model-project

**Prerequisites**: 08-create-service-project completed

**What to Review**:
- [ ] {ProgramName}Model.csproj created
- [ ] Model classes created as HTTP client wrappers
- [ ] VMs/ folder created for ViewModels
- [ ] No business logic in Model classes
- [ ] Project builds with no errors

---

## 10. 10-create-viewmodel-classes-in-model-project

**Prerequisites**: 09-create-model-project completed

**What to Review**:
- [ ] ViewModels created in VMs/ folder
- [ ] ViewModels inherit `R_ViewModel<T>`
- [ ] **Critical**: No `R_FrontGlobalVar` usage
- [ ] FrontResources project created
- [ ] Data state in ViewModels, UI state separate
- [ ] Project builds with no errors

---

## 11. 11-add-batch-data-manipulation-in-viewmodel

**Prerequisites**: 10-create-viewmodel-classes-in-model-project completed

**What to Review**:
- [ ] Batch operations added to ViewModels
- [ ] Batch methods are async
- [ ] Error handling for batch operations
- [ ] Progress reporting implemented
- [ ] Project builds with no errors

---

## Final Validation

**What to Verify**:
- [ ] All projects build successfully (0 errors)
- [ ] No code warnings (or documented)
- [ ] SQL queries unchanged from VB.NET
- [ ] Business logic preserved exactly
- [ ] Ready for manual Front layer creation

---
