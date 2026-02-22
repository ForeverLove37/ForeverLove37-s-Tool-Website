# 服务器工具箱

这是一个专为 DevOps、VPS 维护和系统配置精选的 Shell 脚本集合。这些脚本旨在通过 `curl` 直接在命令行中执行。

---

## 1. 简介
### 快速开始（使用指南）

无需手动下载文件。只需在您的终端中执行下方提供的**短命令**即可。

#### 基本语法
使用本仓库的通用语法为：
```bash
curl -L https://tool.zengjunjie.com/<script_name> | bash
```

#### 前置条件
* **操作系统**：已针对 Debian 10+、Ubuntu 20.04+ 和 CentOS 7+ 进行优化（不保证与其他发行版的完全兼容）。
* **用户**：大多数安装脚本需要 Root 权限（或 `sudo` 权限）。
* **依赖项**：必须安装 `curl` 和 `bash`。
    * *Debian/Ubuntu:* `apt update && apt install curl -y`

---

## 2. Linux 脚本

### 2.1 系统

#### 2.1.1 系统信息
**脚本名称：** `info`
**描述：** 直接从操作系统获取基础硬件和系统信息（准确度可能因虚拟化环境而异）。
**命令：**
```bash
curl -L https://tool.zengjunjie.com/info | bash
```

#### 2.1.2 系统基准测试
**脚本名称：** `benchmark`
**描述：** 对您的设备运行全面的性能基准测试（评估 CPU、I/O 和网络速度）。
**命令：**
```bash
curl -L https://tool.zengjunjie.com/benchmark | bash
```

### 2.2 网络

#### 2.2.1 应用安装

##### i. Docker 环境
**脚本名称：** `docker`
**描述：** 自动化安装最新版的 Docker Engine 和 Docker Compose 插件。配置日志轮转（Log Rotation）以防止磁盘空间耗尽。
**命令：**
```bash
curl -L https://tool.zengjunjie.com/docker | bash
```

##### ii. Nginx 环境
**脚本名称：** `nginx`
**描述：** 自动化安装 Nginx。
**命令：**
```bash
curl -L https://tool.zengjunjie.com/nginx | bash
```

#### 2.2.2 APT/YUM 镜像源替换
**脚本名称：** `sourcereplace`
**描述：** 将默认的系统软件包仓库替换为经过优化的镜像源，以加快下载速度。
**命令：**
```bash
curl -L https://tool.zengjunjie.com/sourcereplace | bash
```

#### 2.2.3 注册表与仓库镜像（中国大陆网络优化）
**脚本名称：** `mirror`
**描述：** 为 Docker、Hugging Face 和 GitHub 配置可靠的镜像加速源，以提升在中国大陆地区的访问速度。
**命令：**
```bash
curl -L https://tool.zengjunjie.com/mirror | bash
```

*附注：上述命令将同时应用 Docker、Hugging Face 和 GitHub 的镜像。如果您仅需要特定的镜像加速，请使用以下命令：*

*仅限 Docker：*
```bash
curl -L https://tool.zengjunjie.com/dmirror | bash
```

*仅限 Hugging Face：*
```bash
curl -L https://tool.zengjunjie.com/hmirror | bash
```

*仅限 GitHub：*
```bash
curl -L https://tool.zengjunjie.com/gmirror | bash
```

#### 2.2.4 网络优化 (BBR)
**脚本名称：** `bbr`
**描述：** 启用 TCP BBR 拥塞控制，以提高网络吞吐量并降低延迟。
**命令：**
```bash
curl -L https://tool.zengjunjie.com/bbr | bash
```

### 2.3 其他工具

#### 2.3.1 Claude Code 安装与配置（交互式）
**脚本名称：** `claudecode`
**描述：** 自动安装并配置 Claude Code 及其所需依赖项。
**命令：**
```bash
bash <(curl -L tool.zengjunjie.com/claudecode)
```

---

## 3. Windows 脚本

### 3.1 系统
*持续开发中...*

### 3.2 网络
*持续开发中...*

### 3.3 其他工具

#### 3.3.1 ssh-copy-id（Windows 版安装）
**脚本名称：** `Add-SshCopyId.ps1`
**描述：** 在 PowerShell 中实现 Linux `ssh-copy-id` 的功能，支持一键将 SSH 密钥部署到远程服务器（兼容 Ubuntu/Debian/CentOS）。
**命令 (PowerShell)：**
```powershell
irm https://tool.zengjunjie.com/Add-SshCopyId.ps1 | iex
```

#### 3.3.2 Claude Code 安装与配置
*持续开发中...*

---

## 4. 外部实用工具（书签）

### 4.1 基准测试

#### 4.1.1 Spiritlhl 融合怪 (ECS)
**描述：** 业界高度认可的综合性基准测试脚本，用于测试 VPS 硬件、网络路由以及流媒体解锁能力。
*为方便起见，您可以使用本站提供的短链接，也可以使用原作者的仓库链接。*

**交互模式：**
```bash
bash <(curl -L tool.zengjunjie.com/ecs)
```
*原版备选：*
```bash
bash <(wget -qO- bash.spiritlhl.net/ecs)
```

**直连模式（带参数自动运行）：**
```bash
curl -L https://gitlab.com/spiritysdx/za/-/raw/main/ecs.sh -o ecs.sh && chmod +x ecs.sh && bash ecs.sh -m 1
```
*如需查看所有可用参数，请访问 [Spiritlhl GitHub 仓库](https://github.com/spiritLHLS/ecs)。*

### 4.2 网络

#### 4.2.1 LinuxMirrors
**描述：** 强大的 GNU/Linux 一键更换系统软件源脚本，以及 Docker 安装与注册表镜像配置工具。
**命令：**
```bash
bash <(curl -sSL https://linuxmirrors.cn/main.sh)
```

---

## 面向高级用户 (Premium Users)

如果您是本工具箱的高级会员：
* **直接访问文件：** 访问 [源码站点](http://051306.xyz) 安全地浏览和检查原始代码文件。
* **安全说明：** 本站受严格保护。通过管理域名的源码文件访问权限仅限白名单 IP。
* **私有节点：** 如果公共镜像失效或遭遇限流，请在目标脚本名称后附加 `_private`（例如：`mirror_private`），即可访问经过身份验证的私有高级节点。

---
*文档由 Zeng 编写。*