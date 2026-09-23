#!/bin/bash
set -e
cd /root/vless
pkill -f main.py || true
pkill -f xray || true
pkill -f cloudflared || true

rm -f frp_info.config frp_info.json

cat << 'EOF' > .env
PORT=127.0.0.1:8888
PASSWORD=123
XRAY_UUID=064cc953-9db4-463f-8e24-a915a19624b6
FAKE_SNI=172.66.1.232#Tiktok
WS_PATH=/tiktok4g
WS_HOST=trycloudflare.com
TRANSPORT=xhttp
XHTTP_MODE=packet-up
ENABLE_WARP=false
DEBUG_MODE=true
EOF

# Kill any existing screen session
screen -X -S vless quit || true

# Start main.py using the virtualenv python
screen -dmS vless /root/vless/venv/bin/python3 main.py

echo 'Đang khởi động Xray và tạo Cloudflare Tunnel mới...'
count=0
while [ ! -s frp_info.config ]; do
    sleep 2
    count=
    if [  -ge 30 ]; then
        echo 'Chờ hơi lâu, kiểm tra tiến trình...'
        break
    fi
done

echo ''
echo '=================================================='
echo 'DA KHOI TAO THANH CONG! LINK CHUAN 100% CUA BAN:'
echo '=================================================='
cat frp_info.config
echo ''
echo '=================================================='
