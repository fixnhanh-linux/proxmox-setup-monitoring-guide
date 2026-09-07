# Huong Dan Bao Mat & Hardening May Chu Proxmox VE

## 1. Bao Mat Dang Nhap SSH
- Su dung SSH Key thay vi mat khau truyen thong.
- Cap nhat file /etc/ssh/sshd_config:
  - PasswordAuthentication no
  - PermitRootLogin prohibit-password
- Khoi dong lai dich vu SSH:
  systemctl restart sshd

## 2. Bao Ve Web UI & Chong Brute-Force Bang Fail2Ban
- Su dung script tai scripts/security/03-setup-fail2ban.sh de kich hoat bo loc cho cong 8006 va cong 22.
- Kiem tra danh sach IP bi khoa bang lenh:
  fail2ban-client status proxmox
- Mo khoa IP neu can:
  fail2ban-client set proxmox unbanip <dia_chi_ip>

## 3. Kich Hoat Xac Thuc Hai Lop (2FA TOTP)
- Dang nhap vao giao dien Proxmox Web GUI bang tai khoan root.
- Chon muc 'Datacenter' -> 'Two-Factor Authentication'.
- Them moi TOTP (Google Authenticator, Authy hoac 1Password) cho tai khoan quan tri.
