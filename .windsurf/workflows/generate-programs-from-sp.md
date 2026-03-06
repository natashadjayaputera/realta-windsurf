---
description: Workflow to generate C# (.NET 6) programs from stored procedures
---

Run this in order, please ask user continue confirmation after each step:
1. Invoke 01-extract-stored-procedures-data skill
2. Invoke 02-generate-partials-from-stored-procedure skill
3. Invoke 03-create-common-project skill
4. Invoke 04-create-additional-files-in-common-project skill
5. Invoke 05-create-back-project skill
6. Invoke 06-create-service-project skill
7. Invoke 07-create-model-project skill
8. Invoke 08-create-viewmodel-classes-in-model-project skill
9. Invoke 09-add-batch-data-manipulation-in-viewmodel skill
