# ZhoudongVPN 🌐

**私有化 VPNGate 代理网关 / Private VPNGate Gateway**

ZhoudongVPN 是一款基于官方 VPNGate 开放协议的私有化代理网关，使用 Python 标准库编写，内置 Web 管理后台，支持节点测速、自动切换、HTTP/SOCKS5 本地代理、3X-ui 对接助手、Clash 订阅导出、实时日志和网关诊断。

本项目适合部署在个人 Linux VPS 上自用，或给小范围用户授权部署使用。

---

## 📢 项目链接

- Telegram：<https://t.me/+7ES4cXxAwEYzNTI1>
- GitHub：<https://github.com/c114/aimili-vpngate101>
- USDT-TRC20 捐赠地址：`TF2kHq7KfiNuifkEv1aGcuD3EC2RhFU9Sk`

---

## 🚀 一键部署

在 Linux VPS 上使用 `root` 执行：

```bash
bash <(curl -Ls https://raw.githubusercontent.com/c114/aimili-vpngate101/main/install.sh)
```

安装完成后，终端会输出：

```text
后台地址
登录用户名
登录密码
随机安全路径
```

然后用浏览器打开终端输出的后台地址即可登录。

---

## 🔄 已安装机器更新方式

如果 VPS 已经安装过，推荐直接使用内置命令更新：

```bash
ml update
```

也可以手动更新：

```bash
cd /opt/aimilivpn
git pull
python3 -m py_compile vpngate_manager.py proxy_server.py vpn_utils.py
systemctl restart aimilivpn
```

如果 `git pull` 不生效，可以重新执行一键安装命令。安装脚本检测到 `/opt/aimilivpn` 已存在时，会自动拉取仓库最新代码并重启服务：

```bash
bash <(curl -Ls https://raw.githubusercontent.com/c114/aimili-vpngate101/main/install.sh)
```

---

## 🧭 常用命令

安装后可在 VPS 终端使用：

```bash
ml
```

打开交互式菜单。

常用快捷命令：

```bash
ml status     # 查看服务状态
ml logs       # 查看实时日志
ml restart    # 重启服务
ml stop       # 停止服务
ml start      # 启动服务
ml update     # 从 GitHub 更新代码并重启
ml web        # 修改 Web 后台地址、端口、路径
ml port       # 修改 Web/代理端口
ml password   # 重置后台登录账号密码
ml uninstall  # 完全卸载
```

---

## ✨ 面板新增功能

### 1. 节点详细信息增强

节点列表现在会尽量展示 VPNGate API 和本地检测能获取到的信息，包括：

```text
国家国旗
国家 / 地区代码
节点 IP 和端口
协议 TCP/UDP
VPNGate API Ping
实际检测延迟
当前连接人数
节点评分
节点速度
累计用户数
累计流量
在线时间
运营商 / ISP
ASN
物理位置
IP 类型：住宅 / 机房 / 移动网
质量标记
最后拉取时间
最后检测时间
检测状态说明
```

节点列表上方也增加了汇总卡片：

```text
当前筛选节点数量
可用 / 已连接数量
国家地区数量
平均检测延迟
当前连接人数合计
最高节点速率
```

当前连接卡片也会显示国旗、在线时间、速度、评分、连接人数、运营商、IP 类型和位置等信息。

---

### 2. 3X-ui 对接助手

登录后台后进入：

```text
管理员 -> 3X-ui 对接
```

可以直接完成以下操作：

```text
查看 AimiliVPN 本地代理地址、端口、用户名、密码
一键复制 HTTP 代理链接
一键复制 SOCKS5 代理链接
一键复制 Xray HTTP 出站 JSON
一键复制 Xray SOCKS 出站 JSON
一键复制 3X-ui 路由规则示例
输入 3X-ui 入站端口并检测是否监听
一键重置 AimiliVPN 本地代理密码
复制 USDT-TRC20 捐赠地址
```

推荐 3X-ui 链路：

```text
客户端 -> 3X-ui 入站 -> aimilivpn-out -> 127.0.0.1:7928 -> ZhoudongVPN -> VPNGate 出口
```

如果 3X-ui 分享节点测速显示 `-1`，优先检查：

```text
1. 3X-ui 入站端口是否监听
2. 云服务商安全组是否放行该入站端口
3. Xray 路由是否设置为 in-端口-tcp -> aimilivpn-out
4. aimilivpn-out 的用户名密码是否和面板显示一致
```

