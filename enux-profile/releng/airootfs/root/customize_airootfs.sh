#!/usr/bin/env bash
set -euo pipefail

cat > /usr/lib/os-release <<'EOF'
NAME="Enux"
PRETTY_NAME="Enux OS"
ID=enux
ID_LIKE=arch
BUILD_ID=rolling
ANSI_COLOR="0;36"
HOME_URL="https://enux.local"
DOCUMENTATION_URL="https://enux.local/docs"
SUPPORT_URL="https://enux.local/support"
BUG_REPORT_URL="https://enux.local/issues"
LOGO=archlinux-logo
EOF

ln -sf ../usr/lib/os-release /etc/os-release
