# Create Stored Procedure Resources Script
# Generates Resources project for stored procedure resources
# Reads resource files from partials\{ProgramName}\**\stored-procedure\resources\*.txt

param(
    [Parameter(Mandatory=$true)]
    [string]$OutputPath,
    
    [Parameter(Mandatory=$true)]
    [string]$ProgramName,

    [Parameter(Mandatory=$false)]
    [string]$DefaultLanguage = "en",
    
    [Parameter(Mandatory=$false)]
    [string]$AdditionalLanguage = "id"
)

# Import common functions
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$commonFunctionsPath = Join-Path $scriptDir "Common-Functions.ps1"

$additional = $AdditionalLanguage -split ',' | ForEach-Object { $_.Trim() }

if (Test-Path $commonFunctionsPath) {
    . $commonFunctionsPath
}

function New-SpResourcesProject {
    param(
        [string]$OutputPath,
        [string]$ProgramName,
        [string]$DefaultLanguage,
        [string[]]$AdditionalLanguages
    )
    
    # Find git root and set paths
    $gitRoot = Find-GitRoot
    
    # Output path is the base directory
    $resourcesProjectPath = Join-Path $gitRoot $OutputPath
    
    # Path to search for all stored-procedure resources folders within ProgramName
    try {
        $searchPath = Join-Path $gitRoot "partials\$ProgramName"
        if (-not (Test-Path $searchPath)) {
            Write-Error "Program directory not found: $searchPath"
            return
        }
        
        $resourceFolders = Get-ChildItem -Path $searchPath -Recurse -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -eq "resources" -and $_.Parent.Name -eq "stored-procedure" }
        $resourceFiles = @()
        
        foreach ($folder in $resourceFolders) {
            $filesInFolder = Get-ChildItem -Path $folder.FullName -Filter "*.txt" -ErrorAction SilentlyContinue
            $resourceFiles += $filesInFolder
        }
    }
    catch {
        Write-Error "Error searching for stored procedure resource files: $($_.Exception.Message)"
        return
    }
    
    Write-Host "Creating Stored Procedure Resources project"
    Write-Host "Path: $resourcesProjectPath"
    Write-Host "Searching for resource files in: $searchPath"
    
    # Create directory structure
    try {
        if (-not (Test-Path $resourcesProjectPath)) {
            New-Item -ItemType Directory -Path $resourcesProjectPath -Force -ErrorAction Stop | Out-Null
            Write-Host "Created directory: $resourcesProjectPath"
        }
    }
    catch {
        Write-Error "Error creating output directory: $($_.Exception.Message)"
        return
    }
    
    # Get all .txt resource files from all stored-procedure resources folders
    if ($resourceFiles.Count -eq 0) {
        Write-Warning "No resource files found in any stored-procedure 'resources' folders under: $searchPath"
        return
    }
    
    Write-Host "Found $($resourceFiles.Count) resource file(s)"
    
    foreach ($resourceFile in $resourceFiles) {
        $projectName = $resourceFile.BaseName
        
        # Read the first line to extract module_name (required for SP resources)
        try {
            $lines = Get-Content -Path $resourceFile.FullName -ErrorAction Stop
            if ($lines.Count -eq 0 -or -not $lines[0].StartsWith("module_name:")) {
                Write-Error "Missing module_name in file: $($resourceFile.Name). SP resources must have module_name as first line."
                continue
            }
            $moduleName = $lines[0].Substring("module_name:".Length).Trim()
            Write-Host "Found module_name: $moduleName in file: $($resourceFile.Name)"
        }
        catch {
            Write-Error "Error reading file $($resourceFile.Name): $($_.Exception.Message)"
            continue
        }
        
        # Use module_name-based output path for SP resources (required)
        $projectResourcesPath = Join-Path $resourcesProjectPath "$($moduleName)\$($moduleName)_SPR\$($projectName)Resources"
        
        # Create project-specific directory
        try {
            if (-not (Test-Path $projectResourcesPath)) {
                New-Item -ItemType Directory -Path $projectResourcesPath -Force -ErrorAction Stop | Out-Null
                Write-Host "Created directory: $projectResourcesPath"
            }
        }
        catch {
            Write-Error "Error creating project directory: $($_.Exception.Message)"
            continue
        }
        
        # Generate .csproj file for this project
        $csprojContent = @"
<Project Sdk="Microsoft.NET.Sdk">

  <PropertyGroup>
    <TargetFramework>netstandard2.1</TargetFramework>
    <LangVersion>10.0</LangVersion>
    <Nullable>enable</Nullable>
    <ImplicitUsings>enable</ImplicitUsings>
  </PropertyGroup>

</Project>
"@
        
        $csprojPath = Join-Path $projectResourcesPath "$($projectName)Resources.csproj"
        $csprojContent | Out-File -FilePath $csprojPath -Encoding UTF8
        Write-Host "Created: $csprojPath"
        
        # Generate default resx content (skip module_name line for SP resources)
        $resourceEntries = $lines | Select-Object -Skip 1
        Write-Host "Skipping module_name line, processing $($resourceEntries.Count) resource entries"
        $defaultResxContent = Generate-ResxContent -ResourceEntries $resourceEntries -DefaultLanguage $DefaultLanguage -AdditionalLanguages $AdditionalLanguages
        
        # Create default resx file
        $defaultResxPath = Join-Path $projectResourcesPath "$($projectName)Resources_msgrsc.resx"
        $defaultResxContent.Default | Out-File -FilePath $defaultResxPath -Encoding UTF8
        Write-Host "Created: $defaultResxPath"
        
        # Generate additional language resx files
        for ($i = 0; $i -lt $AdditionalLanguages.Count; $i++) {
            $lang = $AdditionalLanguages[$i]
            if ($lang -ne "") {
                $langResxPath = Join-Path $projectResourcesPath "$($projectName)Resources_msgrsc.$lang.resx"
                $defaultResxContent.Additional[$i] | Out-File -FilePath $langResxPath -Encoding UTF8
                Write-Host "Created: $langResxPath"
            }
        }
        
        # Generate designer file
        $designerContent = Generate-DesignerContent -ProjectName $projectName
        $designerPath = Join-Path $projectResourcesPath "$($projectName)Resources_msgrsc.Designer.cs"
        $designerContent | Out-File -FilePath $designerPath -Encoding UTF8
        Write-Host "Created: $designerPath"
        
        # Generate dummy class
        $dummyClassContent = @"
namespace $($projectName)Resources
{
    public class Resources_Dummy_Class
    {
    }
}
"@
        
        $dummyClassPath = Join-Path $projectResourcesPath "Resources_Dummy_Class.cs"
        $dummyClassContent | Out-File -FilePath $dummyClassPath -Encoding UTF8
        Write-Host "Created: $dummyClassPath"
    }
}

