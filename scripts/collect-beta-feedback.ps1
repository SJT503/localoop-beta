$ErrorActionPreference = "Stop"

$repo = "SJT503/localoop-beta"
$outDir = Join-Path $PSScriptRoot "..\docs\feedback"
$outFile = Join-Path $outDir "$(Get-Date -Format 'yyyy-MM-dd')-digest.md"

New-Item -ItemType Directory -Force -Path $outDir | Out-Null

$issues = gh issue list `
  --repo $repo `
  --label "beta-feedback" `
  --state all `
  --limit 30 `
  --json number,title,body,createdAt,state,author `
  | ConvertFrom-Json

$open = @($issues | Where-Object { $_.state -eq "OPEN" })
$recent = @($issues | Where-Object {
    ([datetime]$_.createdAt) -gt (Get-Date).AddDays(-1)
  })

$lines = @(
  "# Localoop beta feedback digest — $(Get-Date -Format 'yyyy-MM-dd HH:mm')",
  "",
  "- Repo: https://github.com/$repo/issues?q=label%3Abeta-feedback",
  "- Open feedback issues: $($open.Count)",
  "- New in last 24h: $($recent.Count)",
  ""
)

if ($recent.Count -eq 0) {
  $lines += "No new beta-feedback issues in the last 24 hours."
} else {
  $lines += "## New since yesterday"
  $lines += ""
  foreach ($i in $recent) {
    $lines += "### #$($i.number) $($i.title) ($($i.state))"
    $lines += "- Author: $($i.author.login)"
    $lines += "- Created: $($i.createdAt)"
    $snippet = ($i.body -split "`n" | Select-Object -First 6) -join "`n"
    $lines += ""
    $lines += $snippet
    $lines += ""
  }
}

if ($open.Count -gt 0) {
  $lines += "## All open"
  $lines += ""
  foreach ($i in $open) {
    $lines += "- #$($i.number) $($i.title)"
  }
}

Set-Content -Path $outFile -Value ($lines -join "`n") -Encoding UTF8
Write-Host "Wrote $outFile" -ForegroundColor Green
Get-Content $outFile
