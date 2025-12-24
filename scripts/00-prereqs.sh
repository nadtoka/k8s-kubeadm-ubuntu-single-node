#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
. "$SCRIPT_DIR/common.sh"

require_root
ensure_basics

log "Disabling swap"
swapoff -a
sed -i '/\sswap\s/s/^/#/' /etc/fstab

log "Loading kernel modules"
modprobe br_netfilter
modprobe overlay
cat <<'MODULES' > /etc/modules-load.d/k8s.conf
br_netfilter
overlay
MODULES

log "Applying sysctl settings"
cat <<'SYSCTL' > /etc/sysctl.d/99-kubernetes.conf
net.bridge.bridge-nf-call-iptables=1
net.bridge.bridge-nf-call-arptables=1
net.bridge.bridge-nf-call-ip6tables=1
net.ipv4.ip_forward=1
SYSCTL
sysctl --system

log "Installing chrony (time sync)"
apt-get update
apt-get install -y chrony
systemctl enable --now chrony

if command -v ufw >/dev/null 2>&1; then
  log "UFW detected. Not disabling automatically. Ensure required ports are open if UFW is enabled."
fi

log "Prerequisites completed"
