# SonarQube on Kubernetes — Setup & Wiring to PostgreSQL

This document provides step-by-step instructions to deploy **SonarQube (Community Edition)** and connect it to an existing external PostgreSQL database in the `sonarqube` namespace.

---

## 0) Context & Goals

* Use an existing PostgreSQL instance (`sonardb` release in `sonarqube` namespace).
* Configure SonarQube to connect via JDBC secrets.
* Store sensitive values in Kubernetes Secrets.
* Access SonarQube through port-forward and SSH tunnel.
* Verify database connectivity and persistence.

---

## 1) Files & Folder Structure

```bash
mkdir -p ~/sonarqube/sonarqube
```

All SonarQube-related configurations are stored here.

---

## 2) Secrets

### 2.1 JDBC Secret (SonarQube DB password)

```bash
SONAR_DB_PASS=$(kubectl -n sonarqube get secret postgres-secrets \
  -o jsonpath='{.data.SONAR_PASSWORD}' | base64 -d)

kubectl -n sonarqube create secret generic sonarqube-jdbc \
  --from-literal=jdbc-password="$SONAR_DB_PASS"
```

### 2.2 Monitoring Passcode

Created earlier during PostgreSQL setup (`sonarqube-monitoring-passcode`).

---

## 3) Helm Values — SonarQube

**File:** `~/sonarqube/sonarqube/values-sonarqube.yaml`

```yaml
community:
  enabled: true    # install Community edition

postgresql:
  enabled: false   # disable embedded Postgres

jdbcOverwrite:
  enabled: true
  jdbcUrl: "jdbc:postgresql://sonardb-postgresql.sonarqube.svc.cluster.local:5432/sonarqube"
  jdbcUsername: "sonar"
  jdbcSecretName: "sonarqube-jdbc"

monitoringPasscodeSecretName: sonarqube-monitoring-passcode
monitoringPasscodeSecretKey: monitoring-passcode

resources:
  requests:
    cpu: "500m"
    memory: "2Gi"
  limits:
    cpu: "2"
    memory: "4Gi"
```

---

## 4) Install SonarQube

```bash
helm repo add sonarqube https://SonarSource.github.io/helm-chart-sonarqube
helm repo update

helm upgrade --install sonarqube sonarqube/sonarqube \
  -n sonarqube -f ~/sonarqube/sonarqube/values-sonarqube.yaml
```

Check pods and services:

```bash
kubectl -n sonarqube get pods,svc
```

---

## 5) Access SonarQube UI

### On bastion:

```bash
kubectl -n sonarqube port-forward svc/sonarqube-sonarqube 9000:9000 --address 127.0.0.1
```

### On laptop:

```bash
ssh -i <pem-key> -N -L 127.0.0.1:8080:127.0.0.1:9000 ubuntu@<bastion-ip>
```

Open [http://127.0.0.1:8080](http://127.0.0.1:8080) and log in with `admin` / `admin` (reset password on first login).

---

## 6) Verification

### 6.1 Logs

```bash
kubectl -n sonarqube logs deploy/sonarqube | grep jdbc
```

Confirm that SonarQube uses the external PostgreSQL JDBC URL.

### 6.2 API Status

```bash
curl http://127.0.0.1:8080/api/system/status
```

Expected result: `UP`.

### 6.3 Database Check (users table)

```bash
SONAR_USER=$(kubectl -n sonarqube get secret postgres-secrets -o jsonpath='{.data.SONAR_USER}' | base64 -d)
SONAR_DB=$(kubectl -n sonarqube get secret postgres-secrets -o jsonpath='{.data.SONAR_DB}' | base64 -d)
SONAR_PASS=$(kubectl -n sonarqube get secret postgres-secrets -o jsonpath='{.data.SONAR_PASSWORD}' | base64 -d)

kubectl -n sonarqube exec -it sonardb-postgresql-0 -- bash -lc "
  export PGPASSWORD='${SONAR_PASS}';
  /opt/bitnami/postgresql/bin/psql -h 127.0.0.1 -U '${SONAR_USER}' -d '${SONAR_DB}' -c \"
    SELECT uuid, login, name, email, active, created_at, updated_at
    FROM users
    WHERE login ILIKE '%vikas%';
  \"
"
```

---

## 7) Persistence Test

1. Create a user in the SonarQube UI (e.g., `vikas-user`).
2. Restart SonarQube:

   ```bash
   kubectl -n sonarqube rollout restart statefulset/sonarqube-sonarqube
   ```
3. Re-check the database — the user should persist.
4. (Optional) Restart the PostgreSQL StatefulSet; PVC ensures data remains intact.

---

## 8) Final State ✅

* SonarQube (Community Edition) deployed and connected to external PostgreSQL.
* JDBC credentials managed via `sonarqube-jdbc` Secret.
* Monitoring passcode secured in a Secret.
* Persistence verified: user data survives application restarts and DB restarts.
