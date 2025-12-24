#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
. "$SCRIPT_DIR/common.sh"

require_root
ensure_basics
need_cmd kubectl

CALICO_URL="https://raw.githubusercontent.com/projectcalico/calico/${CALICO_VERSION}/manifests/calico.yaml"

log "Applying Calico ${CALICO_VERSION}"
KUBECONFIG=/etc/kubernetes/admin.conf kubectl apply -f "${CALICO_URL}"

log "Calico applied"
