---
trigger: model_decision
description: "Use in ToCSharpModel workflow to Checklist for {ProgramName}Model project migration"
---
# {ProgramName}Model

- [ ] Read `{ProgramName}Common` project as reference
- [ ] `{ProgramName}Model` class inheriting `R_BusinessObjectServiceClientBase`
- [ ] Constants: `DEFAULT_HTTP_NAME`, `DEFAULT_SERVICEPOINT_NAME`, `DEFAULT_MODULE`
- [ ] Interface methods implemented
- [ ] List methods with `IAsyncEnumerable` return (interface compliance)
- [ ] List async methods with `Task<ResultDTO<List<>>>` return (actual implementation)
- [ ] Using `R_HTTPClientWrapper.R_APIRequestStreamingObject<>()`
- [ ] Using `R_HTTPClientWrapper.R_APIRequestObject<>()`