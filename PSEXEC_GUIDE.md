# PsExec 설치 및 사용 가이드

> 💡 CMD환경에서 SYSTEM 계정으로 mvnw을 실행해보고 싶을 때... PsExec를 사용해서 CMD를 실행하고, 그 안에서 mvnw을 실행해서도 테스트 해볼 수 있다.



## PsExec란?

PsExec는 Microsoft Sysinternals Suite의 일부로, 원격 시스템에서 프로세스를 실행할 수 있게 해주는 경량 텔넷 대체 도구입니다.

## 설치 방법

### 방법 1: 공식 웹사이트에서 다운로드

1. [Microsoft Sysinternals PsExec 다운로드 페이지](https://docs.microsoft.com/en-us/sysinternals/downloads/psexec)에서 ZIP 파일 다운로드
2. ZIP 파일 압축 해제
3. `psexec.exe` 파일을 시스템 PATH에 포함된 디렉토리로 이동 (예: `C:\Windows\System32`) 또는 원하는 위치에 저장 후 해당 경로를 환경변수 PATH에 추가

### 방법 2: Chocolatey를 통한 설치

Chocolatey 패키지 매니저를 사용하여 PsExec를 설치할 수 있습니다.

```bash
choco install psexec
```

### Sysinternals Suite 전체 설치

PsExec 외에 다른 Sysinternals 도구들도 함께 설치하려면:

```bash
choco install sysinternals
```

## 사전 요구사항

- Windows 운영 체제
- 관리자 권한 (설치 및 실행 시)
- Chocolatey 패키지 매니저 ([설치 방법](https://chocolatey.org/install))

## 기본 사용법

```bash
# 로컬 시스템에서 명령 실행
psexec -i -s cmd.exe

# 원격 시스템에서 명령 실행
psexec \\컴퓨터이름 -u 사용자명 -p 비밀번호 명령어
```

## 주요 옵션

- `-i`: 대화형 모드로 실행
- `-s`: System 계정으로 실행 (**주의: 관리자 권한으로 명령 프롬프트/PowerShell을 실행한 상태에서 사용해야 함**)
- `-u`: 사용자 이름 지정
- `-p`: 비밀번호 지정
- `-d`: 프로세스 종료를 기다리지 않음

## 참고 자료

- [Microsoft Sysinternals PsExec 공식 문서](https://docs.microsoft.com/en-us/sysinternals/downloads/psexec)
