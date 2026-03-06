---
name: 00-create-program-front-resource
description: A tool to extract program specification files (.YAML) into program front resource files.
---

# Overview
Extract information from (.YAML) file into program front resource files.

## Phase 1: Create program front resources
1.1 Read `{ROOT}/partials/{ProgramName}/{ProgramName}.yaml` and create program resource (FRONT ONLY) following folder structure and program resource file format defined in `{ROOT}/partials/README.md` (this is non-negotiable). 
This is the format for resource key:
- M001 for text in display_message (incremental)
- V001 for message in validation (incremental)
- actual text value for elements (labels, buttons, grid headers, etc.) in camelCase format (0-9A-Za-z format, no special characters, no space, AND NOT the element_id) 
  - example: "..." -> "ellipsis", "Show All" -> "showAll"