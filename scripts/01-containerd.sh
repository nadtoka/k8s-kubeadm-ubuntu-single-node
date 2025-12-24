#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
. "$SCRIPT_DIR/common.sh"

require_root
ensure_basics
need_cmd sed

log "Installing containerd"
apt-get update
apt-get install -y containerd

log "Generating containerd config"
mkdir -p /etc/containerd
containerd config default | tee /etc/containerd/config.toml >/dev/null

log "Enabling SystemdCgroup and setting pause image"
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
sed -i "s#sandbox_image = \".*\"#sandbox_image = \"${PAUSE_IMAGE}\"#" /etc/containerd/config.toml

log "Restarting containerd"
systemctl restart containerd
systemctl enable containerd

log "Containerd setup completed"
