# Flutter 开发详细执行规划

> 创建时间：2026-04-10
> 你的电脑：Ubuntu 24.04 | 8核CPU | 15GB RAM | 233GB NVMe
> 状态：Flutter 环境尚未安装

---

## 阶段一：环境搭建（约1-2天）

### Day 1：安装 Flutter SDK

```bash
# 1. 安装依赖
sudo apt update
sudo apt install -y curl git unzip xz-utils zip libglu1-mesa clang cmake ninja-build pkg-config libgtk-3-dev

# 2. 下载 Flutter SDK
cd ~
git clone https://github.com/flutter/flutter.git -b stable --depth 1

# 3. 添加到 PATH（永久生效）
echo 'export PATH="$HOME/flutter/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# 4. 验证安装
flutter --version
```

### Day 2：配置 Android SDK（用于 Android 打包）

```bash
# 安装 Android SDK command line tools
mkdir -p ~/android-sdk/cmdline-tools
cd ~/android-sdk/cmdline-tools
curl -o tools.zip https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
unzip tools.zip
mv cmdline-tools latest

# 设置环境变量
echo 'export ANDROID_HOME="$HOME/android-sdk"' >> ~/.bashrc
echo 'export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools"' >> ~/.bashrc
source ~/.bashrc

# 接受协议
yes | sdkmanager --licenses

# 安装 build-tools + platform
sdkmanager "build-tools;34.0.0" "platforms;android-34"
```

### 验证环境

```bash
flutter doctor
# 预期输出：✅ 全部绿色
```

---

## 阶段二：创建项目 + 跑通 Demo（约1天）

### 创建项目

```bash
cd /home/greg/.openclaw/workspace/projects/foreign-tourist-app
flutter create --org com.visitcn --project-name visitcn_app visitcn_app
cd visitcn_app
```

### 添加核心依赖（pubspec.yaml）

```yaml
dependencies:
  flutter:
    sdk: flutter

  # AI / HTTP
  http: ^1.2.0           # API 调用
  dio: ^5.4.0            # 更强大的 HTTP 客户端

  # 状态管理
  flutter_riverpod: ^2.5.0

  # UI 组件
  google_fonts: ^6.1.0
  flutter_svg: ^2.0.9
  cached_network_image: ^3.3.1
  shimmer: ^3.0.0         # 加载骨架屏

  # 工具
  shared_preferences: ^2.2.2   # 本地存储
  intl: ^0.19.0              # 国际化
  url_launcher: ^6.2.4        # 打开外部链接

  # 地图
  amap_flutter_map: ^3.1.0    # 高德地图

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

### 安装依赖

```bash
flutter pub get
```

### 快速验证：Hello World

```bash
flutter run -d linux    # Linux 桌面测试
flutter run -d chrome  # Chrome 网页测试
```

---

## 阶段三：核心功能开发（10-15天）

### 第1周：基础架构 + AI 对话界面

**文件结构**：
```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── api/
│   │   └── minimax_client.dart   # MiniMax API 调用
│   ├── theme/
│   │   └── app_theme.dart        # 主题配置
│   └── constants/
│       └── app_constants.dart
├── features/
│   └── chat/
│       ├── chat_screen.dart
│       ├── chat_controller.dart
│       ├── widgets/
│       │   ├── message_bubble.dart
│       │   ├── quick_actions.dart
│       │   └── loading_indicator.dart
│       └── models/
│           └── message.dart
└── shared/
    └── widgets/
```

**实现步骤**：

```
Day 1-2: 搭建项目结构 + 配置主题
Day 3-4: 实现 MiniMax API 客户端
Day 5-7: 开发 ChatScreen UI + 消息气泡
```

### 第2周：行程生成 + 展示

```
Day 8-9: 行程数据结构设计 + API 对接
Day 10-11: 行程卡片 UI 开发
Day 12-14: 收藏/分享功能
```

### 第3周：语音 + UI 完善

```
Day 15-16: 语音 TTS 集成（MiniMax Speech 2.8）
Day 17-18: 语音识别 STT 集成
Day 19-21: 启动页/首页/设置页完善
```

---

## 阶段四：测试 + 打包（约3-5天）

### Linux 桌面测试（无需模拟器）

```bash
flutter run -d linux
```

### Android APK 打包

```bash
# 生成 debug APK
flutter build apk --debug

