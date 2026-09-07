# Proxmox VE Enterprise Operations & Monitoring Guide

Cam nang kien truc va bo cong cu tu dong hoa trien khai, bao mat, quan tri may ao va giam sat cum Proxmox VE chuan Enterprise.

## Quan tri tien do (Epic Task)
Theo doi tien do chi tiet tai: [Epic Issue #1](https://github.com/fixnhanh-linux/proxmox-setup-monitoring-guide/issues/1)

## Cau truc thu muc
- docs/: Tai lieu kien truc, mang LACP/VLAN, bao mat va quy chuan VM
- scripts/bootstrap/: Script cai dat ban dau PVE va tao VM template
- scripts/network/: Cau hinh LACP Bonding va Linux Bridge VLAN
- scripts/security/: Cau hinh Fail2Ban cho Web GUI 8006 va SSH
- scripts/storage/: Tu dong scrub ZFS va don dep kernel cu
- scripts/monitoring/: Cai dat Node Exporter va Zabbix Agent 2
- monitoring-stack/: Cum Docker Compose (Prometheus, Alertmanager, Grafana)
- dashboards/: Dashboard Grafana JSON mau

## Huong dan thao tac nhanh

### 1. Bootstrap PVE
./scripts/bootstrap/01-pve-post-install.sh

### 2. Tao Ubuntu 24.04 Template & Clone VM
./scripts/bootstrap/07-create-ubuntu-template.sh 9000 ubuntu-2404 local-lvm

# Clone VM moi:
qm clone 9000 101 --name vm-app-01 --full 1
qm set 101 --ipconfig0 ip=192.168.10.101/24,gw=192.168.10.1
qm set 101 --ciuser ubuntu --sshkeys ~/.ssh/id_rsa.pub
qm start 101

### 3. Cai dat giam sat tren Host
./scripts/monitoring/05-install-node-exporter.sh
./scripts/monitoring/06-install-zabbix-agent2.sh 192.168.10.50

### 4. Chay Monitoring Stack
cd monitoring-stack && docker compose up -d
