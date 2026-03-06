#!/bin/bash
# Completely Remove Snapd from Ubuntu (Interactive & Fail-safe)

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${RED}====================================================${NC}"
echo -e "${RED}      警告：即将彻底从系统中根除 Snapd 引擎         ${NC}"
echo -e "${RED}====================================================${NC}"
echo "此操作将删除所有通过 Snap 安装的软件，并阻断其未来自动安装。"
echo ""

# 交互式菜单循环
while true; do
    # 兼容 curl | bash 管道模式和普通执行模式
    if [ -t 0 ]; then
        read -p "请选择操作 [c:查看将要删除的包 | y:确认卸载 | n:取消退出]: " -n 1 -r choice < /dev/tty
    else
        read -p "请选择操作 [c:查看将要删除的包 | y:确认卸载 | n:取消退出]: " -n 1 -r choice
    fi
    
    echo "" # 换行
    
    case "$choice" in
        [Cc]* )
            echo -e "\n${CYAN}--- 当前系统已安装的 Snap 软件包 ---${NC}"
            if command -v snap &> /dev/null; then
                snap list
                echo -e "${YELLOW}注意: 以上列表中的非系统核心包（如 lxd, certbot 等）将会被永久删除！${NC}"
            else
                echo "未检测到 snap 命令，引擎可能已损坏或被卸载。"
            fi
            echo -e "${CYAN}------------------------------------${NC}\n"
            ;;
        [Yy]* )
            echo -e "${GREEN}>>> 确认执行！开始清理流程...${NC}"
            break # 跳出循环，继续往下执行卸载逻辑
            ;;
        * )
            echo -e "${GREEN}>>> 操作已安全取消，系统未做任何修改。${NC}"
            exit 0
            ;;
    esac
done

# ==========================================
# 核心清理逻辑开始
# ==========================================

echo -e "\n${YELLOW}>>> 1. 正在优雅地卸载所有已安装的 Snap 软件包...${NC}"
# 必须先卸载外层应用包，才能卸载底层的 core 依赖
if command -v snap &> /dev/null; then
    for p in $(snap list 2>/dev/null | awk 'NR>1 {print $1}' | grep -vE 'core|snapd|bare'); do
        snap remove "$p"
    done
    # 卸载底层依赖
    for p in $(snap list 2>/dev/null | awk 'NR>1 {print $1}'); do
        snap remove "$p"
    done
fi

echo -e "${YELLOW}>>> 2. 停止并禁用 Snapd 系统服务...${NC}"
systemctl stop snapd.service snapd.socket snapd.seeded.service 2>/dev/null || true
systemctl disable snapd.service snapd.socket snapd.seeded.service 2>/dev/null || true

echo -e "${YELLOW}>>> 3. 从 APT 包管理器彻底清除 Snapd...${NC}"
apt-get purge -y snapd
apt-get autoremove -y

echo -e "${YELLOW}>>> 4. 清理残留垃圾目录与缓存...${NC}"
rm -rf ~/snap
rm -rf /snap
rm -rf /var/snap
rm -rf /var/lib/snapd
rm -rf /var/cache/snapd

echo -e "${YELLOW}>>> 5. 植入 APT 阻断规则 (防止 Ubuntu 自动复活 Snap)...${NC}"
cat > /etc/apt/preferences.d/nosnap.pref <<EOF
Package: snapd
Pin: release a=*
Pin-Priority: -10
EOF

echo -e "\n${GREEN}>>> 净化完成！你的 Ubuntu 系统已经彻底摆脱了 Snap！${NC}"
