#!/bin/bash
echo -e "\033[0;32m>>> 仅配置 Hugging Face 公共加速...\033[0m"
echo 'export HF_ENDPOINT="https://hf-mirror.com"' > /etc/profile.d/hf_mirror.sh
echo -e "\033[0;32m>>> 配置完成！请执行 'source /etc/profile' 生效。\033[0m"
