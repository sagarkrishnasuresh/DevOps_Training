# Docker Guide: Setting Up PostgreSQL Database and Spring Boot Application Containers

This guide outlines the step-by-step process to containerize a PostgreSQL database and a Spring Boot application, and link both containers for seamless communication.

## **1. Prerequisites**
Ensure you have the following installed on your system:
- Docker
- Maven (for building Spring Boot application)
- PostgreSQL client (optional, for testing database connection)

---

## **2. Step 1: Create and Run PostgreSQL Container**

### **2.1. Pull PostgreSQL Image**
```bash
docker pull postgres:15
```

### **2.2. Run PostgreSQL Container**
```bash
docker run -d \
  --name postgres-container \
  -e POSTGRES_USER=postgres \
  -e 'POSTGRES_PASSWORD=your_db_password' \
  -e POSTGRES_DB=docker_trials \
  -p 5432:5432 \
  postgres:15
```

### **2.3. Verify Database is Running**
```bash
docker ps
```
To connect to the PostgreSQL database inside the container:
```bash
docker exec -it postgres-container psql -U postgres -d docker_trials
```
To list all tables:
```sql
\dt
```

---

## **3. Step 2: Build and Run Spring Boot Application Container**

### **3.1. Update `application.properties`**
Modify `src/main/resources/application.properties` in your Spring Boot application to use the PostgreSQL container:
```properties
spring.datasource.url=jdbc:postgresql://postgres-container:5432/docker_trials
spring.datasource.username=postgres
spring.datasource.password=your_db_password
spring.datasource.driver-class-name=org.postgresql.Driver

server.port=8080

# JPA settings
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.database-platform=org.hibernate.dialect.PostgreSQLDialect
```

### **3.2. Build Spring Boot Application**
```bash
mvn clean package -DskipTests
```

### **3.3. Create a Dockerfile for Spring Boot Application**
Create a `Dockerfile` in the root of your Spring Boot project:
```dockerfile
FROM openjdk:17-jdk-slim
WORKDIR /app
COPY target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

### **3.4. Build Docker Image for Spring Boot**
```bash
docker build -t springboot-app .
```

### **3.5. Run Spring Boot Container**
```bash
docker run -d \
  --name springboot-container \
  -p 8080:8080 \
  --link postgres-container \
  springboot-app
```

### **3.6. Verify Containers**
Run:
```bash
docker ps
```
Ensure both `postgres-container` and `springboot-container` are running.

---

## **4. Step 3: Test API Endpoint**
Use `curl` to test the API:
```bash
curl -X POST http://localhost:8080/api/users \
  -H "Content-Type: application/json" \
  -d '{"name":"John Doe", "email":"john@example.com"}'
```
To fetch all users:
```bash
curl -X GET http://localhost:8080/api/users
```

---

## **5. Additional Commands**

### **Stop and Remove Containers**
```bash
docker stop springboot-container postgres-container
docker rm springboot-container postgres-container
```

### **Check Logs**
```bash
docker logs springboot-container
docker logs postgres-container
```

### **Access PostgreSQL Database**
```bash
docker exec -it postgres-container psql -U postgres -d docker_trials
```

---

## **6. Summary**
✅ Pulled PostgreSQL Image and Created Container
✅ Configured Spring Boot to Use PostgreSQL
✅ Built and Containerized Spring Boot Application
✅ Connected Both Containers and Verified Communication
✅ Successfully Tested the API

Your Spring Boot application and PostgreSQL database are now running in Docker containers and communicating with each other. 🚀

