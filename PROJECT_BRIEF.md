# PROJECT_BRIEF.md — Localoop 经期助手

> 工程身份锚点。会话启动必读。  
> **2026-07-05 更名**：Luna → **Localoop**（避开 luna-rhythm.com 等同名竞品）

## 1. 用户问题

私密、轻量的经期记录与预测助手（中文友好，默认英文），本地优先，不做社区信息流。

**差异化（2026-07-05 调研结论）**：
- 国内：红海，暂缓主攻（用户访谈：同类产品太多）
- **海外窄切口（当前 P0）**：给想离开 Flo/Clue 的用户 — **无账号、无云端、JSON 自己带走**
- 英文定位句：*Localoop — A bilingual, local-first period assistant for people leaving Flo.*

相对竞品：比 Flo/Clue **无云传票焦虑**；比 Drip/Euki **更顺手的双语 UI**；比 luna-rhythm.com 的 Luna **更简单、无订阅、本地优先**。

## 2. 核心能力（MVP）

- [x] 本地持久化（shared_preferences）
- [x] 周期档案 + 5 步每日记录
- [x] 动态日历 / 洞察 / 隐私设置
- [x] Web 手机框演示 + JSON 导出
- [x] 中英双语（AppStrings）
- [x] 温和提醒调度（Web stub + 移动端通知）
- [x] 海外隐私页：威胁模型 + Leaving Flo 清单
- [ ] Drift 数据库（P2 可选）
- [ ] 完整 CI（L2 自动化）

## 3. 非目标

- 不做社交/社区推荐
- 不做医疗诊断声明
- 不混用 IL-37 等外部课题数据
- 不与大厂拼日活/盈利（第一阶段）
- **国内大众市场暂缓**
- **iOS / TestFlight 暂缓**（验证期只做 Android + Web）
- 未验证前不堆 Drift/大平台功能

## 4. 不可妥协约束

- 依赖与主入口不可回退到脚手架 Mock 版
- Web 演示必须能 `build web` + 本地静态服务
- 国内环境 `pub.flutter-io.cn` 镜像
- 外部源只读；产物仅在 `d:\Cursor\luna-app`
- Android release **主 Manifest 不含 INTERNET**（隐私叙事）

## 5. 发布形态

- [x] Web（主演示 + 野路子分发）
- [x] Android APK（野路子 beta，`build-beta.ps1`）
- [ ] iOS（暂缓）
- [ ] Google Play 正式上架（验证通过后再说）

## 6. 敏感文件（回退高发）

| 文件 | 职责 |
|------|------|
| `pubspec.yaml` | shared_preferences、web、flutter_local_notifications |
| `lib/main.dart` | MobileShell + LocaloopApp |
| `lib/features/period_tracking/period_tracking_screen.dart` | CycleStore 集成主屏 |
| `android/app/src/main/AndroidManifest.xml` | 隐私向权限集 |
| `verify.ps1` / `build-beta.ps1` | 验证与打包 |

## 7. 当前阶段

**5 — 质量与自动化**；**当前 P0 = 海外隐私窄切口 · 野路子 beta 分发**

## 7b. 顾问与调研

- 规则：`.cursor/rules/advisor-plain-language.mdc`、`market-research-gate.mdc`
- 分发指南：`docs/BETA_DISTRIBUTION.md`
- 新功能立项：先 L1–L3，用户确认后才编码

## 8. 上次 verify

日期：2026-07-05（更名 Localoop）
结果：pass（analyze 0 issue / test pass）
打包：Web ✅ · APK ✅（JDK `D:\jdk17\jdk-17.0.2`）
