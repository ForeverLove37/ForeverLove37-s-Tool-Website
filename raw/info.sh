#!/bin/bash
# System Information Script

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${CYAN}=========================================${NC}"
echo -e "${GREEN}       系统基础信息探测 (System Info)    ${NC}"
echo -e "${CYAN}=========================================${NC}"

# 1. 基础系统信息
echo -e "${YELLOW}[主机名]${NC} $(hostname)"
echo -e "${YELLOW}[系统OS]${NC} $(cat /etc/os-release | grep PRETTY_NAME | cut -d '"' -f 2)"
echo -e "${YELLOW}[内核版]${NC} $(uname -r)"
echo -e "${YELLOW}[架构]${NC}   $(uname -m)"

# 2. 硬件资源
CPU_MODEL=$(lscpu | grep "Model name:" | sed -r 's/Model name:\s{1,}//g')
CPU_CORES=$(nproc)
echo -e "${YELLOW}[处理器]${NC} $CPU_MODEL ($CPU_CORES Cores)"

RAM_TOTAL=$(free -h | awk '/^Mem:/ {print $2}')
RAM_USED=$(free -h | awk '/^Mem:/ {print $3}')
echo -e "${YELLOW}[内存]${NC}   已用 $RAM_USED / 总计 $RAM_TOTAL"

DISK_TOTAL=$(df -h / | awk 'NR==2 {print $2}')
DISK_USED=$(df -h / | awk 'NR==2 {print $3}')
echo -e "${YELLOW}[系统盘]${NC} 已用 $DISK_USED / 总计 $DISK_TOTAL"

# 3. 网络信息
echo -e "${YELLOW}[IP地址]${NC} 获取中..."
IPV4=$(curl -s4 -m 3 ifconfig.me 2>/dev/null || echo "无 IPv4")
LOCATION=$(curl -s -m 3 ipinfo.io/$IPV4/country 2>/dev/null || echo "未知")
echo -e "${YELLOW}[公网IP]${NC} $IPV4 ($LOCATION)"

echo -e "${CYAN}=========================================${NC}"