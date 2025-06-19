# kubectl Commands

This document provides essential commands to analyze the performance of running services in Kubernetes pods.

## 1. Check Running Pods and Services
### Get list of running pods:
```sh
kubectl get pods --all-namespaces
kubectl get pods -n <namespace>
```

### Get list of services:
```sh
kubectl get svc --all-namespaces
kubectl get svc -n <namespace>
```

### Get detailed information about a specific pod:
```sh
kubectl describe pod <pod-name> -n <namespace>
```

## 2. Monitor Pod Resource Utilization
### Check CPU and Memory Usage:
```sh
kubectl top pod --all-namespaces
kubectl top pod -n <namespace>
```

### Check Node Utilization:
```sh
kubectl top node
```

## 3. Analyze Pod Logs
### View logs of a running pod:
```sh
kubectl logs <pod-name> -n <namespace>
```

### Stream live logs:
```sh
kubectl logs -f <pod-name> -n <namespace>
```

### View logs for a specific container inside a pod:
```sh
kubectl logs <pod-name> -c <container-name> -n <namespace>
```

## 4. Debugging Pods and Containers
### Get detailed pod events and status:
```sh
kubectl describe pod <pod-name> -n <namespace>
```

### Start an interactive shell inside a running pod:
```sh
kubectl exec -it <pod-name> -- /bin/sh
kubectl exec -it <pod-name> -c <container-name> -- /bin/bash
```

## 5. Checking Networking and Connectivity
### Get pod IP and connectivity details:
```sh
kubectl get pod <pod-name> -o wide -n <namespace>
```

### Test network connectivity between pods:
```sh
kubectl exec -it <pod-name> -- ping <other-pod-IP>
```

### Get service endpoints:
```sh
kubectl get endpoints <service-name> -n <namespace>
```

## 6. Checking Persistent Storage and Volume Usage
### Get list of Persistent Volume Claims (PVCs):
```sh
kubectl get pvc -n <namespace>
```

### Get details of Persistent Volumes:
```sh
kubectl get pv
```

### Describe storage details:
```sh
kubectl describe pvc <pvc-name> -n <namespace>
```

## 7. Monitoring Kubernetes Events
### View recent events in the cluster:
```sh
kubectl get events --sort-by='.metadata.creationTimestamp'
```

### View events for a specific namespace:
```sh
kubectl get events -n <namespace>
```

## 8. Performance Troubleshooting
### Check pod restarts and failures:
```sh
kubectl get pods --field-selector=status.phase!=Running
```

### Check container resource limits and requests:
```sh
kubectl describe pod <pod-name> -n <namespace> | grep -A 5 "Limits"
```

## 9. Scaling and Load Testing
### Scale a deployment:
```sh
kubectl scale deployment <deployment-name> --replicas=<number> -n <namespace>
```

### Run a stress test inside a pod:
```sh
kubectl run -it --rm load-test --image=busybox -- /bin/sh
```
Then inside the shell, use:
```sh
while true; do wget -q -O- http://<service-name>:<port>; done
```

## Conclusion
These commands help analyze and troubleshoot performance issues in a Kubernetes cluster. Proper monitoring and debugging ensure efficient operation of applications running inside Kubernetes pods.

