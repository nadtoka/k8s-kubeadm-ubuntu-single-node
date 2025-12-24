#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
. "$SCRIPT_DIR/common.sh"

require_root
ensure_basics
need_cmd kubectl

METRICS_URL="https://github.com/kubernetes-sigs/metrics-server/releases/download/${METRICS_SERVER_VERSION}/components.yaml"

log "Applying metrics-server ${METRICS_SERVER_VERSION}"
KUBECONFIG=/etc/kubernetes/admin.conf kubectl apply -f "${METRICS_URL}"

log "Metrics-server applied"
