# Building and Running a Java Application Container with Docker

This guide outlines the steps to containerize and run a Java application using Docker.

---

## **1. Prepare Your Java Application**
1. Ensure your Java application is ready to build:
    - If using Maven, ensure a `pom.xml` file is present.
    - If using Gradle, ensure a `build.gradle` file is present.

2. Navigate to your project directory:
   ```bash
   cd /path/to/your/java-application
   ```

3. Build the application to create a `.jar` file:
    - **For Maven**:
      ```bash
      ./mvnw clean package
      ```
    - **For Gradle**:
      ```bash
      ./gradlew build
      ```
    - The `.jar` file will be created in the `target/` or `build/libs/` directory.

4. Verify the JAR file:
   ```bash
   ls target/*.jar
   ```

---

## **2. Write a Dockerfile**
1. In the root of your Java application project, create a file named `Dockerfile`:
   ```bash
   nano Dockerfile
   ```

2. Add the following content to the `Dockerfile`:
   ```dockerfile
   # Use a lightweight Java runtime as the base image
   FROM openjdk:17-jdk-slim

   # Set the working directory inside the container
   WORKDIR /app

   # Copy the built JAR file into the container
   COPY target/*.jar app.jar

   # Expose the application port
   EXPOSE 8080

   # Command to run the application
   CMD ["java", "-jar", "app.jar"]
   ```

3. Save the file and exit.

---

## **3. Build the Docker Image**
1. Build the image using the `Dockerfile`:
   ```bash
   docker build -t my-java-app .
   ```
    - `-t my-java-app`: Tags the image with the name `my-java-app`.
    - `.`: Refers to the current directory where the `Dockerfile` is located.

2. Verify the image:
   ```bash
   docker images
   ```
   Example output:
   ```
   REPOSITORY       TAG       IMAGE ID       CREATED          SIZE
   my-java-app      latest    a1b2c3d4e5f6   10 seconds ago   428MB
   ```

---

## **4. Run the Docker Container**
1. Start the container:
   ```bash
   docker run -d -p 8080:8080 --name my-java-container my-java-app
   ```
    - `-d`: Runs the container in detached mode (background).
    - `-p 8080:8080`: Maps the container’s port 8080 to your local port 8080.
    - `--name my-java-container`: Names the container `my-java-container`.

2. Verify the running container:
   ```bash
   docker ps
   ```
   Example output:
   ```
   CONTAINER ID   IMAGE          COMMAND               PORTS                    NAMES
   abcd1234efgh   my-java-app    "java -jar app.jar"   0.0.0.0:8080->8080/tcp   my-java-container
   ```

---

## **5. Test the Application**
1. Open a browser or use `curl` to test the application:
   ```bash
   curl http://localhost:8080
   ```

2. You should get the expected output from your Java application.

---

## **6. Manage the Container**
- **Stop the Container**:
  ```bash
  docker stop my-java-container
  ```

- **Restart the Container**:
  ```bash
  docker start my-java-container
  ```

- **Remove the Container**:
  ```bash
  docker rm my-java-container
  ```

- **Remove the Image**:
  ```bash
  docker rmi my-java-app
  ```

---

## **Summary of Commands**
| **Step**            | **Command**                                    | **Description**                          |
|----------------------|-----------------------------------------------|------------------------------------------|
| Build the JAR        | `./mvnw clean package`                       | Creates the `.jar` file.                 |
| Create Dockerfile    | `nano Dockerfile`                            | Specifies instructions for the image.    |
| Build the Image      | `docker build -t my-java-app .`              | Builds the Docker image.                 |
| Run the Container    | `docker run -d -p 8080:8080 my-java-app`     | Runs the container.                      |
| Test Application     | `curl http://localhost:8080`                 | Tests the application.                   |
| Stop the Container   | `docker stop my-java-container`              | Stops the container.                     |
| Remove the Container | `docker rm my-java-container`                | Removes the container.                   |
| Remove the Image     | `docker rmi my-java-app`                     | Deletes the Docker image.                |

---

Follow these steps to containerize and run your Java application using Docker! 🚀
