# 이슈 게시한 분 글에 대한 답변 😅

* https://github.com/apache/maven-wrapper/issues/395#issuecomment-4046354842

  

안녕하세요.

확인에 감사드립니다.

먼저 PR에 댓글에다가. x64 환경에서 x86 빌드가 필요할 때는 Jenkins자체를 x86 JDK로 실행해야된다는 식으로 글을 쓰긴 했는데,

* https://github.com/apache/maven-wrapper/pull/405
* https://github.com/fp024/win-file-link-test/blob/main/jenkins-test_en.md


당신이 댓글에서 이야기 하신데로,

```cmd
set MAVEN_USER_HOME=%WORKSPACE%\.m2
mvnw clean package
```

위처럼 설정하셔서 사용하시는 것이 좋은 방법 같습니다.

Jenkins의 x86 개별 Job 워크스페이스마다 .m2를 두기는 좀 중복이 생길 수 있어서, 윈도우 서버 시스템에 x86용 m2경로를 별도로 독립적으로 두는 방법도 있을  것 같구요.. 






제가 추정하는 문제의 원인은 다음과 같습니다.

Jenkins 자체가 x64-JDK로 실행중일 때,  "Execute Windows batch command" 내에서,

mvnw.cmd가 실행될 때, mvnw.cmd 안에 포함된 PowerShell 코드들이 64bit 환경의 PowerShell로 실행되기 때문에,

wrapper 폴더가  `C:\Windows\System32\config\systemprofile\.m2\wrapper` 경로 이하에 만들어지고, maven 바이너리도 그 경로 이하에 생성됩니다.


그 상태에서 빌드 실행을 위한 JAVA_HOME은 x86-JDK로 설정되어있다면,  

wrapper가 실행에 필요한 Jar 라이브러리를 `C:\Windows\SysWOW64\config\systemprofile\.m2\wrapper` 에서 찾으려 하기 때문에,

클래스를 못찾는 문제가 생기는 것으로 보입니다.



해결책은  x86 JDK로 빌드 해야하는 작업은 위에 당신이 댓글로 이야기 하신대로,

시스템 프로필과 독립된 경로로 MAVEN_USER_HOME을 "Execute Windows batch command"에 설정해서 사용하시는 것이 나아보입니다.

다른 글에서 제가 말한 x86-JDK로 자체 실행되는 Jenkins를 별도로 두는 것은 꽤 번거로운 방법 같구요...😅


감사합니다.

---

Hi,

Thank you for the confirmation.

I previously mentioned in the document linked in the PR that Jenkins might need to run on an x86 JDK when an x86 build is required in an x64 environment. However, as you suggested, setting `MAVEN_USER_HOME` manually seems like a much better approach:

```cmd
set MAVEN_USER_HOME=%WORKSPACE%\.m2
mvnw clean package
```

While setting `MAVEN_USER_HOME` to the workspace is a straightforward solution, it does result in each Jenkins x86 job having its own .m2 folder. To reduce this redundancy, another option worth considering is defining a dedicated, independent path for x86 Maven on the Windows server.

I believe the root cause of the issue is as follows:

When Jenkins itself runs on an x64 JDK, the PowerShell code within mvnw.cmd runs as a 64-bit process, creating the wrapper under the System32 path (`C:\Windows\System32\config\systemprofile\.m2\wrapper`). However, if the build then uses an x86 JDK, the wrapper attempts to find the required JAR libraries in `C:\Windows\SysWOW64\config\systemprofile\.m2\wrapper`, leading to a ClassNotFoundException due to Windows file system redirection.

Therefore, setting `MAVEN_USER_HOME` to a path independent of the system profile is a far more practical solution. My previous idea of running a separate Jenkins instance with an x86 JDK seems unnecessarily complicated in comparison. 😅

Thank you!


#### References
* https://github.com/fp024/win-file-link-test/blob/main/jenkins-test_en.md



---

**One more interesting finding:**

Another definitive way to handle this in an x64 Jenkins environment is to explicitly invoke the 32-bit shell:

```cmd
C:\Windows\SysWOW64\cmd.exe /c mvnw clean package
```



---

그냥 단순하게 cmd 자체를 x86용으로 실행되게 하면 쉽게 풀리는 걸 이제야 생각해냈다...😅😅
