# Prometheus & Grafana Setup Script

## Overview

This script automates the installation of **Prometheus** and **Grafana** monitoring stack using **Helm** in a Kubernetes cluster. It also performs cleanup operations for Helm cache and Docker to free up system space. At the end of execution, it provides access details for both Prometheus and Grafana UIs.

## Features

* Installs Prometheus and Grafana using Helm in the `monitoring` namespace
* Adds required Helm repositories if not already added
* Fetches and displays Grafana admin password
* Outputs port-forwarding commands to access Prometheus and Grafana
* Cleans up unnecessary Docker containers, images, and volumes

## Script Actions

### 1. **System Update and Helm Installation**

* Updates package list using `apt update`
* Installs `helm` if it's not already installed

### 2. **Helm Repositories Setup**

* Adds the following Helm repositories:

  * `prometheus-community`
  * `grafana`
* Runs `helm repo update`

### 3. **Namespace Creation**

* Checks and creates `monitoring` namespace if it doesn't exist

### 4. **Prometheus Installation**

* Installs Prometheus using Helm if not already installed

### 5. **Grafana Installation**

* Installs Grafana using Helm if not already installed

### 6. **System Cleanup**

* Clears `apt` and Helm cache
* Cleans Docker:

  * Exited containers
  * Dangling images
  * Unused volumes
  * Removes all Docker images except students-app:latest (used for a test project — update this condition to match your project's image requirements)

⚠️ **Caution**:

> Docker cleanup steps like `container prune`, `image prune`, and selective `rmi` may remove containers, images, and volumes that could be in use. Ensure these resources are not currently needed before running the script, especially on shared or production systems.

### 7. **Grafana Access Details**

* Retrieves Grafana admin password from Kubernetes secret
* Displays port-forward commands to access Prometheus and Grafana locally

## Prerequisites

* A working Kubernetes cluster with `kubectl` access
* Helm installed (or script will install it)
* Docker installed on the system (for cleanup section)

## Usage

1. Make the script executable:

```bash
chmod +x setup_monitoring_stack.sh
```

2. Run the script:

```bash
./setup_monitoring_stack.sh
```

3. Use the output commands to port-forward and access UIs:

```bash
kubectl port-forward svc/prometheus-server -n monitoring 9090:80
kubectl port-forward svc/grafana -n monitoring 3000:80
```

4. Open the URLs in your browser:

* Prometheus: [http://localhost:9090](http://localhost:9090)
* Grafana: [http://localhost:3000](http://localhost:3000)

5. Login to Grafana with:

* **Username**: `admin`
* **Password**: *(printed at the end of script)*

## Security Notes

* The Grafana password is printed in the terminal. Ensure you secure it after use.
* Consider configuring Ingress and proper authentication for production use.

## License

Internal DevOps use only.
