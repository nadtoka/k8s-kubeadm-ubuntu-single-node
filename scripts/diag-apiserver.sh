#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
. "$SCRIPT_DIR/common.sh"

require_root
ensure_basics

log "Checking kubelet status"
systemctl status kubelet --no-pager || true
journalctl -u kubelet -b --no-pager | tail -n 200 || true

log "Checking API server port 6443"
ss -lntp | grep 6443 || true

if ! command -v crictl >/dev/null 2>&1; then
  log "Installing cri-tools"
  apt-get update
  apt-get install -y cri-tools
fi

log "Checking kube-apiserver container"
crictl ps -a | grep kube-apiserver || true
APISRV=$(crictl ps -a | awk '/kube-apiserver/{print $1}' | head -n1)
if [ -n "${APISRV}" ]; then
  log "kube-apiserver logs (tail 200)"
  crictl logs --tail 200 "${APISRV}" || true
else
  log "No kube-apiserver container found"
fi

log "Resource summary"
free -h || true
df -h || true
nproc || true
dmesg | tail -n 50 || true

log "Diagnostics complete"
