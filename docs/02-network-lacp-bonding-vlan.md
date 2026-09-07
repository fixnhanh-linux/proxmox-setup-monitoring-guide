# Huong Dan Cau Hinh Mang: LACP Bonding (802.3ad) & Linux Bridge VLAN

## 1. Yeu Cau Switch Vat Ly
- Switch can ho tro giao thuc LACP (chuan IEEE 802.3ad) tren port-channel.
- Cau hinh Port-Channel o che do Trunk cho phep cac VLAN di qua.
- Thiet lap Hash Policy: layer2+3 (can bang tai dua tren dia chi MAC va IP).

## 2. Bang Phan Chia VLAN Chuan Hoa
- **VLAN 10:** Management (IP quan tri Proxmox, SSH, Web UI 8006).
- **VLAN 20:** Cluster Corosync (Nhip tim va dong bo giua cac node PVE).
- **VLAN 30:** Storage / Ceph (Luu luong truy van va dong bo o dia).
- **VLAN 40:** Backup (Ket noi den Proxmox Backup Server hoac NFS).
- **VLAN 100-200:** VM / LXC Traffic (Mang noi bo cua cac may ao).

## 3. Quy Trinh Ap Dung Cau Hinh Tren Proxmox
1. Kiem tra ten card mang thuc te bang lenh:
   ip link
2. Chinh sua file /etc/network/interfaces theo mau trong scripts/network/02-setup-lacp-vlan.sh.
3. Kiem tra va ap dung cau hinh mang khong can reboot server:
   ifreload -a
4. Kiem tra trang thai bond da nhan du 2 port chua:
   cat /proc/net/bonding/bond0
