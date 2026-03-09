# Maven Wrapper 공식 리포에 수정 사항 적용

## Maven Wrapper의 maven-wrapper-distribution/src/resources/only-mvnw.cmd 파일 수정

* 윈도우 시스템 프로필 경로에서 문제가 발생하는 코드
  * 내가 2025년 7월에 수정했던 내용
    * https://github.com/apache/maven-wrapper/commit/e0c91a104f9b45b34f3d5f0924776a3e51eecb16#diff-e42448c6d3447263d824f27853622207fd7f4e11448060c7a90332ae42c970bc
  * 현재 상태
    * https://github.com/apache/maven-wrapper/blob/master/maven-wrapper-distribution/src/resources/only-mvnw.cmd


* 기존 코드
```powershell
$MAVEN_WRAPPER_DISTS = $null
if ((Get-Item -Path $MAVEN_M2_PATH -Force).Target[0] -eq $null) {
  $MAVEN_WRAPPER_DISTS = "$MAVEN_M2_PATH/wrapper/dists"
} else {
  $MAVEN_WRAPPER_DISTS = (Get-Item -Path $MAVEN_M2_PATH -Force).Target[0] + "/wrapper/dists"
}
```

* 수정 코드
```powershell
$MAVEN_WRAPPER_DISTS = $null
$m2PathItem = (Get-Item -Path $MAVEN_M2_PATH -Force).Target
if ($m2PathItem -is [array] -and $m2PathItem.Count -gt 0) {
  $MAVEN_WRAPPER_DISTS = $m2PathItem[0] + "/wrapper/dists"
} else {
  $MAVEN_WRAPPER_DISTS = "$MAVEN_M2_PATH/wrapper/dists"
}
```

## PR 제출

* Fix null Target index error under strict mode for system profile path
  * https://github.com/apache/maven-wrapper/pull/405