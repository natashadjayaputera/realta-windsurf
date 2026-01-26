---
name: batch_get_batch_list_data_pattern
description: "Get Batch List Data pattern for batch data handling in Back Project"
---

# GetBatchListData Pattern
```csharp
private List<{BatchListDTO}> GetBatchListData(List<{BatchListDisplayDTO}> poObject)
{
    return loObject.Select(item => new {BatchListDTO}()
    {
        NO = item.No,
        UnitId = item.UnitId,
        UnitName = item.UnitName,
        UnitType = item.UnitType,
        UnitView = item.UnitView,
        GrossSize = item.GrossSize,
        NetSize = item.NetSize,
        StrataStatus = item.StrataStatus,
        LeaseStatus = item.LeaseStatus,
        UnitCategory = item.UnitCategory,
        Active = item.Active,
        NonActiveDate = item.NonActiveDate
    }).ToList();
}
```

# HOW TO USE

Use **R_NetCoreUtility** for safe and consistent deserialization of byte objects.

✅ Correct:
```csharp
var loObject = R_NetCoreUtility.R_DeserializeObjectFromByte<List<{BatchListDisplayDTO}>>(poBatchProcessPar.BigObject); 
var loParam = GetBatchListData(loObject); //This returns List<{BatchListDTO}>
````

❌ Wrong:

```csharp
var loObject = R_Utility.Deserialize<List<{BatchListDisplayDTO}>>(poBatchProcessPar.BigObject); // Deprecated
var loParam = GetBatchListData(loObject); //This returns List<{BatchListDTO}>
```

# Checklist
- [ ] MUST Deserialized BigObject to List<{BatchListDisplayDTO}> as `loObject`.
- [ ] MUST Implement `GetBatchListData(List<{BatchListDisplayDTO}> poObject)` that returns `List<{BatchListDTO}>` as `loParam`
- [ ] MUST Use the `loParam` for subsequent processes