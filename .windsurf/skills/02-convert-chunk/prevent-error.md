---
name: prevent-error
description: "Prevent common error in convert-chunk skill"
---

# Prevent Common Error in Convert-Chunk Skill

## Error 1: Converting 'With' statement in VB.NET to 'lock' statement in C#

When converting VB.NET code that uses `With` statements to C#, the converter might incorrectly replace the `With` block with a `lock` statement. 

Example:

```vbnet
With loObj
    .Property1 = "Value1"
    .Property2 = "Value2"
End With
```

Should be converted to:

```csharp
loObj.Property1 = "Value1";
loObj.Property2 = "Value2";
```