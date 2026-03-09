# Elevate to admin because system profile path requires administrator privileges
. "$PSScriptRoot\Invoke-AsAdmin.ps1"
Invoke-AsAdmin -ScriptPath $PSCommandPath -UseX86 $true

$arch = if ([Environment]::Is64BitProcess) { "x64 (64-bit)" } else { "x86 (32-bit)" }
Write-Host "== PowerShell process: $arch ==" -ForegroundColor Cyan


### Returns the real path for a given path (resolves junctions and symbolic links) ###
# ✨ Function that reproduces the issue from "PR: Fix Windows Junction Link support in mvnw.cmd"
# * https://github.com/apache/maven-wrapper/pull/143/changes/cefb22592fe3397c7652bc3a3866bd73cf5ec8c5
function Resolve-RealPath {
  param([string]$Path)

  if ((Get-Item $Path).Target[0] -eq $null) {
    return $Path  
  }
  else {
    return (Get-Item $Path).Target[0]
  }
}


### Tests ###
# Regular path: no admin rights required
Write-Host "== Regular folder =="
Resolve-RealPath -Path "C:\Regular_Folder"

# 💢System profile path: null error only occurs when referencing a real path under the system profile
Write-Host "== System profile path =="
Resolve-RealPath -Path "C:\Windows\System32\config\systemprofile\.m2-test-folder"

# Junction
Write-Host "== Junction link =="
Resolve-RealPath -Path "C:\Maven-Junction"

# Symbolic link
Write-Host "== Symbolic link =="
Resolve-RealPath -Path "C:\Maven-Symlink"
