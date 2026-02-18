---
name: common_dto_violations
description: "Violation list for Common layer"
---
# Violations
- Business logic in Common
- Logger/Activity in Common
- Using EntityDTO in non business object overridden functions
- Not creating `ParameterDTO` and `ResultDTO` for each functions in back project
- ParameterDTO and ResultDTO inheriting from EntityDTO or R_DTOBase
- Creating `StreamDTO` (not allowed)
- Including IClientHelper parameters in ContextConstants
- Missing properties that VB.NET accesses
- Using `short` for variables with "I" prefix
- Using R_IServiceCRUDBase for interface