# Baseline Kien Truc & Tai Nguyen Phan Cung Cho Proxmox VE

## 1. CPU Sizing & NUMA Topology
- **NUMA (Non-Uniform Memory Access):** Luon bat NUMA trong cau hinh VM doi voi may chu co tu 2 Socket CPU tro len. Tranh cap phat so vCPU vuot qua so core vat ly cua 1 socket de han che do tre truy cap bo nho giua cac socket.
- **CPU Type:** Khuyen nghi chon loai CPU la 'host' thay vi 'kvm64' de may ao tan dung truc tiep tap lenh phan cung cua CPU vat ly (AES-NI, AVX, SSE).

## 2. Phan Bo Bo Nho (RAM & Ballooning)
- **RAM Ballooning:** Su dung cho cac may ao chay ung dung thong thuong (web, worker). Khong bat tren cac co so du lieu nhu PostgreSQL, MySQL, Redis de tranh hien tuong OOM Killer khi tai dot bien.
- **ZFS ARC Limit:** Neu dung ZFS, can gioi han dung luong ARC tai file /etc/modprobe.d/zfs.conf de ZFS khong chiem dung het RAM cua he thong.

## 3. Quy Chuan O Cung (Storage Layout)
- **Phan vung he dieu hanh (OS Boot):** Toi thieu 2 o SSD hoac NVMe chay cau hinh ZFS Mirror (RAID1) de dam bao he thong khong bi ngung khi 1 o bi loi vat ly.
- **Phan vung du lieu VM/LXC:**
  - May chu don le: Chay ZFS Pool (Mirror cho ung dung yeu cau IOPS cao, RAIDZ2 cho luu tru dung luong lon).
  - Cum Cluster HA: Su dung Ceph Storage qua he thong mang toi thieu 10GbE.
