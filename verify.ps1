$ErrorActionPreference = "Stop"

$env:PUB_HOSTED_URL = "https://pub.flutter-io.cn"
$env:FLUTTER_STORAGE_BASE_URL = "https://storage.flutter-io.cn"
$flutter = "D:\flutter\flutter\bin\flutter.bat"

Set-Location $PSScriptRoot

& $flutter pub get
& $flutter analyze
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
& $flutter test
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
Write-Host "Luna verify OK (analyze + test)" -ForegroundColor Green
