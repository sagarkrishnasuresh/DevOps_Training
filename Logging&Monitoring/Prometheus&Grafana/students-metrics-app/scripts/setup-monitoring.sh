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
