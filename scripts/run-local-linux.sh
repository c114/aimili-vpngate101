#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
export VPNGATE_DATA_DIR="${VPNGATE_DATA_DIR:-$PWD/vpngate_data}"
export UI_HOST="${UI_HOST:-127.0.0.1}"
export UI_PORT="${UI_PORT:-8787}"
export LOCAL_PROXY_HOST="${LOCAL_PROXY_HOST:-127.0.0.1}"
export LOCAL_PROXY_PORT="${LOCAL_PROXY_PORT:-7928}"
export LOCAL_PROXY_ALLOWED_IPS="${LOCAL_PROXY_ALLOWED_IPS:-127.0.0.1/32,::1/128}"
export LOCAL_PROXY_USER="${LOCAL_PROXY_USER:-privategate}"
export LOCAL_PROXY_PASS="${LOCAL_PROXY_PASS:-local-test-pass}"
python3 vpngate_manager.py
