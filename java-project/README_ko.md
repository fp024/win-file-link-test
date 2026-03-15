# Jenkins에서 실제 동작 테스트

[English](README.md) | 한국어

>  Windows Server 2022 180일 평가판에 Jenkins 2.541.2를 설치해서 동작을 확인하였습니다.



## Jenkins 설정 준비

### ✨ 로그인 타입

SYSTEM 계정으로 Job이 실행되도록 Run service as LocalSystem으로 설정한다.

![image-20260312070359526](doc-resources/image-20260312070359526.png)



### ✨ Jenkins의 "Execute Windows batch command" 스텝이  x86환경으로 정확하게 실행되기 위한 방법 2가지

#### 1. Jenkins 자체를 실행하는 JDK를 x86용으로 설정

윈도우 64bit에서 Jenkins 자체를 실행하는 JDK가 x64용 일경우 해당 부분의 cmd가 64bit용으로 실행된다.

* x64(64bit): `C:\Windows\System32\cmd.exe`
* x86(32bit): `C:\Windows\SysWOW64\cmd.exe`

그러나 Jenkins 자체를 실행하는 JDK가 x86일 경우 x86용 cmd가 실행된다.



#### 2. Execute Windows batch command에 실행되는 명령을 C:\Windows\SysWOW64\cmd.exe /c로 감싸서 실행한다.

1번 방법은 이미 Jenkins를 x64용 JDK로 잘 사용하고 있을 경우, 바꾸기가 어려운 점이 있다.

그때는 Execute Windows batch command에 실행되는 명령을 C:\Windows\SysWOW64\cmd.exe /c로 감싸서 실행하는 방법을 고려해볼 수 있다.



## Maven Wrapper 3.3.4의 mvnw.cmd 원본 테스트 Job 실행

### Job 생성

FreeStyle 프로젝트로 생성하고 GitHub에서 테스트할 프로젝트를 받아서 mvnw clean test 를 실행하는 단순한 Job을 만든다.

* Git 설정

  * https://github.com/fp024/win-file-link-test
  * 하위 프로젝트 디렉토리: `java-project/test-mvnw-cmd-3_3_4-project`

* Build Steps에다 Execute Windows batch command 추가해서 다음 명령 설정

  ```cmd
  SET TEST_PROJECT_ROOT=.\java-project\test-mvnw-cmd-3_3_4-project
  C:\Windows\SysWOW64\cmd.exe /c "%TEST_PROJECT_ROOT%\mvnw.cmd -f %TEST_PROJECT_ROOT%\pom.xml clean package"
  ```



### 실행결과

```
Started by user fp024
Running as SYSTEM
...
...
[test-mvnw-cmd-3_3_4-project build] $ cmd /c call C:\Windows\TEMP\jenkins2526691040556599341.bat

C:\ProgramData\Jenkins\.jenkins\workspace\test-mvnw-cmd-3_3_4-project build>SET TEST_PROJECT_ROOT=.\java-project\test-mvnw-cmd-3_3_4-project 

C:\ProgramData\Jenkins\.jenkins\workspace\test-mvnw-cmd-3_3_4-project build>C:\Windows\SysWOW64\cmd.exe /c ".\java-project\test-mvnw-cmd-3_3_4-project\mvnw.cmd -f .\java-project\test-mvnw-cmd-3_3_4-project\pom.xml clean package" 
icm : Cannot index into a null array.
At line:1 char:156
+ ... 'mvnw.cmd'; icm -ScriptBlock ([Scriptblock]::Create((Get-Content -Raw ...
+                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : InvalidOperation: (:) [Invoke-Command], RuntimeException
    + FullyQualifiedErrorId : NullArray,Microsoft.PowerShell.Commands.InvokeCommandCommand
 
Cannot start maven from wrapper  

C:\ProgramData\Jenkins\.jenkins\workspace\test-mvnw-cmd-3_3_4-project build>exit 1 
Build step 'Execute Windows batch command' marked build as failure
Finished: FAILURE
```

✨ 이슈 올리신 분의 글 내용 처럼, **Cannot index into a null array. 오류가 발생함을 확인.** ✨





