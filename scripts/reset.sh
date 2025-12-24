#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
. "$SCRIPT_DIR/common.sh"

require_root
ensure_basics

log "WARNING: This will delete the Kubernetes control plane, etcd data, CNI config, and kubeconfig."
log "Proceeding with reset"

kubeadm reset -f

log "Cleaning up Kubernetes and CNI files"
rm -rf /etc/kubernetes /var/lib/etcd /etc/cni/net.d

TARGET_USER="${SUDO_USER:-root}"
TARGET_HOME="$(getent passwd "${TARGET_USER}" | cut -d: -f6)"
if [ -n "${TARGET_HOME}" ]; then
  rm -rf "${TARGET_HOME}/.kube"
fi

log "Restarting services"
systemctl restart kubelet || true
systemctl restart containerd || true

log "Reset completed"
