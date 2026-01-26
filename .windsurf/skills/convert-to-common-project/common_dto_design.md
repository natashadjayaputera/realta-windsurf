---
name: common_dto_design
description: "Rules for DTOs in Common layer"
---
# DTO Design Rules

- All functions returning `List` MUST follow streaming patterns. See `streaming_pattern.md`
- NEVER inherit from EntityDTO
- NEVER inherit from R_DTOBase
- Property names must match VB.NET exactly
- Use `string.Empty` for string defaults
- Nullable annotations applied correctly
- All properties must follow `common_types_mapping.md`

# DTO Types

## EntityDTO (for Business Object Overridden Functions)
IMPORTANT: ALL EntityDTOs MUST include these three standard properties at the top:
```csharp
public string CCOMPANY_ID { get; set; } = string.Empty;
public string CLANG_ID { get; set; } = string.Empty;
public string CUSER_ID { get; set; } = string.Empty;
```

### Example: EntityDTO with standard properties

```csharp
namespace {ProgramName}Common.DTOs;
{
    public class {ProgramName}DTO
    {
        // Required standard properties (ALWAYS include)
        public string CCOMPANY_ID { get; set; } = string.Empty;
        public string CLANG_ID { get; set; } = string.Empty;
        public string CUSER_ID { get; set; } = string.Empty;
        
        // Business properties, this is just an example
        public int ISTART_YEAR { get; set; }
        public string CJRNGRP_CODE { get; set; } = string.Empty;
        public string CJRNGRP_ASSET_CODE { get; set; } = string.Empty;
        // ... other properties
    }
}
```

## ParameterDTO (for non-business object overridden functions)
IMPORTANT: ALL ParameterDTOs MUST include these three standard properties at the top:

```csharp
public string CCOMPANY_ID { get; set; } = string.Empty;
public string CLANG_ID { get; set; } = string.Empty;
public string CUSER_ID { get; set; } = string.Empty;
```

### Example: ParameterDTO with standard properties

```csharp
namespace {ProgramName}Common.DTOs;
{
    public class {FunctionName}ParameterDTO
    {
        // Required standard properties (ALWAYS include)
        public string CCOMPANY_ID { get; set; } = string.Empty;
        public string CLANG_ID { get; set; } = string.Empty;
        public string CUSER_ID { get; set; } = string.Empty;
        
        // Business properties, this is just an example
        public string CTRANS_DEPT_CODE { get; set; } = string.Empty;
    }
}
```

## ResultDTO (for non-business object overridden functions)

### Example: ResultDTO
```csharp
namespace {ProgramName}Common.DTOs;
{
    public class {ProgramName}{FunctionName}ResultDTO
    {
        // all returns value from query or SP
    }
}
```

## Generic Result DTO used in Interface, Service Project and Model Project

```csharp
using R_APICommonDTO;

namespace {ProgramName}Common.DTOs;
{
    // Generic Result DTO with data (for functions that return data)
    public class {ProgramName}ResultDTO<T> : R_APIResultBaseDTO
    {
        public T? Data { get; set; }
    }

    // Generic Result DTO without data (for functions that do not return data)
    public class {ProgramName}ResultDTO : R_APIResultBaseDTO
    {
    }
}
```