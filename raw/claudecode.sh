#!/bin/bash
# Claude Code Auto Installer (China Optimized)

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}>>> 准备安装 Claude Code...${NC}"

# 1. 网络环境探测
echo -e "${YELLOW}正在探测 claude.ai 连通性...${NC}"
if curl -I -s --connect-timeout 3 https://claude.ai | grep -q "HTTP"; then
    echo -e "${GREEN} -> 国际网络通畅，使用官方直装脚本。${NC}"
    curl -fsSL https://claude.ai/install.sh | bash
    exit 0
fi

echo -e "${RED} -> 无法连接到 claude.ai。启动国内镜像加速安装模式...${NC}"

# 2. 检查并安装 Node.js (Claude Code 需要 Node 18+)
if ! command -v npm &> /dev/null; then
    echo -e "${YELLOW}未检测到 Node.js，正在通过 NodeSource 国内镜像安装 (v20 LTS)...${NC}"
    # 这里我们不用官方的 apt 源，因为可能被墙。直接通过 apt 安装基础 node，然后再升级
    apt-get update
    apt-get install -y nodejs npm
    
    # 使用淘宝源全局安装 n (Node版本管理器)，升级到稳定版
    npm config set registry https://registry.npmmirror.com
    npm install -g n
    n lts
    # 刷新环境变量
    hash -r
fi

# 3. 通过 NPM 淘宝镜像安装 Claude Code
echo -e "${YELLOW}正在通过 NPM 国内镜像拉取 Claude Code 核心包...${NC}"
npm config set registry https://registry.npmmirror.com
npm install -g @anthropic-ai/claude-code

if command -v claude &> /dev/null; then
    echo -e "${GREEN}>>> Claude Code (国内镜像版) 安装成功！${NC}"
    echo "请输入 'claude' 启动，并按照屏幕提示进行授权配置。"
else
    echo -e "${RED}>>> 安装失败，请检查 NPM 日志。${NC}"
fi