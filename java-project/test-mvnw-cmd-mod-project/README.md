# test-mvnw-cmd-mod-project

[한국어](README_ko.md) | English

## Project Purpose

A project to test Maven Wrapper 3.3.4 with pre-modified mvnw.cmd

## Verification Scenario

- **✨ Set up a Jenkins Freestyle Job running under the SYSTEM account.**

- In the **Execute Windows batch command** step of the Jenkins Freestyle project, enter the command as follows to run the mvnw command using the x86 cmd.exe:

  ```bat
  C:\Windows\SysWOW64\cmd.exe /c mvnw clean test
  ```

- Verify whether the Jenkins build is marked as `SUCCESS`.

## Expected Behavior

- The test code always succeeds, and the Jenkins Job should be marked as **SUCCESS**.

> **Note:** `C:\Windows\SysWOW64\cmd.exe` is the cmd.exe that runs 32-bit (x86) processes on 64-bit Windows.
> The typical 64-bit cmd is `C:\Windows\System32\cmd.exe`, and you can verify if there are any behavioral differences between the two environments.

## Project Configuration

- ✨ **Jenkins: Running as Local System Account (SYSTEM)**
- **Java 17 - x86**
- **JUnit Jupiter (JUnit 6)**
- Using Maven Wrapper (`mvnw`)
