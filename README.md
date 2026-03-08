# 윈도우 링크의 원본 경로 찾기 테스트

> 🌐 [English version available → README_en.md](README_en.md)

> 예전에 Maven Wrapper에 PR올렸던 아래 내용에 문제가 있다고 이슈가 올라와서... 😂😂😂
>
> ### [Fix Windows Junction Link support in mvnw.cmd](https://github.com/apache/maven-wrapper/pull/143)
>
> 
>
> ### 새로 올라온 이슈
>
> ### [mvnw.cmd crashes with "Cannot index into a null array" on 32-bit System Profile path (Jenkins service)](https://github.com/apache/maven-wrapper/issues/395)
>
> 위의 내용 관련해서 테스트를 진행해보았다.





## 테스트 경로 생성
setup.bat을 실행하면 다음과 같은 경로 구조를 만든다.

```
C:\
├── Regular_Folder\                    ← 일반 디렉토리
├── Maven-Repo-Test-Folder\            ← Junction/Symlink 대상 실제 디렉토리
├── Maven-Junction\                    ← Junction 링크 → C:\Maven-Repo-Test-Folder
├── Maven-Symlink\                     ← Symbolic 링크 → C:\Maven-Repo-Test-Folder
└── Windows\
    └── System32\
        └── config\
            └── systemprofile\         ← 시스템 기본 경로
                └── .m2-test-folder\   ← 직접 생성 (관리자 권한 필요)
```



## 스크립트 실행

시스템 프로필 경로 이하의 경로, 정션 링크, 심볼릭 링크 모두 정상적으로 가져오는지 확인

```cmd
run-junction-test.bat
```

[scripts/junction-test.ps1](scripts/junction-test.ps1) 스크립트의 **Resolve-RealPath** 함수의 기능을 확인하는 것이긴하다. 😅

```powershell
### Returns the real path for a given path (resolves junctions and symbolic links) ###
function Resolve-RealPath {
  param([string]$Path)

  $item = (Get-Item $Path).Target
  if ($item -is [array] -and $item.Count -gt 0) {
    return $item[0]
  }
  return $Path
}
```



## 실행결과

```
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

Install the latest PowerShell for new features and improvements! https://aka.ms/PSWindows

== PowerShell process: x86 (32-bit) ==
== Regular folder ==
C:\Regular_Folder
== System profile path ==
C:\Windows\System32\config\systemprofile\.m2-test-folder
== Junction link ==
C:\Maven-Repo-Test-Folder
== Symbolic link ==
C:\Maven-Repo-Test-Folder
PS C:\WINDOWS\system32>
```

* 일반경로 ✔️
  * `C:\Regular_Folder`
* 시스템 프로파일 경로 이하 ✔️
  * `C:\Windows\System32\config\systemprofile\.m2-test-folder`
* 정션링크 ✔️
  * `C:\Maven-Junction -> C:\Maven-Repo-Test-Folder`
* 심볼릭 링크 ✔️
  * `C:\Maven-Symlink-> C:\Maven-Repo-Test-Folder`

정상동작함을 확인하였다. 👍

