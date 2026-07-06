# Localoop

**Local-first period tracker** — portfolio project: privacy-conscious design, Flutter Web + Android, 8 languages.

> Validation paused (2026-07). **Live demo + case study** for portfolio — not an active growth launch.

| | Link |
|---|------|
| **Web demo** | https://sjt503.github.io/localoop-beta/ |
| **Portfolio write-up** | [docs/PORTFOLIO.md](docs/PORTFOLIO.md) |
| **Source** | https://github.com/SJT503/localoop-beta |
| **Android APK** | https://github.com/SJT503/localoop-beta/releases/latest |
| **Data & privacy** | [DATA_DISCLOSURE.md](docs/DATA_DISCLOSURE.md) |

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

Paused in portfolio mode. To re-enable: `.github/workflows/daily-feedback-digest.yml` + `.\scripts\collect-beta-feedback.ps1`

---

*Not medical advice. Beta software.*
