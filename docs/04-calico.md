# 04 - Calico CNI

## Summary

Apply Calico for pod networking.

## Steps

```bash
sudo bash scripts/04-calico.sh
```

## Optional: add a toleration patch

If you need to tolerate `node.kubernetes.io/not-ready` for Calico controllers:

```bash
KUBECONFIG=/etc/kubernetes/admin.conf kubectl patch deployment calico-kube-controllers \
  -n kube-system --type='json' --patch-file manifests/calico-toleration-patch.json
```
