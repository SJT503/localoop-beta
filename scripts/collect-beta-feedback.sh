#!/usr/bin/env bash
set -euo pipefail

REPO="${GITHUB_REPOSITORY:-SJT503/localoop-beta}"
OUT_DIR="docs/feedback"
DATE="$(date -u +%Y-%m-%d)"
OUT_FILE="$OUT_DIR/${DATE}-digest.md"

mkdir -p "$OUT_DIR"

issues_json="$(gh issue list \
  --repo "$REPO" \
  --label "beta-feedback" \
  --state all \
  --limit 30 \
  --json number,title,body,createdAt,state,author)"

python3 - <<'PY' "$issues_json" "$OUT_FILE" "$REPO"
import json, sys
from datetime import datetime, timedelta, timezone

issues_json, out_file, repo = sys.argv[1:4]
issues = json.loads(issues_json)
now = datetime.now(timezone.utc)
cutoff = now - timedelta(days=1)

open_issues = [i for i in issues if i["state"] == "OPEN"]
recent = []
for i in issues:
    created = datetime.fromisoformat(i["createdAt"].replace("Z", "+00:00"))
    if created > cutoff:
        recent.append(i)

lines = [
    f"# Localoop beta feedback digest — {now.strftime('%Y-%m-%d %H:%M')} UTC",
    "",
    f"- Repo: https://github.com/{repo}/issues?q=label%3Abeta-feedback",
    f"- Open feedback issues: {len(open_issues)}",
    f"- New in last 24h: {len(recent)}",
    "",
]

if not recent:
    lines.append("No new beta-feedback issues in the last 24 hours.")
else:
    lines += ["## New since yesterday", ""]
    for i in recent:
        body = (i.get("body") or "").splitlines()[:6]
        lines += [
            f"### #{i['number']} {i['title']} ({i['state']})",
            f"- Author: {i['author']['login']}",
            f"- Created: {i['createdAt']}",
            "",
            *body,
            "",
        ]

if open_issues:
    lines += ["## All open", ""]
    for i in open_issues:
        lines.append(f"- #{i['number']} {i['title']}")

with open(out_file, "w", encoding="utf-8") as f:
    f.write("\n".join(lines) + "\n")

print(f"Wrote {out_file}")
PY

cat "$OUT_FILE"