注意：`7928` 是本机代理端口，默认只给 VPS 本机和 Xray 使用，不需要在云安全组里公网放行。需要放行的是 3X-ui 的入站端口，例如 `55996/tcp`。

---

### 3. 代理信息复制与密码重置

后台可直接复制：

```text
HTTP 代理链接
SOCKS5 代理链接
Xray HTTP 出站配置
Xray SOCKS 出站配置
```

如果代理密码泄露，可以在后台 3X-ui 对接助手里一键重置代理密码，也可以在 VPS 终端手动修改 `/etc/default/aimilivpn` 后重启服务。

---

## 🔐 安全加固说明

### Web 后台登录保护

后台保留账号密码登录，并带随机安全路径。登录接口带防爆破限制：

```bash
UI_LOGIN_MAX_ATTEMPTS=8
UI_LOGIN_WINDOW_SECONDS=900
UI_LOGIN_LOCK_SECONDS=600
```

默认含义：15 分钟内连续失败 8 次后，临时锁定 10 分钟。

### 后台密码哈希存储

首次安装时会生成随机强密码。首次成功登录后，后台密码会迁移为 PBKDF2 哈希保存。后台修改密码后也会继续使用哈希存储。

忘记后台密码时执行：

```bash
ml password
```

### 本地代理默认仅监听本机

ZhoudongVPN 内置 HTTP/SOCKS5 双协议代理，默认：

```text
127.0.0.1:7928
```

默认不对公网开放，避免被扫描和滥用。

如需本地电脑使用，推荐 SSH 隧道：

```bash
ssh -L 7928:127.0.0.1:7928 root@your_vps_ip
```

然后本地代理填写：

```text
127.0.0.1:7928
```

### OpenVPN 配置过滤

VPNGate 节点配置来自公开节点源。程序会在写入 `.ovpn` 前过滤危险 OpenVPN 指令，例如：

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

### DNS 自动修复默认关闭

默认只诊断 DNS 异常，不自动修改 `/etc/resolv.conf`。

如确实需要自动修复 DNS，可设置：

```bash
AUTO_FIX_DNS=1
```

---

## 💡 快速使用指南

### 第一步：登录后台

打开安装完成后终端输出的地址：

```text
http://your_vps_ip:8787/随机安全后缀/
```

输入终端显示的用户名和密码登录。

### 第二步：更新并连接节点

进入后台后点击：

```text
更新节点
```

程序会拉取 VPNGate 节点并进行并发测速。

支持：

```text
智能自动模式
固定国家/地区
固定 IP 节点
收藏节点优先
```

### 第三步：使用代理

VPS 本机测试 HTTP 代理：

```bash
set -a
. /etc/default/aimilivpn
set +a
LOCAL_PROXY_PORT=${LOCAL_PROXY_PORT:-7928}

curl -x "http://127.0.0.1:${LOCAL_PROXY_PORT}" \
  -U "${LOCAL_PROXY_USER}:${LOCAL_PROXY_PASS}" \
  https://api.ipify.org
```

测试 SOCKS5 代理：

```bash
set -a
. /etc/default/aimilivpn
set +a
LOCAL_PROXY_PORT=${LOCAL_PROXY_PORT:-7928}

curl --proxy "socks5h://127.0.0.1:${LOCAL_PROXY_PORT}" \
  --proxy-user "${LOCAL_PROXY_USER}:${LOCAL_PROXY_PASS}" \
  https://api.ipify.org
```

Python 使用示例：

```python
import requests

proxies = {
    "http": "http://127.0.0.1:7928",
    "https": "http://127.0.0.1:7928",
}

r = requests.get("https://api.ipify.org", proxies=proxies, timeout=15)
print(r.text)
```

---

## 🧩 3X-ui 对接示例

3X-ui / Xray 出站推荐使用后台自动生成的配置。手动配置时可参考：

```json
{
  "tag": "aimilivpn-out",
  "protocol": "http",
  "settings": {
    "servers": [
      {
        "address": "127.0.0.1",
        "port": 7928,
        "users": [
          {
            "user": "填写面板显示的代理用户名",
            "pass": "填写面板显示的代理密码"
          }
        ]
      }
    ]
  }
}
```

路由规则示例：

```json
{
  "type": "field",
  "inboundTag": [
    "in-55996-tcp"
  ],
  "outboundTag": "aimilivpn-out"
}
```

