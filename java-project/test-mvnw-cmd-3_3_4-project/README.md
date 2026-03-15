# test-mvnw-cmd-3_3_4-project

[한국어](README_ko.md) | English

## Project Purpose

A project to test Maven Wrapper 3.3.4 using the unmodified mvnw.cmd

## Verification Scenario

- **✨ Set up a Jenkins Freestyle Job running under the SYSTEM account.**

- In the **Execute Windows batch command** step of the Jenkins Freestyle project, enter the command as follows to run the mvnw.cmd command using the x86 environment cmd.exe:

  ```bat
  C:\Windows\SysWOW64\cmd.exe /c mvnw clean test
  ```

- Verify whether the Jenkins build is marked as `FAILURE`.

## Expected Behavior

- Although the test code always succeeds, there is an issue with the mvnw.cmd logic that sets the .m2 path using the system profile path, causing the build to fail before executing the Java code. The Jenkins Job should be marked as **FAILURE**.

> **Note:** `C:\Windows\SysWOW64\cmd.exe` is the cmd.exe that runs 32-bit (x86) processes on 64-bit Windows.
> The typical 64-bit cmd is `C:\Windows\System32\cmd.exe`, and you can verify if there are any behavioral differences between the two environments.

## Project Configuration

- ✨ **Jenkins: Running as Local System Account (SYSTEM)**
- **Java 17 - x86**
- **JUnit Jupiter (JUnit 6)**
- Using Maven Wrapper (`mvnw`)
