# Localoop 测试反馈 — 每天怎么看

## 已自动化（2026-07-06 启用）

| 渠道 | 时间 | 你怎么收 |
|------|------|----------|
| **GitHub Actions** | 每天 09:00 北京时间 | 仓库 Issue 标题 `Daily beta feedback — YYYY-MM-DD` + 邮件（Watch 仓库） |
| **Windows 计划任务** | 每天 09:00 | 本地文件 `docs/feedback/YYYY-MM-DD-digest.md` |
| **手动** | 随时 | `.\scripts\collect-beta-feedback.ps1` |

Watch 仓库收邮件：打开 https://github.com/SJT503/localoop-beta → Watch → All Activity

---

## 三个入口

| 方式 | 链接 |
|------|------|
| **GitHub Issues** | https://github.com/SJT503/localoop-beta/issues?q=label%3Abeta-feedback |
| **App 内** | Privacy → Send beta feedback |
| **本地摘要** | `docs/feedback/` |

---

## 发给测试者

> **Localoop beta** — private period tracker (Android + web).  
> Web: https://sjt503.github.io/localoop-beta/  
> APK: https://github.com/SJT503/localoop-beta/releases/latest  
> Data notice: https://github.com/SJT503/localoop-beta/blob/main/docs/DATA_DISCLOSURE.md  
> Feedback: https://github.com/SJT503/localoop-beta/issues/new?template=beta_feedback.yml

---

## 看什么算「有用反馈」

1. 愿不愿每周继续用（Yes / Maybe / No）
2. 具体原因（不能是「挺好」）
3. 最大阻碍（信任 / 预测 / 通知 / UI…）

≥2 人给出具体切换理由 → 进入下一版（Flo 导入等）。
