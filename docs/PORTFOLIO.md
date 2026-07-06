# Localoop — Portfolio Case Study

> **Status:** Portfolio piece (validation paused, July 2026)  
> **Role:** Solo builder — product, Flutter UI, privacy architecture, i18n, beta infra  
> **Live demo:** https://sjt503.github.io/localoop-beta/ · **Source:** https://github.com/SJT503/localoop-beta

---

## One-liner (EN — for portfolio hero)

**Localoop** is a local-first period tracker for people who want Flo/Clue-style logging without accounts, cloud sync, or ad feeds. Built in Flutter for **Web + Android**, with **8 languages** and a privacy-first data model.

## 一句话（中文 — 作品集摘要）

**Localoop** 是一款本地优先的经期记录 App：无需注册、默认不上云、可 JSON 导出与一键清空。Flutter 跨端（Web + Android），8 语界面，面向「想离开 Flo/Clue 但还要好用」的隐私敏感用户——**作为产品设计 + 工程实现的作品集项目**。

---

## Problem

Users leaving mainstream cycle apps (Flo, Clue) often cite:

1. **Cloud anxiety** — fear of data sales, subpoenas, incomplete deletion  
2. **Account friction** — forced signup before day-one logging  
3. **Privacy apps that feel worse** — weak predictions, clunky UI, no reminders  

## Approach

Design a **narrow wedge**, not a full competitor:

| Choice | Rationale |
|--------|-----------|
| Local-only storage | `shared_preferences`; no backend in beta |
| No account | Reduces trust surface; aligns with “leave Flo” narrative |
| JSON export + clear-all | User owns exit path |
| Privacy notification mode | Generic lock-screen copy option |
| 8 locales | EN + 中文 + JA/KO + EU langs for overseas portfolio story |
| Android manifest without INTERNET (release path) | Consistent privacy story for APK |

## What I built

- **Onboarding** — 3-screen privacy/value prop (first-run)  
- **Cycle profile + ~20s daily log** — flow, mood, symptoms, factors  
- **Calendar + fertile-window hints** — lightweight prediction from local history  
- **Privacy tab** — threat-model copy, export, clear data, beta feedback link  
- **i18n layer** — `string_catalog` + symptom alias normalization (legacy CN labels → locale)  
- **Beta infra** — GitHub Pages, Release APK, CI verify, feedback digest (later paused)  

## Tech stack

| Layer | Choice |
|-------|--------|
| UI | Flutter 3.x, Material |
| State / storage | `shared_preferences`, in-memory models |
| i18n | `flutter_localizations`, custom catalog (8 langs) |
| Notifications | `flutter_local_notifications` (mobile); web stub |
| CI | GitHub Actions — `flutter analyze` + `test` |
| Distribution | gh-pages + GitHub Releases (sideload APK) |

## Outcomes & learnings

**Shipped**

- Working Web demo + signed beta APK (v0.1.4)  
- Open repo with data disclosure doc and reproducible build scripts  

**Validation paused**

- Reddit launch removed by spam filters (new account + multi-link promo pattern)  
- Decision: **portfolio mode** — demo + case study, not growth spend  

**Takeaways**

1. Privacy positioning is credible only with **technical consistency** (local storage, export, clear-all, manifest discipline).  
2. Overseas health apps face **distribution trust** before feature trust — community channels need account karma, not just good copy.  
3. **Portfolio framing** fits: narrow product thesis, full-stack solo delivery, honest scope boundaries.

## Scope boundaries (intentional)

- Not medical advice; no diagnosis claims  
- No cloud sync / no Flo import in this version  
- No iOS / Play Store listing (portfolio + sideload only)  
- No social feed or community features  

## Links for recruiters / reviewers

| | URL |
|---|-----|
| Live Web | https://sjt503.github.io/localoop-beta/ |
| GitHub | https://github.com/SJT503/localoop-beta |
| APK (Android sideload) | https://github.com/SJT503/localoop-beta/releases/latest |
| Data & privacy notice | https://github.com/SJT503/localoop-beta/blob/main/docs/DATA_DISCLOSURE.md |

## Suggested portfolio layout

1. **Hero** — screenshot (onboarding or home) + one-liner  
2. **Problem → insight** — 2–3 bullets (Flo fatigue)  
3. **Solution** — 3 screenshots: Home / Calendar / Privacy  
4. **Architecture** — local-only diagram (optional)  
5. **My role** — solo: research, UX copy, Flutter, CI, beta packaging  
6. **Links** — Web demo + GitHub  
7. **Reflection** — what I’d do next if validating again (Flo export, karma-building distribution)  

## Screenshot checklist

Capture from Web or Android (1080×1920 or 1270×760):

- [ ] Onboarding — “Your body, your data”  
- [ ] Home — forecast + Log today  
- [ ] Calendar month view  
- [ ] Privacy — export + clear data  
- [ ] Language picker (8 langs)  

Save under `docs/portfolio/assets/` when ready.

---

## 简历 bullet 示例（中文）

- 独立设计并开发 **Localoop**（Flutter）：本地优先经期记录，无账号/无云端，8 语国际化，JSON 导出与一键清空  
- 完成 **Web + Android** 双端交付、GitHub Pages 在线演示、CI 自动化与隐私向数据说明文档  
- 基于海外市场调研确定「Flo 逃离者」窄切口；验证期后因渠道限制转为 **作品集展示**，保留可运行 demo 与开源仓库  

## Resume bullets (EN)

- Built **Localoop**, a local-first period tracker in Flutter (Web + Android): no account, 8 locales, JSON export, one-tap data wipe  
- Shipped live demo (GitHub Pages), sideload APK, CI pipeline, and published privacy/data disclosure docs  
- Scoped product to privacy-conscious users leaving Flo/Clue; pivoted to **portfolio showcase** after distribution validation limits  

---

*Last updated: 2026-07-07 · Mode: Portfolio*
