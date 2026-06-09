# 私有化安全说明

本版本按“自用/团队授权网关”思路加固，默认不建议公开售卖或公开开放代理端口。

## 默认安全策略

- Web 管理后台仍使用随机路径 + 管理账号密码。
- 本地 HTTP/SOCKS5 代理默认只监听 `127.0.0.1`。
- 代理服务新增客户端 IP/CIDR 白名单：`LOCAL_PROXY_ALLOWED_IPS`。
- 安装脚本会生成 `/etc/default/aimilivpn`，包含随机代理账号密码。
- 代理最大并发默认限制为 `64`，可通过 `LOCAL_PROXY_MAX_CONNECTIONS` 调整。

## 推荐使用方式：SSH 隧道

在本地电脑运行：

```bash
ssh -L 7928:127.0.0.1:7928 root@你的VPS_IP
```

然后本地代理填写：

```text
HTTP/SOCKS5: 127.0.0.1:7928
用户名/密码: 查看 VPS 上的 /etc/default/aimilivpn
```

## 如需允许固定公网 IP 访问

编辑 VPS 文件：

```bash
nano /etc/default/aimilivpn
```

示例：

```bash
LOCAL_PROXY_HOST=0.0.0.0
LOCAL_PROXY_ALLOWED_IPS=你的本地公网IP/32,你的办公室公网IP/32
LOCAL_PROXY_USER=自定义用户名
LOCAL_PROXY_PASS=高强度密码
LOCAL_PROXY_MAX_CONNECTIONS=64
```

保存后重启：

```bash
systemctl restart aimilivpn
```

不要把 `LOCAL_PROXY_ALLOWED_IPS` 设置为 `0.0.0.0/0`，除非你完全理解风险。

## 合规提醒

VPNGate 节点来自公共志愿者网络，建议仅用于个人学习、测试和合规授权场景。不要用于垃圾邮件、撞库、攻击、绕过平台风控或未经授权的商业转售。

## 本补丁新增的安全行为

- Web 登录接口默认 15 分钟内 8 次失败后锁定来源 IP 10 分钟，可通过 `UI_LOGIN_MAX_ATTEMPTS`、`UI_LOGIN_WINDOW_SECONDS`、`UI_LOGIN_LOCK_SECONDS` 调整。
- 后台密码支持 PBKDF2 哈希；旧版明文密码会在首次成功登录或修改密码后迁移。
- `ui_auth.json` 会以 `0600` 权限写入，降低本机其他用户读取后台凭据的风险。
- VPNGate 返回的 OpenVPN 配置会过滤 `script-security`、`up`、`down`、`plugin`、`iproute`、`management`、本地证书文件路径等高风险指令。
- DNS 自动写入 `/etc/resolv.conf` 已改为默认关闭，只有设置 `AUTO_FIX_DNS=1` 才会自动追加公共 DNS。

Web 后台可公网登录，但生产环境建议仅向可信 IP 放行后台端口，或使用 HTTPS 反向代理。
