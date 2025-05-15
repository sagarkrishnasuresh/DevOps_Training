# ✅ JaCoCo Code Coverage Integration Guide for Java + Spring Boot (Maven)

This guide explains how to configure **JaCoCo** to measure code coverage in a Java + Spring Boot application using **Maven**.

---

## 📦 1. Required Dependencies

Make sure the following **JUnit** test dependencies are added under the `<dependencies>` section of your `pom.xml`:

```xml
<!-- Spring Boot Test Starter -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-test</artifactId>
    <scope>test</scope>
</dependency>

<!-- JUnit Jupiter API and Engine -->
<dependency>
    <groupId>org.junit.jupiter</groupId>
    <artifactId>junit-jupiter-api</artifactId>
    <version>5.9.2</version>
    <scope>test</scope>
</dependency>

<dependency>
    <groupId>org.junit.jupiter</groupId>
    <artifactId>junit-jupiter-engine</artifactId>
    <version>5.9.2</version>
    <scope>test</scope>
</dependency>

<!-- (Optional) Enable older JUnit 4 test compatibility -->
<dependency>
    <groupId>org.junit.vintage</groupId>
    <artifactId>junit-vintage-engine</artifactId>
    <version>5.9.2</version>
    <scope>test</scope>
</dependency>
```

---

## 💪 2. Add JaCoCo Plugin

Include the **JaCoCo Maven plugin** inside the `<build><plugins>` section of your `pom.xml`:

```xml
<plugin>
    <groupId>org.jacoco</groupId>
    <artifactId>jacoco-maven-plugin</artifactId>
    <version>0.8.8</version>
    <configuration>
        <includes>
            <include>com/igot/cb/*</include>
            <include>com/igot/cb/**/*</include>
        </includes>
        <rules>
            <rule>
                <element>BUNDLE</element>
                <limits>
                    <limit>
                        <counter>INSTRUCTION</counter>
                        <value>COVEREDRATIO</value>
                        <minimum>0.30</minimum>
                    </limit>
                    <limit>
                        <counter>BRANCH</counter>
                        <value>COVEREDRATIO</value>
                        <minimum>0.20</minimum>
                    </limit>
                </limits>
            </rule>
        </rules>
    </configuration>
    <executions>
        <!-- Attach agent before running tests -->
        <execution>
            <goals>
                <goal>prepare-agent</goal>
            </goals>
        </execution>

        <!-- Generate coverage report after tests -->
        <execution>
            <id>report</id>
            <phase>test</phase>
            <goals>
                <goal>report</goal>
            </goals>
        </execution>

        <!-- Enforce coverage check (optional) -->
        <execution>
            <id>check</id>
            <goals>
                <goal>check</goal>
            </goals>
        </execution>
    </executions>
</plugin>
```

---

## 🧪 3. Run Tests and Generate Coverage

Use the following Maven command to run the tests and generate the coverage report:

```bash
mvn clean test
```

The report will be generated at:

```
target/site/jacoco/index.html
```

Open the HTML file in your browser to view class-wise coverage metrics.

---

## 📊 4. (Optional) Enforce Minimum Coverage Threshold

The `<rules>` section in the plugin config will **fail the build** if the coverage is below the defined limits:

```xml
<limit>
    <counter>INSTRUCTION</counter>
    <value>COVEREDRATIO</value>
    <minimum>0.30</minimum> <!-- 30% instruction coverage -->
</limit>
<limit>
    <counter>BRANCH</counter>
    <value>COVEREDRATIO</value>
    <minimum>0.20</minimum> <!-- 20% branch coverage -->
</limit>
```

You can adjust these values as per your project's quality standards.

---

## 🤖 5. Notes

* JaCoCo only reports on code that is executed during tests. Ensure meaningful test cases exist.
* The `junit-vintage-engine` is optional but useful if you have legacy JUnit 4 tests.
* You can integrate this with SonarQube for full coverage and quality analysis.

---
