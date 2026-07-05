$ErrorActionPreference = "Stop"

$env:JAVA_HOME = if ($env:JAVA_HOME) { $env:JAVA_HOME } else { "D:\jdk17\jdk-17.0.2" }
$env:PUB_HOSTED_URL = "https://pub.flutter-io.cn"
$env:FLUTTER_STORAGE_BASE_URL = "https://storage.flutter-io.cn"
$flutter = "D:\flutter\flutter\bin\flutter.bat"

$root = Split-Path $PSScriptRoot -Parent
$repoName = "localoop-beta"
$ghRepo = "SJT503/$repoName"
$remoteUrl = "https://github.com/$ghRepo.git"
$pagesBase = "/$repoName/"

Set-Location $root

Write-Host "==> build web + apk" -ForegroundColor Cyan
& (Join-Path $root "build-beta.ps1")
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "==> rebuild web with GitHub Pages base-href" -ForegroundColor Cyan
& $flutter build web --release --no-wasm-dry-run --base-href $pagesBase
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$webSrc = Join-Path $root "build\web"
$webDist = Join-Path $root "dist\beta\web"
if (Test-Path $webDist) { Remove-Item -Recurse -Force $webDist }
Copy-Item -Recurse -Force $webSrc $webDist

if (-not (Test-Path (Join-Path $root ".git"))) {
  git init
  git branch -M main
}

git add -A
$status = git status --porcelain
if ($status) {
  git commit -m "Localoop beta: rename, privacy page, deploy scripts"
}

$remotes = @(git remote 2>$null)
if ($remotes -notcontains 'origin') {
  gh repo create $repoName --public --source=. --remote=origin --description "Localoop beta — local-first period tracker"
} else {
  $existing = git remote get-url origin
  if ($existing -notmatch $repoName) {
    Write-Host "Remote origin is $existing — expected $remoteUrl" -ForegroundColor Yellow
  }
}

Write-Host "==> push main" -ForegroundColor Cyan
git push -u origin main

Write-Host "==> deploy gh-pages" -ForegroundColor Cyan
$tmp = Join-Path $env:TEMP "localoop-gh-pages"
if (Test-Path $tmp) { Remove-Item -Recurse -Force $tmp }
Copy-Item -Recurse -Force $webDist $tmp
Set-Location $tmp
git init
git checkout -b gh-pages
git add -A
git commit -m "Deploy Localoop web beta $(Get-Date -Format 'yyyy-MM-dd')"
git remote add origin $remoteUrl
git push -f origin gh-pages

Set-Location $root

Write-Host "==> enable GitHub Pages (gh-pages branch)" -ForegroundColor Cyan
gh api "repos/$ghRepo/pages" -X POST -f "build_type=legacy" -f "source[branch]=gh-pages" -f "source[path]=/" 2>$null
if ($LASTEXITCODE -ne 0) {
  gh api "repos/$ghRepo/pages" -X PUT -f "build_type=legacy" -f "source[branch]=gh-pages" -f "source[path]=/" 2>$null
}

Write-Host "==> GitHub release + APK" -ForegroundColor Cyan
$apk = Join-Path $root "dist\beta\android\localoop-beta-0.1.0.apk"
$tag = "v0.1.0-beta"
$releaseNotes = @"
Localoop beta for Flo/Clue privacy testers.

- Web: https://sjt503.github.io/localoop-beta/
- Feedback: https://github.com/$ghRepo/issues/new?template=beta_feedback.yml
"@

gh release view $tag --repo $ghRepo 2>$null
if ($LASTEXITCODE -ne 0) {
  gh release create $tag --repo $ghRepo --title "Localoop Beta 0.1.0" --notes $releaseNotes $apk
} else {
  gh release upload $tag --repo $ghRepo $apk --clobber
}

Write-Host ""
Write-Host "Deploy OK" -ForegroundColor Green
Write-Host "  Web:  https://sjt503.github.io/localoop-beta/"
Write-Host "  APK:  https://github.com/$ghRepo/releases/download/$tag/localoop-beta-0.1.0.apk"
Write-Host "  Feedback: https://github.com/$ghRepo/issues/new?template=beta_feedback.yml"
