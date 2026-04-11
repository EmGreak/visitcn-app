# VisitCN Demo 🇨🇳

> 一个漂亮的 AI 来华旅行助手界面，调用 MiniMax API

## 🚀 快速启动

### 1. 安装依赖

```bash
cd /home/greg/.openclaw/workspace/projects/foreign-tourist-app/demo
pip install -r requirements.txt
```

### 2. 设置 API Key

```bash
# Linux/Mac
export MINIMAX_API_KEY=你的API密钥

# Windows (PowerShell)
$env:MINIMAX_API_KEY="你的API密钥"
```

### 3. 运行

```bash
python app.py
```

### 4. 访问

打开浏览器访问：**http://localhost:5001**

---

## ✨ 功能特点

- 🎨 精美的移动端适配界面
- ⚡ 快速操作按钮（一键发送示例问题）
- 💬 实时 AI 对话
- 🎭 流畅的加载动画
- 📱 完全响应式设计

---

## 📁 文件结构

```
demo/
├── app.py              # Flask 后端
├── templates/
│   └── index.html      # 前端页面
└── requirements.txt    # Python 依赖
```

---

## 🔧 API 配置

后端调用的是 MiniMax Text API：
- Endpoint: `https://api.minimaxi.chat/v1/text/chatcompletion_v2`
- Model: `MiniMax-Text-01`

如果没有设置 API Key，界面会提示错误但不会崩溃。

---

## 📝 后续开发方向

- [ ] 添加对话历史保存
- [ ] 支持多轮对话上下文
- [ ] 添加语音输入/输出
- [ ] 对接景点/酒店 API
- [ ] 行程导出功能
