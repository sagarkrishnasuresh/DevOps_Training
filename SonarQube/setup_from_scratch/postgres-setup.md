# SonarQube + PostgreSQL on Kubernetes — Detailed Progress Log (up to Healthy Postgres)

This document captures **everything did** to bring up a secure, working PostgreSQL instance for SonarQube in the `sonarqube` namespace.

---

## 0) Context & Goals

* Deploy **external PostgreSQL** (Bitnami chart) in **`sonarqube`** namespace.
* Keep credentials in **Kubernetes Secrets**, not in Helm values.
* Use **init script(s)** to ensure `sonarqube` database and `sonar` role exist (idempotent).
* Verify DB readiness from within the cluster.
* Capture common **troubleshooting** patterns we hit and how we fixed them.

> We will finish Postgres first, then will wire SonarQube to it.

---

## 1) Files & Folder Structure (on bastion)

We need a standardized home for all artifacts:

```bash
mkdir -p ~/sonarqube/postgres/init-scripts
# (SonarQube values/configs will go in ~/sonarqube/sonarqube later)
```

**Why:** consistent layout → repeatable operations and simple `kubectl --from-file` usage.

---

## 2) Create / Reset Namespace

Fresh start to avoid drift from previous experiments:

```bash
kubectl delete ns sonarqube --ignore-not-found
kubectl create ns sonarqube
```

**Why:** cleans orphan objects (PVC/ConfigMap/Secrets/workloads). A truly clean slate.

---

## 3) Secrets — What, Why, and How

We need to create two secrets **upfront**. A third will be created after PG is ready.

### 3.1 `postgres-secrets` (DB credentials used by chart + scripts)

Holds all credentials used by Postgres and our init script.

* `POSTGRES_PASSWORD` → superuser password
* `SONAR_USER` → app db user (we use `sonar`)
* `SONAR_PASSWORD` → app db user password
* `SONAR_DB` → db name for SonarQube (we use `sonarqube`)

**Creation (example with your own values):**

```bash
kubectl -n sonarqube create secret generic postgres-secrets \
  --from-literal=POSTGRES_PASSWORD='<admin-strong-pass>' \
  --from-literal=SONAR_USER='sonar' \
  --from-literal=SONAR_PASSWORD='<app-strong-pass>' \
  --from-literal=SONAR_DB='sonarqube'
```

**Why:** charts reference this secret to avoid hardcoding passwords in values files. Our init script also reads these via env.

**Retrieve later (when needed):**

```bash
kubectl -n sonarqube get secret postgres-secrets -o json | jq -r '.data | keys[]'
# then decode, e.g.
kubectl -n sonarqube get secret postgres-secrets \
  -o jsonpath='{.data.SONAR_PASSWORD}' | base64 -d; echo
```

### 3.2 `sonarqube-monitoring-passcode` (for SonarQube — created now, used later)

```bash
METRICS_PASS=$(openssl rand -hex 24)
kubectl -n sonarqube create secret generic sonarqube-monitoring-passcode \
  --from-literal=monitoring-passcode="$METRICS_PASS"
```

**Why:** the SonarQube chart can protect monitoring endpoints with a passcode.

### 3.3 `sonarqube-jdbc` (JDBC details for SonarQube — **create later**)

We will create this after Postgres is confirmed healthy (contains `url`, `username`, `password`).

---

## 4) Init Script — Idempotent DB/Role Provisioning

Place the script in our folder; the Bitnami chart mounts it via ConfigMap and runs it on **first** bootstrap.

**File:** `~/sonarqube/postgres/init-scripts/10-create-sonar.sh`

