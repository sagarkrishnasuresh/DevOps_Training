
# 📊 Monitoring Spring Boot Metrics with Prometheus & Grafana (Static File)

This project demonstrates how to simulate a Spring Boot application's `/actuator/prometheus` metrics endpoint using a local static file and visualize it using Prometheus and Grafana.

---

## 🧱 Prerequisites

Ensure the following tools are installed on your system:

- Python 3
- Prometheus
- Grafana

---

## 📁 Folder Structure

```bash
prometheus-sim/
├── springboot/
│   └── metrics           # Paste the Spring Boot metrics here (raw .txt format)
```

---

## 🌐 Step 1: Host the Metrics File Using Python

```bash
cd ~/prometheus-sim
python3 -m http.server 8000
```

This will serve the file at:
```
http://localhost:8000/springboot/metrics
```

---

## ⚙️ Step 2: Configure Prometheus

### 📍 File: `/etc/prometheus/prometheus.yml`

Add the following under `scrape_configs`:

```yaml
- job_name: 'springboot-static-metrics'
  metrics_path: '/springboot/metrics'
  static_configs:
    - targets: ['localhost:8000']
```

Restart Prometheus:

```bash
sudo systemctl restart prometheus
```

Open Prometheus UI:  
👉 `http://localhost:9090`

Check under:  
**Status → Targets**  
You should see `springboot-static-metrics` listed and in "UP" state.

Try searching a metric like:
```
jvm_threads_states_threads
```

---

## 📊 Step 3: Set Up Grafana

### 🔹 Start Grafana
```bash
sudo systemctl start grafana-server
sudo systemctl enable grafana-server
```

Access Grafana:  
👉 `http://localhost:3000`

Default login:
- **Username:** admin
- **Password:** admin (you'll be prompted to change it)

---

### 🔹 Add Prometheus as a Data Source

1. Go to ⚙️ **Settings > Data Sources**
2. Click **"Add data source"**
3. Select **Prometheus**
4. Set URL:
   ```
   http://localhost:9090
   ```
5. Click **Save & Test**

---

### 🔹 Create Your First Dashboard

1. Click ➕ **Create > Dashboard > Add new panel**
2. Use a query such as:
   ```text
   jvm_threads_states_threads
   ```
3. Select **Time series** visualization
4. Click **Apply**

---

## 📌 Example Metrics to Query

- `jvm_threads_states_threads`
- `http_server_requests_seconds_count`
- `hikaricp_connections`
- `jvm_memory_committed_bytes`

---

## ✅ Summary

This setup allows you to:
- Simulate Spring Boot metrics using a static text file
- Scrape metrics with Prometheus
- Visualize them in Grafana dashboards

---

## 📦 Useful Commands

```bash
# Serve the static metrics file
python3 -m http.server 8000

# Start Prometheus service
sudo systemctl start prometheus

# Start Grafana service
sudo systemctl start grafana-server
```

---

## 💡 Note

To reuse this setup with real data, simply replace the `metrics` file with fresh output from a real Spring Boot `/actuator/prometheus` endpoint.

---
