#!/usr/bin/env bash
set -euo pipefail

echo "=========================================="
echo "   CAI DAT VA CAU HINH FAIL2BAN PROXMOX   "
echo "=========================================="

# 1. Cai dat goi fail2ban
echo "[*] 1. Dang cai dat fail2ban..."
apt-get update -y
apt-get install -y fail2ban

# 2. Tao bo loc filter bat loi dang nhap pve
echo "[*] 2. Tao file filter cho Proxmox Web GUI..."
cat << 'FILTER_EOF' > /etc/fail2ban/filter.d/proxmox.conf
[Definition]
failregex = pvedaemon\[.*authentication failure; rhost=<HOST> user=.* msg=.*
ignoreregex =
FILTER_EOF

# 3. Tao jail kich hoat bao ve cong 8006 va cong 22
echo "[*] 3. Tao jail bao ve cong 8006 va SSH..."
cat << 'JAIL_EOF' > /etc/fail2ban/jail.d/proxmox.local
[DEFAULT]
bantime  = 3600
findtime = 600
maxretry = 3

[sshd]
enabled = true
port    = 22
mode    = aggressive

[proxmox]
enabled  = true
port     = 8006
filter   = proxmox
logpath  = /var/log/daemon.log
maxretry = 3
bantime  = 7200
JAIL_EOF

# 4. Khoi dong lai dich vu fail2ban
echo "[*] 4. Khoi dong lai dich vu..."
systemctl restart fail2ban
systemctl enable fail2ban

echo "[+] Kiem tra trang thai hoat dong:"
fail2ban-client status proxmox || true

echo "=========================================="
echo "[+] Hoan tat cau hinh bao mat Fail2Ban!"
echo "=========================================="
