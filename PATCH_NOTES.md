# PrivateGate 安全加固补丁记录

此包基于用户上传的 `aimili-vpngate-privategate-testable(1).zip` 修改，目标是：可上传到自己的 GitHub 仓库部署，并保留 Web 后台登录管理。

## 已修复/加固

1. **修复运行时缺失导入**
   - `vpngate_manager.py` 补充 `import secrets`，避免订阅 token / 密码比较处运行时报错。

2. **Web 后台保留登录管理并加强防护**
   - 后台仍使用随机安全路径、账号、密码登录。
   - `/api/login` 加入失败限速：默认 15 分钟内 8 次失败后锁定 10 分钟。
   - 新增环境变量：
     - `UI_LOGIN_MAX_ATTEMPTS`
     - `UI_LOGIN_WINDOW_SECONDS`
     - `UI_LOGIN_LOCK_SECONDS`
   - 用户名、密码校验使用 `secrets.compare_digest`。

3. **后台密码哈希存储**
   - 支持 PBKDF2-SHA256 哈希存储。
   - 安装脚本首次生成的明文密码仍会输出给用户；首次成功网页登录或在后台修改密码后，会迁移为哈希。
   - `ml password` 重置密码时保持兼容，可重新设置新明文，服务端会在登录后迁移。

4. **配置文件权限收紧**
   - `ui_auth.json` 写入时自动设置 `0600`。
   - 安装脚本生成 `ui_auth.json` 后也会设置 `0600`。

5. **补齐文档中提到的订阅信息接口**
   - 新增已登录后可访问的 `/api/subscription_info`。
   - Clash 订阅 `/sub/clash?token=...` 仍使用 token 保护。

6. **OpenVPN 配置安全过滤**
   - VPNGate API 返回的 `.ovpn` 配置在写入/测试/连接前会过滤高风险指令。
   - 已过滤类型包括脚本执行、插件、management、本地证书路径、本地日志/状态文件写入等。

7. **DNS 自动修改默认关闭**
   - `vpn_utils.check_and_fix_dns()` 不再默认写 `/etc/resolv.conf`。
   - 需要自动修复时显式设置 `AUTO_FIX_DNS=1`。

8. **Docker / 环境变量模板修正**
   - `.env.example` 移除弱默认密码 `change-this-password`。
   - 明确 Docker 代理发布到宿主机 `127.0.0.1` 的安全模型。
   - 默认代理白名单收窄为 loopback + Docker bridge 网段。

9. **文档安全提示更新**
   - README 增加“部署到你自己的 GitHub 仓库”命令。
   - 不再建议把代理端口长期开放到 `0.0.0.0/0`。

10. **清理打包内容**
    - 删除 `__pycache__` 和 `*.pyc`。

## 已执行检查

```bash
python3 -m py_compile vpngate_manager.py proxy_server.py vpn_utils.py
bash -n install.sh
bash scripts/check.sh
```

检查结果：`basic checks passed`。

## GitHub 部署方式

上传到你自己的仓库后执行：

```bash
bash <(curl -Ls https://raw.githubusercontent.com/你的GitHub用户名/你的仓库名/main/install.sh) 你的GitHub用户名 你的仓库名
```

部署完成后，终端会输出 Web 后台地址、账号、密码。后台仍可登录管理节点、路由、订阅和网关状态。
