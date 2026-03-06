#!/bin/bash
# Install Latest Certbot via Python pip (No Snap)

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}====================================================${NC}"
echo -e "${GREEN}      Certbot 官方纯净安装脚本 (脱离 Snap)          ${NC}"
echo -e "${CYAN}====================================================${NC}"

# 1. 卸载系统自带的老旧 Certbot (如果有)
echo -e "${YELLOW}>>> 1. 清理可能存在的老旧版本...${NC}"
apt-get remove -y certbot certbot-nginx certbot-apache >/dev/null 2>&1 || true

# 2. 安装系统底层依赖 (关键修复：增加了 python3-dev 和 libaugeas-dev 等编译环境)
echo -e "${YELLOW}>>> 2. 安装系统底层依赖 (含编译环境)...${NC}"
apt-get update
apt-get install -y python3 python3-venv libaugeas0 python3-dev libaugeas-dev gcc pkg-config

# 3. 创建专属虚拟环境
echo -e "${YELLOW}>>> 3. 构建 Certbot 专属 Python 虚拟环境 (/opt/certbot)...${NC}"
# 如果之前有失败的残留，先抹除
rm -rf /opt/certbot
python3 -m venv /opt/certbot
/opt/certbot/bin/pip install --upgrade pip

# 4. 安装最新版 Certbot 及常用插件 (增加错误捕获)
echo -e "${YELLOW}>>> 4. 正在通过 pip 拉取最新版 Certbot...${NC}"
if ! /opt/certbot/bin/pip install certbot certbot-nginx certbot-apache; then
    echo -e "${RED}>>> PIP 编译或安装失败！请检查上方报错。${NC}"
    exit 1
fi

# 5. 创建系统软链接
echo -e "${YELLOW}>>> 5. 注入系统环境变量...${NC}"
ln -sf /opt/certbot/bin/certbot /usr/bin/certbot

# 6. 配置自动续签定时任务 (Cron)
echo -e "${YELLOW}>>> 6. 配置证书自动续签任务...${NC}"
echo "0 0,12 * * * root /opt/certbot/bin/python -c 'import random; import time; time.sleep(random.random() * 3600)' && /usr/bin/certbot renew -q" | tee /etc/cron.d/certbot > /dev/null

echo -e "\n${GREEN}>>> Certbot 安装成功！${NC}"
echo -e "当前版本: ${CYAN}$(certbot --version)${NC}"
echo -e "你可以直接使用 'certbot --nginx' 或 'certbot certonly' 命令了。"
