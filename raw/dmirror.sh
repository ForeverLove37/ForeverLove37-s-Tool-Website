#!/bin/bash
echo -e "\033[0;32m>>> 仅配置 Docker 公共加速...\033[0m"
mkdir -p /etc/docker
cat > /etc/docker/daemon.json <<INNER_EOF
{"registry-mirrors": ["https://docker.m.daocloud.io", "https://mirror.baidubce.com"], "log-driver": "json-file", "log-opts": {"max-size": "100m", "max-file": "3"}}
INNER_EOF
systemctl daemon-reload && systemctl restart docker
echo -e "\033[0;32m>>> 配置完成！\033[0m"
