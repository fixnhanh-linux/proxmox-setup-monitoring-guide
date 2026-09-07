# Proxmox VE Enterprise Operations & Monitoring Guide

Cam nang kien truc va bo cong cu tu dong hoa trien khai, bao mat, quan tri may ao va giam sat cum Proxmox VE chuan Enterprise.

H Quan tri tien do (Epic Task)
Theo doi tien do chi tiet tai: [Epic Issue #1](https://github.com/fixnhanh-linux/proxmox-setup-monitoring-guide/issues/1)

## 📜 Cau truc kho luu tru
` level-1
	┐── docs/                                   # Huong dan kien truc ky thuat
	   ├── 01-architecture-hardware-baseline.md
	   ├── 02-network-lacp-bonding-vlan.md
	   �\⒐�P 03-security-hardening.md
	   �\⒐�P 04-monitoring-observability.md
	   ☔⤀⤀ 05-vm-provisioning-standards.md    # Quy chuan phan cung & Cloud-Init VM
	�P�P�P scripts/                                 # Script tu dong hoa trien khai
	   �P�P�P bootstrap/
	   │   ├── 01-pve-post-install.sh         # Chuyen repo no-subscription, tat popup
	   �P   ☔⤀⤀ 07-create-ubuntu-template.sh   # Script CLI tao Cloud-Init template
	   �P── network/
	   │   ☔⤀⤀ 02-setup-lacp-vlan.sh          # Template LACP 802.3ad va Bridge VLAN
	   �P�P�P security/
	   │   ☔⤀⤀ 03-setup-fail2ban.sh           # Bao ve Web GUI 8006 va SSH
	   �P撀▀ storage/
	   ─   �── 04-zfs-maintenance.sh          # Auto scrub ZFS & don dep kernel cu
	   �P撀▀ monitoring/
	   ─   ├── 05-install-node-exporter.sh    # Cai dat Prometheus Node Exporter
	   ─   ☔⤀⤀ 06-install-zabbix-agent2.sh    # Cai dat Zabbix Agent 2
	   ┠── close_epic_issue.sh                # Cap nhat va dong issue tren GitHub
	�P�P�P monitoring-stack/                      # Cum Docker Compose giam sat tap trung
	   �\⒐�P docker-compose.yml                 # Prometheus + Alertmanager + Grafana
	   �\⒐�P prometheus/                         # File cau hinh cao metric & alert rules
	   �── alertmanager/                      # Cau hinh gui canh bao Telegram
	�P撀▀ dashboards/
	   ┠── proxmox-cluster-overview.json         # Dashboard Grafana JSON
``

## 🚀 Huong dan thao tac nhanh

### 1. Bootstrap may chu PVE moi
```bash
./scripts/bootstrap/01-pve-post-install.sh
```

### 2. Tao Ubuntu 24.04 Template & Clone may ao`F`bash
# Tao template VM ID 9000 tren storage local-lvm (hoac local-zfs)
./scripts/bootstrap/07-create-ubuntu-template.sh 9000 ubuntu-2404 local-lvm

# Clone VM moi (ID 101) t{ template
qm clone 9000 101 --name vm-app-01 --full 1
qm set 101 --ipconfig0 ip=192.168.10.101/24,gw=192.168.10.1
qm set 101 --ciuser ubuntu --sshkeys ~/.ssh/id_rsa.pub
qm start 101
```

### 3. Cai dat giam sat tren Host
```bash
./scripts/monitoring/05-install-node-exporter.sh
./scripts/monitoring/06-install-zabbix-agent2.sh 192.168.10.50
```

### 4. Khoi dong Monitoring Stack tap trung
```bash
cd monitoring-stack
docker compose up -d
```
