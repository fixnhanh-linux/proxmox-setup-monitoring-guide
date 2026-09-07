#!/usr/bin/env bash
set -euo pipefail

echo "=========================================="
echo "   CAI DAT PROMETHEUS NODE EXPORTER       "
echo "=========================================="

NODE_VER="1.8.2"
ARCH="linux-amd64"

# 1. Tai ban binary moi nhat
echo "[*] 1. Dang tai Node Exporter phien ban v${NODE_VER}..."
cd /tmp
wget -q "https://github.com/prometheus/node_exporter/releases/download/v${NODE_VER}/node_exporter-${NODE_VER}.${ARCH}.tar.gz"
tar -xzf "node_exporter-${NODE_VER}.${ARCH}.tar.gz"
mv "node_exporter-${NODE_VER}.${ARCH}/node_exporter" /usr/local/bin/
rm -rf "node_exporter-${NODE_VER}.${ARCH}"*

# 2. Tao user he thong chay service
echo "[*] 2. Tao user he thong node_exporter..."
id -u node_exporter &>/dev/null || useradd -rs /bin/false node_exporter

# 3. Tao file service systemd
echo "[*] 3. Tao systemd service..."
cat << 'SVC_EOF' > /etc/systemd/system/node_exporter.service
[Unit]
Description=Prometheus Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter \
  --collector.systemd \
  --collector.processes

Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
SVC_EOF

# 4. Khoi dong dich vu
echo "[*] 4. Khoi dong dich vu va bat tu chay cung he thong..."
systemctl daemon-reload
systemctl enable --now node_exporter

echo "[*] Kiem tra ket qua tren cong 9100:"
curl -s http://127.0.0.1:9100/metrics | head -n 10

echo "=========================================="
echo "[+] Cai dat Node Exporter thanh cong tren cong 9100!"
echo "=========================================="
