$ErrorActionPreference = "Stop"

$root = Split-Path $PSScriptRoot -Parent
$repo = "SJT503/localoop-beta"
Set-Location $root

gh label create "launch-announcement" --repo $repo --color F59E0B --description "Public beta launch" 2>$null
gh label create "daily-digest" --repo $repo --color 0E8A16 --description "Automated daily feedback summary" 2>$null

Write-Host "==> Enable GitHub Discussions" -ForegroundColor Cyan
gh api "repos/$repo" -X PATCH -f has_discussions_enabled=true 2>$null

$launchBody = @"
## Localoop beta is live

Private, local-first period tracker — no account, no cloud sync.

| | |
|---|---|
| **Web** | https://sjt503.github.io/localoop-beta/ |
| **Android APK** | https://github.com/$repo/releases/latest |
| **Privacy / data** | https://github.com/$repo/blob/main/docs/DATA_DISCLOSURE.md |
| **Feedback (2 min)** | https://github.com/$repo/issues/new?template=beta_feedback.yml |

### What we need from testers

Use it **3–7 days**, then tell us:
1. Would you keep using it weekly? (Yes / Maybe / No)
2. One concrete reason (not just "nice UI")
3. Biggest blocker (trust, predictions, notifications, …)

Built for people reconsidering Flo/Clue after privacy concerns. Not medical advice.
"@

Write-Host "==> Launch announcement issue" -ForegroundColor Cyan
$existing = gh issue list --repo $repo --search "in:title Localoop beta is live" --json number --jq '.[0].number // empty'
if ($existing) {
  Write-Host "Launch issue already exists: #$existing"
} else {
  gh issue create --repo $repo --title "🚀 Localoop beta is live — web + APK" --label "launch-announcement" --body $launchBody
}

Write-Host ""
Write-Host "Reddit posts: docs/LAUNCH/REDDIT_POSTS.md" -ForegroundColor Green
Write-Host "Product Hunt: docs/LAUNCH/PRODUCT_HUNT.md" -ForegroundColor Green
