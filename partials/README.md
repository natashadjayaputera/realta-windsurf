# Format
NOTES: 
- ALL PATHS ARE RELATIVE TO THE ROOT
- ALL FILE NAMES ARE CASE SENSITIVE

```
partials/
├── README.txt                                                      # Full guidelines
└── ABC00100/                                                       # Program Name
    ├── ABC00100/                                                   # Sub-Program Name
    │   └── stored-procedure/
    │       ├── sp_list.txt                                         # List of stored procedures
    │       └── resources/
    │           ├── RSP_HD_GET_ASSET_LIST.txt                       # Stored procedure resources content
    │           ├── RSP_HD_GET_CARE_STAFF_LIST.txt                  # Stored procedure resources content
    │           ├── RSP_HD_GET_SYSTEM_PARAM.txt                     ...
    │           └── RSP_HD_MAINTAIN_SYSTEM_PARAMETER.txt            
    ├── ABC00101/                                                   # Sub-Program Name
    │   └── stored-procedure/
    │       ├── sp_list.txt                                         # List of stored procedures
    │       └── resources/
    │           ├── RSP_HD_GET_ASSET_LIST.txt                       # Stored procedure resources content
    │           ├── RSP_HD_GET_CARE_STAFF_LIST.txt                  # Stored procedure resources content
    │           ├── RSP_HD_GET_SYSTEM_PARAM.txt                     ...
    │           └── RSP_HD_MAINTAIN_SYSTEM_PARAMETER.txt            
    └── resources/
        ├── ABC00100Back.txt                                        # BackResources Content
        └── ABC00100Front.txt                                       # FrontResources Content
partials-config.txt                                                 # Configuration file
```

**Prerequisites**: 
- Stored Procedure has been created in the database
- Stored Procedure has paramater and result set up (even if it's just dummy or placeholder)

## Format for partials-config.txt
```
connection_string: server=172.16.0.62\SQL2016;Initial Catalog=BIMASAKTI_11_BSI;User ID=XXXX;Password=XXXX
```

Explanation:
- **connection_string**: Connection string to the database

## Format for sp_list.txt:
```
RSP_HD_MAINTAIN_SYSTEM_PARAMETER|business-object-overridden-function|R_DeletingAsync|NOT_IMPLEMENTED
RSP_HD_MAINTAIN_SYSTEM_PARAMETER|business-object-overridden-function|R_SavingAsync
RSP_HD_GET_SYSTEM_PARAM|business-object-overridden-function|R_DisplayAsync
RSP_HD_GET_CARE_STAFF_LIST|other-function|list
RSP_HD_GET_CARE_LIST|other-function|single
RSP_HD_GET_ASSET_LIST|batch-function
```

Explanation:
- **First field**: Stored procedure name
- **Second field**: Type of function (business-object-overridden-function, other-function, batch-function)
- **Third field**:
  * business-object-overridden-function: Function name (R_DeletingAsync, R_SavingAsync, R_DisplayAsync)
  * other-function: Function type (list, single)
  * batch-function: Empty
- **Fourth field**: Additional information (NOT_IMPLEMENTED for overridden functions)

## Format for FrontResources and BackResources:
```
8001|Duplicate Asset Code|Kode Aset Duplikat
8002|Asset Not Found|Aset Tidak Ditemukan
8003|You are not authorized to access this asset|Anda Tidak Berhak Mengakses Aset Ini
```

Explanation:
- **First field**: Error code
- **Second field**: Error message default (English)
- **Third++ fields**: 
  * Error messages in other languages (Indonesian, etc.)
  * Third++ fields sequence are based on AdditionalLanguage parameter in the prompt
  * For example, if AdditionalLanguage is "id, ja", then third field is Indonesian, fourth field is Japanese
  * If Third++ fields are empty, then it will use the default error message (English)


## Format for Stored Procedure Resources:
```
module_name:HD
8001|Duplicate Asset Code|Kode Aset Duplikat
8002|Asset Not Found|Aset Tidak Ditemukan
8003|You are not authorized to access this asset|Anda Tidak Berhak Mengakses Aset Ini
```

Explanation:
- **First line**: module_name:<module_name> - this is Mandatory
- **First field**: Error code
- **Second field**: Error message default (English)
- **Third++ fields**: 
  * Error messages in other languages (Indonesian, etc.)
  * Third++ fields sequence are based on AdditionalLanguage parameter in the prompt
  * For example, if AdditionalLanguage is "id, ja", then third field is Indonesian, fourth field is Japanese
  * If Third++ fields are empty, then it will use the default error message (English)


