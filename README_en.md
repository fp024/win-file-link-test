# Resolving Real Paths of Windows Links — Test

> 🇰🇷 [한국어 버전 → README.md](README.md)

> This test was created in response to the following issue reported against a fix I previously submitted to Maven Wrapper. 😂
>
> ### [Fix Windows Junction Link support in mvnw.cmd](https://github.com/apache/maven-wrapper/pull/143)
>
> ### New issue
>
> ### [mvnw.cmd crashes with "Cannot index into a null array" on 32-bit System Profile path (Jenkins service)](https://github.com/apache/maven-wrapper/issues/395)
>
> The tests below verify that the proposed fix handles all affected path types correctly.


## Setting Up Test Paths

Run `setup.bat` to create the following directory structure:

```
C:\
├── Regular_Folder\                    ← Regular directory (created directly)
├── Maven-Repo-Test-Folder\            ← Actual target directory for Junction/Symlink
├── Maven-Junction\                    ← Junction link → C:\Maven-Repo-Test-Folder
├── Maven-Symlink\                     ← Symbolic link → C:\Maven-Repo-Test-Folder
└── Windows\
    └── System32\
        └── config\
            └── systemprofile\         ← System default profile path
                └── .m2-test-folder\   ← Created manually (requires admin rights)
```


## Running the Test

Verifies that `Resolve-RealPath` correctly resolves system profile paths, junction links, and symbolic links.

```cmd
run-junction-test.bat
```

This tests the **Resolve-RealPath** function in [scripts/junction-test.ps1](scripts/junction-test.ps1). 😅

```powershell
### Returns the real path for a given path (resolves junctions and symbolic links) ###
function Resolve-RealPath {
  param([string]$Path)

  $linkTarget = (Get-Item $Path).Target
  if ($linkTarget -is [array] -and $linkTarget.Count -gt 0) {
    return $linkTarget[0]
  }
  return $Path
}
```


## Output

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

* Regular path ✔️
  * `C:\Regular_Folder`
* System profile path ✔️
  * `C:\Windows\System32\config\systemprofile\.m2-test-folder`
* Junction link ✔️
  * `C:\Maven-Junction -> C:\Maven-Repo-Test-Folder`
* Symbolic link ✔️
  * `C:\Maven-Symlink -> C:\Maven-Repo-Test-Folder`

All path types resolved correctly. 👍
