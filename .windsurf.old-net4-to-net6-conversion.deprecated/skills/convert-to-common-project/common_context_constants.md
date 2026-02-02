---
name: common_context_constants
description: "Enforce context constant rules in Common layer"
---

# Context Constants Rules

- Only include properties found in any `{FunctionName}ParameterDTO`
- Do not include standard properties (read `common_dto_design.md` for more details)
- Use `{ProgramName}_` prefix in **values** (e.g., `"FAM00100_ISTART_YEAR"`)
- Keep **names** simple and descriptive (e.g., `ISTART_YEAR`)

# Context Constants Pattern

```csharp
namespace {ProgramName}Common;
{
    public static class ContextConstants
    {
        public const string CSOFT_PERIOD = "{ProgramName}_CSOFT_PERIOD";
        public const string CDEPT_CODE = "{ProgramName}_CDEPT_CODE";
    }
}
```