## Maven Wrapper 3.3.4의 mvnw.cmd 파일 수정 후의 테스트 Job 실행



### Job 생성

FreeStyle 프로젝트로 생성하고 GitHub에서 테스트할 프로젝트를 받아서 mvnw clean test 를 실행하는 단순한 Job을 만든다.

* Git 설정

  * https://github.com/fp024/win-file-link-test
  * 하위 프로젝트 디렉토리: `java-project/test-mvnw-cmd-mod-project`

* Build Steps에다 Execute Windows batch command 추가해서 다음 명령 설정

  ```cmd
  SET TEST_PROJECT_ROOT=.\java-project\test-mvnw-cmd-mod-project
  C:\Windows\SysWOW64\cmd.exe /c "%TEST_PROJECT_ROOT%\mvnw.cmd -f %TEST_PROJECT_ROOT%\pom.xml clean package"
  ```



### 실행결과

```
Started by user fp024
Running as SYSTEM
...
...
[test-mvnw-cmd-mod-project] $ cmd /c call C:\Windows\TEMP\jenkins1971809220698492151.bat

C:\ProgramData\Jenkins\.jenkins\workspace\test-mvnw-cmd-mod-project>SET TEST_PROJECT_ROOT=.\java-project\test-mvnw-cmd-mod-project 

C:\ProgramData\Jenkins\.jenkins\workspace\test-mvnw-cmd-mod-project>C:\Windows\SysWOW64\cmd.exe /c ".\java-project\test-mvnw-cmd-mod-project\mvnw.cmd -f .\java-project\test-mvnw-cmd-mod-project\pom.xml clean package" 
[INFO] Scanning for projects...
[INFO] 
[INFO] ------------< org.fp024.example:test-mvnw-cmd-mod-project >-------------
[INFO] Building test-fail-project 1.0-SNAPSHOT
[INFO]   from pom.xml
[INFO] --------------------------------[ jar ]---------------------------------
[INFO] 
...
...
[INFO] 
[INFO] -------------------------------------------------------
[INFO]  T E S T S
[INFO] -------------------------------------------------------
[INFO] Running org.fp024.example.AppTest
[INFO] Tests run: 1, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.051 s -- in org.fp024.example.AppTest
[INFO] 
[INFO] Results:
[INFO] 
[INFO] Tests run: 1, Failures: 0, Errors: 0, Skipped: 0
[INFO] 
[INFO] 
[INFO] --- jar:3.4.1:jar (default-jar) @ test-mvnw-cmd-mod-project ---
[INFO] Building jar: C:\ProgramData\Jenkins\.jenkins\workspace\test-mvnw-cmd-mod-project\java-project\test-mvnw-cmd-mod-project\target\test-mvnw-cmd-mod-project-1.0-SNAPSHOT.jar
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  3.098 s
[INFO] Finished at: 2026-03-15T05:17:20-07:00
[INFO] ------------------------------------------------------------------------

C:\ProgramData\Jenkins\.jenkins\workspace\test-mvnw-cmd-mod-project>exit 0 
Finished: SUCCESS
```

✨  **Cannot index into a null array. 오류가 해결됨을 확인**





## Execute Windows batch command에서 `cmd /c`로 감쌌을 때, 내부의 빌드 실패가 Jenkins 빌드 실패로 전파되는지 확인

### Job 생성

FreeStyle 프로젝트로 생성하고 GitHub에서 테스트할 프로젝트를 받아서 mvnw clean test 를 실행하는 단순한 Job을 만든다.

그런데 이 프로젝트는 JUnit 테스트가 실패하는 프로젝트이다.

* Git 설정

  * https://github.com/fp024/win-file-link-test
  * 하위 프로젝트 디렉토리: `java-project/test-fail-project`

* Build Steps에다 Execute Windows batch command 추가해서 다음 명령 설정

  ```cmd
  SET TEST_PROJECT_ROOT=.\java-project\test-fail-project
  C:\Windows\SysWOW64\cmd.exe /c "%TEST_PROJECT_ROOT%\mvnw.cmd -f %TEST_PROJECT_ROOT%\pom.xml clean package"
  ```



