#!/usr/bin/env bash
set -euo pipefail

REPO="${GITHUB_REPOSITORY:-SJT503/localoop-beta}"
DATE="$(date -u +%Y-%m-%d)"
DIGEST="docs/feedback/${DATE}-digest.md"
TITLE="📊 Daily beta feedback — ${DATE}"

if [[ ! -f "$DIGEST" ]]; then
  echo "Missing $DIGEST"
  exit 0
fi

BODY="$(cat "$DIGEST")"

existing="$(gh issue list --repo "$REPO" --search "in:title ${DATE} Daily beta feedback" --json number --jq '.[0].number // empty')"

if [[ -n "$existing" ]]; then
  gh issue comment "$existing" --repo "$REPO" --body "$BODY"
  echo "Updated comment on issue #$existing"
else
  gh issue create --repo "$REPO" --title "$TITLE" --label "beta-feedback" --label "daily-digest" --body "$BODY"
  echo "Created daily digest issue"
fi