function Generate-ResxContent {
    param(
        [string[]]$ResourceEntries,
        [string]$DefaultLanguage,
        [string[]]$AdditionalLanguages
    )
    
    $resxTemplate = @"
<?xml version="1.0" encoding="utf-8"?>
<root>
  <xsd:schema id="root" xmlns="" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:msdata="urn:schemas-microsoft-com:xml-msdata">
    <xsd:import namespace="http://www.w3.org/XML/1998/namespace" />
    <xsd:element name="root" msdata:IsDataSet="true">
      <xsd:complexType>
        <xsd:choice maxOccurs="unbounded">
          <xsd:element name="metadata">
            <xsd:complexType>
              <xsd:sequence>
                <xsd:element name="value" type="xsd:string" minOccurs="0" />
              </xsd:sequence>
              <xsd:attribute name="name" use="required" type="xsd:string" />
              <xsd:attribute name="type" type="xsd:string" />
              <xsd:attribute name="mimetype" type="xsd:string" />
              <xsd:attribute ref="xml:space" />
            </xsd:complexType>
          </xsd:element>
          <xsd:element name="assembly">
            <xsd:complexType>
              <xsd:attribute name="alias" type="xsd:string" />
              <xsd:attribute name="name" type="xsd:string" />
            </xsd:complexType>
          </xsd:element>
          <xsd:element name="data">
            <xsd:complexType>
              <xsd:sequence>
                <xsd:element name="value" type="xsd:string" minOccurs="0" msdata:Ordinal="1" />
                <xsd:element name="comment" type="xsd:string" minOccurs="0" msdata:Ordinal="2" />
              </xsd:sequence>
              <xsd:attribute name="name" use="required" type="xsd:string" />
              <xsd:attribute name="type" type="xsd:string" />
              <xsd:attribute name="mimetype" type="xsd:string" />
              <xsd:attribute ref="xml:space" />
            </xsd:complexType>
          </xsd:element>
          <xsd:element name="resheader">
            <xsd:complexType>
              <xsd:sequence>
                <xsd:element name="value" type="xsd:string" minOccurs="0" msdata:Ordinal="1" />
              </xsd:sequence>
              <xsd:attribute name="name" use="required" type="xsd:string" />
            </xsd:complexType>
          </xsd:element>
        </xsd:choice>
      </xsd:complexType>
    </xsd:element>
  </xsd:schema>
  <resheader name="resmimetype">
    <value>text/microsoft-resx</value>
  </resheader>
  <resheader name="version">
    <value>2.0</value>
  </resheader>
  <resheader name="reader">
    <value>System.Resources.ResXResourceReader, System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089</value>
  </resheader>
  <resheader name="writer">
    <value>System.Resources.ResXResourceWriter, System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089</value>
  </resheader>
{DATA_ENTRIES}
</root>
"@
    
    $result = @{ Default = ""; Additional = @() }
    
    # Generate default language resx
    $dataEntries = ""
    foreach ($entry in $ResourceEntries) {
        $parts = $entry -split '\|'
        if ($parts.Count -ge 2) {
            $code = $parts[0].Trim()
            $defaultText = $parts[1].Trim()
            $dataEntries += "`r`n  <data name=`"$code`" xml:space=`"preserve`">`r`n    <value>$defaultText</value>`r`n  </data>"
        }
    }
    
    $result.Default = $resxTemplate -replace '{DATA_ENTRIES}', $dataEntries
    
    # Generate additional language resx files
    for ($i = 0; $i -lt $AdditionalLanguages.Count; $i++) {
        $langIndex = $i + 2  # Skip code (0) and default (1)
        $dataEntries = ""
        
        foreach ($entry in $ResourceEntries) {
            $parts = $entry -split '\|'
            if ($parts.Count -ge 2) {
                $code = $parts[0].Trim()
                $langText = if ($parts.Count -gt $langIndex) { $parts[$langIndex].Trim() } else { $parts[1].Trim() }
                if ([string]::IsNullOrWhiteSpace($langText)) {
                    $langText = $parts[1].Trim()
                }
                $dataEntries += "`r`n  <data name=`"$code`" xml:space=`"preserve`">`r`n    <value>$langText</value>`r`n  </data>"
            }
        }
        
        $result.Additional += $resxTemplate -replace '{DATA_ENTRIES}', $dataEntries
    }
    
    return $result
}

