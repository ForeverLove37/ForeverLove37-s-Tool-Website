#!/bin/bash
# Comprehensive System Benchmark Script (Interactive & Parameterized)

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# 获取脚本运行时传入的第一参数
CHOICE=$1

echo -e "${CYAN}====================================================${NC}"
echo -e "${GREEN}      Server Benchmark Toolkit (CPU/Mem/IO/Net)     ${NC}"
echo -e "${CYAN}====================================================${NC}"

# ==========================================
# 0. 依赖检测与安装
# ==========================================
if ! command -v sysbench &> /dev/null || ! command -v fio &> /dev/null; then
    echo -e "${YELLOW}[Info] 正在安装压测依赖组件 (sysbench, fio)...${NC}"
    apt-get update -yqq >/dev/null 2>&1
    apt-get install -yqq sysbench fio >/dev/null 2>&1
fi

CORES=$(nproc)

# ==========================================
# 1. CPU 测试 (Sysbench)
# ==========================================
echo -e "\n${GREEN}>>> 1. CPU 性能压测 (Sysbench)${NC}"
echo -e "${YELLOW}测试项目: 寻找素数 (最大 20000), 线程数: $CORES${NC}"
sysbench cpu --cpu-max-prime=20000 --threads=$CORES run | grep -E "events per second|total time|total number of events" | sed 's/^/  /'

# ==========================================
# 2. 内存 测试 (Sysbench)
# ==========================================
echo -e "\n${GREEN}>>> 2. 内存 吞吐压测 (Sysbench)${NC}"
echo -e "${YELLOW}测试项目: 1K 块大小, 总计 10G 数据量读写${NC}"
sysbench memory --memory-block-size=1K --memory-total-size=10G --threads=$CORES run | grep -E "Total operations|transferred" | sed 's/^/  /'

# ==========================================
# 3. 磁盘 I/O 测试 (dd & fio)
# ==========================================
echo -e "\n${GREEN}>>> 3. 磁盘 I/O 性能测试${NC}"

# 3.1 DD 顺序写入测试
echo -e "${YELLOW} -> 顺序写入测试 (dd):${NC}"
DD_RESULT=$(dd if=/dev/zero of=test_benchmark.img bs=1M count=1024 conv=fdatasync 2>&1 | awk -F, '{print $3}' | tail -n 1)
rm -f test_benchmark.img
echo -e "    顺序写入速度: ${CYAN}${DD_RESULT}${NC}"

# 3.2 FIO 随机读写测试
echo -e "${YELLOW} -> 随机读写测试 (fio - 4K块, 队列深度 32, 测试文件 512M):${NC}"
# 运行 20 秒，防止占用过长时间
fio_output=$(fio --name=randrw --ioengine=libaio --iodepth=32 --rw=randrw --bs=4k --direct=1 --size=512M --numjobs=1 --runtime=20 --time_based --group_reporting 2>/dev/null)
IOPS_READ=$(echo "$fio_output" | grep -E "read: IOPS" | awk -F'=' '{print $2}' | awk -F',' '{print $1}')
IOPS_WRITE=$(echo "$fio_output" | grep -E "write: IOPS" | awk -F'=' '{print $2}' | awk -F',' '{print $1}')
echo -e "    随机读取 IOPS: ${CYAN}${IOPS_READ}${NC}"
echo -e "    随机写入 IOPS: ${CYAN}${IOPS_WRITE}${NC}"

# ==========================================
# 4. 网络环境检测
# ==========================================
echo -e "\n${GREEN}>>> 4. 网络连通性检测${NC}"
IPV4=$(curl -s4 -m 3 ifconfig.me || echo "获取失败")
echo -e " ${YELLOW}当前公网 IP:${NC} $IPV4"

echo -n " 海外连通性 (Google/GitHub): "
if ping -c 1 -W 2 google.com &> /dev/null || ping -c 1 -W 2 github.com &> /dev/null; then
    echo -e "${GREEN}通畅${NC}"
else
    echo -e "${RED}阻断 (建议选择国内版测速)${NC}"
fi

echo -n " 国内连通性 (Baidu/Tencent): "
if ping -c 1 -W 2 baidu.com &> /dev/null || ping -c 1 -W 2 qq.com &> /dev/null; then
    echo -e "${GREEN}通畅${NC}"
else
    echo -e "${RED}阻断 (可能处于纯海外无回国路由环境)${NC}"
fi

# ==========================================
# 5. 交互式网络测速菜单 (调用其他脚本)
# ==========================================
echo -e ""
# 如果没有传入参数，则进入交互式菜单
if [ -z "$CHOICE" ]; then
    echo -e "${CYAN}====================================================${NC}"
    echo -e " 请选择网络测速方案："
    echo -e "   ${GREEN}1)${NC} 完整测试 (可连海外选这个)  [调用 speednet + ping-cn]"
    echo -e "   ${GREEN}2)${NC} 完整测试 (国内版)          [调用 speedcn + ping-cn]"
    echo -e "   ${GREEN}3)${NC} 仅 Ping 三网路由           [调用 ping-cn]"
    echo -e "   ${GREEN}4)${NC} 退出网络测试"
    echo -e "${CYAN}====================================================${NC}"
    
    # 使用 /dev/tty 确保在 curl | bash 管道下依然能读取键盘输入
    if [ -t 0 ]; then
        read -p "请输入选项 [1-4]: " CHOICE
    else
        read -p "请输入选项 [1-4]: " CHOICE < /dev/tty
    fi
fi

echo -e ""
BASE_URL="https://tool.zengjunjie.com"

case "$CHOICE" in
    1)
        echo -e "${YELLOW}>>> 正在启动全球网速测试...${NC}"
        bash <(curl -sL $BASE_URL/speednet)
        echo -e "\n${YELLOW}>>> 正在启动国内三网 Ping 延迟测试...${NC}"
        bash <(curl -sL $BASE_URL/ping-cn)
        ;;
    2)
        echo -e "${YELLOW}>>> 正在启动中国特供版网速测试...${NC}"
        bash <(curl -sL $BASE_URL/speedcn)
        echo -e "\n${YELLOW}>>> 正在启动国内三网 Ping 延迟测试...${NC}"
        bash <(curl -sL $BASE_URL/ping-cn)
        ;;
    3)
        echo -e "${YELLOW}>>> 正在启动国内三网 Ping 延迟测试...${NC}"
        bash <(curl -sL $BASE_URL/ping-cn)
        ;;
    4)
        echo -e "${GREEN}已跳过网络测速模块，压测结束。${NC}"
        exit 0
        ;;
    *)
        echo -e "${RED}输入无效，网络测速已终止。${NC}"
        exit 1
        ;;
esac

echo -e "\n${GREEN}>>> 全套系统评测运行完毕！${NC}"