FROM python:3.11-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends openvpn curl iptables iproute2 psmisc ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . /app
RUN mkdir -p /data/configs
ENV VPNGATE_DATA_DIR=/data \
    LOCAL_PROXY_HOST=127.0.0.1 \
    LOCAL_PROXY_PORT=7928 \
    UI_HOST=0.0.0.0 \
    UI_PORT=8787 \
    LOCAL_PROXY_ALLOWED_IPS=127.0.0.1/32,172.16.0.0/12,10.0.0.0/8,192.168.0.0/16 \
    LOCAL_PROXY_MAX_CONNECTIONS=64

EXPOSE 8787 7928
CMD ["python3", "vpngate_manager.py"]
