# Real-World Behavior Test on Jenkins

> Verified behavior by installing Jenkins 2.541.2 on a Windows Server 2022 180-day evaluation edition.



## Jenkins Configuration

### ✨ Login Type

Set **Run service as LocalSystem** so that jobs run under the SYSTEM account.

![image-20260312070359526](doc-resources/image-20260312070359526.png)

### ✨ The JDK running Jenkins itself must also be an x86 JDK.

When Jenkins is configured to run with an x64 JDK, Maven Wrapper cannot find the required classes during a build using an x86 JDK. Therefore, the JDK that runs Jenkins itself must also be set to an x86 JDK.

If you have already configured it with an x64 JDK...

* In `C:\Program Files\Jenkins\jenkins.xml`, update the JDK path:

  ```xml
  <service>
    ...
    <executable>C:\JDK\JDK17_x86\latest\bin\java.exe</executable>
    ...
  ```

  Change the JDK path and restart Jenkins.

  In the example above, it has been changed to x86 JDK 17.



## Creating Test Jobs

### Toolchain Configuration (Prerequisites)

The Java build project used for testing requires a ToolChain configuration.

* Create `toolchains.xml` under `C:\Windows\SysWOW64\config\systemprofile\.m2`. 😅

  ```xml
  <?xml version="1.0" encoding="UTF-8"?>
  <toolchains>
    <toolchain>
      <type>jdk</type>
      <provides>
        <version>17</version>
        <vendor>temurin</vendor>
      </provides>
      <configuration>
        <jdkHome>C:/JDK/JDK17_x86/latest</jdkHome>
      </configuration>
    </toolchain>
  </toolchains>
  ```



### Job Creation

Create a FreeStyle project that clones the test project from GitHub and runs `mvnw clean test`.

* Git configuration

  * https://github.com/fp024/spring-mvc-practice-study/
  * Branch: **jenkins-jdk-x86-test**

* Add an **Execute Windows batch command** build step with the following command:

  ```cmd
  mvnw clean test
  ```



### Build Result

```
Started by user fp024
Running as SYSTEM
Building in workspace C:\ProgramData\Jenkins\.jenkins\workspace\Java Build Test
The recommended git tool is: NONE
...
...
[Java Build Test] $ cmd /c call C:\Windows\TEMP\jenkins13618979669008619938.bat

C:\ProgramData\Jenkins\.jenkins\workspace\Java Build Test>mvnw clean test 
icm : Cannot index into a null array.
At line:1 char:97
+ ... 'mvnw.cmd'; icm -ScriptBlock ([Scriptblock]::Create((Get-Content -Raw ...
+                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : InvalidOperation: (:) [Invoke-Command], RuntimeException
    + FullyQualifiedErrorId : NullArray,Microsoft.PowerShell.Commands.InvokeCommandCommand
 
Cannot start maven from wrapper  
Build step 'Execute Windows batch command' marked build as failure
Finished: FAILURE
```

✨ **Confirmed that the "Cannot index into a null array." error occurs, exactly as reported in the issue.** ✨



### Create a New Job Using the Branch with the Fixed mvnw.cmd
* Applied commit: https://github.com/fp024/spring-mvc-practice-study/commit/a868de62a749ebd414f2189c16a652cfc332d6f0
* Git configuration
  * https://github.com/fp024/spring-mvc-practice-study/
  * Branch: **master**

#### Build Result After Fixing mvnw.cmd

```
Started by user fp024
Running as SYSTEM
Building in workspace C:\ProgramData\Jenkins\.jenkins\workspace\Java Build Test - fix
...
...
[Java Build Test - fix] $ cmd /c call C:\Windows\TEMP\jenkins4397049118303502916.bat

C:\ProgramData\Jenkins\.jenkins\workspace\Java Build Test - fix>mvnw clean test 
[INFO] Scanning for projects...
[INFO] 
[INFO] ----------< org.fp024.mvcpractice:spring-mvc-practice-study >-----------
[INFO] Building spring-mvc-practice-study 1.0.0-SNAPSHOT
[INFO]   from pom.xml
[INFO] --------------------------------[ war ]---------------------------------
[INFO] 
[INFO] --- clean:3.5.0:clean (default-clean) @ spring-mvc-practice-study ---
...
...
[INFO] Tests run: 1, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 1.978 s -- in org.fp024.mvcpractice.HomeControllerTests
[INFO] 
[INFO] Results:
[INFO] 
[INFO] Tests run: 2, Failures: 0, Errors: 0, Skipped: 0
[INFO] 
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  10.264 s
[INFO] Finished at: 2026-03-11T14:52:18-07:00
[INFO] ------------------------------------------------------------------------
Finished: SUCCESS
```

Build completed successfully.

Also confirmed that Maven was properly downloaded to the `.m2\wrapper\dists` path under **SysWOW64**.

```
C:\Windows\SysWOW64\config\systemprofile\.m2\wrapper\dists>dir
 Volume in drive C is SDT_x64FREE_EN-US_VHD
 Volume Serial Number is 88CF-9A7A

 Directory of C:\Windows\SysWOW64\config\systemprofile\.m2\wrapper\dists

2026-03-11  오후 02:52    <DIR>          .
2026-03-11  오후 02:52    <DIR>          ..
2026-03-11  오후 02:52    <DIR>          apache-maven-3.9.12
               0 File(s)              0 bytes
               3 Dir(s)  25,909,067,776 bytes free

C:\Windows\SysWOW64\config\systemprofile\.m2\wrapper\dists>
```
