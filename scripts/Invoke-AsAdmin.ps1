# Checks whether the current process has administrator privileges.
# If not, re-launches the specified script elevated.
#
# Usage:
#   . "$PSScriptRoot\Invoke-AsAdmin.ps1"
#   Invoke-AsAdmin -ScriptPath $PSCommandPath

function Invoke-AsAdmin {
    param(
        [Parameter(Mandatory)][string]$ScriptPath,
        # Default: $true (32-bit) to reproduce Jenkins x86 environment
        # Pass $false to run as 64-bit
        [bool]$UseX86 = $true
    )

    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator
    )

    if (-not $isAdmin) {
        if ($UseX86) {
            # Fixed path for 32-bit PowerShell (Windows Server 2022 / Windows 10 & 11)
            $exe = "C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe"
        } else {
            $exe = if (Get-Command pwsh -ErrorAction SilentlyContinue) { "pwsh" } else { "powershell" }
        }
        Start-Process $exe -ArgumentList "-NoExit", "-File", "`"$ScriptPath`"" -Verb RunAs
        exit
    }
}
