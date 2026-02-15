# 这是一个安装脚本，运行后会将 ssh-copy-id 函数写入用户的 PowerShell 配置文件
$ErrorActionPreference = 'Stop'

Write-Host ">>> 正在为当前用户安装 ssh-copy-id 工具..." -ForegroundColor Cyan

# 1. 确保配置文件存在
if (!(Test-Path -Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force | Out-Null
    Write-Host " -> 已创建 PowerShell 配置文件: $PROFILE" -ForegroundColor Gray
}

# 2. 定义核心函数代码 (合并了兼容性逻辑)
$FunctionCode = @'

function ssh-copy-id {
    <#
    .SYNOPSIS
        Windows 下的 ssh-copy-id 实现，支持 Debian/Ubuntu/CentOS
    .EXAMPLE
        ssh-copy-id root@192.168.1.1
    #>
    param (
        [Parameter(Mandatory=$true)]
        [string]$Target
    )
    
    # 优先查找 Ed25519，其次 RSA
    $pubKeyPath = "$env:USERPROFILE\.ssh\id_ed25519.pub"
    if (!(Test-Path $pubKeyPath)) { $pubKeyPath = "$env:USERPROFILE\.ssh\id_rsa.pub" }
    
    if (!(Test-Path $pubKeyPath)) {
        Write-Error "错误: 未找到公钥文件 (id_ed25519.pub 或 id_rsa.pub)。请先运行 ssh-keygen。"
        return
    }
    
    $pubKey = Get-Content $pubKeyPath -Raw
    # 去除可能存在的换行符
    $pubKey = $pubKey.Trim()

    Write-Host "正在将公钥部署到 $Target ..." -ForegroundColor Cyan

    # 远程执行脚本 (Here-String)
    $remoteCmd = @"
        # 1. 创建目录并设置权限
        mkdir -p ~/.ssh && chmod 700 ~/.ssh
        
        # 2. 写入公钥 (追加模式，自动去重)
        echo '$pubKey' >> ~/.ssh/authorized_keys
        chmod 600 ~/.ssh/authorized_keys
        sort -u ~/.ssh/authorized_keys -o ~/.ssh/authorized_keys

        # 3. 开启公钥登录
        sudo sed -i 's/^#\?PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config

        # 4. 修复 SELinux (CentOS/RHEL 特有)
        if command -v restorecon > /dev/null 2>&1; then
            sudo restorecon -Rv ~/.ssh
        fi

        # 5. 重启 SSH 服务 (兼容不同发行版服务名)
        if sudo systemctl is-active --quiet sshd; then
            sudo systemctl restart sshd
        elif sudo systemctl is-active --quiet ssh; then
            sudo systemctl restart ssh
        else
            sudo service sshd restart || sudo service ssh restart
        fi
"@
    
    # 执行 SSH 命令
    ssh -t $Target $remoteCmd
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "`n[成功] 公钥已添加，SSH 服务已重启！" -ForegroundColor Green
        Write-Host "请尝试: ssh $Target" -ForegroundColor Yellow
    }
}
'@

# 3. 将代码写入 Profile (先检查是否已存在，避免重复写入)
$CurrentProfileContent = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue
if ($CurrentProfileContent -match "function ssh-copy-id") {
    Write-Warning "检测到 ssh-copy-id 似乎已经安装过。正在覆盖更新..."
}

# 追加或覆盖逻辑 (这里简单起见，我们追加到文件末尾)
Add-Content -Path $PROFILE -Value "`n$FunctionCode" -Encoding utf8

# 4. 立即生效当前会话
Invoke-Expression $FunctionCode

Write-Host ">>> 安装完成！你现在可以直接使用 'ssh-copy-id user@host' 了。" -ForegroundColor Green