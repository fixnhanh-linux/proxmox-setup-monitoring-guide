# Huong Dan Trien Khai He Thong Giam Sat & Canh Bao

## 1. Cai Dat Agent Tren Tung Node Proxmox
- Chay script cai dat Prometheus Node Exporter:
  ./scripts/monitoring/05-install-node-exporter.sh
- Chay script cai dat Zabbix Agent 2 (truyen vao IP cua Zabbix Server):
  ./scripts/monitoring/06-install-zabbix-agent2.sh 192.168.10.50

## 2. Khoi Dong Stack Giam Sat Tap Trung
- Di chuyen vao thu muc monitoring-stack:
  cd monitoring-stack
- Chinh sua file prometheus/prometheus.yml de them dia chi IP cua cac node PVE can theo doi.
- Chinh sua file alertmanager/config.yml de dien Telegram Bot Token va Chat ID.
- Khoi dong toan bo he thong bang Docker Compose:
  docker compose up -d

## 3. Import Dashboard Grafana
- Dang nhap Grafana qua trinh duyet tai dia chi: http://<ip_server>:3000 (Tai khoan mac dinh: admin / admin).
- Vao muc Dashboards -> New -> Import.
- Chon file dashboards/proxmox-cluster-overview.json hoac paste truc tiep noi dung json vao de xem bieu do.
