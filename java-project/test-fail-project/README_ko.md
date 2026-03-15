# test-fail-project

한국어 | [English](README.md)

## 프로젝트 목적

Jenkins의 **Execute Windows batch command** 빌드 스텝에서 `C:\Windows\SysWOW64\cmd.exe /c`를 사용해 `mvnw clean test`를 실행했을 때,
테스트가 실패한 경우 해당 실패가 Jenkins 빌드 전체의 실패로 올바르게 전파되는지 확인하기 위해 만든 테스트 프로젝트입니다.

## 확인 시나리오

- **✨ SYSTEM 계정으로 실행되는 Jenkins에서 Jenkins Freestyle Job을 설정합니다.**

- Jenkins Freestyle 프로젝트의 **Execute Windows batch command** 스텝에서 사용하는 cmd.exe를 x86 환경의 아래 경로로 지정합니다.

- 빌드 스텝의 커맨드에 아래와 같이 입력합니다.

  ```bat
  C:\Windows\SysWOW64\cmd.exe /c mvnw clean test
  ```

- 프로젝트 내 테스트가 의도적으로 실패하도록 작성되어 있으며, 이때 Jenkins 빌드가 `FAILURE`로 처리되는지 여부를 검증합니다.

## 기대하는 동작

- 테스트 실패 시 Jenkins Job이 **실패(FAILURE)** 처리되어야 합니다.

> **참고:** `C:\Windows\SysWOW64\cmd.exe`는 64비트 Windows에서 32비트(x86) 프로세스를 실행하는 cmd.exe입니다.
> 일반적인 64비트 cmd는 `C:\Windows\System32\cmd.exe`이며, 두 환경 간에 동작 차이가 있는지 함께 확인할 수 있습니다.

## 프로젝트 구성

- **✨ SYSTEM 계정으로 실행되는 Jenkins에서 Jenkins Freestyle Job을 설정합니다.**
- **Java 17 - x86**
- **JUnit Jupiter (JUnit 6)**
- Maven Wrapper(`mvnw`) 사용



## 확인결과 (`cmd /c`로 감싸더라도 실패 전파 잘됩니다. 😅)

![image-20260314181353260](doc-resources/image-20260314181353260.png)
