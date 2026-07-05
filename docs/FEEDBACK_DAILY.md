# Localoop 测试反馈 — 每天怎么看

## 三个入口（选一个习惯用的）

| 方式 | 你怎么做 | 适合 |
|------|----------|------|
| **GitHub Issues**（已配置） | 打开 [全部反馈](https://github.com/SJT503/localoop-beta/issues?q=label%3Abeta-feedback) | 结构化、可追踪 |
| **App 内按钮** | Privacy 页 → **Send beta feedback** | 测试者一键跳转 |
| **每日摘要文件** | 运行 `.\scripts\collect-beta-feedback.ps1` | 本地 Markdown 汇总 |

---

## 每天 2 分钟流程（手动）

```powershell
cd d:\Cursor\luna-app
.\scripts\collect-beta-feedback.ps1
```

会生成：`docs/feedback/YYYY-MM-DD-digest.md`

或直接浏览器书签：

- 反馈列表：https://github.com/SJT503/localoop-beta/issues?q=label%3Abeta-feedback

---

## 我能「每天自动收集」吗？

**这个聊天窗口里的我**：不能在你不打开 Cursor 时自己醒来。

**可以自动化的两种方式**（二选一）：

### A. Cursor 定时自动化（推荐）

已为你准备好草稿：每天跑一次 Agent，执行 `collect-beta-feedback.ps1` 并把摘要贴到这个对话/通知你。

→ 对我说「打开反馈自动化」或自己在 **Cursor → Automations** 里启用。

### B. Windows 计划任务

每天 9:00 运行：

```powershell
powershell -File D:\Cursor\luna-app\scripts\collect-beta-feedback.ps1
```

摘要落在 `docs/feedback/`，你打开文件看即可。

---

## 发给测试者的话（含反馈入口）

> **Localoop beta** — private period tracker (Android + web).  
> Web: https://sjt503.github.io/localoop-beta/  
> APK: https://github.com/SJT503/localoop-beta/releases/latest  
> After 3–7 days, please leave feedback (2 min): https://github.com/SJT503/localoop-beta/issues/new?template=beta_feedback.yml

---

## 看什么算「有用反馈」

验证期只看三条：

1. **愿不愿每周继续用**（Yes / Maybe / No）
2. **具体原因**（不能是「挺好」）
3. **阻碍是什么**（信任、预测、通知、UI…）

≥2 人给出具体切换理由 → 进入下一版功能（Flo 导入等）。
