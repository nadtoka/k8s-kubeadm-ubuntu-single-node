#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
. "$SCRIPT_DIR/common.sh"

require_root
ensure_basics
need_cmd kubeadm
need_cmd kubectl

if [ -f /etc/kubernetes/admin.conf ]; then
  die "/etc/kubernetes/admin.conf already exists. Run scripts/reset.sh before re-initializing."
fi

log "Initializing cluster"
kubeadm init --pod-network-cidr=192.168.0.0/16

TARGET_USER="${SUDO_USER:-root}"
TARGET_HOME="$(getent passwd "${TARGET_USER}" | cut -d: -f6)"
if [ -z "$TARGET_HOME" ]; then
  die "Unable to determine home directory for ${TARGET_USER}."
fi

log "Configuring kubeconfig for ${TARGET_USER}"
mkdir -p "${TARGET_HOME}/.kube"
cp -i /etc/kubernetes/admin.conf "${TARGET_HOME}/.kube/config"
chown "${TARGET_USER}:${TARGET_USER}" "${TARGET_HOME}/.kube/config"

log "Removing control-plane taint for single-node scheduling"
KUBECONFIG=/etc/kubernetes/admin.conf kubectl taint nodes --all node-role.kubernetes.io/control-plane- || true

log "Cluster initialization completed"
