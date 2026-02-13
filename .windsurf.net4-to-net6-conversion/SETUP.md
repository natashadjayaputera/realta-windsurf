# Cross-PC Setup Guide

## Prerequisites

### 1. .NET SDK Requirements
- **Required**: .NET 8.0 SDK or later
- **Recommended**: Latest .NET 8.0 LTS version

**Installation:**
```powershell
# Download and install from: https://dotnet.microsoft.com/download/dotnet/8.0
# Or use winget:
winget install Microsoft.DotNet.SDK.8
```

**Verification:**
```powershell
dotnet --version
# Should show 8.x.x or later
```

### 2. PowerShell Requirements
- **Required**: PowerShell 5.1 (Windows built-in) or PowerShell 7.x (recommended)
- **Execution Policy**: Must allow script execution

**Setup Execution Policy:**
```powershell
# Check current policy
Get-ExecutionPolicy

# Set to allow scripts (run as Administrator if needed)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### 3. Repository Setup
1. Clone the repository:
```powershell
git clone <repository-url>
cd <repository-directory>
```

2. Verify structure:
```powershell
# Should see these directories
ls .windsurf\scripts
ls .windsurf\tools
```

### 4. Install Extensions
- [Compare Folders](https://marketplace.windsurf.com/vscode/item?itemName=moshfeu.compare-folders)
- [Right Click Run File](https://marketplace.windsurf.com/vscode/item?itemName=crsx.right-click-run-file)

## Tool Validation

### Build All Tools
```powershell
# Navigate to repository root
cd <repository-directory>

# Build each tool to verify dependencies
dotnet build .windsurf\tools\VbParser\VbParser.csproj
dotnet build .windsurf\tools\CsIndentFixer\CsIndentFixer.csproj
dotnet build .windsurf\tools\CsTemplateInjector\CsTemplateInjector.csproj
dotnet build .windsurf\tools\VbCodeReducer\VbCodeReducer.csproj
```

### Test Script Execution
```powershell
# Test a simple script to verify PowerShell execution
.\.windsurf\scripts\find-cls-file.ps1 -SearchFolder "test" -OutputFolder "test"
```

## Path Compatibility

### Cross-Platform Path Support
- **Tools**: Use `Path.Combine()` for automatic cross-platform path handling
- **Scripts**: Use PowerShell which automatically handles path separators
- **Documentation**: All examples now use forward slashes `/` for cross-platform compatibility

### Path Resolution
- **Repository Root**: Automatically detected by looking for `.git` directory
- **Working Directory**: Scripts can be run from any directory within the repository
- **Relative Paths**: All internal paths are relative to auto-detected repository root
- **Shared Functions**: Common functionality in `Common-Functions.ps1` with `Find-GitRoot()` function

### Directory Structure
```
.windsurf/
├── scripts/           # PowerShell scripts (cross-platform)
│   ├── detect-batch-processes.ps1
│   ├── discover-interfaces.ps1
│   ├── execute-vb-parser.ps1
│   ├── find-cls-cs-files.ps1
│   ├── find-cls-file.ps1
│   ├── find-dto-files.ps1
│   ├── fix-indentation.ps1
│   └── inject-functions.ps1
└── tools/             # .NET console applications (cross-platform)
    ├── CsIndentFixer/
    ├── CsTemplateInjector/
    ├── VbCodeReducer/
    └── VbParser/

chunks_cs/             # Generated C# chunks
chunks_vb/             # Generated VB chunks
```

## Usage Guidelines

### Running Scripts
1. **Run from any directory** - Scripts auto-detect repository root via `.git` folder
2. **Use PowerShell** - All scripts are PowerShell scripts (.ps1)
3. **Provide required parameters** - Scripts validate required parameters
4. **No RootPath needed** - Root folder is automatically detected

### Example Usage
```powershell
# From any directory within repository
.\.windsurf\scripts\detect-batch-processes.ps1 -ProgramName "FAT00100"

# From subdirectory
cd .windsurf
.\scripts\detect-batch-processes.ps1 -ProgramName "FAT00100"

# From repository root
.\.windsurf\scripts\detect-batch-processes.ps1 -ProgramName "FAT00100"
```

## Troubleshooting

### Common Issues

#### 1. "Cannot be loaded because running scripts is disabled"
**Solution:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

#### 2. "dotnet: command not found"
**Solution:** Install .NET 8.0 SDK from the official Microsoft website

#### 3. "The specified project file does not exist"
**Solution:** Ensure you're running from the repository root directory

#### 4. "Access denied" errors
**Solution:** Run PowerShell as Administrator or check file permissions

### Path Issues
- Scripts use `Find-GitRoot()` function to automatically detect repository root
- All paths are relative to the auto-detected repository root
- Scripts work from any directory within the git repository
- Ensure no spaces in repository path or quote paths if spaces exist

### .NET Version Issues
- Tools target .NET 8.0 for maximum compatibility
- If you have .NET 6.0 only, change `<TargetFramework>net8.0</TargetFramework>` to `<TargetFramework>net6.0</TargetFramework>` in all .csproj files

## Development Notes

### Adding New Scripts
1. Use shared `Find-GitRoot()` function for repository root detection
2. Load shared functions: `. (Join-Path (Split-Path $PSScriptRoot -Parent) "scripts\Common-Functions.ps1")`
3. Include proper error handling and validation
4. Follow existing parameter naming conventions
5. Add execution policy error handling as shown in existing scripts

### Adding New Tools
1. Target .NET 8.0 for compatibility
2. Include proper error handling
3. Update this documentation with any new requirements

## Support

For issues related to:
- **Setup**: Check this documentation first
- **Script errors**: Verify prerequisites and run from repository root
- **Tool errors**: Ensure .NET 8.0 SDK is installed and tools build successfully

## File Structure
```
.windsurf/
├── scripts/           # PowerShell scripts
│   ├── categorize-functions.ps1
│   ├── detect-batch-processes.ps1
│   ├── discover-interfaces.ps1
│   ├── execute-vb-parser.ps1
│   ├── find-cls-cs-files.ps1
│   ├── find-cls-file.ps1
│   ├── find-dto-files.ps1
│   ├── fix-class-declaration.ps1
│   ├── fix-indentation.ps1
│   └── inject-functions.ps1
└── tools/             # .NET console applications
    ├── CsIndentFixer/
    ├── CsTemplateInjector/
    ├── VbCodeReducer/
    └── VbParser/
```

All scripts and tools are now configured for cross-PC compatibility with proper error handling and version requirements.
