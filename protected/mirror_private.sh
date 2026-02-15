#!/bin/bash

# --- 配置区 ---
# 核心脚本的加密地址
PROTECTED_URL="https://tool.zengjunjie.com/protected/setup_private.sh"
AUTH_USER="agnes" # 我们刚才在 htpasswd 里设的用户名

# --- 逻辑区 ---
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}>>> 准备配置私有化镜像源...${NC}"

# 1. 检查环境变量是否存在 (Token 思路)
# 你可以在机器上提前设置 export MY_DOCKER_TOKEN="你的密码"
if [ -n "$MY_DOCKER_TOKEN" ]; then
    echo -e "${GREEN}检测到环境变量 Token，尝试自动登录...${NC}"
    PASSWORD="$MY_DOCKER_TOKEN"
else
    # 2. 如果没有 Token，交互式询问密码
    echo -e "${RED}此脚本包含私有配置，需要鉴权！${NC}"
    # -s 表示输入不显示在屏幕上，保护隐私
    read -s -p "请输入访问密码: " PASSWORD
    echo "" # 换行
fi

# 3. 携带密码去请求核心脚本
# -u user:password 是 curl 的标准认证方式
# -f 只有当 HTTP 状态码为 200 时才输出，避免把 401 错误页面的 HTML 当脚本执行
SCRIPT_CONTENT=$(curl -s -f -u "${AUTH_USER}:${PASSWORD}" "$PROTECTED_URL")

# 4. 检查是否获取成功
if [ $? -ne 0 ]; then
    echo -e "${RED}认证失败！密码错误或无法连接服务器。${NC}"
    exit 1
fi

# 5. 执行核心脚本
echo -e "${GREEN}认证通过，正在执行载荷...${NC}"
# 通过管道将下载的内容交给 bash 执行
echo "$SCRIPT_CONTENT" | bash
