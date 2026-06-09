# Patch Notes

## ZhoudongVPN node details + 3X-ui helper build

This build includes the previous private-gateway hardening plus these user-facing panel updates:

- Renamed panel branding to `ZhoudongVPN 节点管理`.
- Updated Telegram link to `https://t.me/+7ES4cXxAwEYzNTI1`.
- Updated GitHub link to `https://github.com/c114/aimili-vpngate101`.
- Replaced VPS recommendation content with donation support only.
- Added USDT-TRC20 donation address: `TF2kHq7KfiNuifkEv1aGcuD3EC2RhFU9Sk`.
- Added `管理员 -> 3X-ui 对接` helper panel.
- Added proxy info copy helpers for HTTP and SOCKS5.
- Added Xray HTTP/SOCKS outbound JSON copy helpers.
- Added Xray routing rule example copy helper.
- Added local 3X-ui inbound port listening check.
- Added proxy password reset API and UI action.
- Added detailed node display fields: flags, country code, IP/port, protocol, API ping, detected latency, sessions, score, speed, total users, total traffic, uptime, ISP, ASN, location, IP type, quality, fetch time, probe time, and probe message.
- Added node summary cards for filtered count, available/active count, country count, average latency, total sessions, and maximum speed.
- Updated README with deployment, update, 3X-ui helper, node details, and troubleshooting instructions.
- Removed stale README items such as unused YouTube/Email placeholders and test-branch install text.
- Removed generated `__pycache__` files from the release package.

Validation run:

```bash
python3 -m py_compile vpngate_manager.py proxy_server.py vpn_utils.py
bash scripts/check.sh
```


## Final repository/update and UI stability cleanup
- Forced installer and `ml update` to use `https://github.com/c114/aimili-vpngate101.git`, preventing updates from old upstream repositories.
- Renamed remaining legacy-facing service text to ZhoudongVPN where user-facing.
- Made node table independently scrollable with sticky headers and sticky action column.
- Added frontend load-failure fallback so the dashboard keeps the last node cache instead of going blank.
- Added OpenVPN disconnected state reporting in `/api/nodes` and dashboard state.
