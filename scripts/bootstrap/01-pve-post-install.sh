#!/usr/bin/env bash
set -euo pipefail

echo "=========================================="
echo "   PROXMOX VE POST-INSTALL BOOTSTRAP      "
echo "=========================================="

# 1. Vô hiệu hóa Enterprise Repo
echo "[*] 1. Vô hiệu hóa pve-enterprise repo..."
if [ -f /etc/apt/sources.list.d/pve-enterprise.list ]; then
    sed -i -e 's/^deb/#deb/' /etc/apt/sources.list.d/pve-enterprise.list
fi

# 2. Thêm no-subscription repo
echo "[*] 2. Kích hoạt pve-no-subscription repo..."
cat << 'REPO' > /etc/apt/sources.list.d/pve-no-subscription.list
deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription
deb http://download.proxmox.com/debian/ceph-quincy bookworm no-subscription
REPO

# 3. Tắt popup "No valid subscription" trên Web GUI
echo "[*] 3. Vô hiệu hóa popup thông báo bản quyền trên giao diện Web..."
PVE_JS="/usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js"
if [ -f "$PVE_JS" ]; then
    cp "$PVE_JS" "${PVE_JS}.bak"
    sed -Ezi.bak "s/(Ext.Msg.show\(\{\s+title: gettext\('No valid sub)/void\(\{ \/\/\1/g" "$PVE_JS"
    systemctl restart pveproxy.service
    echo "[+] Đã patch pveproxy và khởi động lại dịch vụ web."
fi

# 4. Cập nhật gói hệ thống
echo "[*] 4. Cập nhật apt cache và nâng cấp gói hệ thống..."
apt-get update -y
apt-get install -y chrony curl wget vim htop net-tools ifupdown2 smartmontools lm-sensors jq

# 5. Cấu hình đồng bộ NTP
echo "[*] 5. Khởi động và kiểm tra đồng bộ thời gian (Chrony)..."
systemctl enable --now chrony
chronyc tracking

echo "=========================================="
echo "[+] Hoàn tất cấu hình nền tảng Proxmox VE!"
echo "=========================================="
