# Windsurf Migration Guide: .NET 4 to .NET 6

## Table of Contents

1. [Introduction and Architecture Overview](#introduction-and-architecture-overview)
2. [Prerequisites and Setup](#prerequisites-and-setup)
3. [Migration Workflow (Step-by-Step)](#migration-workflow-step-by-step)
4. [Skills Reference Guide](#skills-reference-guide)

---

## Introduction and Architecture Overview

### What is This Guide?

This guide explains how to use Windsurf's AI-powered skills to systematically migrate VB.NET (.NET Framework 4) applications to modern C# (.NET 6) applications. The migration follows a structured, layer-by-layer approach that preserves business logic while modernizing the codebase.

### Migration Architecture

The migration follows a **layered architecture** where each layer is migrated in a specific order:

```
┌─────────────────────────────────────────────────────────┐
│  Layer 1: Common (DTOs, Interfaces, Enums)               │
│  ─────────────────────────────────────────────────────  │
│  Layer 2: Back (Business Logic + Resources)             │
│  ─────────────────────────────────────────────────────  │
│  Layer 3: Service (API Controllers)                    │
│  ─────────────────────────────────────────────────────  │
│  Layer 4: Model (Service Clients)                      │
│  ─────────────────────────────────────────────────────  │
│  Layer 5: ViewModel (Data State Management)             │
│  ─────────────────────────────────────────────────────  │
│  Layer 6: Front (Blazor Components)                    │
│  ─────────────────────────────────────────────────────  │
│  Layer 7: Solution Integration                         │
└─────────────────────────────────────────────────────────┘
```

### Project Structure

After migration, your projects will be organized as follows:

```
net6/RSF/BIMASAKTI_11/1.00/PROGRAM/BS Program/SOURCE/
├── COMMON/{Module}/{ProgramName}Common/          # DTOs, Interfaces, Enums
├── BACK/{Module}/{ProgramName}Back/              # Business Logic
├── BACK/{Module}/{ProgramName}BackResources/      # Error Messages
├── SERVICE/{Module}/{ProgramName}Service/          # API Controllers
├── FRONT/{ProgramName}Model/                     # Service Clients
├── FRONT/{ProgramName}FrontResources/             # UI Labels
└── FRONT/{ProgramName}Front/                      # Blazor Components
```

### Key Principles

1. **Business Logic Preservation**: Never modify SQL queries, stored procedure names, or business calculations. Replicate VB.NET logic exactly, even if it contains bugs.

2. **Error Handling**: Always use the standardized `R_Exception` pattern with resource-based error messages.

3. **Layer Separation**: Each layer has strict responsibilities:
   - **Common**: Only DTOs, interfaces, and enums (no business logic)
   - **Back**: Business logic, logging, and database access
   - **Service**: API controllers that delegate to Back
   - **Model**: Thin service clients for ViewModels
   - **ViewModel**: Data state and validation (no UI logic)
   - **Front**: UI components and presentation logic

4. **Variable Naming**: Follow strict naming conventions with type prefixes (e.g., `lcName` for string, `liCount` for int).

---

## Prerequisites and Setup

### Required Folder Structure

Ensure you have the following directory structure:

```
_Windsurf/
├── .windsurf/               # Windsurf configuration
│   ├── rules/               # Migration rules and patterns
│   ├── scripts/             # Migration scripts
│   ├── skills/              # Migration skills
│   ├── tools/               # Migration tools
│   └── workflows/           # Documentation references
├── net4/                    # Source VB.NET code (.NET Framework 4)
├── net6/                    # Target C# code (.NET 6)
├── chunks_cs/               # C# chunks used for migration
└── chunks_vb/               # VB.NET chunks used for migration
```

### Windsurf Configuration

Windsurf is pre-configured with:
- **Skills**: Custom skills for each migration layer
- **Rules**: Migration patterns and validation rules
- **Documentation**: Reference docs for NET4 and NET6 libraries

---

## Migration Workflow (Step-by-Step)

### Overview

The migration process follows a strict sequence using the `/convert-net4-to-net6` workflow. **Do not skip steps** or migrate layers out of order, as each layer depends on the previous one.

### Using the Workflow

**Primary Method**: Use the `/convert-net4-to-net6` workflow command
- This workflow automates steps 1-11 (Common through ViewModel layers)
- Each step requires user confirmation before proceeding
- The workflow handles skill invocation in the correct order
- After step 11, you must manually perform steps 12-13 (Front layer and Solution Integration)

**How to Run**: Type `/convert-net4-to-net6` in the chat and follow the prompts

**Manual Method**: Follow the layer-by-layer guide below if you prefer manual control

**Workflow Summary**:
- **Steps 1-11**: ✅ Automated (Common → Back → Service → Model → ViewModel)
- **Step 12**: ⚠️ Manual (Front layer)
- **Step 13**: ⚠️ Manual (Solution Integration)

### Workflow Steps to Layers Mapping

The 11 automated workflow steps map to 7 migration layers:

| Workflow Steps | Migration Layer | Status |
|---------------|----------------|---------|
| Steps 1-6 | **Layer 1: Common** (DTOs, Interfaces, Enums) | ✅ Automated |
| Steps 7 | **Layer 2: Back** (Business Logic) | ✅ Automated |
| Step 8 | **Layer 3: Service** (API Controllers) | ✅ Automated |
| Step 9 | **Layer 4: Model** (Service Clients) | ✅ Automated |
| Steps 10-11 | **Layer 5: ViewModel** (Data State) | ✅ Automated |
| Step 12 | **Layer 6: Front** (Blazor Components) | ⚠️ Manual |
| Step 13 | **Layer 7: Solution Integration** | ⚠️ Manual |

### Step 1: Common Layer (DTOs, Interfaces, Enums)

**Purpose**: Create shared contracts (DTOs, interfaces, enums) that will be used across all layers.

**Workflow Steps**: `1-6` (automated in `/convert-net4-to-net6` workflow)

**Manual Skills**: `01-run-vb-parser` → `02-convert-chunk` → `03-fix-chunk` → `04-standardized-function-file` → `05-create-common-project` → `06-create-additional-files-in-common-project`

**What Gets Migrated**:
- DTOs (data transfer objects)
- Interfaces (service contracts)
- Enums (enumerations)

**Key Rules**:
- No business logic in Common layer
- Interfaces must inherit `R_IServiceCRUDAsyncBase` where applicable

**Output**: `{ProgramName}Common` project with DTOs and interfaces

---

### Step 2: Back Layer (Business Logic)

**Purpose**: Convert business logic from VB.NET to C# while preserving all database operations and calculations.

**Workflow Step**: `7` (automated in `/convert-net4-to-net6` workflow)

**Manual Skill**: `07-create-back-project`

**Prerequisites**: Steps 1-6 (Common layer) must be completed first

**What Gets Migrated**:
- Business logic classes
- Database access methods
- Logger and Activity classes
- Error messages (to BackResources project)

**Key Rules**:
- **Never rename SQL queries or stored procedures**
- Preserve all business logic exactly (even bugs)
- Implement Logger and Activity patterns
- Create separate `{ProgramName}BackResources` project for error messages
- Use `R_Exception` pattern for all error handling
- All methods must be async (`async Task`)

**Output**: 
- `{ProgramName}Back` project (business logic)
- `{ProgramName}BackResources` project (error messages)

---

### Step 3: Service Layer (API Controllers)

**Purpose**: Create ASP.NET Core API controllers that implement Common interfaces and delegate to Back business logic.

**Workflow Step**: `8` (automated in `/convert-net4-to-net6` workflow)

**Manual Skill**: `08-create-service-project`

**Prerequisites**: Step 7 (Back layer) must be completed first

**What Gets Migrated**:
- API controllers
- HTTP endpoints
- Authorization and routing

**Key Rules**:
- Controllers implement interfaces from Common layer
- Controllers delegate to Back classes (no business logic in controllers)

**Output**: `{ProgramName}Service` project with API controllers

---

### Step 4: Model Layer (Service Clients)

**Purpose**: Create lightweight service client classes that ViewModels will use to call the API.

**Workflow Step**: `9` (automated in `/convert-net4-to-net6` workflow)

**Manual Skill**: `09-create-model-project`

**Prerequisites**: Step 8 (Service layer) must be completed first

**What Gets Migrated**:
- Service client classes
- HTTP client wrappers

**Key Rules**:
- Models are thin wrappers (no business logic)
- Models use HTTP client to call Service layer
- Models reference Common project for DTOs

**Output**: `{ProgramName}Model` project with service clients

---

### Step 5: ViewModel Layer (Data State Management)

**Purpose**: Convert UI logic from VB.NET forms into ViewModels that manage data state and validation.

**Workflow Steps**: `10-11` (automated in `/convert-net4-to-net6` workflow)

**Manual Skills**: `10-create-viewmodel-classes-in-model-project` → `11-add-batch-data-manipulation-in-viewmodel`

**Prerequisites**: Step 9 (Model layer) must be completed first

**What Gets Migrated**:
- ViewModel classes (in `VMs/` folder under Model project)
- FrontResources project (UI labels and messages)



**Output**: 
- ViewModel classes in `{ProgramName}Model/VMs/`
- `{ProgramName}FrontResources` project (UI labels)

---

### Step 6: Front Layer (Blazor Components)

**Purpose**: Convert VB.NET WinForms/WPF UI into modern Blazor components.

**Workflow Step**: `12` (manual step in `/convert-net4-to-net6` workflow)

**Status**: ⚠️ **MANUAL PROCESS** - Skills do not automate Front layer creation

**What Gets Migrated**:
- `.razor` files (UI markup)
- `.razor.cs` files (code-behind)
- Component bindings and event handlers

**Manual Steps**:
1. Create `{ProgramName}Front` project structure
2. Create `.razor` and `.razor.cs` files following patterns
3. Create `_Imports.razor` with using statements


**Key Rules**:

- UI state in `.razor.cs`; data state in ViewModel
- Work one program at a time

**Output**: 
- `{ProgramName}.razor` files (UI markup)
- `{ProgramName}.razor.cs` files (code-behind)
- `_Imports.razor` file (using statements)

---

## Skills Reference Guide

### 01-run-vb-parser

**Purpose**: Parse VB.NET (.NET Framework 4) Classes to get class signature and functions chunks.

**When to Use**: First step of any migration process.

**Input**: VB.NET files from `net4/**/Back/{ProgramName}*/**/*.vb` or `net4/**/Front/{ProgramName}*/**/*.vb`

**Output**: Parsed class signatures and function chunks

**Example Usage**:
```
Run the VB parser to analyze the source code structure. ProgramName: FAM00500
```

---

### 02-convert-chunk

**Purpose**: Convert VB.NET (.NET Framework 4) Chunk files into C# (.NET 6) Chunk files.

**When to Use**: After running the VB parser.

**Input**: VB.NET chunks from parser output

**Output**: C# chunk files

**Example Usage**:
```
Convert the VB.NET chunks to C# chunks for migration. ProgramName: FAM00500
```

---

### 03-fix-chunk

**Purpose**: Fix C# (.NET 6) Chunk files to follow new standard.

**When to Use**: After converting chunks to C#.

**Input**: C# chunk files that need fixing

**Output**: Fixed C# chunk files following standards

**Example Usage**:
```
Fix the C# chunks to follow the new .NET 6 standards. ProgramName: FAM00500
```

---

### 04-standardized-function-file

**Purpose**: Fix C# (.NET 6) Function Chunk files to follow more complex new standard.

**When to Use**: For complex function files that need additional standardization.

**Input**: C# function chunk files

**Output**: Standardized C# function files

**Example Usage**:
```
Standardize the function files to follow the complex new standards. ProgramName: FAM00500
```

---

### 05-create-common-project

**Purpose**: Create a .NET 6 common project based on .NET4 common projects.

**When to Use**: After parsing and converting VB.NET DTOs/interfaces.

**Input**: Converted C# DTOs and interfaces

**Output**: `{ProgramName}Common` project

**Example Usage**:
```
Create the Common project for the migrated DTOs and interfaces. ProgramName: FAM00500
```

---

### 06-create-additional-files-in-common-project

**Purpose**: Create additional files in .NET6 common project.

**When to Use**: When Common project needs additional supporting files.

**Input**: Common project structure

**Output**: Additional files in Common project

**Example Usage**:
```
Create additional files needed in the Common project. ProgramName: FAM00500
```

---

### 07-create-back-project

**Purpose**: Create a .NET 6 back project.

**When to Use**: After Common project is created.

**Input**: Business logic chunks and Common project references

**Output**: `{ProgramName}Back` project

**Example Usage**:
```
Create the Back project with business logic. ProgramName: FAM00500
```

---

### 08-create-service-project

**Purpose**: Create a .NET 6 service project based on interface files in Common Project.

**When to Use**: After Back project is created.

**Input**: Common interfaces and Back project references

**Output**: `{ProgramName}Service` project

**Example Usage**:
```
Create the Service project with API controllers. ProgramName: FAM00500
```

---

### 09-create-model-project

**Purpose**: Create a .NET 6 model project.

**When to Use**: After Service project is created.

**Input**: Service controller signatures

**Output**: `{ProgramName}Model` project

**Example Usage**:
```
Create the Model project with service clients. ProgramName: FAM00500
```

---

### 10-create-viewmodel-classes-in-model-project

**Purpose**: Create viewmodel classes in model project.

**When to Use**: After Model project is created.

**Input**: Model project structure and VB.NET form logic

**Output**: ViewModel classes in `VMs/` folder

**Example Usage**:
```
Create ViewModel classes in the Model project. ProgramName: FAM00500
```

---

### 11-add-batch-data-manipulation-in-viewmodel

**Purpose**: Add batch data manipulation in viewmodel classes in model project.

**When to Use**: After creating basic ViewModels.

**Input**: ViewModel classes that need batch operations

**Output**: Enhanced ViewModels with batch capabilities

**Example Usage**:
```
Add batch data manipulation capabilities to the ViewModels. ProgramName: FAM00500
```

---
