---
name: batch_transaction_pattern
description: "Transaction pattern for batch operations in Back Project"
---

# TRANSACTION MANAGEMENT PATTERN

Always use `TransactionScope` with `TransactionScopeAsyncFlowOption.Enabled` for async-safe batch processing.

```csharp
using var transScope = new TransactionScope(TransactionScopeOption.Required, TransactionScopeAsyncFlowOption.Enabled);

// Perform batch operations here

transScope.Complete();
```