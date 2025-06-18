**Document: End-to-End Request Flow with Kong Gateway and NGINX Reverse Proxy**

---

### 🔎 Overview

This document explains the general end-to-end flow of a user request in a Kubernetes-based environment where **Kong** is used as an **API Gateway**, sitting in front of an existing **NGINX reverse proxy** and various backend microservices.

In a typical architecture, requests may initially reach an NGINX LoadBalancer service which forwards traffic to an internal NGINX reverse proxy pod. After implementing Kong, Kong becomes the **new public-facing entry point**, and all requests flow **through Kong first**, before being forwarded to the internal NGINX service.

---

### 📄 Key Components

| Component            | Role                                                                   |
| -------------------- | ---------------------------------------------------------------------- |
| **Kong Gateway**     | Acts as the public-facing entry point (Ingress Controller/API Gateway) |
| **NGINX Service**    | Internal LoadBalancer or ClusterIP service forwarding to the NGINX pod |
| **NGINX Pod**        | NGINX reverse proxy pod that routes traffic to backend services        |
| **Frontend Service** | (Optional) Serves static frontend content                              |
| **Microservices**    | Backend services (e.g., auth-service, booking-service)                 |

---

### 🔄 Request-Response Flow (API Request Example)

#### Scenario:

User accesses: `https://your-app.example.com/api/auth/login`

1. **User (Browser or App)**

    * Sends a request to the public endpoint.

2. **Kong Gateway**

    * Receives the request via a Kubernetes LoadBalancer (kong-kong-proxy).
    * Applies configured plugins: Authentication, Rate Limiting, Logging, etc.
    * Matches an Ingress rule and forwards the request to the internal NGINX service.

3. **NGINX Service (Internal LoadBalancer or ClusterIP)**

    * Routes traffic to the NGINX pod.

4. **NGINX Pod**

    * Acts as a reverse proxy.
    * Forwards API requests (e.g., `/api/auth/login`) to the appropriate backend microservice.

5. **Backend Microservice (e.g., auth-service)**

    * Processes the request.
    * Returns response (e.g., auth token or error message).

6. **Response Path**

    * Flows back from the backend service → NGINX pod → NGINX service → **Kong** → **User**

---

### 📊 Simplified Diagram

```
User Request
   ↓
Kong Gateway (Ingress Controller)
   ↓
NGINX Service (Internal LoadBalancer or ClusterIP)
   ↓
NGINX Pod (Reverse Proxy)
   ↓
Backend Service (e.g., auth-service)
   ↓
Response flows back to user
```

---

### ✅ Summary

* Kong is the **public-facing entry point**, managing **security, routing, and observability**.
* NGINX continues to serve as a reverse proxy within the cluster.
* All backend services are exposed internally using Kubernetes `ClusterIP`.
* External access is centralized and managed by Kong for better control.

---

**Next Steps:** Install Kong, configure Ingress rules, and test routing through Kong to NGINX.