### 실행결과

```
Started by user fp024
Running as SYSTEM
...
...
[test-fail-project build] $ cmd /c call C:\Windows\TEMP\jenkins15495466030859893950.bat

C:\ProgramData\Jenkins\.jenkins\workspace\test-fail-project build>SET TEST_PROJECT_ROOT=.\java-project\test-fail-project 

C:\ProgramData\Jenkins\.jenkins\workspace\test-fail-project build>C:\Windows\SysWOW64\cmd.exe /c ".\java-project\test-fail-project\mvnw.cmd -f .\java-project\test-fail-project\pom.xml clean package" 
[INFO] Scanning for projects...
[INFO] 
[INFO] ----------------< org.fp024.example:test-fail-project >-----------------
[INFO] Building test-fail-project 1.0-SNAPSHOT
[INFO]   from pom.xml
[INFO] --------------------------------[ jar ]---------------------------------
[INFO] 
...
[INFO] 
[INFO] -------------------------------------------------------
[INFO]  T E S T S
[INFO] -------------------------------------------------------
[INFO] Running org.fp024.example.AppTest
[ERROR] Tests run: 1, Failures: 1, Errors: 0, Skipped: 0, Time elapsed: 0.059 s <<< FAILURE! -- in org.fp024.example.AppTest
[ERROR] org.fp024.example.AppTest.shouldAnswerWithTrue -- Time elapsed: 0.037 s <<< FAILURE!
org.opentest4j.AssertionFailedError: expected: <true> but was: <false>
	at org.junit.jupiter.api.AssertionFailureBuilder.build(AssertionFailureBuilder.java:158)
	at org.junit.jupiter.api.AssertionFailureBuilder.buildAndThrow(AssertionFailureBuilder.java:139)
	at org.junit.jupiter.api.AssertTrue.failNotTrue(AssertTrue.java:69)
	at org.junit.jupiter.api.AssertTrue.assertTrue(AssertTrue.java:41)
	at org.junit.jupiter.api.AssertTrue.assertTrue(AssertTrue.java:35)
	at org.junit.jupiter.api.Assertions.assertTrue(Assertions.java:195)
	at org.fp024.example.AppTest.shouldAnswerWithTrue(AppTest.java:12)

[INFO] 
[INFO] Results:
[INFO] 
[ERROR] Failures: 
[ERROR]   AppTest.shouldAnswerWithTrue:12 expected: <true> but was: <false>
[INFO] 
[ERROR] Tests run: 1, Failures: 1, Errors: 0, Skipped: 0
[INFO] 
[INFO] ------------------------------------------------------------------------
[INFO] BUILD FAILURE
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  2.105 s
[INFO] Finished at: 2026-03-15T05:28:23-07:00
[INFO] ------------------------------------------------------------------------
[ERROR] Failed to execute goal org.apache.maven.plugins:maven-surefire-plugin:3.5.5:test (default-test) on project test-fail-project: There are test failures.
[ERROR] 
[ERROR] See C:\ProgramData\Jenkins\.jenkins\workspace\test-fail-project build\java-project\test-fail-project\target\surefire-reports for the individual test results.
[ERROR] See dump files (if any exist) [date].dump, [date]-jvmRun[N].dump and [date].dumpstream.
[ERROR] -> [Help 1]
[ERROR] 
[ERROR] To see the full stack trace of the errors, re-run Maven with the -e switch.
[ERROR] Re-run Maven using the -X switch to enable full debug logging.
[ERROR] 
[ERROR] For more information about the errors and possible solutions, please read the following articles:
[ERROR] [Help 1] http://cwiki.apache.org/confluence/display/MAVEN/MojoFailureException

C:\ProgramData\Jenkins\.jenkins\workspace\test-fail-project build>exit 1 
Build step 'Execute Windows batch command' marked build as failure
Finished: FAILURE
```

✨ **프로젝트 내부의 빌드/테스트 실패가 바깥으로 잘 전파 됨을 확인**
