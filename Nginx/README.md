# 📖 Understanding NGINX: A Beginner's Guide

## ✅ **1. What is NGINX?**
NGINX is a high-performance, open-source web server and reverse proxy server. It is commonly used for:
- Serving static content
- Load balancing
- Reverse proxying
- Securing applications

---

## 💡 **2. Installation of NGINX**

### 🐧 **On Ubuntu:**
```bash
sudo apt update
sudo apt install nginx
```

### 🚀 **Start and Enable NGINX:**
```bash
sudo systemctl start nginx
sudo systemctl enable nginx
```

### ✅ **Check NGINX Status:**
```bash
sudo systemctl status nginx
```

### 🌍 **Access NGINX:**
Open a browser and go to:
```
http://localhost
```
You should see the **"Welcome to NGINX"** page.

---

## 🗂️ **3. NGINX Configuration Files**

- The main configuration file is located at:
```bash
/etc/nginx/nginx.conf
```

- Site-specific configurations are located in:
```bash
/etc/nginx/sites-available
/etc/nginx/sites-enabled
```

- Default site configuration file:
```bash
/etc/nginx/sites-available/default
```

---

## 🌐 **4. Basic NGINX Configuration**
```nginx
server {
    listen 80;
    server_name localhost;

    location / {
        root /var/www/html;
        index index.html index.htm;
    }
}
```

---

## 🔁 **5. Restart NGINX**
```bash
sudo nginx -t   # Test configuration for syntax errors
sudo systemctl reload nginx
sudo systemctl restart nginx
```

---

## 💎 **6. Reverse Proxy Configuration**
```nginx
server {
    listen 80;

    location /api/users/ {
        proxy_pass http://localhost:8080/api/users;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /api/orders/ {
        proxy_pass http://localhost:8082/api/orders;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

- **`proxy_pass`**: Forwards requests to backend servers
- **`proxy_set_header`**: Sets request headers

---

## 📋 **7. Log Files**
- Access log:
```bash
/var/log/nginx/access.log
```

- Error log:
```bash
/var/log/nginx/error.log
```

Use `tail` to monitor logs in real-time:
```bash
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log
```

---

## 🌍 **8. Useful Commands**
```bash
sudo nginx -t               # Test config
sudo systemctl reload nginx # Reload without downtime
sudo systemctl restart nginx # Restart NGINX
sudo systemctl stop nginx    # Stop NGINX
sudo systemctl status nginx  # Check NGINX status
```

---

## 📦 **9. NGINX with Docker Containers**
Use NGINX to route requests to **Dockerized** Spring Boot applications:
```nginx
location /api/users/ {
    proxy_pass http://springboot-container:8080/api/users;
}

location /api/orders/ {
    proxy_pass http://orders-service:8082/api/orders;
}
```

---

## ⚡ **10. Troubleshooting**
- **Check Syntax:** Ensure there are no typos using `sudo nginx -t`
- **Check Logs:** Use `sudo tail -f /var/log/nginx/error.log` for debugging
- **Firewall Issues:** Allow NGINX through the firewall
```bash
sudo ufw allow 'Nginx Full'
sudo ufw enable
```

---

## 📝 **11. Best Practices**
✔ Always test configurations before restarting NGINX
✔ Use separate files for each site in `/sites-available`
✔ Enable sites using symbolic links in `/sites-enabled`
✔ Monitor logs for errors and access patterns

---

## 📦 **12. Conclusion**
NGINX is essential for modern web applications, offering powerful features like **reverse proxying**, **load balancing**, and **security enhancements**. Understanding its configuration and commands is key to optimizing web performance.

✅ Now you're ready to use NGINX for **Spring Boot microservices** deployed with **Docker and Ansible**! 🚀

