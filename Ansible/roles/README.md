### README: Deploying Spring Boot & PostgreSQL with Ansible Roles

#### 📌 Overview
This repository contains an **Ansible-based automation setup** to deploy a **Spring Boot** application with **PostgreSQL**, using **Docker** without `docker-compose`. The deployment is organized using **Ansible roles**, making it modular and reusable.

---

## 💁️ Project Structure

```
├── ansible/
│   ├── roles/
│   │   ├── environment_setup/  # Installs Docker, pip, and dependencies
│   │   │   ├── tasks/main.yml
│   │   ├── database_container_setup/  # Pulls PostgreSQL and runs a container
│   │   │   ├── tasks/main.yml
│   │   ├── springboot_app/  # Copies JAR, builds image, and runs Spring Boot container
│   │   │   ├── tasks/main.yml
│   ├── inventory  # Inventory file defining remote hosts and private key
│   ├── deploy_springboot_no_compose.yml  # Main playbook
│   ├── README.md  # Documentation
│   ├── Dockerfile  # Dockerfile for Spring Boot application
│   ├── target/dockertrials-0.0.1-SNAPSHOT.jar  # Compiled Spring Boot JAR
```

---

## 🔧 Prerequisites

- Ansible installed on the control machine (`ansible --version` to check)
- Remote machine accessible via SSH with a private key
- Docker installed on the remote machine (handled by Ansible)
- A compiled JAR file (`target/dockertrials-0.0.1-SNAPSHOT.jar`) available on the control machine

---

## 🔑 Inventory File (`inventory`)

Define the **remote server** and **private key** for SSH authentication:

```ini
[remote]
<remote-ip-address> ansible_user=your_username ansible_ssh_private_key_file=<Path to SSH private key>
```

---

## 🚀 Running the Playbook

Execute the Ansible playbook with:

```sh
ansible-playbook deploy_springboot_no_compose.yml -i inventory --ask-become-pass
```

- `-i inventory` → Specifies the inventory file
- `--ask-become-pass` → Prompts for `sudo` password when required

---

## 🔧 Ansible Roles Breakdown

### 🔹 1. `environment_setup` (Installs dependencies)
Located at `roles/environment_setup/tasks/main.yml`
```yaml
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

- name: Install pip
  apt:
    name: python3-pip
    state: present

- name: Install Docker Python SDK
  pip:
    name: docker
    state: present
```

---

### 🔹 2. `database_container_setup` (Sets up PostgreSQL)
Located at `roles/database_container_setup/tasks/main.yml`
```yaml
- name: Pull PostgreSQL Image
  docker_image:
    name: postgres:15
    source: pull

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
      POSTGRES_PASSWORD: "postgres_password"
      POSTGRES_DB: "docker_trials"
    ports:
      - "5432:5432"
```

---

### 🔹 3. `springboot_app` (Deploys Spring Boot)
Located at `roles/springboot_app/tasks/main.yml`
```yaml
- name: Ensure project directory exists
  file:
    path: "{{ project_dir }}"
    state: directory
    mode: '0755'

- name: Copy Dockerfile to remote machine
  copy:
    src: "/home/ssagarkrishna/Desktop/dockertrials/Dockerfile"
    dest: "{{ project_dir }}/Dockerfile"
    mode: '0644'

- name: Copy JAR file to remote machine
  copy:
    src: "/home/ssagarkrishna/Desktop/dockertrials/target/{{ jar_file }}"
    dest: "{{ project_dir }}/app.jar"
    mode: '0755'

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
      SPRING_DATASOURCE_URL: "jdbc:postgresql://postgres-container:5432/docker_trials"
      SPRING_DATASOURCE_USERNAME: "postgres"
      SPRING_DATASOURCE_PASSWORD: "postgres_password"
```

---

## 🛠️ Debugging Tips

1. **Check inventory setup**
   ```sh
   ansible-inventory -i inventory --list
   ```

2. **Verify SSH Connection**
   ```sh
   ansible all -i inventory -m ping
   ```

3. **Run Playbook with Detailed Logs**
   ```sh
   ansible-playbook deploy_springboot_no_compose.yml -i inventory -vvv --ask-become-pass
   ```

---

🛠 **Now, your Spring Boot application with PostgreSQL is deployed using Ansible roles!**

