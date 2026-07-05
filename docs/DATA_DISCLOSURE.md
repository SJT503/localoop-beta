# Localoop — Data & privacy disclosure (beta)

**App:** Localoop (local-first period tracker)  
**Current beta:** `0.1.4`  
**Last updated:** 2026-07-06

## What we collect

**Nothing leaves your device by default.**

- Cycle profile, daily logs, symptoms, mood, BBT, and notes are stored **only in local app storage** (SharedPreferences on this beta build).
- No account, no email, no analytics SDK, no ad network in the beta APK manifest.
- Optional actions that touch the network (only if you tap them):
  - **Send beta feedback** → opens GitHub Issues in your browser (you choose what to write).
  - **Beta links** → Web demo URL or APK download page on GitHub.

## What we do not do (beta)

- No cloud sync
- No selling or sharing cycle data
- No community feed or social graph
- No push of health data to our servers

## Your controls

| Action | Where |
|--------|--------|
| Export JSON backup | Privacy tab → Export JSON |
| Clear all data & restart | Privacy tab → **Clear all local data** |
| Hide sensitive notification words | Privacy tab → Hide sensitive words |
| Change language | Home → globe icon (top right) |

Clearing data removes profile and logs on **this device only**. Language and privacy toggles are kept.

## Download (latest beta)

| Channel | URL |
|---------|-----|
| **Web (no install)** | https://sjt503.github.io/localoop-beta/ |
| **Android APK** | https://github.com/SJT503/localoop-beta/releases/latest/download/localoop-beta-0.1.4.apk |
| **All releases** | https://github.com/SJT503/localoop-beta/releases/latest |
| **Feedback** | https://github.com/SJT503/localoop-beta/issues/new?template=beta_feedback.yml |

## Open source

Code & this document: https://github.com/SJT503/localoop-beta

---

*Beta disclaimer: Localoop is for personal tracking and lifestyle observation, not medical diagnosis. Consult a clinician if your cycle changes suddenly.*

