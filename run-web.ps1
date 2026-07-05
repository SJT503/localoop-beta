$ErrorActionPreference = "Stop"

$env:PUB_HOSTED_URL = "https://pub.flutter-io.cn"
$env:FLUTTER_STORAGE_BASE_URL = "https://storage.flutter-io.cn"
$flutter = "D:\flutter\flutter\bin\flutter.bat"

Set-Location $PSScriptRoot

& $flutter pub get
& $flutter build web --release
& $flutter run -d web-server --web-hostname=127.0.0.1 --web-port=7357
