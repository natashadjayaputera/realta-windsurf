# Shared PowerShell Functions
# Common functions used across windsurf scripts

function Find-GitRoot {
    <#
    .SYNOPSIS
    Finds the root directory of the git repository by searching for .git folder.
    
    .DESCRIPTION
    This function starts from the current directory and searches up the directory tree
    until it finds a .git folder, which indicates the root of a git repository.
    
    .RETURN
    Returns the full path to the git repository root directory.
    If no git repository is found, returns the current directory.
    #>
    $currentDir = (Get-Location).Path
    
    while ($null -ne $currentDir) {
        $gitPath = Join-Path $currentDir ".git"
        if (Test-Path $gitPath) {
            return $currentDir
        }
        $currentDir = Split-Path $currentDir -Parent
    }
    
    # If no git repository found, return current directory
    return (Get-Location).Path
}
