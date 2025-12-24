# 01 - Container runtime (containerd)

## Summary

Install and configure containerd with systemd cgroups and a pinned pause image.

## Steps

```bash
sudo bash scripts/01-containerd.sh
```

## Notes

* The script generates `/etc/containerd/config.toml`.
* It sets `SystemdCgroup = true`.
* It sets `sandbox_image = "${PAUSE_IMAGE}"` from `PAUSE_IMAGE`.

## Override example

```bash
PAUSE_IMAGE=registry.k8s.io/pause:3.9 sudo bash scripts/01-containerd.sh
```
