#!/bin/bash
# Claude Code Auto Installer (Geo-block & China Optimized)

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}>>> 准备安装 Claude Code...${NC}"

# 1. 智能连通性与内容探测
echo -e "${YELLOW}正在尝试获取官方安装脚本...${NC}"
# 先把下载的内容存到变量里，而不是直接运行
INSTALL_SCRIPT=$(curl -fsSL --connect-timeout 5 https://claude.ai/install.sh)

# 检查内容是否为空，或者是否包含了网页标签 (如果是网页，说明被拦截了)
if [ -z "$INSTALL_SCRIPT" ] || echo "$INSTALL_SCRIPT" | grep -qi "<html"; then
    echo -e "${RED} -> 官方获取失败！当前 IP 区域可能受限 (如中国大陆、香港等)。${NC}"
    echo -e "${YELLOW} -> 启动 NPM 镜像降维安装模式...${NC}"
    
    # 2. 备用安装模式：Node.js + NPM
    if ! command -v npm &> /dev/null; then
        echo -e "${YELLOW}未检测到 Node.js，正在通过基础源安装...${NC}"
        apt-get update
        apt-get install -y nodejs npm
        
        # 升级到最新的 Node LTS
        npm config set registry https://registry.npmmirror.com
        npm install -g n
        n lts
        hash -r
    fi
    
    echo -e "${YELLOW}正在拉取 Claude Code 核心包...${NC}"
    npm config set registry https://registry.npmmirror.com
    npm install -g @anthropic-ai/claude-code
    
else
    echo -e "${GREEN} -> 官方源连通正常且验证通过，正在执行原版安装...${NC}"
    # 把安全的脚本内容交给 bash 执行
    echo "$INSTALL_SCRIPT" | bash
fi

# 3. 最终验证
if command -v claude &> /dev/null; then
    echo -e "${GREEN}>>> Claude Code 安装成功！${NC}"
    echo "请输入 'claude' 启动，并按照屏幕提示进行授权。"
else
    echo -e "${RED}>>> 安装失败，请检查环境日志。${NC}"
fi