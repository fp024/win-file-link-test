# 현재 프로세스가 관리자 권한인지 확인하고,
# 아닐 경우 지정한 스크립트를 관리자 권한으로 재실행한다.
# 
# 사용법:
#   . "$PSScriptRoot\Invoke-AsAdmin.ps1"
#   Invoke-AsAdmin -ScriptPath $PSCommandPath

function Invoke-AsAdmin {
    param(
        [Parameter(Mandatory)][string]$ScriptPath,
        # Jenkins x86 환경 재현을 위해 기본값을 32비트로 고정
        # 64비트로 실행하려면 -UseX86:$false 를 명시한다
        [switch]$UseX86 = $true
    )

    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator
    )

    if (-not $isAdmin) {
        if ($UseX86) {
            # 32비트 PowerShell 고정 경로 (Windows Server 2022 / Windows 10·11 공통)
            $exe = "C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe"
        } else {
            $exe = if (Get-Command pwsh -ErrorAction SilentlyContinue) { "pwsh" } else { "powershell" }
        }
        Start-Process $exe -ArgumentList "-NoExit", "-File", "`"$ScriptPath`"" -Verb RunAs
        exit
    }
}
