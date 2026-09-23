#!/bin/bash
set -e
cd /root/vless
pkill -9 -f main.py || true
pkill -9 -f xray || true
pkill -9 -f cloudflared || true

rm -f frp_info.config frp_info.json

cat << 'EOF' > .env
PORT=127.0.0.1:8888
PASSWORD=123
XRAY_UUID=064cc953-9db4-463f-8e24-a915a19624b6
FAKE_SNI=172.66.1.232#Tiktok
WS_PATH=/tiktok4g
WS_HOST=trycloudflare.com
TRANSPORT=websocket,xhttp
XHTTP_MODE=packet-up
ENABLE_WARP=false
DEBUG_MODE=true
EOF

# Kill any existing screen session
screen -wipe || true

# Start main.py using virtualenv python
screen -dmS vless /root/vless/venv/bin/python3 /root/vless/main.py

echo "Đang đợi Cloudflare cấp tên miền Tunnel mới (khoảng 15s)..."
for i in {1..20}; do
    if [ -s frp_info.config ]; then
        break
    fi
    sleep 2
done

echo ""
echo "=================================================="
echo "DA KHOI TAO THANH CONG! LINK CHUAN 100% CUA BAN:"
echo "=================================================="
cat frp_info.config
echo ""
echo "=================================================="
