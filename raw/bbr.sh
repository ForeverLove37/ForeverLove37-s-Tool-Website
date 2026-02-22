#!/bin/bash
# Enable TCP BBR

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}>>> 正在配置 TCP BBR 网络优化...${NC}"

# 检查当前是否已开启
if lsmod | grep -q bbr; then
    echo -e "${YELLOW}BBR 已经处于开启状态，无需重复配置。${NC}"
    exit 0
fi

# 写入 sysctl 配置
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf

# 应用配置
sysctl -p > /dev/null

# 验证
if sysctl net.ipv4.tcp_congestion_control | grep -q bbr; then
    echo -e "${GREEN}>>> BBR 开启成功！网络吞吐量已优化。${NC}"
else
    echo -e "\033[0;31m开启失败，您的内核版本可能过低 (需 >= 4.9)。${NC}"
fi