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
wait_for_apiserver 15 2
KUBECONFIG=/etc/kubernetes/admin.conf kubectl apply -f "${METRICS_URL}"

log "Patching metrics-server to allow insecure Kubelet TLS (required for kubeadm self-signed certificates)"
KUBECONFIG=/etc/kubernetes/admin.conf kubectl patch deployment metrics-server -n kube-system --type='json' \
  -p='[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--kubelet-insecure-tls"}]' || true

log "Metrics-server applied"
