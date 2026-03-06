#!/bin/bash

# ========================================================
# ZeroTier 一键加入私有网络 & 轨道同步脚本
# 适用环境：Ubuntu/Debian/CentOS
# ========================================================

NETWORK_ID="1bce5c58ffa76149"
GZ_MOON="d4a0215fa6"
HK_MOON="388e5d6727"
TK_MOON="119a9a480b"

# 1. 检查并安装 ZeroTier
if ! command -v zerotier-cli &> /dev/null; then
    echo "[*] 正在安装 ZeroTier..."
    curl -s https://install.zerotier.com | bash
else
    echo "[+] ZeroTier 已安装，跳过安装步骤。"
fi

# 2. 启动服务并等待就绪
sudo systemctl start zerotier-one
sleep 2

# 3. 加入私有 Network
echo "[*] 正在加入网络: $NETWORK_ID ..."
sudo zerotier-cli join $NETWORK_ID

# 4. 轨道同步 (Orbiting Moons)
echo "[*] 正在同步广州 Moon: $GZ_MOON ..."
sudo zerotier-cli orbit $GZ_MOON $GZ_MOON

echo "[*] 正在同步香港 Moon: $HK_MOON ..."
sudo zerotier-cli orbit $HK_MOON $HK_MOON

echo "[*] 正在同步东京 Moon: $TK_MOON ..."
# 5. 验证状态
echo "------------------------------------------"
echo "[+] 部署完成！当前节点状态："
sudo zerotier-cli info

echo "------------------------------------------"
echo "重启服务中..."
sudo systemctl restart zerotier-one
sleep 2

echo ""
echo "[*] 正在检查 Moon 连接情况 (请查看到 $GZ_MOON 和 $HK_MOON 是否显示为 MOON):"
sleep 3
sudo zerotier-cli listpeers | grep MOON

echo ""
echo "[!] 请记得去 Santa Clara 控制器面板 (ztncui) 勾选授权此设备！"
echo "------------------------------------------"
