---
trigger: always_on
name: core_program_name_rules
description: "Program name rules for .NET 6 conversion"
---
# Program Name Format
`{AA}{B}{XXX}{YY}`

Exactly 5 characters long.

Where:
- AA: Module Name
- B: Type of program
- XXX: Program Number
- YY: Sub Program Number

# List of Type of Program (MUST NOT BE WRONGLY ASSIGNED)
- B: Batch
- R: Report
- M: Master
- T: Transaction
- I: Inquiry

For Example:
`FAM00500`

Read as: `{FA}{M}{005}{00}`

Means:
- Module Name: FA
- Type of program: M - Master
- Program Number: 005
- Sub Program Number: 00