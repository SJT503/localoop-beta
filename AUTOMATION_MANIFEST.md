# AUTOMATION_MANIFEST.md — Luna

## 一键验证

| 名称 | 命令 | 预期 |
|------|------|------|
| verify | `.\verify.ps1` | exit 0 |
| analyze | `flutter analyze` | No issues found |
| test | `flutter test` | All tests passed |
| build web | `flutter build web` | `build/web` 存在 |

## 环境变量

```
PUB_HOSTED_URL=https://pub.flutter-io.cn
FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
```

Flutter 路径：`D:\flutter\flutter\bin\flutter.bat`

## 冒烟路径（30 秒）

1. 打开 http://127.0.0.1:7357
2. 隐私页切换 English → 文案变化
3. 点「预览提醒」→ SnackBar 出现

## watch_paths

- `pubspec.yaml`
- `lib/main.dart`
- `lib/features/period_tracking/period_tracking_screen.dart`
- `lib/core/storage/luna_store.dart`
- `verify.ps1`

## CI / 自动化

| 级别 | 触发 | 动作 | 状态 |
|------|------|------|------|
| L1 本地 | 会话结束 | `verify.ps1` | 已启用 |
| L2 git | push / PR | GitHub Actions | ✅ 已配置 |
| L3 定时 | — | — | 未规划 |

## 发布产物

| 平台 | 路径 | 演示 |
|------|------|------|
| Web | `build/web` | `python -m http.server 7357` → http://127.0.0.1:7357 |

## 最近运行记录

| 日期 | verify | build web | 备注 |
|------|--------|-----------|------|
| 2026-07-05 | pass | pass | C 路线接入 + verify 复跑 |