```bash
#!/bin/bash
set -euo pipefail

# Expected env vars (injected via chart extraEnvVars):
#   SONAR_USER, SONAR_PASSWORD, SONAR_DB, POSTGRES_PASSWORD

export PGPASSWORD="${POSTGRES_PASSWORD}"

# 1) Ensure the role exists (safe inside DO block)
psql -v ON_ERROR_STOP=1 -U postgres -d postgres -c "
DO
$$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '${SONAR_USER}') THEN
    CREATE ROLE ${SONAR_USER} LOGIN PASSWORD '${SONAR_PASSWORD}';
  END IF;
END
$$;
"

# 2) Create database if missing (MUST be outside transaction/DO)
DB_EXISTS=$(psql -U postgres -d postgres -Atc "SELECT 1 FROM pg_database WHERE datname='${SONAR_DB}'")
if [ -z "${DB_EXISTS}" ]; then
  psql -U postgres -d postgres -c "CREATE DATABASE ${SONAR_DB} OWNER ${SONAR_USER};"
fi

# 3) Ensure ownership/privileges (idempotent)
psql -U postgres -d postgres -c "ALTER DATABASE ${SONAR_DB} OWNER TO ${SONAR_USER};"
psql -U postgres -d "${SONAR_DB}" -c "GRANT ALL ON SCHEMA public TO ${SONAR_USER};"
```

**Why this structure:** `CREATE DATABASE` is illegal in a transaction (hence not inside `DO`). Role logic can live inside `DO` safely. We export `PGPASSWORD` so `psql` auth works without prompting.

**Create ConfigMap from the folder:**

```bash
kubectl -n sonarqube create configmap sonardb-init \
  --from-file=/home/ubuntu/sonarqube/postgres/init-scripts/ \
  --dry-run=true -o yaml | kubectl apply -f -
```

> We initially saw `configmap "sonardb-init" not found` in Events (pod stuck in `ContainerCreating`). Creating the ConfigMap fixed it.

---

## 5) Helm Values — PostgreSQL (Bitnami chart)

**File:** `~/sonarqube/postgres/values-postgres.yaml`

```yaml
# Map our secret keys so chart never stores plaintext
auth:
  existingSecret: postgres-secrets
  secretKeys:
    adminPasswordKey: POSTGRES_PASSWORD   # superuser
    userPasswordKey: SONAR_PASSWORD       # app user password
    usernameKey: SONAR_USER               # app user name
    databaseKey: SONAR_DB                 # app database name

primary:
  persistence:
    enabled: true
    existingClaim: ""                     # fresh dynamic PVC
    size: 10Gi
    storageClass: gp3-expand              # or omit to use cluster default

  initdb:
    scriptsConfigMap: sonardb-init        # run our script(s) on bootstrap

  # Env passed to our script
  extraEnvVars:
    - name: SONAR_USER
      valueFrom: { secretKeyRef: { name: postgres-secrets, key: SONAR_USER } }
    - name: SONAR_DB
      valueFrom: { secretKeyRef: { name: postgres-secrets, key: SONAR_DB } }
    - name: SONAR_PASSWORD
      valueFrom: { secretKeyRef: { name: postgres-secrets, key: SONAR_PASSWORD } }
    - name: POSTGRES_PASSWORD
      valueFrom: { secretKeyRef: { name: postgres-secrets, key: POSTGRES_PASSWORD } }

  resources:
    requests:
      cpu: 250m
      memory: 512Mi
    limits:
      cpu: "1"
      memory: 1Gi

service:
  type: ClusterIP
  port: 5432
```

**Why these keys matter:**

* `auth.existingSecret` + `secretKeys` → chart picks up our creds securely.
* `persistence` → data durability; `existingClaim` left blank so Helm makes a new PVC.
* `initdb.scriptsConfigMap` → runs our provisioning once (idempotent).
* `extraEnvVars` → supplies creds to the script.

**About `existingClaim`:**

* Leave **empty** for a clean install → chart creates a new PVC (e.g., `data-sonardb-postgresql-0`).
* Set to an existing PVC name to **reuse** data across reinstalls.

---

## 6) Install/Upgrade PostgreSQL and Watch

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

helm upgrade --install sonardb bitnami/postgresql \
  -n sonarqube -f ~/sonarqube/postgres/values-postgres.yaml

