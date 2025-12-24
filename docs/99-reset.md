# 99 - Reset

## Summary

This is **destructive** and wipes the control plane, etcd data, CNI config, and kubeconfig.

## Steps

```bash
sudo bash scripts/reset.sh
```

## What gets removed

* `/etc/kubernetes`
* `/var/lib/etcd`
* `/etc/cni/net.d`
* `$HOME/.kube`

After reset you can run `make up` again to re-create the cluster.
