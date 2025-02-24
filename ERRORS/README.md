# 🛑 Errors Encountered During Deployment

### 🚀 Deployment Stack:
- **Applications:** Spring Boot (User Management & Order Management)
- **Tools:** Jenkins, Ansible, Docker, Minikube, Kubernetes
- **Security:** Ansible Vault, Kubernetes Secrets

---

## 1. Docker Login Error
**Error:**
```
docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
Error: Login failed due to incorrect credentials.
```
**Cause:** Docker credentials were not properly set in Jenkins or Ansible Vault.
**Solution:**
- Added Docker credentials in `defaults/main.yml` of Ansible roles (`user_management` and `order_management`).
- Encrypted the file using Ansible Vault:
```bash
ansible-vault encrypt defaults/main.yml
```

---

## 2. Permission Denied While Removing Files in Ansible
**Error:**
```
rm: cannot remove '/tmp/kubernetes-secrets.yml': Operation not permitted
```
**Cause:** Jenkins user did not have permissions to delete files in `/tmp`.
**Solution:**
- Changed Ansible task to use a directory owned by Jenkins:
```yaml
dest: /var/lib/jenkins/tmp/kubernetes-secrets.yml
```
- Created the directory using Jenkins pipeline:
```groovy
sh 'mkdir -p /var/lib/jenkins/tmp'
```
- Set ownership and permissions:
```bash
sudo chown -R jenkins:jenkins /var/lib/jenkins/tmp
sudo chmod 755 /var/lib/jenkins/tmp
```

---

## 3. Docker Image Build Error - File Not Found
**Error:**
```
COPY failed: file not found in build context or excluded by .dockerignore: stat app.jar: file does not exist
```
**Cause:** The JAR file was not present in the Docker build context.
**Solution:**
- Added Maven build step before Docker build to ensure `app.jar` was generated:
```groovy
sh 'mvn clean package -DskipTests'
```
- Ensured the JAR file was correctly copied in the Dockerfile:
```Dockerfile
COPY target/app.jar app.jar
```

---

## 4. Kubernetes Configuration File Permission Error
**Error:**
```
error loading config file "/var/lib/jenkins/.kube/config": permission denied
```
**Cause:** Jenkins user did not have permission to access the Kubernetes config file.
**Solution:**
- Created a user group named `kubeaccess` and added Jenkins and the main user:
```bash
sudo groupadd kubeaccess
sudo usermod -aG kubeaccess jenkins
sudo usermod -aG kubeaccess sagarkrishna
```
- Set permissions for Kubernetes config:
```bash
sudo chown sagarkrishna:kubeaccess ~/.kube/config
sudo chmod 664 ~/.kube/config
```
- Ensured permissions took effect:
```bash
sudo systemctl restart jenkins
```

---

## 5. Jenkins Pipeline Error - Missing Tool Configuration
**Error:**
```
Tool type "maven" does not have an install of "Maven3" configured
```
**Cause:** The Jenkins pipeline was referencing a Maven installation name that was not configured.
**Solution:**
- Configured Maven in Jenkins:
    - Go to **Jenkins Dashboard > Manage Jenkins > Global Tool Configuration**
    - Under **Maven**, added a Maven installation named **Maven3**
- Updated the Jenkinsfile:
```groovy
tools {
    maven 'Maven3'
}
```

---

## 6. Kubernetes Secrets Not Found
**Error:**
```
Error from server (Forbidden): Authentication required
```
**Cause:** Kubernetes Secrets were not applied, or permissions were missing.
**Solution:**
- Created Kubernetes Secrets using Ansible:
```yaml
- name: Apply PostgreSQL Secrets in Kubernetes
  command: kubectl apply -f /var/lib/jenkins/tmp/kubernetes-secrets.yml
```
- Ensured that the Kubernetes Secret was correctly referenced in the deployment manifests:
```yaml
envFrom:
  - secretRef:
      name: postgres-credentials
```

---

## 7. Docker Image Not Found in Kubernetes (ImagePullBackOff)
**Error:**
```
ImagePullBackOff
```
**Cause:** Kubernetes could not pull Docker images from Docker Hub.
**Solution:**
- Verified that Docker images were successfully pushed:
```bash
docker images
docker push sagarkrishnasuresh/user_management:latest
docker push sagarkrishnasuresh/order_management:latest
```
- Corrected the image name in Kubernetes deployment manifests:
```yaml
image: sagarkrishnasuresh/user_management:latest
```

---
