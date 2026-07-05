$ErrorActionPreference = "Stop"

$env:PUB_HOSTED_URL = "https://pub.flutter-io.cn"
$env:FLUTTER_STORAGE_BASE_URL = "https://storage.flutter-io.cn"
$flutter = "D:\flutter\flutter\bin\flutter.bat"

Set-Location $PSScriptRoot

$dist = Join-Path $PSScriptRoot "dist\beta"
$webOut = Join-Path $dist "web"
$apkOut = Join-Path $dist "android"

Write-Host "==> pub get" -ForegroundColor Cyan
& $flutter pub get
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "==> analyze + test" -ForegroundColor Cyan
& $flutter analyze
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
& $flutter test
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "==> build web (release)" -ForegroundColor Cyan
& $flutter build web --release --no-wasm-dry-run
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

New-Item -ItemType Directory -Force -Path $webOut | Out-Null
if (Test-Path $webOut) { Remove-Item -Recurse -Force $webOut }
Copy-Item -Recurse -Force "build\web" $webOut
Write-Host "  Web copied to $webOut" -ForegroundColor Green

$javaCandidates = @(
  $env:JAVA_HOME,
  "D:\jdk17\jdk-17.0.2",
  "C:\Program Files\Android\Android Studio\jbr",
  "D:\Android\Android Studio\jbr",
  "C:\Program Files\Java\jdk-17",
  "C:\Program Files\Eclipse Adoptium\jdk-17*"
)
$javaHome = $null
foreach ($c in $javaCandidates) {
  if (-not $c) { continue }
  $resolved = $null
  if ($c -like '*`**') {
    $resolved = (Get-Item $c -ErrorAction SilentlyContinue | Select-Object -First 1).FullName
  } elseif (Test-Path $c) {
    $resolved = $c
  }
  if ($resolved -and (Test-Path (Join-Path $resolved "bin\java.exe"))) {
    $javaHome = $resolved
    break
  }
}

if (-not $javaHome) {
  Write-Host "==> skip APK: JAVA_HOME not found (install Android Studio JDK or set JAVA_HOME)" -ForegroundColor Yellow
  $readme = @"
Localoop beta build — $(Get-Date -Format 'yyyy-MM-dd HH:mm')

Web:  dist/beta/web/  (READY — upload to Cloudflare Pages / GitHub Pages)
APK:  SKIPPED — set JAVA_HOME then re-run .\\build-beta.ps1

Example JAVA_HOME:
  C:\\Program Files\\Android\\Android Studio\\jbr
"@
  Set-Content -Path (Join-Path $dist "README.txt") -Value $readme -Encoding UTF8
  Write-Host ""
  Write-Host "Localoop web beta OK (APK skipped)" -ForegroundColor Green
  Write-Host "  Web: $webOut"
  exit 0
}

$env:JAVA_HOME = $javaHome
Write-Host "==> build apk (release) using JAVA_HOME=$javaHome" -ForegroundColor Cyan
& $flutter build apk --release
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

New-Item -ItemType Directory -Force -Path $webOut, $apkOut | Out-Null

if (Test-Path $webOut) { Remove-Item -Recurse -Force $webOut }
Copy-Item -Recurse -Force "build\web" $webOut

$apkSrc = "build\app\outputs\flutter-apk\app-release.apk"
$apkDst = Join-Path $apkOut "localoop-beta-0.1.0.apk"
Copy-Item -Force $apkSrc $apkDst

$readme = @"
Localoop beta build — $(Get-Date -Format 'yyyy-MM-dd HH:mm')

Web:  dist/beta/web/          → upload folder to Cloudflare Pages / GitHub Pages
APK:  dist/beta/android/localoop-beta-0.1.0.apk → Firebase App Distribution or direct link

Wild-path install (Android):
1. Send APK link to tester
2. Tester enables Install unknown apps for browser/files
3. Open link → install → allow notifications when prompted

Privacy note: release APK has no INTERNET permission in main manifest.
"@

Set-Content -Path (Join-Path $dist "README.txt") -Value $readme -Encoding UTF8

Write-Host ""
Write-Host "Localoop beta build OK" -ForegroundColor Green
Write-Host "  Web: $webOut"
Write-Host "  APK: $apkDst"
