# Localoop

**Local-first period tracker** — no account, no cloud sync, no ad feed. Beta for privacy-conscious users leaving Flo/Clue.

| | Link |
|---|------|
| **Web beta** | https://sjt503.github.io/localoop-beta/ |
| **Android APK** | https://github.com/SJT503/localoop-beta/releases/latest |
| **Data & privacy** | [DATA_DISCLOSURE.md](docs/DATA_DISCLOSURE.md) |
| **Feedback** | [GitHub Issues](https://github.com/SJT503/localoop-beta/issues/new?template=beta_feedback.yml) |

## Features (beta 0.1.4)

- 8 languages (EN / 中文 / 日本語 / 한국어 / FR / DE / ES / PT)
- Local storage only; JSON export; clear-all-data restart
- Privacy notification mode; optional sensitive-word hiding
- ~20s daily log; period / fertile window calendar

## Build

```powershell
$env:JAVA_HOME = "D:\jdk17\jdk-17.0.2"
cd d:\Cursor\luna-app
.\build-beta.ps1
```

## Deploy

```powershell
.\scripts\deploy-beta.ps1
```

## Daily feedback digest

- GitHub Actions: `.github/workflows/daily-feedback-digest.yml` (09:00 Beijing)
- Local: `.\scripts\collect-beta-feedback.ps1` → `docs/feedback/`

---

*Not medical advice. Beta software.*
