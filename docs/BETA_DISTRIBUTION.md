# Localoop 测试版分发指南（野路子）

> 验证期：**Android APK + Web 链接**，不走 App Store / Google Play 正式上架。iOS 不做。

---

### 本机已配置（无需再装 Android Studio）

项目已检测到：

- **JDK**：`D:\jdk17\jdk-17.0.2`
- **Android SDK**：`D:\android-sdk`（见 `android/local.properties`）

打包命令：

```powershell
$env:JAVA_HOME = "D:\jdk17\jdk-17.0.2"
cd d:\Cursor\luna-app
.\build-beta.ps1
```

产物：

- Web：`dist\beta\web\`
- APK：`dist\beta\android\localoop-beta-0.1.0.apk`

---

## 你会得到两个东西

| 产物 | 路径 | 给谁用 |
|------|------|--------|
| **网页版** | `dist/beta/web/` | 所有手机浏览器点开即试 |
| **Android 安装包** | `dist/beta/android/localoop-beta-0.1.0.apk` | 要装真 App、要系统通知的人 |

打包命令（项目根目录）：

```powershell
.\build-beta.ps1
```

---

## 一、网页版发哪里（推荐先发这个）

把 `dist/beta/web/` 整个文件夹上传到免费静态托管：

### 方案 A：Cloudflare Pages（推荐，海外快）

1. 注册 [Cloudflare](https://dash.cloudflare.com/)
2. Pages → Create project → Upload assets
3. 上传 `dist/beta/web` 里的**所有文件**
4. 得到链接，例如 `https://localoop.pages.dev`

### 方案 B：GitHub Pages

1. 建一个仓库（可私有，用 Pages workflow）
2. 把 `dist/beta/web` 内容推到 `gh-pages` 分支
3. 链接形如 `https://你的用户名.github.io/localoop/`

### 发给测试者的话（英文，可复制）

> **Localoop beta (web)** — private period tracker, no account, no cloud.  
> Open on your phone: [你的链接]  
> Tap Privacy tab → already in English. Try 3–7 days and tell me what would make you switch from Flo.

---

## 二、Android APK 野路子分发

正式商店要审核和 $25，验证期用下面两种之一：

### 方案 A：Firebase App Distribution（稍正规，仍免费）

1. [Firebase Console](https://console.firebase.google.com/) 建项目
2. 添加 Android 应用，包名填 **`app.localoop.cycle`**
3. 菜单 → App Distribution → 上传 `localoop-beta-0.1.0.apk`
4. 添加测试者邮箱 → 他们收邮件安装

### 方案 B：直链 APK（最野、最快）

1. 把 APK 传到网盘 / GitHub Releases / 你自己的服务器
2. 把下载链接私发给测试者
3. 对方手机：**设置 → 允许此来源安装未知应用**
4. 下载 → 安装 → 允许通知权限

### 安装注意

- 包名：`app.localoop.cycle`
- 显示名：**Localoop**
- Release 包**没有 INTERNET 权限**（隐私向；不能联网是设计如此）
- 首次打开默认 **英文界面**

---

## 三、不要做的事（验证期）

- ❌ Reddit 公开发帖求下载（易被当 spam）
- ❌ 还没聊过就大规模推广
- ❌ 混用旧名 Luna（已更名，避免和 luna-rhythm.com 撞车）
- ❌ iOS / TestFlight（本轮不做）

---

## 四、成功标准（7 天）

- ≥2 位海外/双语测试者愿意**持续用 3–7 天**
- 能说出**具体**愿切换理由（不是「挺好」）
- 未达标 → 当作品集，不投上架费

---

## 五、更名说明

| 旧名 | 新名 | 原因 |
|------|------|------|
| Luna | **Localoop** | 与 [luna-rhythm.com](https://luna-rhythm.com/en) 等同名经期 App 冲突；对方已占「Flo alternative」SEO |

**Localoop** = local + loop，强调本地循环记录，目前无主流同名经期产品。
