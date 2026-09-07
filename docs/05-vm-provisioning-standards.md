# Quy Chuan Tao Va Cau Hinh May Ao (VM Provisioning)

## 1. Thiet Lap Phan Cung Toi Uu (Hardware Baseline)
- **BIOS:** Su dung OVMF (UEFI) cho he dieu hanh hien dai, ho tro Secure Boot.
- **Machine:** q35 (chuan PCIe hien dai nhat tren QEMU).
- **SCSI Controller:** VirtIO SCSI single (ho tro IO Thread giup giam tai CPU khi dia doc/ghi cao).
- **Hard Disk:**
  - Bus/Device: SCSI.
  - Cache: Write back (neu server co UPS/BBU) hoac None de tranh mat du lieu khi sup nguon dot ngot.
  - Tich hop Discard (TRIM) va IO Thread: Luon bat.
- **Network:** Card mang VirtIO de dat toc do toi da qua Linux Bridge.
- **CPU Type:** 'host' de may ao nhan day du tap lenh CPU vat ly.
- **Qemu Guest Agent:** Bat (Enabled) de host PVE theo doi dung dia chi IP va snapshot he thong an toan.

## 2. Quy Trinh Tao Cloud-Init Template
1. Tai image cloud chuan (Ubuntu / Debian / AlmaLinux / Rocky).
2. Tao VM bang lenh 'qm create' tren terminal.
3. Import disk vao storage va gan vao cong scsi0.
4. Them o Cloud-Init de tu dong cau hinh IP, User, SSH Key khi clone.
5. Chuyen VM thanh Template ('qm template').