function Generate-DesignerContent {
    param(
        [string]$ProjectName
    )
    
    $fullProjectName = "$($ProjectName)Resources"
    
    return @"
//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.42000
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace $fullProjectName {
    using System;
    
    
    /// <summary>
    ///   A strongly-typed resource class, for looking up localized strings, etc.
    /// </summary>
    // This class was auto-generated by the StronglyTypedResourceBuilder
    // class via a tool like ResGen or Visual Studio.
    // To add or remove a member, edit your .ResX file then rerun ResGen
    // (or VS etc.) to regenerate it again.  If you remove a member from the
    // .ResX file and then regenerate, the strongly-typed resource class will
    // no longer contain that member.
    [global::System.CodeDom.Compiler.GeneratedCodeAttribute("System.Resources.Tools.StronglyTypedResourceBuilder", "17.0.0.0")]
    [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
    [global::System.Runtime.CompilerServices.CompilerGeneratedAttribute()]
    internal class $fullProjectName`_msgrsc {
        
        private static global::System.Resources.ResourceManager resourceMan;
        
        private static global::System.Globalization.CultureInfo resourceCulture;
        
        [global::System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1811:AvoidUncalledPrivateCode")]
        internal $fullProjectName`_msgrsc() {
        }
        
        /// <summary>
        ///   Returns the cached ResourceManager instance used by this class.
        /// </summary>
        [global::System.ComponentModel.EditorBrowsableAttribute(global::System.ComponentModel.EditorBrowsableState.Advanced)]
        internal static global::System.Resources.ResourceManager ResourceManager {
            get {
                if (object.ReferenceEquals(resourceMan, null)) {
                    global::System.Resources.ResourceManager temp = new global::System.Resources.ResourceManager("$fullProjectName.$fullProjectName`_msgrsc", typeof($fullProjectName`_msgrsc).Assembly);
                    resourceMan = temp;
                }
                return resourceMan;
            }
        }
        
        /// <summary>
        ///   Overrides the current thread's CurrentUICulture property for all
        ///   resource lookups using this strongly typed resource class.
        /// </summary>
        [global::System.ComponentModel.EditorBrowsableAttribute(global::System.ComponentModel.EditorBrowsableState.Advanced)]
        internal static global::System.Globalization.CultureInfo Culture {
            get {
                return resourceCulture;
            }
            set {
                resourceCulture = value;
            }
        }
    }
}
"@
}

# Main execution
try {
    New-SpResourcesProject -OutputPath $OutputPath -ProgramName $ProgramName -DefaultLanguage $DefaultLanguage -AdditionalLanguages $additional
}
catch {
    Write-Error "Error creating Stored Procedure Resources project: $($_.Exception.Message)"
    exit 1
}
