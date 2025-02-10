# Docker Installation Guide

## Steps to Install Docker on Ubuntu

### **1. Remove Old Versions of Docker**
Run the following command to remove any previously installed versions of Docker:
```bash
sudo apt-get remove docker docker.io containerd runc
```
This ensures no conflicts with older versions of Docker.

---

### **2. Update Package Index**
Update your system’s package list to fetch the latest versions of packages and dependencies:
```bash
sudo apt-get update
```

---

### **3. Install Docker**
Use the following command to install Docker:
```bash
sudo apt-get install -y docker.io
```

---

### **4. Start and Enable Docker Service**
Start the Docker service and configure it to run on system boot:
```bash
sudo systemctl start docker
sudo systemctl enable docker
```

---

### **5. Verify Docker Installation**
Check the installed Docker version to ensure it’s installed correctly:
```bash
docker --version
```
Expected output:
```
Docker version X.Y.Z, build XXXXXXX
```

---

### **6. Test Docker Installation**
Run a test container to verify Docker is working:
```bash
sudo docker run hello-world
```
Expected output:
```
Hello from Docker!
This message shows that your installation appears to be working correctly.
```

---

## Common Docker Commands (Basics Learned)

### **List Running Containers**
```bash
docker ps
```

### **List All Containers (Including Stopped)**
```bash
docker ps -a
```

### **Stop a Container**
```bash
docker stop <container-id>
```

### **Remove a Container**
```bash
docker rm <container-id>
```

---

## Next Steps
Once Docker is installed, explore:
1. **Running Additional Containers**.
2. **Learning Dockerfile Basics** to build custom images.
3. **Using Docker with CI/CD Tools**.

---

**Author**: Sagarkrishna Suresh  
**Last Updated**: February 7, 2025