# 路径：build/app/outputs/flutter-apk/app-debug.apk
```

### iOS 打包（macOS 上操作，需要 Xcode）

```bash
# 在 macOS 上运行以下命令
flutter build ios --simulator --no-codesign
# 或发布版本
flutter build ios --release
```

---

## 阶段五：应用市场上架（约1-2周）

### Google Play 上架

```
1. 创建 Google Play 开发者账号（$25）
2. 准备应用商店素材：
   - App 图标（1024x1024）
   - 截图（手机+平板）
   - 隐私政策页面（需要你的域名）
   - 简介（英文+中文）
3. 生成 signed APK/AAB
4. 提交审核（1-7天）
```

### App Store 上架

```
1. 注册 Apple Developer 账号（$99/年）
2. 在 Apple Developer 后台创建 App
3. 在 macOS 上用 Xcode 上传
4. 提交审核（1-3天）
5. 注意：需要提供"外国人来华"相关资质或说明
```

---

## 阶段六：隐私合规（必须）

上架前必须准备：

```bash
# 1. 创建隐私政策页面（部署到你的网站）
# 访问：https://your-domain.com/privacy

# 2. 在 Flutter 中配置
# lib/main.dart 或 app.dart 添加：
<key>NSAppTransportSecurity</key>  # iOS
<key>ITSAppUsesNonExemptEncryption</key>  # 外国人用，不算出口加密
```

---

## 具体每日任务清单

### 环境搭建（Day 1-2）

```
□ Day 1：安装 Flutter SDK + 验证 flutter --version
□ Day 1：安装 Android SDK + 验证 sdkmanager
□ Day 2：运行 flutter doctor，修复红色警告
□ Day 2：创建项目 flutter create visitcn_app
□ Day 2：运行 flutter run -d linux 确认 Hello World
□ Day 2：配置 pubspec.yaml 依赖
□ Day 2：flutter pub get 确认无报错
```

### 核心开发（Day 3-17）

```
□ Day 3：搭建 lib/ 目录结构
□ Day 4：实现 minimax_client.dart（API 调用）
□ Day 5：实现 chat_screen.dart（主界面）
□ Day 6：实现 message_bubble.dart（聊天气泡）
□ Day 7：实现 quick_actions.dart（快捷按钮）
□ Day 8：集成 AI 对话，跑通第一轮对话
□ Day 9：行程数据结构设计
□ Day 10：行程卡片 UI 开发
□ Day 11：行程详情页
□ Day 12：收藏功能
□ Day 13：分享功能（生成图片/链接）
□ Day 14：语音 TTS 集成（MiniMax Speech）
□ Day 15：语音 STT 集成
□ Day 16：首页 + 发现页
□ Day 17：设置页 + 多语言支持
□ Day 18：主题切换（深色/浅色）
□ Day 19：Bug 修复 + 体验优化
□ Day 20：性能优化
□ Day 21：最终测试
```

### 打包上架（Day 22-28）

```
□ Day 22-23：Google Play 素材准备（图标/截图/描述）
□ Day 24-25：生成 signed AAB
□ Day 26：Google Play 提交审核
□ Day 27-28：Apple App Store 提交审核（macOS）
```

---

## 我能帮你做的

| 你需要做的 | 我能帮你做的 |
|-----------|-------------|
| 搭建环境 | ⬜ 我可以帮你写所有代码 |
| 配置依赖 | ✅ 代码我全部可以写 |
| 写 API 客户端 | ✅ 代码我全部可以写 |
| UI 开发 | ✅ 代码我全部可以写 |
| Bug 修复 | ✅ 我可以帮你排查 |
| Flutter 学习 | ✅ 我可以给你讲解原理 |

---

## 下一步

**Day 1 任务**：你的 Ubuntu 上安装 Flutter，我帮你执行。

要现在开始吗？我把安装命令整理好，你复制粘贴执行就行。🦞
