# **PostgreSQL Environment Variable Mapping in Kubernetes and Spring Boot**

## **Overview**
When deploying a PostgreSQL database inside a Kubernetes environment using a Docker container, it is essential to use the correct **environment variables**. The PostgreSQL **official image** recognizes specific variable names for configuration. Using incorrect names can lead to initialization errors.

## **Correct Environment Variable Mapping**

### **1. PostgreSQL Recognized Environment Variables**
PostgreSQL requires specific environment variables inside the **container**:

| **Environment Variable**  | **Description** |
|----------------------|-------------|
| `POSTGRES_DB`       | The name of the default database to be created. |
| `POSTGRES_USER`     | The username for the PostgreSQL database. |
| `POSTGRES_PASSWORD` | The password for the PostgreSQL database. |

If these variables are missing or incorrect, PostgreSQL **will not initialize properly** and may throw errors such as:

```sh
Error: Database is uninitialized and superuser password is not specified.
```

### **2. Incorrect Variables (Why `DB_USER`, `DB_PASSWORD`, and `DB_URL` Won’t Work?)**
- PostgreSQL **does not recognize** `DB_USER` and `DB_PASSWORD`.
- `DB_URL` is **not needed inside the PostgreSQL container**.
- If incorrect variables are used, the database container **will crash** with an error.

---

## **Correct Usage in Kubernetes Deployment**

### **1. PostgreSQL Deployment (`postgres-deployment.yml`)**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: postgres
spec:
  replicas: 1
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
        - name: postgres
          image: postgres:latest
          ports:
            - containerPort: 5432
          env:
            - name: POSTGRES_DB
              valueFrom:
                secretKeyRef:
                  name: postgres-credentials
                  key: DB_NAME
            - name: POSTGRES_USER
              valueFrom:
                secretKeyRef:
                  name: postgres-credentials
                  key: DB_USER
            - name: POSTGRES_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: postgres-credentials
                  key: DB_PASSWORD
          volumeMounts:
            - mountPath: /var/lib/postgresql/data
              name: postgres-storage
      volumes:
        - name: postgres-storage
          emptyDir: {}
```

### **2. Spring Boot Application (`application.properties`)**
Spring Boot **does not use** `POSTGRES_USER`, `POSTGRES_PASSWORD`, or `POSTGRES_DB`. Instead, it expects database-related **JDBC configuration**:

```properties
spring.datasource.url=${DB_URL}
spring.datasource.username=${DB_USER}
spring.datasource.password=${DB_PASSWORD}
```

---

## **3. Creating Kubernetes Secrets for Secure Credentials Management**
Instead of exposing plain text credentials, Kubernetes **Secrets** should be used. Below is an **Ansible template (`kubernetes-secrets.yml.j2`)** for securely encoding credentials:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: postgres-credentials
type: Opaque
data:
  DB_NAME: {{ "docker_trials" | b64encode }}
  DB_USER: {{ POSTGRES_USER | b64encode }}
  DB_PASSWORD: {{ POSTGRES_PASSWORD | b64encode }}
  DB_URL: {{ "jdbc:postgresql://postgres-service:5432/docker_trials" | b64encode }}
```

After updating the template, apply it to Kubernetes:

```sh
kubectl apply -f /var/lib/jenkins/tmp/kubernetes-secrets.yml
```

---

## **4. Next Steps: Testing the Deployment**

### **Restart the PostgreSQL Pod**
```sh
kubectl delete pod postgres-XXXXX
```

### **Check Logs for Errors**
```sh
kubectl logs pod/postgres-XXXXX
```

### **Verify Connection from the Spring Boot Application**
```sh
kubectl exec -it user-management-XXXXX -- nc -vz postgres-service 5432
```

---

## **Conclusion**
- **PostgreSQL container requires** `POSTGRES_DB`, `POSTGRES_USER`, `POSTGRES_PASSWORD`.
- **Spring Boot needs** `DB_URL`, `DB_USER`, `DB_PASSWORD`.
- **Use Kubernetes Secrets** to store credentials securely.
- **Ensure correct variable mapping** in both PostgreSQL and Spring Boot configurations.
- **Restart PostgreSQL Pod** and **test connectivity** after deployment.

This ensures a secure and properly configured deployment of PostgreSQL with Spring Boot in Kubernetes. 🚀

