$ErrorActionPreference = "Stop"
$root = if ($PSScriptRoot) { Split-Path $PSScriptRoot -Parent } else { Get-Location }
$pubspecPath = Join-Path $root "pubspec.yaml"
$betaLinksPath = Join-Path $root "lib\core\beta_links.dart"
$dataDocPath = Join-Path $root "docs\DATA_DISCLOSURE.md"

$pubspec = Get-Content $pubspecPath -Raw
$match = [regex]::Match($pubspec, '(?m)^version:\s*([\d.]+)\+(\d+)')
if (-not $match.Success) { throw "Could not parse version from pubspec.yaml" }
$version = $match.Groups[1].Value

$content = Get-Content $betaLinksPath -Raw
$content = [regex]::Replace($content, "static const appVersion = '[^']+'", "static const appVersion = '$version'")
$content = [regex]::Replace(
  $content,
  "releases/latest/download/localoop-beta-[^']+\.apk'",
  "releases/latest/download/localoop-beta-$version.apk'"
)
Set-Content -Path $betaLinksPath -Value ($content.TrimEnd() + "`n") -Encoding UTF8

if (Test-Path $dataDocPath) {
  $doc = Get-Content $dataDocPath -Raw
  $doc = [regex]::Replace($doc, '\*\*Current beta:\*\* `[\d.]+`', "**Current beta:** ``$version``")
  $doc = [regex]::Replace(
    $doc,
    'releases/latest/download/localoop-beta-[\d.]+\.apk',
    "releases/latest/download/localoop-beta-$version.apk"
  )
  Set-Content -Path $dataDocPath -Value ($doc.TrimEnd() + "`n") -Encoding UTF8
}

Write-Host "Synced beta links to version $version" -ForegroundColor Green
