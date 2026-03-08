# 시스템 프로필 경로 접근에 관리자 권한이 필요하므로 권한 상승
. "$PSScriptRoot\Invoke-AsAdmin.ps1"
Invoke-AsAdmin -ScriptPath $PSCommandPath -UseX86

$arch = if ([Environment]::Is64BitProcess) { "x64 (64비트)" } else { "x86 (32비트)" }
Write-Host "== PowerShell 프로세스: $arch ==" -ForegroundColor Cyan

function Resolve-RealPath {
  param([string]$Path)

  $item = (Get-Item ($Path)).Target
  if ($item -is [array] -and $item.Count -gt 0) {
    "정션/심볼릭 링크 원본 경로: $($item[0])"
  }
  else {
    "링크가 아닌 경로 (또는 빈 Target): $($Path)"
  }
}

# 실제 경로 : 관리자 권한이 필요없는 보통의 실제 경로
Write-Host "== 일반 폴더 경로 =="
$m2path = "C:\Normal_Folder"
Resolve-RealPath -Path $m2path

# 시스템 프로필 경로:  관리자 권한이 필요한 실제 경로
Write-Host "== 시스템 프로필 경로 =="
$m2path = "C:\Windows\System32\config\systemprofile\.m2"
Resolve-RealPath -Path $m2path

# 정션 경로
Write-Host "== 정션 링크 =="
$m2path = "C:\Maven-Junction"
Resolve-RealPath -Path $m2path

# 심볼릭 링크 경로
Write-Host "== 심볼릭 링크 =="
$m2path = "C:\Maven-Symlink"
Resolve-RealPath -Path $m2path

