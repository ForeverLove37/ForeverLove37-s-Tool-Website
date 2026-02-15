#!/bin/bash

# --- Color Settings ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}>>> 开始配置 Docker 国内镜像加速器...${NC}"

# 1. 检查 Docker 是否安装
if ! command -v docker &> /dev/null; then
    echo -e "${RED}错误: 未检测到 Docker，请先运行安装脚本！${NC}"
    exit 1
fi

# 2. 备份现有配置 (Safety First)
if [ -f /etc/docker/daemon.json ]; then
    echo -e "${YELLOW}发现现有配置文件，正在备份为 daemon.json.bak...${NC}"
    cp /etc/docker/daemon.json /etc/docker/daemon.json.bak
fi

# 3. 写入镜像源配置
# 这里选用了目前国内相对稳定的几个源：
# 1. 道客云 (DaoCloud) - 长期稳定
# 2. 阿里云 (Aliyun) - 公共源
# 3. 腾讯云 (Tencent) - 公共源
# 4. 百度云 (Baidu)
echo -e "${YELLOW}正在写入镜像加速配置...${NC}"

mkdir -p /etc/docker
cat > /etc/docker/daemon.json <<EOF
{
    "registry-mirrors": [
        "https://docker.m.daocloud.io",
        "https://mirror.baidubce.com",
        "https://docker.nju.edu.cn",
        "https://dockerproxy.com"
    ],
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "100m",
        "max-file": "3"
    }
}
EOF
# 注：额外添加了日志限制 (max-size)，防止 Docker 日志把服务器硬盘写满，这是生产环境的好习惯。

# 4. 重启 Docker 服务使配置生效
echo -e "${YELLOW}正在重启 Docker 服务...${NC}"
systemctl daemon-reload
systemctl restart docker

# 5. 验证配置
echo -e "${GREEN}>>> 配置完成！${NC}"
echo -e "${YELLOW}当前生效的镜像源：${NC}"
docker info | grep -A 5 "Registry Mirrors"

echo -e "${GREEN}现在你可以尝试重新拉取镜像了。${NC}"
