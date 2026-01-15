---
trigger: model_decision
description: "Use in ToCSharpFront workflow to Event handling patterns for {ProgramName}Front (OnLostFocus, OnBlur, R_Grid cell events)"
---

# Event Patterns

## OnLostFocus / OnBlur
```razor
<R_TextBox @bind-Value="@viewModel.Field" OnLostFocused="OnFieldLostFocused" />
<R_ComboBox Data="@viewModel.List" OnLostFocused="OnComboLostFocused" />
<R_Grid DataSource="@viewModel.DataList"
        R_CellLostFocused="@OnCellLostFocused">
</R_Grid>
```

### Handler Signatures

```csharp
public async Task OnFieldLostFocused() { }
public async Task OnCellLostFocused(R_CellLostFocusedEventArgs eventArgs) { }
```