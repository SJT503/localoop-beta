# 一键完成 GitHub 上线（网络畅通时运行）

> 仓库已创建：https://github.com/SJT503/localoop-beta  
> 若 `git push` 报 Connection reset，多试几次或开代理后再跑本脚本。

```powershell
cd d:\Cursor\luna-app
$env:JAVA_HOME = "D:\jdk17\jdk-17.0.2"
.\scripts\deploy-beta.ps1
```

成功后你会得到：

| 链接 | 用途 |
|------|------|
| https://sjt503.github.io/localoop-beta/ | 网页测试版 |
| https://github.com/SJT503/localoop-beta/releases/latest/download/localoop-beta-0.1.4.apk | APK 直链（最新） |
| https://github.com/SJT503/localoop-beta/blob/main/docs/DATA_DISCLOSURE.md | 数据与隐私公开说明 |
| https://github.com/SJT503/localoop-beta/issues/new?template=beta_feedback.yml | 反馈表单 |

## 仅重传网页（已打包在 dist 时）

```powershell
cd d:\Cursor\luna-app
.\scripts\publish-gh-pages.ps1
```

## 仅收集反馈摘要

```powershell
.\scripts\collect-beta-feedback.ps1
# 输出：docs\feedback\YYYY-MM-DD-digest.md
```
