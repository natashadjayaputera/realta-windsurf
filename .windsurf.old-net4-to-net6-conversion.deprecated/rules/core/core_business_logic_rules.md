---
trigger: always_on
name: core_business_logic_rules
description: "Business logic rules for .NET 6 conversion"
---

# BUSINESS LOGIC PRESERVATION

- Never modify SQL queries or stored procedure names.
- Never change business logic calculations.
- Replicate VB.NET logic exactly — even if it contains bugs.
- Never change data types from VB.NET conventions (`I` prefix = int, etc.).
