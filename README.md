# Kubernetes single-node on Ubuntu 24.04 (kubeadm)

Repeatable, pinned, single-node Kubernetes installation on Ubuntu 24.04.2 LTS using kubeadm.

## What this repo is

A guided, scriptable setup for a single-node Kubernetes cluster on **Ubuntu 24.04.2 LTS (noble)** using **kubeadm**, **containerd**, **Calico**, and **metrics-server**.

## Tested on

* Ubuntu 24.04.2 LTS (noble)

## Requirements

* Minimum: 2 CPU / 4 GB RAM
* Recommended: 4 CPU / 8 GB RAM
* systemd
* apt

## Quickstart

Run the scripts in order (or use `make up`):

```bash
make up
```

Manual sequence:

```bash
sudo bash scripts/00-prereqs.sh
sudo bash scripts/01-containerd.sh
sudo bash scripts/02-kubernetes.sh
sudo bash scripts/03-init.sh
sudo bash scripts/04-calico.sh
sudo bash scripts/05-metrics-server.sh
```

Verify:

```bash
kubectl get nodes
kubectl get pods -A
kubectl top nodes
```

## Make targets

* `make up` — run all steps (00..05)
* `make calico` — (re)apply Calico
* `make metrics` — (re)apply metrics-server
* `make diag` — API server diagnostics
* `make reset` — destructive reset

## Version pinning (override with env vars)

Defaults are pinned but can be overridden at runtime:

```bash
export K8S_MINOR=v1.35
export CALICO_VERSION=v3.31.2
export METRICS_SERVER_VERSION=v0.8.0
export PAUSE_IMAGE=registry.k8s.io/pause:3.9
```

The scripts will use the exported values if present.

## Documentation

Step-by-step instructions live in `docs/`:

* `docs/00-prereqs.md`
* `docs/01-containerd.md`
* `docs/02-kubernetes-packages.md`
* `docs/03-init-cluster.md`
* `docs/04-calico.md`
* `docs/05-metrics-server.md`
* `docs/90-troubleshooting.md`
* `docs/99-reset.md`

## Notes

* UFW is **not** disabled by default; see `docs/00-prereqs.md` for recommended firewall checks.
* If the API server drops after a few minutes, start with `make diag` and `docs/90-troubleshooting.md`.
