"""
VisitCN Demo - AI 外国人来华旅行助手
运行方式: python app.py
需要: Flask, requests
安装依赖: pip install flask requests
"""

from flask import Flask, request, jsonify, render_template
import requests
import json
import os

app = Flask(__name__)

# ============================================================
# MiniMax API 配置（Token Plan Plus）
# ============================================================
MINIMAX_API_KEY = "sk-cp-FsoI_MVQHJ3ONsrFvVcQJ_iL6XQ9CkldLbIxi3osxwiQenUVTjA2AggnAZfqmWMgxyXCiomxDHbA-2m-fVS9_sq_pjMKbxzRI0EymbZl74medLbpaoXlNwA"
MINIMAX_BASE_URL = "https://api.minimaxi.com/v1"  # 注意：是 minimaxi.com，不是 minimaxi.chat

# ============================================================
# 系统提示词
# ============================================================
SYSTEM_PROMPT = """你是 VisitCN，一个专为来华自由行外国旅客服务的AI旅行助手。

【产品介绍】
VisitCN: AI驱动的外国人来华行程规划平台，覆盖签证、支付、交通、景点、紧急联络等全流程服务。

【你的使命】
让每一位来华旅客都能轻松规划行程，深度体验中国。

【你的性格】
- 友好、专业、乐于助人
- 用词简洁，不啰嗦
- 主动推荐，不只是回答
- 适度幽默，但不失专业

【核心功能】
1. AI智能行程生成：输入目的地+天数+偏好，生成专属行程
2. 行前准备清单：签证、APP、电话卡等
3. 支付指南：Alipay/WeChat Pay绑定教程
4. 交通指南：打车、高铁、地铁
5. 景点推荐：含开放时间、门票、预约方式
6. 紧急联络：医院、领事馆、紧急电话

【语言能力】
主力语言：英文，同时支持中文、日文、韩文、法文、西班牙文
"""


@app.route("/")
def index():
    return render_template("index.html")


@app.route("/api/chat", methods=["POST"])
def chat():
    data = request.json
    user_message = data.get("message", "")

    headers = {
        "Authorization": f"Bearer {MINIMAX_API_KEY}",
        "Content-Type": "application/json"
    }

    payload = {
        "model": "MiniMax-M2.7",
        "messages": [
            {"role": "system", "content": SYSTEM_PROMPT},
            {"role": "user", "content": user_message}
        ],
        "temperature": 0.7
    }

    try:
        response = requests.post(
            f"{MINIMAX_BASE_URL}/chat/completions",
            headers=headers,
            json=payload,
            timeout=30
        )
        result = response.json()

        # 提取 AI 回复
        choices = result.get("choices", [])
        if choices:
            reply = choices[0].get("message", {}).get("content", "抱歉，服务暂时不可用。")
        else:
            reply = f"抱歉，服务暂时不可用。错误信息: {result.get('error', str(result))}"

        return jsonify({"reply": reply})

    except requests.exceptions.Timeout:
        return jsonify({
            "error": "请求超时",
            "reply": "抱歉，AI服务响应超时，请稍后重试。"
        })
    except Exception as e:
        return jsonify({
            "error": str(e),
            "reply": f"请求出错: {str(e)}"
        })


if __name__ == "__main__":
    print("🚀 VisitCN Demo 启动中...")
    print("📍 访问 http://localhost:5001")
    print("✅ MiniMax API 已配置 (Plus)")
    app.run(host="0.0.0.0", port=5001, debug=True)