kubectl -n sonarqube rollout status statefulset/sonardb-postgresql
kubectl -n sonarqube get pods,svc,pvc
```

---

## 7) Troubleshooting We Did (and Fixes)

### 7.1 Pod stuck `ContainerCreating` with `FailedMount` for ConfigMap

**Symptom (Events):**

```
Warning  FailedMount  MountVolume.SetUp failed for volume "custom-init-scripts" : configmap "sonardb-init" not found
```

**Fix:** Create the ConfigMap (Section 4) and delete the pod to re-mount:

```bash
kubectl -n sonarqube delete pod sonardb-postgresql-0
```

### 7.2 `CREATE DATABASE cannot be executed from a function`

**Symptom (Logs):**

```
ERROR:  CREATE DATABASE cannot be executed from a function
CONTEXT:  SQL statement "CREATE DATABASE sonarqube OWNER sonar"
```

**Fix:** Move `CREATE DATABASE` out of the `DO $$ ... $$;` block (see final script in Section 4), export `PGPASSWORD` for auth.

### 7.3 `psql: command not found`

**Symptom:** Running `psql` inside the Bitnami container failed via PATH.
**Fix:** Use full path: `/opt/bitnami/postgresql/bin/psql`.

### 7.4 Attempted to run `kubectl` inside ephemeral client pod

**Symptom:** `kubectl: not found` when composing commands inside the container.
**Fix:** Resolve secrets on the bastion first, then pass environment variables into the client pod, or exec into the Postgres pod and run `psql` there.

### 7.5 StorageClass questions (when PVC Pending)

* Confirm available storage classes:

  ```bash
  kubectl get storageclass
  ```
* Use an existing one (e.g., `gp3-expand`) in values; or omit to use the default.

---

## 8) Health Verification (What We Ran)

**From the Postgres pod:**

```bash
SONAR_USER=$(kubectl -n sonarqube get secret postgres-secrets -o jsonpath='{.data.SONAR_USER}' | base64 -d)
SONAR_DB=$(kubectl -n sonarqube get secret postgres-secrets -o jsonpath='{.data.SONAR_DB}' | base64 -d)
SONAR_PASSWORD=$(kubectl -n sonarqube get secret postgres-secrets -o jsonpath='{.data.SONAR_PASSWORD}' | base64 -d)

kubectl -n sonarqube exec -it sonardb-postgresql-0 -- bash -lc "
  export PGPASSWORD='${SONAR_PASSWORD}';
  /opt/bitnami/postgresql/bin/psql -h 127.0.0.1 -U '${SONAR_USER}' -d '${SONAR_DB}' -c '\\l'
"
```

**Expected output (simplified):**

```
   Name     | Owner | Encoding
----------- + ----- + --------
 sonarqube  | sonar | UTF8
 postgres   | ...
 template0  | ...
 template1  | ...
```

**Conclusion:** Postgres is healthy; `sonarqube` DB exists and is owned by `sonar`.

---

## 9) (Optional) NetworkPolicy to Restrict Access

Allow only SonarQube pods to reach Postgres on 5432.

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: sonardb-allow-from-sonarqube
  namespace: sonarqube
spec:
  podSelector:
    matchLabels:
      app.kubernetes.io/name: postgresql
      app.kubernetes.io/instance: sonardb
      app.kubernetes.io/component: primary
  policyTypes: [Ingress]
  ingress:
    - from:
        - podSelector:
            matchLabels:
              app.kubernetes.io/name: sonarqube
              app.kubernetes.io/instance: sonarqube
      ports:
        - protocol: TCP
          port: 5432
```

Apply when ready:

```bash
kubectl apply -f ~/sonarqube/postgres/postgres-netpol.yaml
```

---

## 10) Current State ✅

* Namespace: **created and clean**
* Secrets: **`postgres-secrets`**, **`sonarqube-monitoring-passcode`** (ready)
* ConfigMap: **`sonardb-init`** with idempotent init script
* Helm: **Bitnami PostgreSQL** installed as `sonardb`
* PVC: dynamically provisioned and bound
* Pod: `sonardb-postgresql-0` **Running**
* Database: `sonarqube` owned by `sonar` **verified**

> You can now proceed to SonarQube installation with confidence that Postgres is healthy and reachable.
Proceed to the [SonarQube Setup](./sonarqube-setup.md) to setup Sonarqube and wire PostgreSQL with it.