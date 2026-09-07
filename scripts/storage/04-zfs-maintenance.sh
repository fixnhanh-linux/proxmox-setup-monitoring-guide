#!/usr/bin/env bash
set -euo pipefail

echo "=========================================="
echo "   BAO TRI ZFS POOL VA DON DEP HE THONG   "
echo "=========================================="

# 1. Kiem tra va chay ZFS Scrub cho tat ca cac pool
echo "[*] 1. Kiem tra danh sach va trang thai ZFS pool..."
if command -v zpool >/dev/null 2>&1; then
    POOLS=$(zpool list -H -o name || true)
    if [ -n "$POOLS" ]; then
        for p in $POOLS; do
            echo "[*] Bat dau chay ZFS scrub cho pool: $p"
            zpool scrub "$p"
        done
        echo "[+] Da gui lenh scrub thanh cong cho tat ca pool."
    else
        echo "[!] He thong khong su dung ZFS hoac khong tim thay pool."
    fi
else
    echo "[!] Lenh zpool khong ton tai, bo qua buoc nay."
fi

# 2. Don dep kernel cu giai phong o cung /boot
echo "[*] 2. Kiem tra va don dep kernel cu..."
CURRENT_KERNEL=$(uname -r)
echo "[*] Kernel dang hoat dong: $CURRENT_KERNEL"

# Lay danh sach kernel pve cu khong phai ban dang chay
OLD_KERNELS=$(dpkg --list | grep -E 'pve-kernel-[0-9]|proxmox-kernel-[0-9]' | awk '{print $2}' | grep -v "$CURRENT_KERNEL" || true)

if [ -n "$OLD_KERNELS" ]; then
    echo "[*] Dang go bo cac ban kernel cu sau:"
    echo "$OLD_KERNELS"
    for k in $OLD_KERNELS; do
        apt-get purge -y "$k" || true
    done
    apt-get autoremove --purge -y
    update-grub
    echo "[+] Da don dep xong kernel cu."
else
    echo "[+] He thong dang sach se, khong co kernel thua."
fi

echo "=========================================="
echo "[+] Hoan tat bao tri he thong!"
echo "=========================================="
