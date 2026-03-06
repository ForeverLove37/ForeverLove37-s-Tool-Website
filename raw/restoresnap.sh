#!/bin/bash
# Restore Snapd to Ubuntu

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}====================================================${NC}"
echo -e "${GREEN}             恢复 Snapd 包管理引擎                  ${NC}"
echo -e "${CYAN}====================================================${NC}"

echo -e "${YELLOW}>>> 1. 解除 APT 阻断封印...${NC}"
if [ -f /etc/apt/preferences.d/nosnap.pref ]; then
    rm -f /etc/apt/preferences.d/nosnap.pref
    echo "阻断规则已移除。"
else
    echo "未发现阻断规则，继续执行。"
fi

echo -e "${YELLOW}>>> 2. 更新软件源并重新安装 Snapd...${NC}"
apt-get update
apt-get install -y snapd

echo -e "${YELLOW}>>> 3. 启动并启用服务...${NC}"
systemctl enable --now snapd.socket

echo -e "\n${GREEN}>>> Snapd 引擎已成功恢复！${NC}"
echo "注意: 之前删除的具体 Snap 软件包需要您手动重新安装。"