如果客户端测速 `-1`：

```bash
ss -lntp | grep 55996
ufw status
```

云服务器还需要在安全组放行 3X-ui 入站端口，例如：

```text
TCP 55996
```

不要公网放行 `7928`，除非你明确知道自己在做什么，并设置了强密码和 IP 白名单。

---

## 🛠️ 核心功能

```text
Web 管理后台
节点自动拉取
节点并发测速
节点详细信息展示
当前连接详情卡片
智能自动切换
固定国家/地区
固定 IP 节点
收藏节点优先
HTTP/SOCKS5 本地代理
3X-ui 对接助手
Xray 出站配置复制
3X-ui 入站端口检测
代理密码一键重置
Clash 订阅导出
网关状态检测
代理出口 IP 检测
实时日志查看
日志导出
后台登录防爆破
OpenVPN 配置安全过滤
```

---

## ⚠️ 常见问题 FAQ

### 1. Cannot allocate tun / Cannot open tun/tap dev

原因：VPS 未启用 TUN/TAP。

解决：在服务商控制台开启 TUN/TAP 后重启 VPS。如果控制台没有该选项，请提交工单。

### 2. Web 后台打不开

检查服务：

```bash
systemctl status aimilivpn --no-pager
```

检查端口：

```bash
ss -lntp | grep 8787
```

系统防火墙放行：

```bash
ufw allow 8787/tcp
```

云服务商安全组也需要放行：

```text
TCP 8787
```

### 3. 3X-ui 分享节点显示 -1

先确认 AimiliVPN 本地代理可用：

```bash
set -a
. /etc/default/aimilivpn
set +a
LOCAL_PROXY_PORT=${LOCAL_PROXY_PORT:-7928}

curl -x "http://127.0.0.1:${LOCAL_PROXY_PORT}" \
  -U "${LOCAL_PROXY_USER}:${LOCAL_PROXY_PASS}" \
  https://api.ipify.org
```

如果能返回 IP，再检查：

```text
3X-ui 入站端口是否监听
Xray 出站是否选择 aimilivpn-out
路由规则是否绑定正确入站 tag
云服务商安全组是否放行 3X-ui 入站端口
```

### 4. API Domain Blocked / 备用节点为 0

可能是 DNS、网络或 VPNGate API 访问异常。可在后台配置上游代理，或检查 DNS。默认不会自动修改系统 DNS。

### 5. VPN 已连接但代理无流量

可能是路由、TUN、rp_filter、iptables/nftables 或节点失效。可先查看后台网关状态和日志。

必要时执行：

```bash
sysctl -w net.ipv4.conf.all.rp_filter=2
sysctl -w net.ipv4.conf.default.rp_filter=2
```

---

## 🧱 Docker 说明

Docker Compose 默认只将代理端口绑定到宿主机本地地址：

```text
127.0.0.1:7928
```

启动：

```bash
docker compose up -d
```

OpenVPN 容器通常需要：

```yaml
cap_add:
  - NET_ADMIN
devices:
  - /dev/net/tun:/dev/net/tun
```

---

## 🔒 部署建议

```text
仓库公开后，别人可以直接使用一键命令部署到自己的 VPS
每台 VPS 会生成自己的后台密码、代理密码和订阅 token
不要上传 vpngate_data、ui_auth.json、.env、日志、/etc/default/aimilivpn 等私密文件
代理端口 7928 默认不要公网开放
3X-ui 入站端口需要在云安全组放行
后台端口 8787 建议使用强密码和随机路径
订阅链接不要公开分享
```

---

## English

ZhoudongVPN is a private VPNGate-based proxy gateway with a built-in Web dashboard, smart node testing, automatic failover, HTTP/SOCKS5 local proxy, 3X-ui helper, detailed node information, Clash subscription export, real-time logs, and gateway diagnostics.

Quick install:

```bash
bash <(curl -Ls https://raw.githubusercontent.com/c114/aimili-vpngate101/main/install.sh)
```

Update an existing VPS:

```bash
ml update
```

Or manually:

```bash
cd /opt/aimilivpn
git pull
systemctl restart aimilivpn
```

The proxy listens on `127.0.0.1:7928` by default and should not be publicly exposed. Use the dashboard's **Admin -> 3X-ui Helper** to copy Xray outbound JSON and routing examples.

---

## License

Please use this project only in compliance with local laws, network policies, and service provider terms.
