# setup.ps1
. "$PSScriptRoot\Invoke-AsAdmin.ps1"
Invoke-AsAdmin -ScriptPath $PSCommandPath

# From here, running with administrator privileges
mkdir C:\Regular_Folder -Force
mkdir C:\Maven-Repo-Test-Folder -Force
if (Test-Path C:\Maven-Junction) { Write-Warning "C:\Maven-Junction already exists. Delete it manually and re-run." }
else { New-Item -ItemType Junction     -Path C:\Maven-Junction -Target C:\Maven-Repo-Test-Folder }

if (Test-Path C:\Maven-Symlink)  { Write-Warning "C:\Maven-Symlink already exists. Delete it manually and re-run." }
else { New-Item -ItemType SymbolicLink -Path C:\Maven-Symlink  -Target C:\Maven-Repo-Test-Folder }
mkdir "C:\Windows\System32\config\systemprofile\.m2-test-folder" -Force