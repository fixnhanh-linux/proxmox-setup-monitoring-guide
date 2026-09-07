#!/usr/bin/env bash
set -euo pipefail

echo "=========================================="
echo "   CAI DAT ZABBIX AGENT 2 (DEBIAN 12)     "
echo "=========================================="

ZBX_SERVER="${1:-127.0.0.1}"
AGENT_HOST="${2:-$(hostname)}"

echo "[*] Zabbix Server IP: $ZBX_SERVER"
echo "[*] Hostname khai bao: $AGENT_HOST"

# 1. Cai dat repo Zabbix 7.0 LTS
echo "[*] 1. Cai dat Zabbix repo..."
cd /tmp
wget -q https://repo.zabbix.com/zabbix/7.0/debian/pool/main/z/zabbix-release/zabbix-release_latest_7.0+debian12_all.deb
dpkg -i zabbix-release_latest_7.0+debian12_all.deb
rm -f zabbix-release_latest_7.0+debian12_all.deb

# 2. Cai dat goi agent2
echo "[*] 2. Cai dat zabbix-agent2..."
apt-get update -y
apt-get install -y zabbix-agent2 zabbix-agent2-plugin-*

# 3. Cau hinh file zabbix_agent2.conf
echo "[*] 3. Cau hinh thong so IP server va hostname..."
sed -i "s/^Server=127.0.0.1/Server=${ZBX_SERVER}/" /etc/zabbix/zabbix_agent2.conf
sed -i "s/^ServerActive=127.0.0.1/ServerActive=${ZBX_SERVER}/" /etc/zabbix/zabbix_agent2.conf
sed -i "s/^Hostname=Zabbix server/Hostname=${AGENT_HOST}/" /etc/zabbix/zabbix_agent2.conf

# 4. Khoi dong dich vu
echo "[*] 4. Khoi dong lai dich vu..."
systemctl restart zabbix-agent2
systemctl enable zabbix-agent2

echo "[*] Kiem tra trang thai dich vu:"
systemctl is-active zabbix-agent2

echo "=========================================="
echo "[+] Cai dat Zabbix Agent 2 thanh cong!"
echo "=========================================="
