---
name: common_types_mapping 
description: "Property Types Mapping from VB.NET (.NET Framework 4) to C# (.NET 6)"
---

rules:
  - if_source_is_any_of: ["char","Char","string","String"]
    map_to: "string"
    nullable: true
    default_value_when_not_specified_in_source: "string.Empty"

  - if_source_is_any_of: ["sbyte","SByte","byte","Byte","short","Int16","ushort","UInt16","int","Int32","uint","UInt32","long","Int64","ulong","UInt64","Integer"]
    map_to: "integer"
    nullable: false

  - if_source_is_any_of: ["float","Single","double","Double"]
    map_to: "Decimal"
    nullable: false

  - if_source_is_any_of: ["decimal","Decimal"]
    map_to: "Decimal"
    nullable: false

  - if_source_is_any_of: ["bool","Boolean"]
    map_to: "bool"
    nullable: false

  - if_source_is_any_of: ["DateTime"]
    map_to: "DateTime"
    nullable: true
    default_value_when_not_specified_in_source: "null"

  - if_source_is_any_of: ["TimeSpan"]
    map_to: "TimeSpan"
    nullable: true
    default_value_when_not_specified_in_source: "null"

  - if_source_is_any_of: ["Guid"]
    map_to: "Guid"
    nullable: true
    default_value_when_not_specified_in_source: "null"

  - if_source_is_any_of: ["byte[]","Byte()"]
    map_to: "byte[]"
    nullable: true
    default_value_when_not_specified_in_source: "null"

  - if_source_is_any_of: ["enum","Enum"]
    map_to: "integer"
    nullable: false

  - if_source_is_any_of: ["object","Object"]
    map_to: "object"
    nullable: true
    default_value_when_not_specified_in_source: "null"