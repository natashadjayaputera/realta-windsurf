---
name: back_additional_properties_recognizer
description: "Back Project Additional Properties Recognizer"
---
# Steps to Add Additional Properties

1. Find any {YOUR_SP_NAME} in between `R_ExternalException.R_SP_Init_Exception(loConn);` and `loEx.Add(R_ExternalException.R_SP_Get_Exception(loConn));`. (IT MUST BE BETWEEN THOSE TWO LINES NOT JUST SOME RANDOM STORED PROCEDURE)
2. For each {YOUR_SP_NAME} found (please exclude `RSP_WriteUploadProcessStatus`), add the following line in `0000_AdditionalProperties.cs` (MUST FOLLOW EXACTLY):
`private {YOUR_SP_NAME}Resources.Resources_Dummy_Class _{YOUR_SP_NAME} = new();` 