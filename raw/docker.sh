#!/bin/bash

# --- 颜色设置 ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}>>> 开始安装 Docker (智能适配版)...${NC}"

# 1. 基础环境清理与安装
echo -e "${YELLOW}Step 1: 准备环境...${NC}"
apt-get update
apt-get install -y ca-certificates curl gnupg lsb-release

# 2. 智能源选择逻辑
echo -e "${YELLOW}Step 2: 检测网络环境并选择最佳源...${NC}"
# 默认使用官方源
DOWNLOAD_URL="https://download.docker.com"
GPG_URL="$DOWNLOAD_URL/linux/$(. /etc/os-release; echo "$ID")/gpg"

# 测试官方源连通性 (超时时间 3秒)
if curl -I --connect-timeout 3 -m 3 -fsSL "https://download.docker.com" > /dev/null 2>&1; then
    echo -e "${GREEN} -> 国际网络正常，使用 Docker 官方源。${NC}"
else
    echo -e "${RED} -> 无法连接 Docker 官方源，自动切换至 阿里云镜像源 (国内优化)。${NC}"
    DOWNLOAD_URL="https://mirrors.aliyun.com/docker-ce"
    GPG_URL="$DOWNLOAD_URL/linux/$(. /etc/os-release; echo "$ID")/gpg"
fi

# 3. 添加 GPG 密钥 (不论选了哪个源，逻辑都一样)
echo -e "${YELLOW}Step 3: 添加 GPG 密钥...${NC}"
mkdir -p /etc/apt/keyrings
rm -f /etc/apt/keyrings/docker.gpg # 删除旧的以防万一

# 这里的关键是使用上面判定好的 $GPG_URL
curl -fsSL "$GPG_URL" | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

# 4. 设置软件源仓库
echo -e "${YELLOW}Step 4: 写入软件源...${NC}"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] $DOWNLOAD_URL/linux/$(. /etc/os-release; echo "$ID") \
  $(. /etc/os-release; echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

# 5. 安装 Docker
echo -e "${YELLOW}Step 5: 开始安装 Docker Engine & Compose...${NC}"
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 6. 启动服务
systemctl enable docker --now

# 7. 最终检查
if command -v docker &> /dev/null; then
    echo -e "${GREEN}>>> 安装成功!${NC}"
    echo -e "Docker 版本: $(docker --version)"
    echo -e "Compose 版本: $(docker compose version)"
else
    echo -e "${RED}>>> 安装失败，请检查上方报错信息。${NC}"
    exit 1
fi
