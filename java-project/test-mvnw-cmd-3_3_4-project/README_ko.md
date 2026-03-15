# test-mvnw-cmd-3_3_4-project

한국어 | [English](README.md)

## 프로젝트 목적

Maven Wrapper 3.3.4에서 mvnw.cmd를 수정하지 않고 그대로 사용한 프로젝트의 테스트



## 확인 시나리오
- **✨ SYSTEM 계정으로 실행되는 Jenkins에서 Jenkins Freestyle Job을 설정합니다.**

- Jenkins Freestyle 프로젝트의 **Execute Windows batch command** 스텝안에서,  실행하려는 mvnw.cmd 명령을 x86 환경 cmd.exe로서 사용되도록 빌드 스텝의 커맨드에 아래와 같이 입력합니다.

  ```bat
  C:\Windows\SysWOW64\cmd.exe /c mvnw clean test
  ```

- Jenkins 빌드가 `FAILURE`로 처리되는지 여부를 검증합니다.



## 기대하는 동작

- 테스트 코드는 항상 성공하는 코드이지만, 시스템 프로필 경로를 사용하는 .m2 경로를 설정하는 mvnw.cmd의 로직에 문제가 있어, Java 코드 실행전에 실패하며, Jenkins Job은 **실패(FAILURE)** 처리되어야 합니다.

> **참고:** `C:\Windows\SysWOW64\cmd.exe`는 64비트 Windows에서 32비트(x86) 프로세스를 실행하는 cmd.exe입니다.
> 일반적인 64비트 cmd는 `C:\Windows\System32\cmd.exe`이며, 두 환경 간에 동작 차이가 있는지 함께 확인할 수 있습니다.

## 프로젝트 구성

- ✨ **Jenkins: 로컬 시스템 계정(SYSTEM)으로 서비스 실행**
- **Java 17 - x86**
- **JUnit Jupiter (JUnit 6)**
- Maven Wrapper(`mvnw`) 사용


