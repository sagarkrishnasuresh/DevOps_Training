# Monitoring Setup with Prometheus and Grafana in Minikube

This guide provides a step-by-step process for setting up monitoring using Prometheus and Grafana in a Minikube environment. It includes installing both tools using Helm, configuring Prometheus to scrape metrics from Kubernetes services, and visualizing those metrics in Grafana.

---

## Prerequisites
- Minikube running
- `kubectl` installed and configured
- `helm` installed
- Applications deployed in Kubernetes (e.g., `students-20`, `students-30` pods exposing metrics)

> Note: Script for installing helm,prometheus, grafana is there in /Logging&Monitoring/Prometheus&Grafana/students-metrics-app/scripts
---

## 1. Add Helm Repositories
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
```

---

## 2. Create Monitoring Namespace
```bash
kubectl create namespace monitoring
```

---

## 3. Install Prometheus using Helm
Create a file named `prometheus-values.yaml` with custom scrape configs:

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

Install Prometheus:
```bash
helm install prometheus prometheus-community/prometheus \
  -n monitoring -f prometheus-values.yaml
```

---

## 4. Install Grafana using Helm
```bash
helm install grafana grafana/grafana -n monitoring
```

---

## 5. Port-Forward to Access UIs
```bash
kubectl port-forward svc/prometheus-server -n monitoring 9090:80
kubectl port-forward svc/grafana -n monitoring 3000:80
```
Access Prometheus at: `http://localhost:9090`
Access Grafana at: `http://localhost:3000`

---

## 6. Get Grafana Admin Password
```bash
kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 -d && echo
```

---

## 7. Configure Prometheus as a Data Source in Grafana
1. Login to Grafana (`admin`/`<password>`).
2. Go to **Connections > Data sources**.
3. Select **Prometheus**.
4. Enter:
    - **URL**: `http://<Prometheus ClusterIP>` (e.g., `http://10.99.58.248`)
    - **Access**: Server (default)
5. Click **Save & Test**.

> Note: Using `localhost:9090` or `prometheus-server.monitoring.svc.cluster.local` may not work from within Grafana pod due to DNS or networking issues. Use the ClusterIP of the Prometheus service.

---

## 8. Visualize Metrics
- Create a new dashboard in Grafana.
- Add a panel.
- Use query like:
```promql
number_of_students
```


---

## 10. Troubleshooting Tips
- Ensure Prometheus is correctly scraping your application's metrics.
- Use `kubectl get svc -n monitoring prometheus-server` to confirm the correct ClusterIP.
- Use `kubectl exec -it <grafana-pod> -- wget <prometheus-url>` to verify connectivity.
- Avoid using `localhost:9090` in Grafana if it's installed inside the cluster.

---

## Summary
You have now:
- Installed Prometheus and Grafana in Minikube
- Connected Grafana to Prometheus
- Created dashboards with application metrics

---

Happy Monitoring! 📊

