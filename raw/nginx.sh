#!/bin/bash
# Install Latest Mainline Nginx

set -e
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}>>> 开始安装 Nginx (官方主线最新版)...${NC}"

# 1. 安装基础依赖
apt-get update
apt-get install -y curl gnupg2 ca-certificates lsb-release debian-archive-keyring

# 2. 导入 Nginx 官方 GPG 密钥
echo -e "${YELLOW}导入官方密钥...${NC}"
curl -fsSL https://nginx.org/keys/nginx_signing.key | gpg --dearmor -o /usr/share/keyrings/nginx-archive-keyring.gpg

# 3. 写入 Mainline 源
echo -e "${YELLOW}配置 APT 源...${NC}"
OS_NAME=$(. /etc/os-release; echo "$ID")
OS_CODENAME=$(lsb_release -cs)
echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/mainline/${OS_NAME} ${OS_CODENAME} nginx" > /etc/apt/sources.list.d/nginx.list

# 4. 优先级配置 (优先使用官方源而不是系统默认源)
echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" > /etc/apt/preferences.d/99nginx

# 5. 安装并启动
apt-get update
apt-get install -y nginx
systemctl enable nginx --now

# 6. 配置日志轮转 (保留7天，每天轮转，压缩历史日志)
cat > /etc/logrotate.d/nginx <<EOF
/var/log/nginx/*.log {
    daily
    missingok
    rotate 7
    compress
    delaycompress
    notifempty
    create 0640 www-data adm
    sharedscripts
    postrotate
        if [ -f /var/run/nginx.pid ]; then
            kill -USR1 \$(cat /var/run/nginx.pid)
        fi
    endscript
}
EOF

echo -e "${GREEN}>>> Nginx 安装成功！当前版本：${NC}"
nginx -v