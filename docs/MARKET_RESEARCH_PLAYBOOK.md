# Luna — 市场调研与顾问流水线

> 跨项目通用版见 `~/.cursor/skills/market-research-pipeline/SKILL.md`

## 四层架构

```
顾问席（你拍板）
  L1 agent-reach        眼睛：采集证据
  L2 opportunity-scout  大脑：打分竞品
  L3 before-you-build   闸门：做不做
  技术 senior-tech-advisor  技术怎么落地（大白话）
  L4 dev-studio + superpowers  施工
```

## Luna 专属关键词示例

| 维度 | 词 |
|------|-----|
| 品类 | 经期记录 / period tracker / cycle app |
| 痛点 | 隐私 / 广告 / 臃肿 / 离线 / 订阅贵 |
| 中文采集 | 小红书 + B站 |
| 英文采集 | Exa + Reddit |
| 开源参考 | `gh search repos flutter period` |

## Agent Reach 启动

```powershell
& "$env:USERPROFILE\.agent-reach\tools\start-agent-reach-chrome.ps1"
agent-reach doctor --json
```

## 产物位置

`docs/market-research/`

## 跳过调研

修 bug、i18n、样式、用户说「不要调研」
