---
trigger: model_decision
description: "Use in ToCSharpViewModel workflow for All ViewModels must inherit R_ViewModel<T> and avoid redefining Data"
---
# Inheritance Rule

- Every ViewModel inherits from `R_ViewModel<T>`  
- Never redeclare `Data` property manually  
- Define separate property like `CurrentRecord`  

```csharp
public class FAM00100ViewModel : R_ViewModel<FAM00100DTO>
{
    private readonly FAM00100Model _model = new();
}
```