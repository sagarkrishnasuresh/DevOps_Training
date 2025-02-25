# 📦 Kubernetes `kubectl` Commands Reference

This document provides a comprehensive list of essential `kubectl` commands for managing Kubernetes clusters.

---

## 🗂️ General Commands

```bash
# Check cluster information
kubectl cluster-info

# Display the Kubernetes version
kubectl version

# Get the current context
kubectl config current-context

# List all contexts
kubectl config get-contexts

# Switch to a different context
kubectl config use-context <context-name>
```

---

## 🛑 Node Management

```bash
# List all nodes
kubectl get nodes

# Get detailed information about a specific node
kubectl describe node <node-name>

# Drain a node (prepare for maintenance)
kubectl drain <node-name> --ignore-daemonsets

# Mark node as schedulable
kubectl uncordon <node-name>

# Mark node as unschedulable
kubectl cordon <node-name>
```

---

## 🐳 Pod Management

```bash
# List all pods
kubectl get pods

# List pods with more details
kubectl get pods -o wide

# Describe a specific pod
kubectl describe pod <pod-name>

# View pod logs
kubectl logs <pod-name>

# View logs of a specific container in a pod
kubectl logs <pod-name> -c <container-name>

# Execute a command inside a running pod
kubectl exec -it <pod-name> -- /bin/bash

# Delete a specific pod
kubectl delete pod <pod-name>

# Delete all pods
kubectl delete pods --all
```

---

## ⚙️ Deployment Management

```bash
# List all deployments
kubectl get deployments

# Describe a specific deployment
kubectl describe deployment <deployment-name>

# Scale a deployment
kubectl scale deployment <deployment-name> --replicas=<number>

# Update a deployment
kubectl rollout restart deployment <deployment-name>

# Roll back a deployment
kubectl rollout undo deployment <deployment-name>

# Check the rollout status
kubectl rollout status deployment <deployment-name>
```

---

## 🌐 Service Management

```bash
# List all services
kubectl get services

# Describe a specific service
kubectl describe service <service-name>

# Expose a deployment as a service
kubectl expose deployment <deployment-name> --type=<ClusterIP|NodePort|LoadBalancer> --port=<port>

# Forward a local port to a pod
kubectl port-forward pod/<pod-name> <local-port>:<pod-port>
```

---

## 🔒 Secret and ConfigMap Management

```bash
# List all secrets
kubectl get secrets

# Describe a specific secret
kubectl describe secret <secret-name>

# List all ConfigMaps
kubectl get configmaps

# Describe a specific ConfigMap
kubectl describe configmap <configmap-name>
```

---

## 💾 Storage Management

```bash
# List persistent volume claims
kubectl get pvc

# Describe a specific persistent volume claim
kubectl describe pvc <pvc-name>

# List persistent volumes
kubectl get pv

# Describe a specific persistent volume
kubectl describe pv <pv-name>
```

---

## 🧹 Cleaning Up

```bash
# Delete all resources in the current namespace
kubectl delete all --all

# Delete specific resource types
kubectl delete <resource-type> <resource-name>

# Delete all deployments, services, and pods
kubectl delete deployments --all
kubectl delete services --all
kubectl delete pods --all
```

---

## ✅ Troubleshooting

```bash
# Check events in the cluster
kubectl get events

# Get detailed information about a resource
kubectl describe <resource-type> <resource-name>

# Debug a running pod
kubectl debug pod/<pod-name> -it --image=busybox
```

---

## 📁 Namespaces

```bash
# List all namespaces
kubectl get namespaces

# Switch to a different namespace
kubectl config set-context --current --namespace=<namespace-name>

# Create a new namespace
kubectl create namespace <namespace-name>

# Delete a namespace
kubectl delete namespace <namespace-name>
```

---

## 💡 Useful Tips

- Use `-o yaml` or `-o json` to get resource details in different formats.
- Add `-A` to list resources across all namespaces.
- Use `kubectl explain <resource>` to get documentation for a specific resource.

---

Keep this document handy for quick reference while working with Kubernetes clusters! 🚀

