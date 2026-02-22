# Welcome to My Server Toolkit

This is a curated collection of shell scripts for DevOps, VPS maintenance, and system configuration. These scripts are designed for direct command-line execution via `curl`.

---

## 1. Introduction
### Quick Start (Usage Guide)

There is no need to download files manually. Simply execute the **Short Commands** provided below in your terminal.

#### Basic Syntax
The generic syntax for utilizing this repository is:
```bash
curl -L https://tool.zengjunjie.com/<script_name> | bash
```

#### Prerequisites
* **OS**: Optimized for Debian 10+, Ubuntu 20.04+, and CentOS 7+ (Compatibility with other distributions is not guaranteed).
* **User**: Root access (or `sudo` privileges) is required for most installation scripts.
* **Dependencies**: `curl` and `bash` must be installed.
    * *Debian/Ubuntu:* `apt update && apt install curl -y`

---

## 2. Linux Scripts

### 2.1 System

#### 2.1.1 System Information
**Script Name:** `info`
**Description:** Retrieves basic hardware and system information directly from the OS (accuracy may vary depending on the virtualization environment).
**Command:**
```bash
curl -L https://tool.zengjunjie.com/info | bash
```

#### 2.1.2 System Benchmarking
**Script Name:** `benchmark`
**Description:** Runs a comprehensive performance benchmark on your device (evaluates CPU, I/O, and network speeds).
**Command:**
```bash
curl -L https://tool.zengjunjie.com/benchmark | bash
```

### 2.2 Networks

#### 2.2.1 Application Installations

##### i. Docker Environment
**Script Name:** `docker`
**Description:** Automates the installation of the latest Docker Engine and Docker Compose plugin. Configures log rotation to prevent disk space exhaustion.
**Command:**
```bash
curl -L https://tool.zengjunjie.com/docker | bash
```

##### ii. Nginx Environment
**Script Name:** `nginx`
**Description:** Automates the installation of Nginx.
**Command:**
```bash
curl -L https://tool.zengjunjie.com/nginx | bash
```

#### 2.2.2 APT/YUM Mirror Replacement
**Script Name:** `sourcereplace`
**Description:** Replaces default system package repositories with optimized mirrors for faster downloads.
**Command:**
```bash
curl -L https://tool.zengjunjie.com/sourcereplace | bash
```

#### 2.2.3 Registry & Repository Mirrors (China Optimization)
**Script Name:** `mirror`
**Description:** Configures reliable mirrors for Docker, Hugging Face, and GitHub to accelerate access within mainland China.
**Command:**
```bash
curl -L https://tool.zengjunjie.com/mirror | bash
```

*PS: The command above applies mirrors for Docker, Hugging Face, and GitHub simultaneously. If you only need a specific mirror, use the commands below:*

*For Docker only:*
```bash
curl -L https://tool.zengjunjie.com/dmirror | bash
```

*For Hugging Face only:*
```bash
curl -L https://tool.zengjunjie.com/hmirror | bash
```

*For GitHub only:*
```bash
curl -L https://tool.zengjunjie.com/gmirror | bash
```

#### 2.2.4 Network Optimization (BBR)
**Script Name:** `bbr`
**Description:** Enables TCP BBR congestion control to improve network throughput and reduce latency.
**Command:**
```bash
curl -L https://tool.zengjunjie.com/bbr | bash
```

### 2.3 Other Tools

#### 2.3.1 Claude Code Installation and Config (Interactive)
**Script Name:** `claudecode`
**Description:** Installs and configures Claude Code along with its required dependencies automatically.
**Command:**
```bash
bash <(curl -L tool.zengjunjie.com/claudecode)
```

---

## 3. Windows Scripts

### 3.1 System
*Work in progress...*

### 3.2 Networks
*Work in progress...*

### 3.3 Other Tools

#### 3.3.1 ssh-copy-id (Windows Version Installation)
**Script Name:** `Add-SshCopyId.ps1`
**Description:** Implements the Linux `ssh-copy-id` functionality in PowerShell, enabling one-click SSH key deployment to remote servers (compatible with Ubuntu/Debian/CentOS).
**Command (PowerShell):**
```powershell
irm https://tool.zengjunjie.com/Add-SshCopyId.ps1 | iex
```

#### 3.3.2 Claude Code Installation and Config
*Work in progress...*

---

## 4. External Utilities (Bookmarks)

### 4.1 Benchmarking

#### 4.1.1 Spiritlhl (ECS)
**Description:** A highly recognized and comprehensive benchmarking script for VPS hardware, network routing, and media unlocking capabilities.
*You can use our site's short link for convenience, or the original author's repository link.*

**Interactive Mode:**
```bash
bash <(curl -L tool.zengjunjie.com/ecs)
```
*Original alternative:*
```bash
bash <(wget -qO- bash.spiritlhl.net/ecs)
```

**Direct Mode (Auto-run with args):**
```bash
curl -L https://gitlab.com/spiritysdx/za/-/raw/main/ecs.sh -o ecs.sh && chmod +x ecs.sh && bash ecs.sh -m 1
```
*To explore all available arguments, please visit the [Spiritlhl GitHub Repository](https://github.com/spiritLHLS/ecs).*

### 4.2 Networks

#### 4.2.1 LinuxMirrors
**Description:** The ultimate GNU/Linux mirror switching script & Docker installation and registry mirror configuration tool.
**Command:**
```bash
bash <(curl -sSL https://linuxmirrors.cn/main.sh)
```

---

## For Premium Users

If you are a Premium Member of this toolkit:
* **Direct File Access:** Visit [Raw File Site](http://051306.xyz) to browse and inspect raw files securely.
* **Security:** This site is heavily protected. Raw file access via the admin domain is strictly limited to whitelisted IPs.
* **Private Nodes:** If the public mirrors become invalid or rate-limited, append `_private` to the target script name (e.g., `mirror_private`) to access our authenticated private Premium Nodes.

---
*Documentation crafted by Zeng.*