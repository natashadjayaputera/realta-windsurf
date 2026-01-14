---
trigger: glob
description: "Ensure unique and consistent GUIDs for all projects"
globs: "*SolutionManager*"
---

# GUID Management

- **MUST** generate unique GUIDs for every project  
- **MUST** update ALL references when GUIDs change  
  - Project definitions  
  - Build configuration entries  
  - Nested project mappings  
- **MUST** follow the existing GUID format  
- **NEVER** reuse existing GUIDs  
- **NEVER** leave orphaned GUID references