---
name: batch_deserialization_pattern
description: "Deserialization pattern for batch data handling in Back Project"
---

# BATCH DATA DESERIALIZATION PATTERN

Use **R_NetCoreUtility** for safe and consistent deserialization of byte objects.

✅ Correct:
```csharp
var loObject = R_NetCoreUtility.R_DeserializeObjectFromByte<List<{BatchListDisplayDTO}>>(poBatchProcessPar.BigObject); 
````

❌ Wrong:

```csharp
var loObject = R_Utility.Deserialize<List<{BatchListDisplayDTO}>>(poBatchProcessPar.BigObject);
```
