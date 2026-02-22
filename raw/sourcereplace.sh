#!/bin/bash
# Smart APT Source Replacer

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}>>> 启动智能软件源检测...${NC}"

# 检测网络环境
if curl -I -s --connect-timeout 3 https://www.google.com >/dev/null; then
    echo -e "${YELLOW}检测到国际网络连通正常。无需替换源，使用默认源速度最佳。${NC}"
    exit 0
fi

echo -e "${RED}检测到国际网络受阻 (国内环境)。正在自动切换至阿里云镜像源...${NC}"

OS_ID=$(. /etc/os-release; echo "$ID")
OS_CODENAME=$(lsb_release -cs)
BACKUP_FILE="/etc/apt/sources.list.bak_$(date +%s)"

cp /etc/apt/sources.list $BACKUP_FILE
echo "已备份原配置文件至 $BACKUP_FILE"

if [ "$OS_ID" == "debian" ]; then
    cat > /etc/apt/sources.list <<EOF
deb https://mirrors.aliyun.com/debian/ ${OS_CODENAME} main non-free contrib
deb-src https://mirrors.aliyun.com/debian/ ${OS_CODENAME} main non-free contrib
deb https://mirrors.aliyun.com/debian-security/ ${OS_CODENAME}-security main
deb-src https://mirrors.aliyun.com/debian-security/ ${OS_CODENAME}-security main
deb https://mirrors.aliyun.com/debian/ ${OS_CODENAME}-updates main non-free contrib
deb-src https://mirrors.aliyun.com/debian/ ${OS_CODENAME}-updates main non-free contrib
deb https://mirrors.aliyun.com/debian/ ${OS_CODENAME}-backports main non-free contrib
deb-src https://mirrors.aliyun.com/debian/ ${OS_CODENAME}-backports main non-free contrib
EOF

elif [ "$OS_ID" == "ubuntu" ]; then
    sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list
    sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list
else
    echo -e "${RED}抱歉，本脚本暂不支持当前系统自动换源。${NC}"
    exit 1
fi

apt-get update
echo -e "${GREEN}>>> 软件源替换成功并已刷新！${NC}"