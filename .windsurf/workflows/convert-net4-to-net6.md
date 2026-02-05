---
description: Workflow to convert VB.NET (.NET Framework 4) program to C# (.NET 6) program
---

Run this in order, please ask user continue confirmation after each step:
1. Invoke 01-run-vb-parser skill
2. For every {SubProgramName}, invoke 02-convert-chunk skill
3. For every {SubProgramName}, invoke 03-fix-chunk skill
4. For every {SubProgramName}, invoke 04-standardized-function-file skill
5. Invoke 05-create-common-project skill
6. Invoke 06-create-additional-files-in-common-project skill
7. Invoke 07-create-back-project skill
8. Invoke 08-create-service-project skill
9. Invoke 09-create-model-project skill
10. Invoke 10-create-viewmodel-classes-in-model-project skill
11. Invoke 11-add-batch-data-manipulation-in-viewmodel skill
