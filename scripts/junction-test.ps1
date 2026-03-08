# 시스템 프로필 경로 접근에 관리자 권한이 필요하므로 권한 상승
. "$PSScriptRoot\Invoke-AsAdmin.ps1"
Invoke-AsAdmin -ScriptPath $PSCommandPath -UseX86

$arch = if ([Environment]::Is64BitProcess) { "x64 (64비트)" } else { "x86 (32비트)" }
Write-Host "== PowerShell 프로세스: $arch ==" -ForegroundColor Cyan


### 경로를 입력받아 실제 경로를 반환 함수 ###
function Resolve-RealPath {
  param([string]$Path)

  $item = (Get-Item $Path).Target
  if ($item -is [array] -and $item.Count -gt 0) {
    return $item[0]
  }
  return $Path
}


#### 테스트 ###
# 실제 경로 : 관리자 권한이 필요없는 보통의 실제 경로
Write-Host "== 일반 폴더 경로 =="
Resolve-RealPath -Path "C:\Normal_Folder"

# 시스템 프로필 경로:  관리자 권한이 필요한 실제 경로
Write-Host "== 시스템 프로필 경로 =="
Resolve-RealPath -Path "C:\Windows\System32\config\systemprofile\.m2"

# 정션 경로
Write-Host "== 정션 링크 =="
Resolve-RealPath -Path "C:\Maven-Junction"

# 심볼릭 링크 경로
Write-Host "== 심볼릭 링크 =="
Resolve-RealPath -Path "C:\Maven-Symlink"

