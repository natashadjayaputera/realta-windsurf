---
description: "Migration pattern for R_StreamUtility (NET4) → Native Streaming Pattern (NET6)"
---

# R_StreamUtility (NET4) → Native Streaming Pattern (NET6)

## Purpose
- Migrate NET4 `R_StreamUtility(Of Byte()).ReadFromMessage()` in Front layer and `R_StreamUtility(Of Byte()).WriteToMessage()` in Service layer.
- NET6 uses native streaming patterns; `R_StreamUtility` is deprecated and not needed.

## Rules

### Front Layer Migration
- NET4: `R_StreamUtility(Of Byte()).ReadFromMessage(loRtn)` followed by `R_Utility.R_CombineData<T>(loTemp)`.
- NET6: **Must follow streaming pattern** using `R_HTTPClientWrapper.R_APIRequestStreamingObject<T>()` in Model layer.
- No `ReadFromMessage` call needed; streaming handled automatically by the framework.

### Service Layer Migration
- NET4: `R_StreamUtility(Of Byte()).WriteToMessage(loList.AsEnumerable, "methodName")`.
- NET6: **Must follow streaming pattern** where Controller returns `IAsyncEnumerable<T>` directly.
- No `WriteToMessage` call needed; framework handles streaming automatically.

## NET4 → NET6 Mapping
- NET4 Front: `R_StreamUtility(Of Byte()).ReadFromMessage()` → NET6: Follow streaming pattern in Model layer.
- NET4 Service: `R_StreamUtility(Of Byte()).WriteToMessage()` → NET6: Follow streaming pattern in Controller layer.
- `R_StreamUtility` is not available in NET6; **must use native streaming patterns** instead.

## References
- `.windsurf/rules/patterns/streaming_pattern.md` (Complete streaming pattern overview)
- `.windsurf/rules/patterns/model_streaming_API_pattern.md` (Model streaming implementation)
- `.windsurf/rules/patterns/service_streaming_controller_pattern.md` (Controller streaming implementation)
- `.windsurf/rules/patterns/viewmodel_streaming_method_pattern.md` (ViewModel streaming method pattern)
- `.windsurf/rules/patterns/viewmodel_streaming_context_pattern.md` (ViewModel streaming context pattern)
- `.windsurf/rules/patterns/model_streaming_vs_nonstreaming.md` (Streaming vs non-streaming differences)
- `.windsurf/rules/service/service_streaming_context.md` (Service layer streaming context)
- `.windsurf/rules/front/components/migration-patterns/r_setstreamingcontext.md` (R_SetStreamingContext migration)
- `.windsurf/rules/front/components/migration-patterns/r_combinedata.md` (R_CombineData migration - used with R_StreamUtility)
