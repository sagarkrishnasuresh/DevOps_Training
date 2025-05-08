**Title: Deploying Sample Application to Local Minikube using GitHub Actions**

---

### Objective

To validate the automation process by deploying a simple Node.js sample application to a local Minikube Kubernetes cluster using GitHub Actions and a self-hosted runner.

---

### Step-by-Step Setup

#### ✅ 1. Start Minikube

```bash
minikube start --driver=docker
```

Ensure `kubectl` context is set to Minikube:

```bash
kubectl config use-context minikube
```

#### ✅ 2. Sample App Directory Structure

```
sample-app/
├── Dockerfile
├── app.js
├── package.json
├── k8s/
│   ├── deployment.yaml
│   └── service.yaml
```

#### ✅ 3. Sample `Dockerfile`

```dockerfile
FROM node:18
WORKDIR /app
COPY . .
RUN npm install
EXPOSE 3000
CMD ["node", "app.js"]
```

#### ✅ 4. Sample Kubernetes Deployment YAML

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sample-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: sample
  template:
    metadata:
      labels:
        app: sample
    spec:
      containers:
        - name: sample
          image: sample-app:v1
          imagePullPolicy: Never
          ports:
            - containerPort: 3000
```

#### ✅ 5. Build Docker Image in Minikube

```bash
eval $(minikube docker-env)
docker build -t sample-app:v1 .
```

#### ✅ 6. Apply Kubernetes Manifests

```bash
kubectl apply -f k8s/
```

#### ✅ 7. Verify Deployment

```bash
kubectl get pods
kubectl logs <pod-name>
```

#### ✅ 8. Access the Application

```bash
minikube service sample-app --url
```

Open the URL in browser or use curl.

---

### GitHub Actions Workflow for Local Minikube Deployment

Place the following YAML under `.github/workflows/deploy-local.yaml`:

```yaml
name: Deploy Sample to Minikube

on:
  workflow_dispatch:

jobs:
  deploy:
    runs-on: [self-hosted, Linux, X64]
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Set Docker Context to Minikube
        run: eval $(minikube docker-env)

      - name: Build Docker Image
        run: docker build -t sample-app:v1 ./GitHub_Actions/sample-app

      - name: Apply Manifests
        run: |
          kubectl apply -f ./GitHub_Actions/sample-app/k8s/
          kubectl rollout status deployment/sample-app

      - name: Show App URL
        run: minikube service sample-app --url
```

---

### Notes

* Make sure `minikube` is started before triggering workflow
* GitHub self-hosted runner must have Docker and kubectl installed (Local setup is added as a markup file in the repo)
* This setup is for local validation only

---

**End of Document**
