#!/bin/bash
echo -e "\033[0;32m>>> 仅配置 GitHub 公共加速...\033[0m"
git config --global url."https://mirror.ghproxy.com/https://github.com/".insteadOf "https://github.com/"
echo -e "\033[0;32m>>> 配置完成！\033[0m"
