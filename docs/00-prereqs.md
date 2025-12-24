# 00 - Prerequisites

## Summary

Prepare Ubuntu 24.04 for Kubernetes by disabling swap, loading kernel modules, setting sysctls, and enabling time sync.

## Steps

```bash
sudo bash scripts/00-prereqs.sh
```

## What the script does

* Disables swap and comments out swap entries in `/etc/fstab`
* Loads `br_netfilter` and `overlay`
* Applies Kubernetes sysctl settings
* Installs and enables **chrony**
* Warns if UFW is enabled (does not disable it)

## Firewall note (UFW)

If UFW is enabled, ensure the Kubernetes control-plane ports are allowed.
For a single-node setup, the most critical port is **6443/tcp**.

Example:

```bash
sudo ufw allow 6443/tcp
sudo ufw status verbose
```
