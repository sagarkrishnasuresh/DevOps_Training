# Monitoring Setup with Prometheus and Grafana in Kubernetes

This guide provides a step-by-step process for setting up monitoring using Prometheus and Grafana in a Kubernetes environment. It includes installation using Helm, Prometheus configuration to scrape metrics from services, and visualization with Grafana dashboards.

---

## 📌 Prerequisites

- A running Kubernetes cluster (Minikube or managed Kubernetes)
- `kubectl` installed and configured
- `helm` installed
- Applications deployed in Kubernetes (e.g., `students-20`, `students-30` pods exposing metrics)

---

## 📁 Script: Install Helm, Prometheus, Grafana, and Perform Cleanup

Location: `/Logging&Monitoring/Prometheus&Grafana/students-metrics-app/scripts/setup-monitoring.sh`

```bash
#!/bin/bash

# Define color codes
GREEN='\033[0;32m'
BLUE='\033[1;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "\n${BLUE}🔧 Updating package list...${NC}"
sudo apt update

echo -e "\n${BLUE}📦 Installing Helm if not installed...${NC}"
if ! command -v helm &> /dev/null; then
  sudo apt install -y helm
  echo -e "${GREEN}✅ Helm installed successfully.${NC}"
else
  echo -e "${YELLOW}⚠️ Helm is already installed.${NC}"
fi

echo -e "\n${BLUE}📁 Adding Helm repositories...${NC}"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts 2>/dev/null || true
helm repo add grafana https://grafana.github.io/helm-charts 2>/dev/null || true
helm repo update

echo -e "\n${BLUE}📂 Creating namespace 'monitoring' if not exists...${NC}"
kubectl get ns monitoring &> /dev/null || kubectl create namespace monitoring

echo -e "\n${BLUE}📡 Installing Prometheus...${NC}"
if helm list -n monitoring | grep -q prometheus; then
  echo -e "${YELLOW}⚠️ Prometheus is already installed in 'monitoring' namespace.${NC}"
else
  helm install prometheus prometheus-community/prometheus --namespace monitoring
  echo -e "${GREEN}✅ Prometheus installed successfully.${NC}"
fi

echo -e "\n${BLUE}📊 Installing Grafana...${NC}"
if helm list -n monitoring | grep -q grafana; then
  echo -e "${YELLOW}⚠️ Grafana is already installed in 'monitoring' namespace.${NC}"
else
  helm install grafana grafana/grafana --namespace monitoring
  echo -e "${GREEN}✅ Grafana installed successfully.${NC}"
fi

echo -e "\n${BLUE}🧹 Cleaning up unnecessary cache...${NC}"
sudo apt clean
helm repo update > /dev/null
rm -rf ~/.cache/helm

echo -e "\n${BLUE}🧼 Cleaning up Docker residue...${NC}"
echo -e "${YELLOW}🧊 Removing exited containers...${NC}"
docker container prune -f

echo -e "${YELLOW}🧱 Removing dangling (untagged) images...${NC}"
docker image prune -f

echo -e "${YELLOW}🗑️ Removing unused volumes...${NC}"
docker volume prune -f

# Remove all images except 'students-app:latest'
echo -e "${YELLOW}🚮 Removing unused images except 'students-app:latest'...${NC}"
docker images --format "{{.Repository}}:{{.Tag}} {{.ID}}" | \
  grep -v "students-app:latest" | \
  awk '{print $2}' | \
  xargs -r docker rmi -f

echo -e "${GREEN}✅ Docker cleanup complete.${NC}"
echo -e "${GREEN}✅ System is tidy!${NC}\n"

echo -e "\n${BLUE}🔑 Getting Grafana admin password...${NC}"
GRAFANA_PASSWORD=$(kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 -d)
echo -e "${GREEN}🔐 Grafana Password: $GRAFANA_PASSWORD${NC}"

```

---

## 🔧 Step 1: Create Custom Prometheus Scrape Configuration

Create a file named `prometheus-values.yaml`:

```yaml
server:
  extraScrapeConfigs:
    - job_name: 'students-app'
      kubernetes_sd_configs:
        - role: endpoints
      relabel_configs:
        - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_scrape]
          action: keep
          regex: true
        - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_path]
          target_label: __metrics_path__
        - source_labels: [__address__, __meta_kubernetes_service_annotation_prometheus_io_port]
          target_label: __address__
          regex: (.+):(?:\d+);(.+)
          replacement: $1:$2
```

Upgrade Prometheus installation with:

```bash
helm upgrade prometheus prometheus-community/prometheus \
  -n monitoring -f prometheus-values.yaml
```

---

## 🌐 Step 2: Port-Forward Prometheus and Grafana UIs

Run these in separate terminals if not already running:

```bash
kubectl port-forward svc/prometheus-server -n monitoring 9090:80
kubectl port-forward svc/grafana -n monitoring 3000:80
```

Then open in your browser:
- Prometheus UI → http://localhost:9090
- Grafana UI → http://localhost:3000

---

## 🔑 Step 3: Retrieve Grafana Credentials

```bash
kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 -d && echo
```

---

## ⚙️ Step 4: Configure Prometheus as a Data Source in Grafana

1. Log in to Grafana UI using `admin / <password>`
2. Navigate to **Connections > Data sources**
3. Select **Prometheus**
4. Set the URL to Prometheus ClusterIP (e.g., `http://10.99.58.248`)
5. Access: Server (default)
6. Click **Save & Test**

---

## 📊 Step 5: Create Dashboard and Panel

1. Go to **Dashboards > New > New Dashboard**
2. Click **Add a new panel**
3. In **Query** tab, enter:

```promql
number_of_students
```

4. Choose graph type and customize visualization
5. Click **Apply**

---

## 🩺 Troubleshooting Tips

- Check Prometheus is scraping metrics from your service
- Confirm correct service annotations are in place
- Use `kubectl exec -it <grafana-pod> -- wget <prometheus-url>` to test network
- Don’t use `localhost` in the URL inside Grafana pod

---

## ✅ Summary

You have successfully:
- Installed and configured Prometheus and Grafana
- Enabled Prometheus to scrape metrics from services
- Visualized metrics using Grafana dashboards

---

Happy Monitoring! 🎉

