# 03 - Initialize the cluster

## Summary

Initialize a single-node control plane using kubeadm and set up kubeconfig.

## Steps

```bash
sudo bash scripts/03-init.sh
```

## Notes

* Uses `--pod-network-cidr=192.168.0.0/16` for Calico.
* Copies `/etc/kubernetes/admin.conf` into the invoking user's `$HOME/.kube/config`.
* Removes the control-plane taint so workloads can schedule on the single node.
