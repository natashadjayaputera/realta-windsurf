**EXPECTED FLOW**
1. BA create Program Specs in .md format (MANUAL)
   1. For existing spec, can use docling to convert from docx to md `.\docling.txt`
   2. And then ask the AI to convert into structured format `net6\RSF\BIMASAKTI_11\1.00\PROGRAM\BS Program\SPEC\GLT00300\GLT00300-Reversing-Journal.md`
   3. This is unreliable though, so need to manually review and fix the output
2. SKILL: 00-parse-program-spec (DONE)
   1. Convert the md file into yaml file
   2. Given in the skill folder is the example for the yaml file
   3. Assign `sub_program_id` for mapping with folder name
   4. Assign category for each processes
3. SKILL: 00-create-sp-list (DONE)
   1. Chunk the yaml file into smaller pieces based on tabs
   2. Save each chunk as a separate file
   3. Create `sp_list.txt` file inside `.\partials\{ProgramName}\{SubProgramName}\stored-procedure\`
   4. All functions is categorized as `other-function` because it's gonna be called by another function based on the processes name
4. SKILL: 00-create-stored-procedure-resource (DONE)
   1. From the `net6\RSF\BIMASAKTI_11\1.00\PROGRAM\BS Program\SPEC\GLT00300\resources` folder, there should be list of resources use in the program
   2. For each resource found in the list, convert it to the format defined in `{ROOT}/partials/README.md` and place it in the appropriate folder structure
5. SKILL: 00-create-program-front-resources (DONE)
   1. Create `{ProgramName}Front.txt` inside `.\partials\{ProgramName}\resources`.
   2. The content are validation messages, display messages, labels
6. SKILL: 01-extract-stored-procedure-data (DONE)
7. SKILL: 02-generate-partials-other-function (DONE)
   1. Generate DTO
   2. Generate Function (with DbConnection as optional parameter)
   3. SP Resource Project
   4. Front Resource Project
8. ... create the actual process from the spec
   1. `other-function` & `initialization` category is DONE
   2. `business-object-overridden-function` not yet implemented
   3. `batch-function` not yet implemented

... dunno yet
