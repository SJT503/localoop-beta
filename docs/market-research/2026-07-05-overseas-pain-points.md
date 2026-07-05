# L1 证据包 — 海外隐私窄切口 · 用户痛点 — 2026-07-05

> 目标人群：**离开 Flo/Clue、怕云传票、愿换本地 App 的海外用户**（含双语华人副人群）  
> 采集：Reddit（Agent Reach）+ App Store 评论 + 隐私博客/竞品对比页

---

## 一句话结论

海外用户不是缺「又一个经期 App」，而是缺：**能讲清楚「数据在哪」、能顺利从 Flo 逃出来、提醒准、界面不丑、还不用订阅** 的那一款。Luna 已有本地+导出+双语底子，缺口在**信任叙事、迁移路径、预测可信度证明**。

---

## 痛点清单（按证据强度排序）

### P1 — 怕云上的数据被卖 / 被传票（最强）

| 痛点 | 用户原话/场景 | 证据 |
|------|---------------|------|
| Flo 曾把经期数据发给 Facebook/Meta | 「Flo shared data with Facebook, Google…」集体诉讼 $59.5M | [r/Hijabis 警告帖](https://www.reddit.com/r/Hijabis/comments/1tz4kff/) · [WSJ 2019](https://www.wsj.com/articles/you-give-apps-sensitive-personal-information-then-they-tell-facebook-11550851636) |
| Dobbs 后「公司手里的数据可被 subpoena」 | 「period-tracking data became something that can be subpoenaed」 | [r/DigitalEscapeTools · Grovely 作者](https://www.reddit.com/r/DigitalEscapeTools/comments/1u7f45w/) |
| Meta 非法收集 Flo 数据（陪审团认定） | 5000+ upvotes 讨论 | [r/TwoXChromosomes](https://www.reddit.com/r/TwoXChromosomes/comments/1mj84jg/) |
| 卸载 ≠ 删账号，数据仍在服务器 | 「Uninstalling is not enough… subpoena six months later」 | [Floriva 迁移指南](https://floriva.app/resources/guides/delete-flo-account-keep-data) |

**用户要什么：** 数据只在设备上、无账号、公司「物理上拿不到」我的周期史。

---

### P2 — 从 Flo/Clue 迁出来太难

| 痛点 | 细节 | 证据 |
|------|------|------|
| 先导出再删账号，步骤绕 | Flo：Settings → Privacy → Request My Data，等邮件 | Floriva 指南同上 |
| 隐私 App 导入体验差 | Drip「difficult to transfer data from previous tracker」 | [App Store · Drip 评论](https://apps.apple.com/us/app/drip-period-cycle-tracker/id1584564949) |
| 需要 JSON/CSV 可携带 | 「CSV export — download your full symptom history」被列为换 App 理由 | [Dawn Phase · Flo alternative](https://www.dawnphase.com/blog/flo-alternative) |

**用户要什么：** 换 App 指南 + 一键导入最近经期开始日（最少字段）。

---

### P3 — 订阅、广告、推销烦人

| 痛点 | 细节 | 证据 |
|------|------|------|
| Flo 免费版广告多、老弹升级 | 「cluttered with fertility product ads」「upgrade prompts」 | Dawn Phase 博文 |
| 年费 $40 级别 | Grovely 作者：「Flo and Clue charge $40/year」 | r/DigitalEscapeTools |
| 暗模式 upsell | 「dark-pattern upsells」 | Dawn Phase |

**用户要什么：** 免费或一次性买断、界面干净、不推销备孕商品。

---

### P4 — 隐私 App 功能/体验短板（换过来又后悔）

| App | 具体吐槽 | 证据 |
|-----|----------|------|
| **Drip** | 周期 >99 天算错；预测不准；图表难用；缺自定义症状；常崩溃 | App Store / AppRecs 评论 |
| **Euki** | 预测比 Drip/Health 差 1–2 天；无经期前通知；无 dark mode；界面丑 | [App Store · Euki](https://apps.apple.com/us/app/euki/id1469213846) |
| **Drip** | 「UI functional, not polished」 | [Drip Review 2026](https://www.fitness-tracking.com/reviews/drip/) |
| **开源圈** | Drip F-Droid 久未更新；用户更重外观 | [F-Droid Forum](https://forum.f-droid.org/t/apps-for-menstrual-cycle-and-fertility/19163) |

**用户要什么：** 提醒在预测窗口前触发、症状含腰酸/痛经、日历别每次跳回今天、界面现代。

---

### P5 — 信任与可验证性

| 痛点 | 细节 | 证据 |
|------|------|------|
| 隐私承诺不可验证 | 「If not open source, privacy claims are unverifiable」 | [VGER · Clio Daye](https://thevgergroup.com/blog/we-built-a-period-tracker-that-cant-sell-your-data-heres-why-that-matters/) |
| 选 App 的检查清单 | 要不要账号？有没有广告 SDK？公司在哪注册？ | 同上 |
| 中国开发者 + 健康数据 | *推断*：海外用户对中国主体 App 更谨慎（待访谈验证） | 顾问层风险项 |

**用户要什么：** 一页「威胁模型」：数据存哪、有没有网络请求、怎么删干净。

---

### P6 — 副人群：双语 / 海外华人

| 痛点 | 细节 |
|------|------|
| 英文主流 App 中文体验差 | Luna 已有中英切换 |
| 国内 App 隐私叙事弱 | 用户已决定国内暂缓 |

---

## Luna 现状 vs 痛点（速查）

| 痛点 | Luna 已有 | 缺口 |
|------|-----------|------|
| P1 本地无云 | shared_preferences，无账号 | 隐私页 hero 曾仅中文；缺英文威胁模型 |
| P2 迁移 | JSON 导出 | **无 Flo 迁出清单、无导入** |
| P3 无广告订阅 | 是 | 缺英文一句话价值主张 |
| P4 体验 | 5 步记录、腰酸症状、温和提醒、隐私通知文案 | 无 dark mode；预测准确度未验证 |
| P5 信任 | Web 可演示 | 无开源/审计叙事（非必须） |
| P6 双语 | LunaStrings 中英 | 英文 onboarding 可加强 |

---

## 竞品地图（海外隐私带）

| 产品 | 定位 | 强项 | 弱项（用户说） |
|------|------|------|----------------|
| Flo/Clue | 大盘 | 预测、功能全 | 云、诉讼、广告、订阅 |
| Drip | 开源本地 | FAM、透明计算 | UI、bug、导入难 |
| Euki | 隐私 | 教育内容 | 预测、通知、UI |
| Clio Daye | iOS 本地 | 极简、开源叙事 | 仅 iOS |
| Floriva / Dawn Phase | 营销+本地 | SEO、对比文 | 新品牌信任 |
| Grovely | 自托管 | 夫妇/服务器 | 技术门槛高 |
| Periodt | Android 无网络权限 | 硬核隐私 | 功能路线图慢 |

**Luna 可卡位：** 「比 Drip/Euki 更顺手的双语 PWA + 比 Flo 简单十倍的迁出故事」—— 人群仍窄，但故事清晰。

---

## 待验证假设（需 3–5 人访谈）

1. 海外用户是否愿意用**中国开发者**的隐私 App？（最大信任债）
2. 「JSON 导出 + Flo 删号清单」是否足以让人试用一周？
3. 双语是否是**独立卖点**，还是仅华人副人群？
4. PWA（不上商店）vs 商店上架，哪个转化更高？

---

## 来源索引

- Reddit: r/Hijabis, r/DigitalEscapeTools, r/TwoXChromosomes, r/fossdroid
- 博客: dawnphase.com, thevgergroup.com, floriva.app
- 商店: App Store Drip/Euki 评论区
- 开源: github.com/benny10ben/Periodt, F-Droid forum
