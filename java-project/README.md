# Jenkins Real Environment Testing

English | [한국어](README_ko.md)

>  Tested on Windows Server 2022 180-day evaluation version with Jenkins 2.541.2 installed.



## Jenkins Configuration Setup

### ✨ Login Type

Configure the service to run as LocalSystem so that jobs execute under the SYSTEM account.

![image-20260312070359526](doc-resources/image-20260312070359526.png)



### ✨ Two Methods for Ensuring Jenkins "Execute Windows batch command" Runs in x86 Environment

#### 1. Set Jenkins Runtime JDK to x86

When the JDK running Jenkins itself on Windows 64-bit is x64, the cmd will be executed as 64-bit.

* x64(64bit): `C:\Windows\System32\cmd.exe`
* x86(32bit): `C:\Windows\SysWOW64\cmd.exe`

However, if the JDK running Jenkins itself is x86, then the x86 cmd will be executed.



#### 2. Wrap the Execute Windows batch command with C:\Windows\SysWOW64\cmd.exe /c

Method 1 can be difficult if Jenkins is already running well with an x64 JDK.

In that case, you can consider wrapping the command executed in Execute Windows batch command with C:\Windows\SysWOW64\cmd.exe /c.



## Testing Job Execution with Original Maven Wrapper 3.3.4 mvnw.cmd

### Job Creation

Create a FreeStyle project, pull the test project from GitHub, and create a simple job that runs mvnw clean test.

* Git Configuration

  * https://github.com/fp024/win-file-link-test
  * Sub-project directory: `java-project/test-mvnw-cmd-3_3_4-project`

* Add Execute Windows batch command to Build Steps with the following command:

  ```cmd
  SET TEST_PROJECT_ROOT=.\java-project\test-mvnw-cmd-3_3_4-project
  C:\Windows\SysWOW64\cmd.exe /c "%TEST_PROJECT_ROOT%\mvnw.cmd -f %TEST_PROJECT_ROOT%\pom.xml clean package"
  ```



### Execution Result

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

✨ **Confirmed that the "Cannot index into a null array" error occurs, as reported in the issue.** ✨





## Testing Job Execution with Modified Maven Wrapper 3.3.4 mvnw.cmd



### Job Creation

Create a FreeStyle project, pull the test project from GitHub, and create a simple job that runs mvnw clean test.

* Git Configuration

  * https://github.com/fp024/win-file-link-test
  * Sub-project directory: `java-project/test-mvnw-cmd-mod-project`

* Add Execute Windows batch command to Build Steps with the following command:

  ```cmd
  SET TEST_PROJECT_ROOT=.\java-project\test-mvnw-cmd-mod-project
  C:\Windows\SysWOW64\cmd.exe /c "%TEST_PROJECT_ROOT%\mvnw.cmd -f %TEST_PROJECT_ROOT%\pom.xml clean package"
  ```



### Execution Result

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

✨  **Confirmed that the "Cannot index into a null array" error has been resolved**



## Verifying Error Propagation When Wrapping with cmd /c in Execute Windows batch command

### Job Creation

Create a FreeStyle project, pull the test project from GitHub, and create a simple job that runs mvnw clean test.

However, this project contains a JUnit test that intentionally fails.

* Git Configuration

  * https://github.com/fp024/win-file-link-test
  * Sub-project directory: `java-project/test-fail-project`

* Add Execute Windows batch command to Build Steps with the following command:

  ```cmd
  SET TEST_PROJECT_ROOT=.\java-project\test-fail-project
  C:\Windows\SysWOW64\cmd.exe /c "%TEST_PROJECT_ROOT%\mvnw.cmd -f %TEST_PROJECT_ROOT%\pom.xml clean package"
  ```



### Execution Result

```
Started by user fp024
Running as SYSTEM
...
...
[test-fail-project build] $ cmd /c call C:\Windows\TEMP\jenkins15495466030859893950.bat

C:\ProgramData\Jenkins\.jenkins\workspace\test-fail-project build&gt;SET TEST_PROJECT_ROOT=.\java-project\test-fail-project

C:\ProgramData\Jenkins\.jenkins\workspace\test-fail-project build&gt;C:\Windows\SysWOW64\cmd.exe /c ".\java-project\test-fail-project\mvnw.cmd -f .\java-project\test-fail-project\pom.xml clean package"
[INFO] Scanning for projects...
[INFO]
[INFO] ----------------&lt; org.fp024.example:test-fail-project &gt;-----------------
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
[ERROR] Tests run: 1, Failures: 1, Errors: 0, Skipped: 0, Time elapsed: 0.059 s &lt;&lt;&lt; FAILURE! -- in org.fp024.example.AppTest
[ERROR] org.fp024.example.AppTest.shouldAnswerWithTrue -- Time elapsed: 0.037 s &lt;&lt;&lt; FAILURE!
org.opentest4j.AssertionFailedError: expected: &lt;true&gt; but was: &lt;false&gt;
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
[ERROR]   AppTest.shouldAnswerWithTrue:12 expected: &lt;true&gt; but was: &lt;false&gt;
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
[ERROR] -&gt; [Help 1]
[ERROR]
[ERROR] To see the full stack trace of the errors, re-run Maven with the -e switch.
[ERROR] Re-run Maven using the -X switch to enable full debug logging.
[ERROR]
[ERROR] For more information about the errors and possible solutions, please read the following articles:
[ERROR] [Help 1] http://cwiki.apache.org/confluence/display/MAVEN/MojoFailureException

C:\ProgramData\Jenkins\.jenkins\workspace\test-fail-project build&gt;exit 1
Build step 'Execute Windows batch command' marked build as failure
Finished: FAILURE
```

✨ **Confirmed that build/test failures inside the project are properly propagated to the outer Jenkins build job**
