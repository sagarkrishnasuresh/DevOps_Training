# Kong Setup Flow for Rent-n-Go Project

This document outlines the step-by-step setup flow for integrating Kong Gateway as the public-facing entry point in the **Rent-n-Go** project Kubernetes architecture.

---

## 🔧 Current Architecture (Before Kong)

```
User Request
   ↓
nginx-in (AWS LoadBalancer Service)
   ↓
nginx-rent (Reverse Proxy Pod)
   ↓
Backend Microservices
```

* `nginx-in` is a Kubernetes LoadBalancer service.
* Exposes port 80 and 443 and routes traffic to the NGINX reverse proxy (`nginx-rent`).
* NGINX then routes requests internally to respective services.

---

## ✅ Target Architecture (After Kong Integration)

```
User Request
   ↓
Kong Gateway (Ingress Controller, LoadBalancer)
   ↓
nginx-in (Internal ClusterIP)
   ↓
nginx-rent (Reverse Proxy Pod)
   ↓
Backend Microservices
```

* Kong Gateway is deployed with `proxy.type=LoadBalancer`, exposing it publicly via an AWS ELB.
* Kong acts as an **Ingress Controller** by processing Ingress resources assigned to it (`ingressClassName: kong`).
* NGINX service (`nginx-in`) becomes internal-only (`ClusterIP`).
* Kong applies plugins, routing, and security policies before forwarding traffic to internal NGINX.

---

## 🪜 Setup Flow

### Step 1: Prepare Environment
- Ensure `kubectl` and `helm` are configured for your cluster.
- Identify and back up existing NGINX service (`nginx-in`) config.

### Step 2: Install Kong Gateway
Refer to [kong-helm-install.md](./kong-helm-install.md) for Helm-based installation.

> ✅ When `--set proxy.type=LoadBalancer` is used, Kubernetes will automatically provision an **AWS Elastic Load Balancer (ELB)** — **no manual AWS setup is needed**.

### Step 3: Validate Kong Installation
- Confirm Kong pod is running in `kong` namespace.
- Run `kubectl get svc -n kong` and get `EXTERNAL-IP` for `kong-kong-proxy`.

### Step 4: Modify DNS or Access Flow
- Point your domain in GoDaddy (or other DNS) to the Kong LoadBalancer hostname.
- (Optional) Retain old NGINX LB for fallback testing if needed.

### Step 5: Update NGINX-in Service
- Change `nginx-in` service type from `LoadBalancer` → `ClusterIP` using:

```bash
kubectl patch svc nginx-in -n rent-n-go -p '{"spec": {"type": "ClusterIP"}}'
```

### Step 6: Create Ingress Rule in Kong

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: rent-n-go-nginx
  namespace: rent-n-go
  annotations:
    konghq.com/strip-path: "true"
spec:
  ingressClassName: kong
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: nginx-in
            port:
              number: 80
```

### Step 7: Test Routing
- Access frontend/backend services via Kong LoadBalancer IP:
```bash
curl -k https://<KONG_LB_HOSTNAME>/api/auth/login
```

### Step 8: (Optional) Add Plugins
- Rate limiting, Auth (Basic/JWT), Logging, CORS etc.

---


## Why Kong is "Ingress Controller + LoadBalancer"

Although NGINX is still acting as an internal reverse proxy (and Ingress Controller for previous rules), Kong is now:

- Watching Ingress resources with `ingressClassName: kong`
- Acting as public entry point via ELB
- Applying authentication, rate limiting, logging, etc.

Thus, Kong is effectively **Ingress Controller + LoadBalancer**.

---

## ✅ Status Checklist

| Task                                | Done |
|-------------------------------------|------|
| Kong installed using Helm           | ⬜   |
| Kong LoadBalancer reachable         | ⬜   |
| DNS pointed to Kong ELB             | ⬜   |
| NGINX-in converted to ClusterIP     | ⬜   |
| Kong Ingress configured             | ⬜   |
| Routing verified                    | ⬜   |
| Plugins configured (if needed)      | ⬜   |

---

## 📂 Related Docs

- [request-flow.md](./request-flow.md)
- [kong-helm-install.md](./kong-helm-install.md)
