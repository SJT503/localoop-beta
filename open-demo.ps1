$index = Join-Path $PSScriptRoot "build\web\index.html"
if (-not (Test-Path $index)) {
  Write-Host "未找到 build/web，请先运行 run-web.ps1 或 flutter build web"
  exit 1
}
Start-Process $index
