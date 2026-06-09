# AimiliVPN 🌐

**Private VPNGate Gateway / 私有化 VPNGate 代理网关**

Bilingual: [中文](#中文-chinese) | [English](#english)

---

<a name="中文-chinese"></a>
## 中文 (Chinese)

AimiliVPN 是一款基于官方 VPNGate 开放协议的私有化 VPN 代理网关。它使用纯 Python 标准库编写，内置响应式 Web 管理后台，支持智能并发测速、多路由模式、出站代理网关、实时日志、Clash 订阅导出和网关状态诊断。

本版本在原有功能基础上进行了私有化安全加固，适合部署在个人 Linux VPS 上自用，或在小范围授权场景中使用。

---

## 📢 官方交流与反馈

Telegram Forum | YouTube | Email

---

## 🚀 一键极速部署

在您的 Linux VPS 上以 `root` 用户执行以下命令。

### 🌟 正式稳定版本 main 分支

```bash
bash <(curl -Ls https://raw.githubusercontent.com/c114/aimili-vpngate101/main/install.sh)
```

如果安装脚本需要指定仓库用户名和仓库名，可使用：

```bash
bash <(curl -Ls https://raw.githubusercontent.com/c114/aimili-vpngate101/main/install.sh) 你的GitHub用户名 你的仓库名
```

### 🧪 测试开发版本 bate 分支

```bash
bash <(curl -Ls https://raw.githubusercontent.com/c114/aimili-vpngate101/bate/install.sh)
```

💡 小贴士：部署完成后，终端会输出管理网页的专属链接，包含随机安全后缀，例如：

```text
http://your_vps_ip:8787/u71e9IXp4TPx/
```

同时会输出后台登录账号和随机密码。后续可在终端输入：

```bash
ml
```

调出交互式命令行管理菜单。

---

## 🔐 本版本安全加固说明

本版本保留 Web 后台登录管理，同时对默认部署方式进行了安全加固。

### 1. Web 后台仍可登录管理

部署完成后，终端会输出：

- 后台访问地址
- 登录用户名
- 随机强密码
- 随机安全路径

用户可以正常登录后台进行节点管理、节点更新、路由切换、日志查看、网关检测和 Clash 订阅管理。

---

### 2. Web 登录防爆破

后台登录接口已加入失败次数限制和临时锁定机制，降低公网后台被爆破的风险。

默认策略：

```bash
UI_LOGIN_MAX_ATTEMPTS=8
UI_LOGIN_WINDOW_SECONDS=900
UI_LOGIN_LOCK_SECONDS=600
```

含义为：15 分钟内连续失败 8 次后，临时锁定 10 分钟。

---

### 3. 后台密码哈希存储

首次安装时，系统会生成随机强密码，方便首次登录。

首次成功登录后，程序会自动将明文密码迁移为 PBKDF2 哈希格式保存。之后在后台修改密码，也会以哈希形式保存，减少长期明文密码落盘风险。

如果忘记后台密码，可以在 VPS 终端执行：

```bash
ml password
```

重新生成后台登录密码。

---

### 4. 本地代理默认仅监听本机

AimiliVPN 内置双协议代理服务，默认端口为：

```text
7928
```

该端口自适应支持：

- HTTP Proxy
- SOCKS5 Proxy

为了防止代理端口暴露到公网后被恶意扫描和滥用，本版本默认仅监听：

```text
127.0.0.1
```

也就是只允许 VPS 本机访问代理服务。

推荐在本地电脑通过 SSH 隧道安全使用代理：

```bash
ssh -L 7928:127.0.0.1:7928 root@your_vps_ip
```

然后在本地浏览器、代理工具、爬虫程序或 Clash 中配置：

```text
127.0.0.1:7928
```

---

### 5. 代理账号密码与 IP 白名单

代理服务支持用户名密码认证和 IP 白名单限制。

推荐配置示例：

```bash
LOCAL_PROXY_HOST=127.0.0.1
LOCAL_PROXY_ALLOWED_IPS=127.0.0.1/32,::1/128
LOCAL_PROXY_USER=privategate
LOCAL_PROXY_PASS=请设置高强度随机密码
LOCAL_PROXY_MAX_CONNECTIONS=64
```

如果确实需要向公网其他设备开放代理端口，请务必同时配置：

- 强密码
- 防火墙白名单
- 云服务商安全组白名单
- 仅允许可信 IP 访问

不建议直接把代理端口无保护地暴露到公网。

---

### 6. OpenVPN 配置安全过滤

VPNGate 节点配置来自公开节点源。为降低风险，AimiliVPN 会在写入和启动 OpenVPN 配置前过滤危险指令。

系统会拒绝或移除以下高风险 OpenVPN 指令：

```text
script-security
up
down
route-up
iproute
plugin
management
learn-address
client-connect
client-disconnect
```

这样可以降低外部 `.ovpn` 配置在高权限环境下执行危险脚本或加载异常插件的风险。

---

### 7. DNS 自动修复默认关闭

本版本默认只诊断 DNS 异常，不会自动修改系统 `/etc/resolv.conf`，避免影响云厂商 DNS、公司内网 DNS 或 systemd-resolved 配置。

如确实需要自动修复 DNS，可手动开启：

```bash
AUTO_FIX_DNS=1
```

---

### 8. Clash 订阅接口已补齐

本版本已补齐订阅信息接口：

```text
/api/subscription_info
```

该接口需要登录后台后访问，不会对未授权用户公开返回订阅 token。

Clash 订阅链接通常类似：

```text
http://your_vps_ip:8787/随机安全后缀/sub/clash?token=你的订阅token
```

请妥善保管订阅链接。订阅链接中可能包含代理连接信息，泄露后可能导致他人使用您的代理服务。

---

## 💡 快速使用指南

部署成功后，如何使用它进行代理出站？

### 第一步：登录 Web 管理后台

打开浏览器，访问部署完成时终端提示的专属后台地址：

```text
http://your_vps_ip:8787/随机安全后缀/
```

输入终端输出的用户名和密码，即可进入 Web 管理后台。

后台支持：

- 查看节点列表
- 更新 VPNGate 节点
- 智能测速
- 切换出站节点
- 固定国家/地区
- 固定 IP 节点
- 查看实时日志
- 检测代理出口 IP
- 导出 Clash 订阅
- 查看网关运行状态

---

### 第二步：获取并连接节点

首次进入后台时，节点列表可能仍在首次自动测速和拉取中。

您可以点击：

```text
更新节点
```

系统会在后台通过多线程并发测速，自动筛选出延迟较低、可连接的 VPNGate 节点。

支持三种常用路由模式：

#### 智能自动配置，推荐

如果当前连接的节点失效，系统会自动切换至其他备用健康节点，无需手动干预。

#### 固定国家/地区

只选择指定国家或地区的最佳节点，例如：

```text
JP 日本
KR 韩国
US 美国
SG 新加坡
TW 台湾
```

#### 固定 IP 节点

始终锁定连接到某一个特定节点。

适合需要稳定出口 IP 的场景，但该节点失效后需要手动切换或重新选择。

---

### 第三步：使用本机代理

AimiliVPN 默认在 VPS 本机启动代理：

```text
127.0.0.1:7928
```

#### Python 脚本中使用代理

```python
import requests

proxies = {
    "http": "http://127.0.0.1:7928",
    "https": "http://127.0.0.1:7928",
}

response = requests.get("https://www.google.com", proxies=proxies, timeout=15)
print(response.text[:500])
```

#### Shell 终端环境中使用代理

```bash
export http_proxy="http://127.0.0.1:7928"
export https_proxy="http://127.0.0.1:7928"

curl https://ipinfo.io
```

#### SOCKS5 使用方式

```text
socks5://127.0.0.1:7928
```

如果启用了代理账号密码，则格式为：

```text
socks5://用户名:密码@127.0.0.1:7928
```

---

## 🛠️ 核心功能与操作说明

### 合并操作面板

将“更新节点”与“立即检测补齐”合并，一键触发多线程拉取与测速。

### 网关状态面板

- 检测网关心跳
- 检查 Web 服务是否正常
- 检查 VPN 连接管理线程是否正常
- 检查出站代理网关服务是否正常
- 检测真实代理出站 IP 和所在地理位置

### 日志追踪面板

- 分类过滤日志
- 实时滚动加载
- 查看 VPN 连接日志
- 查看 API 请求日志
- 查看系统异常日志
- 支持复制日志
- 支持导出 `.log` 日志文件

### 私有代理网关

- HTTP Proxy
- SOCKS5 Proxy
- 账号密码认证
- IP 白名单
- 最大连接数限制
- 默认仅本机监听
- 可配合 SSH 隧道安全使用

---

## ⚠️ 小白安装与运行常见问题 FAQ

### 1. 提示 Cannot allocate tun 或 Cannot open tun/tap dev

原因：VPS 宿主机未启用虚拟网卡 TUN/TAP 设备。这种情况常见于 LXC 或 OpenVZ 架构的轻量 VPS。

解决办法：登录 VPS 服务商控制面板，找到：

```text
Enable TUN/TAP
```

或：

```text
开启 TUN
```

启用后重启 VPS。

如果没有该选项，请提交工单联系客服开启。

---

### 2. Web 管理后台无法打开

#### 原因一：服务没有启动

请执行：

```bash
systemctl status aimilivpn
```

或输入：

```bash
ml
```

查看服务状态。

#### 原因二：VPS 防火墙未放行后台端口

默认后台端口：

```text
8787
```

Ubuntu/Debian：

```bash
ufw allow 8787/tcp
```

CentOS/RHEL：

```bash
firewall-cmd --zone=public --add-port=8787/tcp --permanent
firewall-cmd --reload
```

#### 原因三：云服务商安全组未放行

登录云服务商控制台，在安全组入站规则中放行：

```text
TCP 8787
```

如果只想自己访问后台，建议授权对象填写自己的家庭公网 IP，而不是 `0.0.0.0/0`。

---

### 3. 代理端口 7928 从外部访问不了

这是正常现象。

为了安全，本版本默认只让代理监听：

```text
127.0.0.1
```

也就是只允许 VPS 本机访问。

推荐通过 SSH 隧道使用：

```bash
ssh -L 7928:127.0.0.1:7928 root@your_vps_ip
```

如果确实需要公网设备直接访问代理，请自行修改环境变量：

```bash
LOCAL_PROXY_HOST=0.0.0.0
LOCAL_PROXY_ALLOWED_IPS=你的公网IP/32
LOCAL_PROXY_USER=你的用户名
LOCAL_PROXY_PASS=高强度随机密码
```

修改后重启服务：

```bash
systemctl restart aimilivpn
```

强烈不建议将代理端口无密码、无白名单地暴露到公网。

---

### 4. 页面提示 API Domain Blocked 且备选节点显示为 0

可能原因：

- VPS DNS 解析异常
- VPNGate 域名被网络环境干扰
- 当前服务器无法访问 VPNGate API
- 上游网络对相关域名有限制

解决办法：

- 在 Web 后台配置可用上游代理
- 手动检查 VPS DNS
- 检查服务器防火墙和云服务商网络限制

本版本默认不会自动修改 `/etc/resolv.conf`。

如确认需要自动修复 DNS，可设置：

```bash
AUTO_FIX_DNS=1
```

然后重启服务。

---

### 5. VPN 已连接，但客户端设置代理后无法上网

可能原因：

- TUN 设备异常
- 系统路由未生效
- iptables/nftables 规则冲突
- rp_filter 反向路径过滤过严格
- 当前 VPNGate 节点失效

解决办法：

先在后台点击网关状态检测，再查看日志面板中的 OpenVPN 日志。

也可以在终端执行：

```bash
ml
```

使用交互菜单进行诊断和修复。

如果是 `rp_filter` 问题，可将其调整为宽松模式：

```bash
sysctl -w net.ipv4.conf.all.rp_filter=2
sysctl -w net.ipv4.conf.default.rp_filter=2
```

---

### 6. 忘记后台登录密码

在 VPS 终端执行：

```bash
ml password
```

系统会重新生成后台密码。

---

## 🧱 Docker 使用说明

Docker Compose 默认只将代理端口绑定到宿主机本地地址：

```text
127.0.0.1:7928
```

启动：

```bash
docker compose up -d
```

如果容器需要运行 OpenVPN，通常需要：

```yaml
cap_add:
  - NET_ADMIN
devices:
  - /dev/net/tun:/dev/net/tun
```

请确保宿主机已启用 TUN/TAP。

---

## 🔒 部署建议

推荐部署方式：

- Web 后台端口 8787 可以按需公网访问，但必须使用强密码和随机路径
- 更安全的方式是后台也只通过 SSH 隧道访问
- 代理端口 7928 默认只监听 127.0.0.1
- 本地电脑通过 SSH 隧道访问代理
- 不要公开分享 Clash 订阅链接
- 不要使用弱密码
- 不要将代理端口无保护暴露给公网
- 定期更新节点
- 定期查看日志

更安全的后台访问方式：

```bash
ssh -L 8787:127.0.0.1:8787 root@your_vps_ip
```

然后在本地浏览器打开：

```text
http://127.0.0.1:8787/随机安全后缀/
```

---

<a name="english"></a>
## English

AimiliVPN is a private VPNGate-based proxy gateway written with the Python standard library. It provides a built-in responsive Web dashboard, smart node testing, automatic failover, fixed country routing, fixed IP routing, HTTP/SOCKS5 proxy gateway, real-time logs, gateway diagnostics, and Clash subscription export.

This hardened version is designed for safer private VPS deployment.

### Key Features

- Web dashboard with login authentication
- Random management path
- Brute-force protection for login API
- PBKDF2 password hashing
- Local-only proxy binding by default
- HTTP/SOCKS5 proxy authentication
- Client IP whitelist support
- Dangerous OpenVPN directive filtering
- Login-protected subscription info API
- DNS auto-modification disabled by default
- Smart VPNGate node testing and failover
- Clash subscription export

### Quick Install

```bash
bash <(curl -Ls https://raw.githubusercontent.com/your-github-user/your-repo/main/install.sh)
```

After installation, the terminal will print the dashboard URL, username, and password.

### Recommended Proxy Usage

By default, the proxy listens on:

```text
127.0.0.1:7928
```

Use SSH tunneling from your local computer:

```bash
ssh -L 7928:127.0.0.1:7928 root@your_vps_ip
```

Then configure your local applications to use:

```text
127.0.0.1:7928
```

### Security Notice

Do not expose the proxy port to the public Internet without a strong password, firewall rules, cloud security group restrictions, and trusted IP allowlisting.

---

## License

Please use this project only in compliance with local laws, network policies, and service provider terms.
