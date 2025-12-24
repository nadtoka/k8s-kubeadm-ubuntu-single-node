#!/usr/bin/env bash
set -euo pipefail

K8S_MINOR="${K8S_MINOR:-v1.35}"
CALICO_VERSION="${CALICO_VERSION:-v3.31.2}"
METRICS_SERVER_VERSION="${METRICS_SERVER_VERSION:-v0.8.0}"
PAUSE_IMAGE="${PAUSE_IMAGE:-registry.k8s.io/pause:3.9}"

export K8S_MINOR
export CALICO_VERSION
export METRICS_SERVER_VERSION
export PAUSE_IMAGE

log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

die() {
  echo "ERROR: $*" >&2
  exit 1
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "Missing command: $1"
}

require_root() {
  if [ "$(id -u)" -ne 0 ]; then
    die "Run as root (sudo)."
  fi
}

require_non_root() {
  if [ "$(id -u)" -eq 0 ]; then
    die "Do not run this script as root."
  fi
}

check_os() {
  if [ ! -f /etc/os-release ]; then
    die "Cannot detect OS: /etc/os-release missing."
  fi
  . /etc/os-release
  if [ "${ID:-}" != "ubuntu" ]; then
    die "Unsupported OS: ${ID:-unknown}. Expected Ubuntu."
  fi
}

check_systemd() {
  if [ "$(ps -p 1 -o comm=)" != "systemd" ]; then
    die "systemd is required (PID 1 is not systemd)."
  fi
}

check_apt() {
  need_cmd apt-get
}

ensure_basics() {
  check_os
  check_systemd
  check_apt
}
