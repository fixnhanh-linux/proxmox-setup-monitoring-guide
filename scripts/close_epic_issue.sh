#!/usr/bin/env bash
set -euo pipefail

# Thong tin du an
REPO_OWNER="fixnhanh-linux"
REPO_NAME="proxmox-setup-monitoring-guide"
ISSUE_NUMBER="1"

# Nap token tu file neu chua co
if [ -f ~/.github_token ]; then
    source ~/.github_token
fi

if [ -z "${GITHUB_TOKEN:-}" ]; then
    echo "[-] Loi: Khong tim thay bien GITHUB_TOKEN!"
    exit 1
fi

API_BASE="https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/issues/$ISSUE_NUMBER"
AUTH_HEADER="Authorization: Bearer $GITHUB_TOKEN"
JSON_HEADER="Accept: application/vnd.github+json"

echo "=========================================="
echo "   CAP NHAT & DONG EPIC ISSUE #$ISSUE_NUMBER"
echo "=========================================="

# 1. Lay noi dung hien tai cua issue va doi toan bo [ ] thanh [x]
echo "[*] 1. Dang cap nhat danh sach cong viec thanh hoan thanh [x]..."
CURRENT_BODY=$(curl -s -H "$AUTH_HEADER" -H "$JSON_HEADER" "$API_BASE" | python3 -c '
import json, sys
data = json.load(sys.stdin)
print(data.get("body", ""))
')

UPDATED_BODY=$(python3 -c '
import sys
body = sys.argv[1]
# Thay the tat ca checkbox chua tick thanh da tick
new_body = body.replace("- [ ]", "- [x]")
print(new_body)
' "$CURRENT_BODY")

UPDATE_PAYLOAD=$(python3 -c '
import json, sys
# Cap nhat body moi va dong issue (state = closed)
payload = {
    "body": sys.argv[1],
    "state": "closed",
    "state_reason": "completed"
}
print(json.dumps(payload))
' "$UPDATED_BODY")

curl -s -X PATCH \
  -H "$AUTH_HEADER" \
  -H "$JSON_HEADER" \
  "$API_BASE" \
  -d "$UPDATE_PAYLOAD" > /dev/null

echo "[+] Da tick toan bo checklist va chuyen trang thai thanh Closed!"

# 2. Dang comment tong ket du an
echo "[*] 2. Dang dang comment tong ket du an..."
COMMENT_TEXT="🎉 **HOAN TAT DU AN PROXMOX ENTERPRISE OPERATIONS & MONITORING**

Toan bo cac hang muc theo checklist da duoc hoan thanh va day len repository day du:
- **Phase 1 (Setup & Baseline):** Script bootstrap pve-no-subscription repo, tat popup, chrony NTP va template LACP Bonding 802.3ad + VLAN Tagging.
- **Phase 2 (Configuration & Hardening):** Script cau hinh Fail2Ban (bao ve port 8006, SSH), tu dong scrub ZFS va don dep kernel cu.
- **Phase 3 (Monitoring & Observability):** Script cai dat Node Exporter, Zabbix Agent 2, Docker Compose stack (Prometheus, Alertmanager, Grafana) va Dashboard JSON mau.
- **Docs:** Tai lieu huong dan chi tiet ve Architecture, Network, Hardening va Monitoring trong thu muc \`docs/\`.

Chinh thuc dong Issue tracking nay."

COMMENT_PAYLOAD=$(python3 -c '
import json, sys
print(json.dumps({"body": sys.argv[1]}))
' "$COMMENT_TEXT")

curl -s -X POST \
  -H "$AUTH_HEADER" \
  -H "$JSON_HEADER" \
  "$API_BASE/comments" \
  -d "$COMMENT_PAYLOAD" > /dev/null

echo "[+] Da dang comment tong ket thanh cong!"
echo "=========================================="
echo "[+] Du an da hoan thanh 100%!"
echo "[+] Xem lai issue tai: https://github.com/$REPO_OWNER/$REPO_NAME/issues/$ISSUE_NUMBER"
