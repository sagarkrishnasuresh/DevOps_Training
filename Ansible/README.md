# **Tutorial: Deploying a Spring Boot Application with PostgreSQL using Ansible and Docker**

## **Introduction**
This tutorial provides step-by-step guidance on deploying a containerized Spring Boot application with a PostgreSQL database to a remote system using **Ansible** and **Docker**.

## **Prerequisites**
1. A **remote system** with **SSH access**.
2. Ansible installed on the local machine.
3. Docker installed on both local and remote systems.
4. A **Spring Boot application** built as a JAR file.
5. A **Dockerfile** to containerize the Spring Boot application.

---

## **1️⃣ Preparing the Remote System**
Before deploying, ensure that the remote system has Docker installed and is accessible via SSH.

### **Steps:**
1. Connect to the remote system using SSH:
   ```bash
   ssh user@remote-ip-address
   ```
2. Install **Docker** on the remote system:
   ```bash
   sudo apt update
   sudo apt install -y docker.io
   ```
3. Verify Docker installation:
   ```bash
   docker --version
   ```
4. Ensure Docker is running:
   ```bash
   sudo systemctl start docker
   sudo systemctl enable docker
   ```

---

## **2️⃣ Preparing the Ansible Playbook**
An **Ansible Playbook** automates the deployment process. Below is the YAML script to deploy the Spring Boot application and PostgreSQL database.

### **File: `deploy_springboot_no_compose.yml`**
```yaml
- name: Deploy Spring Boot and PostgreSQL Containers (Without Docker Compose)
  hosts: remote
  become: yes  # Run as sudo/root
  vars:
    project_dir: /home/ssagarkrishna/Desktop/dockertrials
    jar_file: dockertrials-0.0.1-SNAPSHOT.jar  # Corrected filename

  tasks:
    - name: Install Docker
      apt:
        name: docker.io
        state: present
        update_cache: yes

    - name: Ensure Docker service is running
      service:
        name: docker
        state: started
        enabled: yes

    - name: Install Docker Python SDK
      pip:
        name: docker
        state: present

    - name: Pull PostgreSQL Image
      docker_image:
        name: postgres:15
        source: pull

    - name: Create project directory if not exists
      file:
        path: "{{ project_dir }}"
        state: directory
        mode: '0755'

    - name: Copy Dockerfile to remote machine
      copy:
        src: "{{ project_dir }}/Dockerfile"
        dest: "{{ project_dir }}/Dockerfile"
        mode: '0644'

    - name: Copy JAR file to remote machine
      copy:
        src: "{{ project_dir }}/target/{{ jar_file }}"
        dest: "{{ project_dir }}/app.jar"
        mode: '0755'

    - name: Remove existing PostgreSQL container (if exists)
      docker_container:
        name: postgres-container
        state: absent
      ignore_errors: yes

    - name: Start PostgreSQL Container
      docker_container:
        name: postgres-container
        image: postgres:15
        state: started
        restart_policy: always
        env:
          POSTGRES_USER: "postgres"
          POSTGRES_PASSWORD: "db_password"
          POSTGRES_DB: "db_name"
        ports:
          - "5432:5432"

    - name: Remove existing Spring Boot container (if exists)
      docker_container:
        name: springboot-container
        state: absent
      ignore_errors: yes

    - name: Build Spring Boot Docker Image
      docker_image:
        name: springboot-app
        build:
          path: "{{ project_dir }}"
          dockerfile: "{{ project_dir }}/Dockerfile"
        source: build

    - name: Start Spring Boot Container
      docker_container:
        name: springboot-container
        image: springboot-app
        state: started
        restart_policy: always
        links:
          - postgres-container
        ports:
          - "8080:8080"
        env:
          SPRING_DATASOURCE_URL: "jdbc:postgresql://postgres-container:5432/db_name"
          SPRING_DATASOURCE_USERNAME: "postgres"
          SPRING_DATASOURCE_PASSWORD: "db_password"
```

---

## **3️⃣ Configuring the Dockerfile**
A **Dockerfile** is required to containerize the Spring Boot application.

### **File: `Dockerfile`**
```dockerfile
FROM openjdk:17-jdk-slim
WORKDIR /app
COPY app.jar app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
```

---

## **4️⃣ Running the Ansible Playbook**
### **1. Define Remote Hosts**
Edit **`/etc/ansible/hosts`** to add the remote system:
```ini
[remote]
remote-ip-address ansible_user=username ansible_ssh_private_key_file=~/.ssh/private_key_file
```

### **2. Execute the Playbook**
Run the Ansible Playbook to deploy the application:
```bash
ansible-playbook deploy_springboot_no_compose.yml
```

### **3. Verify Deployment**
Check if the containers are running on the remote system:
```bash
ssh user@remote-ip-address
sudo docker ps
```

If both `postgres-container` and `springboot-container` are running, your deployment was successful!

### **4. Test the API**
```bash
curl -X POST http://remote-ip-address:8080/api/users \
-H "Content-Type: application/json" \
-d '{"name":"John Doe", "email":"john@example.com"}'
```

---

## **✅ Summary**
- Installed Docker on the remote system.
- Configured Ansible to automate deployment.
- Pulled and ran PostgreSQL container.
- Copied the Spring Boot JAR file to the remote machine.
- Built the Spring Boot Docker image and ran the container.
- Verified that the deployment was successful.

This tutorial provides a structured approach to **deploying a Spring Boot application with PostgreSQL using Ansible and Docker (without Docker Compose)**. 🚀

---

## **💡 Next Steps**
- Automate further with CI/CD pipelines.
- Explore container orchestration using Kubernetes.
- Secure Ansible Playbooks using vaults for sensitive information.

**Congratulations on completing your deployment! 🎉**

