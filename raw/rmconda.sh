#!/bin/bash

INSTALL_DIR="$HOME/miniconda3"
CONDA_BIN="$INSTALL_DIR/bin/conda"

if [ ! -d "$INSTALL_DIR" ]; then
    echo "未检测到 Miniconda 安装目录 ($INSTALL_DIR)。"
    exit 1
fi

echo "========================================"
echo "        Miniconda 卸载向导"
echo "========================================"

while true; do
    echo "请选择操作:"
    echo "  [c] 检查当前已存在的 Conda 环境"
    echo "  [y] 确认卸载 Miniconda 及其所有环境"
    echo "  [n] 取消卸载并退出"
    read -p "请输入您的选择 (c/y/n): " choice
    
    case "$choice" in
        c|C )
            echo "----------------------------------------"
            if [ -x "$CONDA_BIN" ]; then
                echo "系统当前存在的 Conda 环境如下："
                "$CONDA_BIN" env list
            else
                echo "无法执行 conda 命令，可能已损坏。"
            fi
            echo "----------------------------------------"
            ;;
        y|Y )
            echo "=> 开始清理 Miniconda..."
            
            # 删除主目录和缓存
            rm -rf "$INSTALL_DIR"
            rm -rf ~/.conda ~/.condarc
            
            # 清理 shell 配置文件中的初始化块
            echo "=> 正在清理终端环境变量..."
            sed -i '/>>> conda initialize >>>/,/<<< conda initialize <<</d' ~/.bashrc 2>/dev/null || true
            sed -i '/>>> conda initialize >>>/,/<<< conda initialize <<</d' ~/.zshrc 2>/dev/null || true
            
            echo "✅ Miniconda 已完全卸载！"
            echo "建议重新打开终端或执行 'source ~/.bashrc' 刷新当前环境变量。"
            break
            ;;
        n|N )
            echo "=> 卸载已取消。"
            exit 0
            ;;
        * )
            echo "无效的输入，请重新选择。"
            ;;
    esac
done