# 🧩 Node Disk Cleanup & Maintenance — Standard Procedure

## 📘 Purpose

This document outlines the standard procedure for identifying, analyzing, and resolving disk-space issues on Kubernetes nodes. It applies to both staging and production environments and focuses on safe cleanup practices for nodes running containerd as the container runtime.

---

## ⚙️ Steps to Diagnose Disk Utilization

### 1. Check Overall Disk Usage

```bash
df -h /
```

* Identify the root volume usage percentage.
* If usage exceeds 75%, proceed with investigation.

### 2. Identify Large Directories

```bash
sudo du -xhd1 / | sort -h
sudo du -xhd1 /var | sort -h
sudo du -xhd1 /var/lib | sort -h
```

* Pay attention to `/var/lib/containerd`, `/var/log`, and `/var/lib/kubelet` as common offenders.

### 3. Analyze Containerd Cache

```bash
sudo du -sh /var/lib/containerd
sudo ctr -n k8s.io images ls | wc -l
sudo ctr -n k8s.io snapshots ls | wc -l
```

* High counts or large directory sizes indicate accumulated unused images and snapshots.

---

## 🧹 Safe Cleanup Procedure

### 1. Prune Unused Container Images

```bash
sudo ctr -n k8s.io images prune --all
```

Removes unreferenced (dangling) images. This operation is safe for running pods.

### 2. Prune Stale Snapshots

```bash
sudo ctr -n k8s.io snapshots prune
```

Deletes leftover overlay filesystem layers from previously deleted containers.

### 3. Restart Containerd to Release Space

```bash
sudo systemctl restart containerd
```

Releases file handles and makes freed disk space visible.

### 4. Verify Disk Usage After Cleanup

```bash
df -h /
sudo du -sh /var/lib/containerd
```

Confirm disk usage reduction and ensure sufficient free space (preferably below 70%).

---

## 🧠 Observations & Expected Behavior

* No downtime or service restarts occur during cleanup.
* Kubernetes-managed pods continue to run normally.
* On subsequent deployments or restarts, container images may be re-pulled once from the registry.

---

## 🧭 Preventive Maintenance

### 1. Automate Periodic Cleanup (Weekly Cron Job)

```bash
# /etc/cron.weekly/containerd-prune
/usr/bin/ctr -n k8s.io images prune --all >/dev/null 2>&1
/usr/bin/ctr -n k8s.io snapshots prune >/dev/null 2>&1
```

### 2. Limit System Log Size

```bash
sudo sed -i 's/^#\?SystemMaxUse=.*/SystemMaxUse=100M/' /etc/systemd/journald.conf
sudo systemctl restart systemd-journald
sudo journalctl --vacuum-time=2d
```

### 3. Monitor Disk Utilization in Prometheus/Grafana

* Set alert thresholds at **70% usage** to trigger early warnings.
* Include node-level metrics such as `/var/lib/containerd` size and inode usage.

---

## ✅ Summary

| Task                     | Description                                    |
| ------------------------ | ---------------------------------------------- |
| **Check Disk Usage**     | Identify nodes exceeding 75% usage             |
| **Analyze Directories**  | Locate large paths (containerd, logs, kubelet) |
| **Prune Cache**          | Remove unused images and snapshots safely      |
| **Restart containerd**   | Refresh handles to release disk space          |
| **Verify & Monitor**     | Confirm disk usage and ensure alerts resolve   |
| **Automate Maintenance** | Schedule weekly cleanups to prevent recurrence |

---
