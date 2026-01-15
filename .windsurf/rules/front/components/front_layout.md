---
trigger: model_decision
description: "Use in ToCSharpFront workflow to R_ItemLayout and R_StackLayout column validation rules for {ProgramName}Front"
---
# Layout Rules

- Each `R_StackLayout Row` must have column sum ≤ 12
- When column sum equals 12: The last `R_ItemLayout` **MUST** use `auto="false"` instead of `col=...`
- Do NOT use both `col` and `auto` on the same `R_ItemLayout`

## Example

**❌ WRONG:** `<R_ItemLayout col="3">` + `<R_ItemLayout col="5">` + `<R_ItemLayout col="4">` (sum=12, last uses col)

**✅ CORRECT:** `<R_ItemLayout col="3">` + `<R_ItemLayout col="5">` + `<R_ItemLayout auto="false">` (last changed to auto="false")