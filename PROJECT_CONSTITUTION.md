# PROJECT_CONSTITUTION.md — Luna

## 技术栈

- Flutter 3.x / Dart 3.12+
- 持久化：`shared_preferences`（P2 可迁 Drift）
- 通知：`flutter_local_notifications` + `timezone`（条件导出）
- Web 导出：`package:web`

## 目录约定

```
lib/
  main.dart                 # 入口 + MobileShell(Web)
  core/                     # 模型、存储、工具、通知
  features/period_tracking/ # 主功能 + widgets/
  ui/                       # 主题、MobileShell
verify.ps1                  # 质量门禁
```

## 编码纪律

- 颜色用 `ui/theme/luna_colors.dart` 的 `C`，禁止主文件内联配色类
- 文案走 `LunaStrings`，新 UI 禁止硬编码中文
- 最小 diff；LogSheet/ProfileSheet 已模块化，勿膨胀单文件
- doer ≠ verifier：改完跑 `verify.ps1`

## 质量门禁

| 检查 | 命令 |
|------|------|
| 静态分析 | `flutter analyze` |
| 测试 | `flutter test` |
| Web 构建 | `flutter build web` |
| 一键 | `.\verify.ps1` |

## 环境

```powershell
$env:PUB_HOSTED_URL="https://pub.flutter-io.cn"
$env:FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"
$flutter = "D:\flutter\flutter\bin\flutter.bat"
```

## 已冻结决策

- 主屏必须用 `LunaStore`，禁止 Mock setState 版回退
- Web 用 `MobileShell` 手机框
- 提醒：Web stub，移动端真实调度

## 已知风险

- `android/app/src/main/AndroidManifest.xml` 缺失 → 真机 Android 构建/通知待补
- 多 workspace 下文件偶发回退 → 会话首尾必跑 verify
