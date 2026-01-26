---
trigger: always_on
name: core_error_handling_rules
---

# ERROR HANDLING

- Always use the pattern below.
- All error messages must come from resource files.
- Never hardcode exception text.
- Use a single consistent `R_Exception` pattern everywhere.
- Aggregate exceptions with `loEx.Add(ex)`
- Throw using `loEx.ThrowExceptionIfErrors()`
- Log before rethrow if in backend

```csharp
public async Task {FunctionName}()
{
    var loEx = new R_Exception();
    try
    {
        // code here
    }
    catch (Exception ex)
    {
        loEx.Add(ex);
    }
    loEx.ThrowExceptionIfErrors();
}
````
