#!/bin/bash

# --- 配置区 ---
PROTECTED_URL="https://tool.zengjunjie.com/protected/setup_private.sh"

# --- 颜色定义 ---
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}>>> 正在请求私有镜像配置脚本...${NC}"

# =========================================================
#  Token 获取逻辑 (优先级：环境变量 -> 交互式输入)
# =========================================================
TOKEN=""

# 1. 优先检查环境变量 (适合自动化脚本/CI环境)
if [ -n "$MY_TOOL_TOKEN" ]; then
    echo -e "${GREEN}[INFO] 检测到环境变量 MY_TOOL_TOKEN，将自动使用。${NC}"
    TOKEN="$MY_TOOL_TOKEN"
else
    # 2. 如果没有环境变量，且当前是交互式终端，则询问
    # /dev/tty 强制读取键盘输入，防止因为管道符 '| bash' 导致 read 读取不到输入
    if [ -t 0 ]; then
        echo -e "${YELLOW}[AUTH] 此脚本需要访问权限。${NC}"
        read -s -p "请输入 Access Token: " TOKEN < /dev/tty
        echo "" # 换行
    else
        # 3. 非交互式且无变量（比如在定时任务中直接运行），直接报错
        echo -e "${RED}[ERROR] 未检测到 Token，且无法进行交互式输入。${NC}"
        echo "请设置 export MY_TOOL_TOKEN='你的Token' 后再试。"
        exit 1
    fi
fi

# =========================================================
#  执行请求
# =========================================================
# -H "Authorization: Bearer ..." 是标准的 API 认证头
# -f 失败时不输出内容 (fail silently)
# -s 静默模式
SCRIPT_CONTENT=$(curl -s -f -H "Authorization: Bearer $TOKEN" "$PROTECTED_URL")

EXIT_CODE=$?

if [ $EXIT_CODE -ne 0 ]; then
    echo -e "${RED}[ERROR] 认证失败 (HTTP 401/403) 或网络连接错误。${NC}"
    echo "请检查 Token 是否正确，或者您的 IP 是否被封禁。"
    exit 1
fi

# =========================================================
#  执行载荷
# =========================================================
echo -e "${GREEN}[SUCCESS] 认证通过，正在执行私有脚本...${NC}"
# 执行下载下来的脚本内容
bash -c "$SCRIPT_CONTENT"
