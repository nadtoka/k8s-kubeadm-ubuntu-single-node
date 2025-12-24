# 90 - Troubleshooting

Use this as a **Symptom → Check → Fix** guide.

## API server disappears after a few minutes

**Symptom**
* `kubectl` fails with `connection refused` or `timeout`
* `ss -lntp | grep 6443` shows nothing

**Check**
* `sudo bash scripts/diag-apiserver.sh`
* Confirm `kubelet` status and logs

**Fix**
* Ensure containerd uses **SystemdCgroup=true** and restart it:
  * `sudo bash scripts/01-containerd.sh`

## Pods stuck in Pending or CrashLoop

**Symptom**
* `kubectl get pods -A` shows `Pending` or `CrashLoopBackOff`

**Check**
* `kubectl describe pod <pod> -n <ns>`
* `kubectl get nodes -o wide`

**Fix**
* Verify Calico was applied and pods are running:
  * `sudo bash scripts/04-calico.sh`

## Cgroup mismatch

**Symptom**
* kubelet logs mention cgroup driver or runtime mismatch

**Check**
* `journalctl -u kubelet -b --no-pager | tail -n 200`

**Fix**
* Ensure containerd uses systemd cgroups:
  * `sudo bash scripts/01-containerd.sh`

## Not enough CPU/RAM

**Symptom**
* etcd or apiserver crashes, frequent restarts

**Check**
* `free -h`
* `nproc`

**Fix**
* Increase VM resources (min 2 CPU / 4 GB RAM; recommended 4 CPU / 8 GB RAM)

## Clock drift / TLS errors

**Symptom**
* TLS errors in kubelet/apiserver logs

**Check**
* `timedatectl status`

**Fix**
* Ensure chrony is running:
  * `sudo systemctl enable --now chrony`

## Firewall or UFW blocking 6443

**Symptom**
* Remote access to the API server fails

**Check**
* `sudo ufw status verbose`
* `ss -lntp | grep 6443`

**Fix**
* Allow control-plane port:
  * `sudo ufw allow 6443/tcp`

## MTU or NIC issues (virtio + MTU 1500)

**Symptom**
* Node Ready but pod-to-pod networking is broken

**Check**
* `ip link show`
* `ip -d link show <iface>`

**Fix**
* Prefer virtio NICs and MTU 1500 on the VM

## Why port 6443 disappears

**Explanation**
* The API server runs as a **static pod** managed by kubelet.
* If kubelet or containerd fails, the static pod stops and port 6443 vanishes.

**Check**
* `sudo crictl ps -a | grep kube-apiserver`
* `sudo crictl logs --tail 200 <container-id>`

**Fix**
* Resolve runtime issues (cgroup mismatch, OOM, filesystem full).
