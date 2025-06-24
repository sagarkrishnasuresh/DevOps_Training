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
nginx-in (Internal ClusterIP or LoadBalancer)
   ↓
nginx-rent (Reverse Proxy Pod)
   ↓
Backend Microservices
```

* Kong Gateway will now be exposed as the **LoadBalancer**.
* NGINX service (`nginx-in`) becomes internal-only.
* All routing, plugins, and security policies (auth, rate-limiting, etc.) handled by Kong.

---

## 🪜 Setup Flow

### Step 1: Prepare Environment
- Ensure `kubectl` and `helm` are configured for your cluster.
- Identify and back up existing NGINX service (`nginx-in`) config.

### Step 2: Install Kong Gateway
Refer to [kong-helm-install.md](./kong-helm-install.md) for Helm-based installation.

### Step 3: Validate Kong Installation
- Confirm Kong pod is running in `kong` namespace.
- Get LoadBalancer hostname (`EXTERNAL-IP`) from service `kong-kong-proxy`.

### Step 4: Modify DNS or Access Flow
- Update DNS or client-side configurations to route requests to Kong's LoadBalancer IP.
- (Optional) Retain old NGINX LB for fallback during testing.

### Step 5: Update NGINX-in Service
- Change `nginx-in` service type from `LoadBalancer` → `ClusterIP`.
- This makes it accessible **only from inside the cluster** (Kong → NGINX-in).

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
- Access frontend or backend services using Kong LoadBalancer IP.
- Example:
  ```bash
  curl -k https://<KONG_LB_HOSTNAME>/api/auth/login
  ```

### Step 8: (Optional) Add Plugins
- Rate limiting
- Basic or JWT auth
- Logging and analytics

---

## 📌 Notes

- Kong LoadBalancer replaces NGINX LoadBalancer in external exposure.
- Internal routing and microservice behavior remains unchanged.
- Ingress objects define service paths to route from Kong → NGINX → Backend.

---

## ✅ Status Checklist

| Task                                | Done |
|-------------------------------------|------|
| Kong installed using Helm           | ⬜   |
| Kong LoadBalancer reachable         | ⬜   |
| NGINX-in converted to ClusterIP     | ⬜   |
| Kong Ingress configured             | ⬜   |
| Routing verified                    | ⬜   |
| Plugins configured (if needed)      | ⬜   |

---

## 📂 Related Docs

- [request-flow.md](./request-flow.md)
- [kong-helm-install.md](./kong-helm-install.md)
