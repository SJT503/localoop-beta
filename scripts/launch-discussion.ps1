$ErrorActionPreference = "Continue"

$root = Split-Path $PSScriptRoot -Parent
$repo = "SJT503/localoop-beta"
Set-Location $root

gh label create "launch-announcement" --repo $repo --color F59E0B --description "Public beta launch" 2>$null | Out-Null
gh label create "daily-digest" --repo $repo --color 0E8A16 --description "Automated daily feedback summary" 2>$null | Out-Null

Write-Host "==> Enable GitHub Discussions" -ForegroundColor Cyan
gh api "repos/$repo" -X PATCH -f has_discussions_enabled=true 2>$null | Out-Null

Write-Host "==> Launch announcement issue" -ForegroundColor Cyan
$bodyFile = Join-Path $root "docs\LAUNCH\launch-issue-body.md"
$existing = gh issue list --repo $repo --search "in:title Localoop beta is live" --json number --jq '.[0].number // empty'
if ($existing) {
  Write-Host "Launch issue already exists: #$existing"
} else {
  gh issue create --repo $repo --title "Localoop beta is live — web + APK" --label "launch-announcement" --body-file $bodyFile
}

Write-Host ""
Write-Host "Reddit posts: docs/LAUNCH/REDDIT_POSTS.md" -ForegroundColor Green
Write-Host "Product Hunt: docs/LAUNCH/PRODUCT_HUNT.md" -ForegroundColor Green
