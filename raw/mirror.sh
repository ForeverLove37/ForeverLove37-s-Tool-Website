#!/bin/bash
# ==========================================
# Public Community Mirrors Configuration
# ==========================================
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}====================================================${NC}"
echo -e "${GREEN}        正在配置公共社区镜像加速网络...             ${NC}"
echo -e "${CYAN}====================================================${NC}"

# 1. Docker
echo -e "${YELLOW}>>> 1. 配置 Docker 公共加速 (DaoCloud等)...${NC}"
mkdir -p /etc/docker
cat > /etc/docker/daemon.json <<EOF
{
    "registry-mirrors": [
        "https://docker.m.daocloud.io",
        "https://mirror.baidubce.com",
        "https://dockerproxy.com"
    ],
    "log-driver": "json-file",
    "log-opts": {"max-size": "100m", "max-file": "3"}
}
EOF
systemctl daemon-reload
systemctl restart docker || echo "Docker 服务未运行。"

# 2. GitHub
echo -e "${YELLOW}>>> 2. 配置 GitHub 公共加速 (GHProxy)...${NC}"
# 公共反代通常是在 URL 前加前缀
git config --global url."https://mirror.ghproxy.com/https://github.com/".insteadOf "https://github.com/"

# 3. Hugging Face
echo -e "${YELLOW}>>> 3. 配置 Hugging Face 公共加速 (HF-Mirror)...${NC}"
echo 'export HF_ENDPOINT="https://hf-mirror.com"' > /etc/profile.d/hf_mirror.sh
export HF_ENDPOINT="https://hf-mirror.com"

echo -e "\n${GREEN}>>> 公共镜像加速网络配置完毕！${NC}"
