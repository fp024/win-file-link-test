# Elevate to admin because system profile path requires administrator privileges
. "$PSScriptRoot\Invoke-AsAdmin.ps1"
Invoke-AsAdmin -ScriptPath $PSCommandPath -UseX86 $true

$arch = if ([Environment]::Is64BitProcess) { "x64 (64-bit)" } else { "x86 (32-bit)" }
Write-Host "== PowerShell process: $arch ==" -ForegroundColor Cyan


### Returns the real path for a given path (resolves junctions and symbolic links) ###
function Resolve-RealPath {
  param([string]$Path)

  $item = (Get-Item $Path).Target
  if ($item -is [array] -and $item.Count -gt 0) {
    return $item[0]
  }
  return $Path
}


### Tests ###
# Regular path: no admin rights required
Write-Host "== Regular folder =="
Resolve-RealPath -Path "C:\Regular_Folder"

# System profile path: requires admin rights
Write-Host "== System profile path =="
Resolve-RealPath -Path "C:\Windows\System32\config\systemprofile\.m2"

# Junction
Write-Host "== Junction link =="
Resolve-RealPath -Path "C:\Maven-Junction"

# Symbolic link
Write-Host "== Symbolic link =="
Resolve-RealPath -Path "C:\Maven-Symlink"
