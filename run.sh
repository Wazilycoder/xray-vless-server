#!/bin/bash
set -e
apt update && apt install -y git python3 python3-pip python3-venv screen curl
rm -rf /root/vless
git clone https://github.com/vincentng295/xray_vless_ws_server.git /root/vless
cd /root/vless
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python3 download-xray.py
python3 download-cloudflared.py

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
EOF

screen -dmS vless python3 main.py
sleep 10
echo ''
echo '=================================================='
echo 'DA CAI DAT XONG! DAY LA LINK VLESS CUA BAN:'
echo '=================================================='
cat frp_info.config
echo '=================================================='
