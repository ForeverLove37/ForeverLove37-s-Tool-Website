#!/bin/bash
set -e

echo "=> 开始检测系统架构..."
ARCH=$(uname -m)
case "$ARCH" in
    x86_64)
        CONDA_ARCH="x86_64"
        ;;
    aarch64)
        CONDA_ARCH="aarch64"
        ;;
    armv7l)
        CONDA_ARCH="armv7l"
        ;;
    s390x)
        CONDA_ARCH="s390x"
        ;;
    *)
        echo "错误: 不支持的架构 $ARCH"
        exit 1
        ;;
esac
echo "检测到架构: $CONDA_ARCH"

echo "=> 测试网络连通性以配置最佳源..."
USE_MIRROR=false
# 设置3秒超时测试国际网络
if curl -I -s -m 3 https://www.google.com > /dev/null; then
    echo "检测到国际网络，将使用官方默认源。"
    DOWNLOAD_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-${CONDA_ARCH}.sh"
else
    echo "检测到中国大陆网络环境，将使用清华大学(TUNA)镜像源加速。"
    DOWNLOAD_URL="https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-${CONDA_ARCH}.sh"
    USE_MIRROR=true
fi

INSTALL_DIR="$HOME/miniconda3"
if [ -d "$INSTALL_DIR" ]; then
    echo "提示: 发现已存在的 $INSTALL_DIR 目录，如需重装请先运行卸载脚本。"
    exit 0
fi

echo "=> 正在下载 Miniconda 安装包..."
curl -L -o /tmp/miniconda_installer.sh "$DOWNLOAD_URL"

echo "=> 正在执行静默安装..."
bash /tmp/miniconda_installer.sh -b -u -p "$INSTALL_DIR"
rm -f /tmp/miniconda_installer.sh

echo "=> 正在初始化终端环境..."
"$INSTALL_DIR/bin/conda" init bash > /dev/null
if command -v zsh > /dev/null; then
    "$INSTALL_DIR/bin/conda" init zsh > /dev/null
fi

if [ "$USE_MIRROR" = true ]; then
    echo "=> 正在配置清华大学 Conda 镜像源..."
    cat <<EOF > ~/.condarc
channels:
  - defaults
show_channel_urls: true
default_channels:
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2
custom_channels:
  conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
EOF
fi

echo -e "\n✅ Miniconda 安装完成！"
echo "请执行 'source ~/.bashrc' 或重新打开终端以使配置生效。"