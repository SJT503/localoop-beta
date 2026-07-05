# Reddit 公开发帖包（复制即用）

> **注意**：Reddit 需用你的账号登录后发帖。下面按 sub 规则写好，发帖前请读各版 sidebar / 自检是否允许 self-promo。

---

## 推荐顺序（间隔 24–48h，避免 spam）

1. r/SideProject（最宽松）
2. r/Periods 或 r/TwoXChromosomes（需更软、更求助口吻）
3. r/privacy 或 r/degoogle（强调 local-first）

---

## Post A — r/SideProject

**Title:** `[Beta] Localoop — local-first period tracker (no account, 8 languages, Android + web)`

**Body:**

```
I built Localoop after reading too many Flo/Clue privacy threads — wanted something that never phones home by default.

What it is:
- Period + calendar + ~20s daily log
- Data stays on device; JSON export; clear-all restart
- Privacy notification mode (generic lock-screen copy)
- 8 languages including EN/中文/日本語

Try it (free beta, no signup):
- Web: https://sjt503.github.io/localoop-beta/
- Android APK: https://github.com/SJT503/localoop-beta/releases/latest
- Data notice: https://github.com/SJT503/localoop-beta/blob/main/docs/DATA_DISCLOSURE.md

Looking for 5–10 people who'd actually use it 3–7 days and tell me what's missing (not "looks nice").
2-min feedback form: https://github.com/SJT503/localoop-beta/issues/new?template=beta_feedback.yml

Stack: Flutter. Open repo. Not medical advice.
```

---

## Post B — r/Periods（ softer, ask for testers）

**Title:** `Anyone tried a period app that doesn't require an account? Built a small beta`

**Body:**

```
Flo/Clue fatigue is real. I'm testing a tiny beta called Localoop — everything stays on your phone, no email signup, you can export JSON or wipe all data and start over.

Web (works in browser): https://sjt503.github.io/localoop-beta/
Android: https://github.com/SJT503/localoop-beta/releases/latest

If you try it for a few days I'd love honest feedback — especially what would *not* make you switch. Form: https://github.com/SJT503/localoop-beta/issues/new?template=beta_feedback.yml

(Privacy write-up: https://github.com/SJT503/localoop-beta/blob/main/docs/DATA_DISCLOSURE.md)
```

---

## Post C — r/privacy

**Title:** `Local-first period tracker beta — no cloud, no account, open feedback on GitHub`

**Body:**

```
Short pitch: Localoop keeps cycle logs on-device only. No analytics SDK in the beta APK manifest path we're targeting. Export JSON anytime; clear local data in one tap.

Links:
- Web demo: https://sjt503.github.io/localoop-beta/
- APK + source: https://github.com/SJT503/localoop-beta
- Threat model / data notice: https://github.com/SJT503/localoop-beta/blob/main/docs/DATA_DISCLOSURE.md

Seeking privacy-minded testers for a 7-day beta. Feedback (no health data required in the form): https://github.com/SJT503/localoop-beta/issues/new?template=beta_feedback.yml
```

---

## 发帖后

- 把帖子 URL 记到 GitHub Issue 标签 `launch-channel`（可选）
- 48h 内回复每条评论（GitHub 反馈优先）
