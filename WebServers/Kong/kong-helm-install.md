# Kong Helm Installation Guide

This guide walks through the steps to install **Kong Gateway** on a Kubernetes cluster using **Helm**, preparing it to act as an Ingress Controller and API Gateway in front of services like NGINX.

---

## ✅ Prerequisites

* Kubernetes cluster (e.g., EKS, Minikube, etc.)
* `kubectl` configured and connected to the cluster
* `helm` installed and available in your shell

---

## 🚀 Step-by-Step Installation

### 🔹 Step 1: Add the Kong Helm Chart Repository

```bash
helm repo add kong https://charts.konghq.com
helm repo update
```

### 🔹 Step 2: Install Kong using Helm

Install Kong into its own namespace (`kong`) and expose it via a LoadBalancer service:

```bash
helm install kong kong/kong \
  --namespace kong \
  --create-namespace \
  --set ingressController.installCRDs=false \
  --set proxy.type=LoadBalancer
```

### 🔹 Step 3: Verify the Deployment

Check the pods:

```bash
kubectl get pods -n kong
```

You should see a pod similar to:

```
kong-kong-xxxxx-xxxxx   2/2   Running   0   Xm
```

### 🔹 Step 4: Get the External IP

```bash
kubectl get svc -n kong
```

Look for the service named `kong-kong-proxy` and note the `EXTERNAL-IP`. This will be used to route traffic through Kong.

---

## ✅ Summary

* Kong is now installed as a Kubernetes **Ingress Controller**
* A **LoadBalancer service** exposes Kong externally
* You are ready to define Ingress rules and route traffic through Kong

Next step: Create an Ingress rule pointing Kong to an internal service (e.g., NGINX).
