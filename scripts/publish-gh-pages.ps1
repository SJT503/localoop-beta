$ErrorActionPreference = "Stop"

$root = Split-Path $PSScriptRoot -Parent
$ghRepo = "SJT503/localoop-beta"
$remoteUrl = "https://github.com/$ghRepo.git"
$webDist = Join-Path $root "dist\beta\web"

if (-not (Test-Path $webDist)) {
  Write-Host "Missing $webDist — run build-beta.ps1 first" -ForegroundColor Red
  exit 1
}

$tmp = Join-Path $env:TEMP "localoop-gh-pages"
if (Test-Path $tmp) { Remove-Item -Recurse -Force $tmp }
Copy-Item -Recurse -Force $webDist $tmp
Set-Location $tmp
git init
git checkout -b gh-pages
git add -A
git commit -m "Deploy Localoop web beta $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
git remote add origin $remoteUrl
git push -f origin gh-pages

gh api "repos/$ghRepo/pages" -X POST -f "build_type=legacy" -f "source[branch]=gh-pages" -f "source[path]=/" 2>$null
if ($LASTEXITCODE -ne 0) {
  gh api "repos/$ghRepo/pages" -X PUT -f "build_type=legacy" -f "source[branch]=gh-pages" -f "source[path]=/" 2>$null
}

Write-Host "Pages deploy pushed. URL: https://sjt503.github.io/localoop-beta/" -ForegroundColor Green
