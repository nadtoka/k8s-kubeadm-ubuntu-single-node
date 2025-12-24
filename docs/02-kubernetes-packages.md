# 02 - Kubernetes packages

## Summary

Install kubelet, kubeadm, and kubectl from the official `pkgs.k8s.io` repository for the selected minor version.

## Steps

```bash
sudo bash scripts/02-kubernetes.sh
```

## Notes

* Uses the repo for `${K8S_MINOR}` (default: `v1.35`).
* Packages are held with `apt-mark hold` to prevent unintended upgrades.

## Override example

```bash
K8S_MINOR=v1.35 sudo bash scripts/02-kubernetes.sh
```
