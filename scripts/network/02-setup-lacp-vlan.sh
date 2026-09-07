#!/usr/bin/env bash
set -euo pipefail

echo "=========================================="
echo "   CAU HINH HA TANG MANG LACP & VLAN      "
echo "=========================================="

# 1. Cai dat goi quan ly mang khong can reboot
echo "[*] 1. Kiem tra va cai dat goi ifupdown2..."
apt-get update -y
apt-get install -y ifupdown2 ethtool

# 2. Sao luu cau hinh mang hien tai
BACKUP_DIR="/etc/network/backups"
mkdir -p "$BACKUP_DIR"
BACKUP_FILE="$BACKUP_DIR/interfaces.bak.$(date +%F_%H%M%S)"
cp /etc/network/interfaces "$BACKUP_FILE"
echo "[+] Da sao luu file interfaces tai: $BACKUP_FILE"

# 3. Tao file cau hinh mau
TEMPLATE_FILE="/etc/network/interfaces.template-lacp"
cat << 'NET_EOF' > "$TEMPLATE_FILE"
# Loopback
auto lo
iface lo inet loopback

# 2 Card mang vat ly cam switch trunking (thay the eno1, eno2 theo card thuc te)
iface eno1 inet manual
iface eno2 inet manual

# Bond0: Gop 2 card vat ly thanh trunk LACP 802.3ad
auto bond0
iface bond0 inet manual
	bond-slaves eno1 eno2
	bond-miimon 100
	bond-mode 802.3ad
	bond-xmit-hash-policy layer2+3

# Linux Bridge vlan-aware lam switch ao chinh
auto vmbr0
iface vmbr0 inet manual
	bridge-ports bond0
	bridge-stp off
	bridge-fd 0
	bridge-vlan-aware yes
	bridge-vids 2-4094

# Interface quan tri Proxmox nam tren VLAN 10 (Management)
auto vmbr0.10
iface vmbr0.10 inet static
	address 192.168.10.20/24
	gateway 192.168.10.1
	dns-nameservers 1.1.1.1 8.8.8.8

# Interface dong bo Corosync nam tren VLAN 20 (Cluster Heartbeat)
auto vmbr0.20
iface vmbr0.20 inet static
	address 192.168.20.20/24
NET_EOF

echo "[+] Da tao xong file mau tai: $TEMPLATE_FILE"
echo "[*] Luu y: Kiem tra dung ten card mang bang lenh 'ip link' truoc khi ap dung vao /etc/network/interfaces"
echo "[*] Sau khi sua dung ten card va dai IP, chay lenh: ifreload -a"
echo "=========================================="
echo "[+] Hoan tat tao template mang LACP & VLAN!"
echo "=========================================="
