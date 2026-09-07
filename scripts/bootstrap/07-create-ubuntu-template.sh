#!/usr/bin/env bash
set -euo pipefail

echo "=========================================="
echo "   TAO UBUNTU CLOUD-INIT TEMPLATE PROXMOX "
echo "=========================================="

# 1. Khai bao thong so mac dinh (co the truyen tu ngoai vao)
VM_ID="${1:-9000}"
VM_NAME="${2:-ubuntu-2404-template}"
STORAGE="${3:-local-lvm}" # Ten storage tren PVE (local-lvm, local-zfs, ceph-pool)
MEMORY="2048"
CORES="2"
IMAGE_NAME="noble-server-cloudimg-amd64.img"
IMAGE_URL="https://cloud-images.ubuntu.com/noble/current/${IMAGE_NAME}"

echo "[*] VM ID template: $VM_ID"
echo "[*] Storage luu tru: $STORAGE"

# 2. Tai image goc tu Canonical ve thu muc tam /tmp
cd /tmp
if [ ! -f "$IMAGE_NAME" ]; then
    echo "[*] Dang tai Ubuntu 24.04 Cloud Image..."
    wget -q --show-progress "$IMAGE_URL"
else
    echo "[+] Da co san file image tai /tmp/$IMAGE_NAME"
fi

# 3. Kiem tra va xoa VM cu neu bi trung ID
if qm status "$VM_ID" &>/dev/null; then
    echo "[!] Phat hien VM $VM_ID da ton tai, tien hanh xoa ban cu..."
    qm stop "$VM_ID" || true
    qm destroy "$VM_ID"
fi

# 4. Khoi tao khung may ao
echo "[*] Khoi tao khung VM..."
qm create "$VM_ID" \
  --name "$VM_NAME" \
  --memory "$MEMORY" \
  --cores "$CORES" \
  --cpu host \
  --net0 virtio,bridge=vmbr0 \
  --scsihw virtio-scsi-pci \
  --agent enabled=1

# 5. Import o dia vao storage va bat tinh nang SSD Discard
echo "[*] Import o dia vao storage $STORAGE..."
qm set "$VM_ID" --scsi0 "${STORAGE}:0,import-from=/tmp/${IMAGE_NAME},discard=on,ssd=1"

# 6. Tao o Cloud-Init de cau hinh IP va SSH Key
echo "[*] Gan o Cloud-Init..."
qm set "$VM_ID" --ide2 "${STORAGE}:cloudinit"

# 7. Thiet lap uu tien boot tu o dia scsi0 va man hinh console
echo "[*] Cau hinh boot order va serial console..."
qm set "$VM_ID" --boot order=scsi0
qm set "$VM_ID" --serial0 socket --vga serial0

# 8. Chuyen may ao thanh Template
echo "[*] Chuyen VM $VM_ID thanh Template..."
qm template "$VM_ID"

echo "=========================================="
echo "[+] Tao thanh cong Template ID $VM_ID!"
echo "[*] Huong dan clone nhanh VM moi tu template:"
echo "    qm clone $VM_ID 101 --name vm-app-01 --full 1"
echo "    qm set 101 --ipconfig0 ip=192.168.10.101/24,gw=192.168.10.1"
echo "    qm set 101 --ciuser ubuntu --sshkeys ~/.ssh/id_rsa.pub"
echo "    qm start 101"
echo "=========================================="
