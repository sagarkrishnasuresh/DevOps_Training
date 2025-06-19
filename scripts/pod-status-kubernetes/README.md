# Kubernetes Pod Status Checker via Bastion Host

## Overview

This Bash script provides an interactive way to connect to a Bastion Host of a specific environment (Production, Staging, or Rent-n-Go) and check the Kubernetes pod status and resource usage in the corresponding namespace.

## Features

* Interactive environment selection
* Secure SSH connection to Bastion Host
* Executes `kubectl get pods` and `kubectl top pods` remotely
* Environment-specific configuration for credentials and namespaces

## Script Structure

### Environment Configuration

```bash
PROD_IP="<prod-ip>"
STAGING_IP="<staging-ip>"
RENTNGO_IP="<rent-n-go-ip>"

BASTION_USER="ubuntu"
PRIVATE_KEY_PATH_staging="<path-to-pem-key>"
PRIVATE_KEY_PATH_prod="<path-to-pem-key>"
PRIVATE_KEY_PATH_rent="<path-to-pem-key>"
```

### Environment Selection

The script prompts the user to select one of the environments:

* Iter-production (1)
* Iter-staging (2)
* rent-n-go (3)

Each option sets the relevant IP address, key path, and Kubernetes namespace.

### SSH and Remote Commands

Once an environment is selected, the script connects to the Bastion Host using SSH and executes the following commands:

```bash
kubectl get pods -n <namespace>
kubectl top pods -n <namespace>
```

## Prerequisites

* SSH access to Bastion Hosts
* Valid private keys at configured paths
* Bastion Host must have:

    * `kubectl` configured
    * Access to the Kubernetes cluster
    * `metrics-server` installed for `kubectl top` to work

## How to Run

1. Make the script executable:

```bash
chmod +x check_k8s_pod_status.sh
```

2. Run the script:

```bash
./check_k8s_pod_status.sh
```

3. Select the appropriate environment when prompted.

## Example Output

```
🔐 Connecting to staging environment at <staging-ip>...

✅ Connected to Bastion. Checking Kubernetes pod status...

Getting Pods in namespace: staging
...

📊 Top Pods in namespace: staging
...

✅ Done checking pod status.
```

## Security Note

Ensure your private key files have secure permissions:

```bash
chmod 400 <path-to-pem-key>
chmod 400 <path-to-pem-key>
```

## License

Internal use only.
