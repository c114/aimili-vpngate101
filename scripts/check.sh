#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
python3 -m py_compile vpngate_manager.py proxy_server.py vpn_utils.py
bash -n install.sh
[ -f docker-compose.yml ] && python3 - <<'PY'
from pathlib import Path
for p in [Path('Dockerfile'), Path('docker-compose.yml'), Path('.env.example')]:
    assert p.exists(), f"missing {p}"
print('basic checks passed')
PY
