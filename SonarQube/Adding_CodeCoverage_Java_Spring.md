# ✅ JaCoCo Code Coverage Integration Guide for Java + Spring Boot (Maven)

This guide explains how to configure **JaCoCo** to measure code coverage in a Java + Spring Boot application using **Maven**.

---

## 📦 1. Required Dependencies

Ensure the following test dependencies are present in your `pom.xml`:

```xml
<!-- Spring Boot Test Starter -->
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-test</artifactId>
  <scope>test</scope>
</dependency>

<!-- JUnit 5 API and Engine -->
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

<!-- (Optional) JUnit 4 Compatibility -->
<dependency>
  <groupId>org.junit.vintage</groupId>
  <artifactId>junit-vintage-engine</artifactId>
  <version>5.9.2</version>
  <scope>test</scope>
</dependency>
```

---

## 💪 2. JaCoCo Plugin Setup (Single Module)

Add the following plugin block to the `<build><plugins>` section of your `pom.xml`:

```xml
<plugin>
  <groupId>org.jacoco</groupId>
  <artifactId>jacoco-maven-plugin</artifactId>
  <version>0.8.8</version>
  <executions>
    <execution>
      <goals>
        <goal>prepare-agent</goal>
      </goals>
    </execution>
    <execution>
      <id>report</id>
      <phase>test</phase>
      <goals>
        <goal>report</goal>
      </goals>
    </execution>
    <execution>
      <id>check</id>
      <goals>
        <goal>check</goal>
      </goals>
    </execution>
  </executions>
  <configuration>
    <includes>
      <include>com/example/*</include>
      <include>com/example/**/*</include>
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
</plugin>
```

---

## 🧪 3. Run Tests and Generate Report

```bash
mvn clean test
```

The coverage report will be available at:

```
target/site/jacoco/index.html
```

Open it in your browser to see class/method-level test coverage.

---

## 📊 4. Minimum Coverage Enforcement

The `<rules>` section in the plugin will fail the build if the defined thresholds are not met. You can update these values based on your quality gate.

---

## 🧩 5. Multi-Module Projects

If your Maven project has multiple modules:

### 🧱 Step 1: Add Plugin to Each Submodule

In each submodule’s `pom.xml`, include:

```xml
<plugin>
  <groupId>org.jacoco</groupId>
  <artifactId>jacoco-maven-plugin</artifactId>
  <version>0.8.8</version>
  <executions>
    <execution>
      <id>prepare-agent</id>
      <goals>
        <goal>prepare-agent</goal>
      </goals>
    </execution>
    <execution>
      <id>report</id>
      <phase>verify</phase>
      <goals>
        <goal>report</goal>
      </goals>
    </execution>
  </executions>
</plugin>
```

### 📦 Step 2: (Optional) Parent Aggregated Report

In the **parent `pom.xml`**, to generate a merged coverage report:

```xml
<plugin>
  <groupId>org.jacoco</groupId>
  <artifactId>jacoco-maven-plugin</artifactId>
  <version>0.8.8</version>
  <executions>
    <execution>
      <id>prepare-agent</id>
      <goals>
        <goal>prepare-agent</goal>
      </goals>
    </execution>
    <execution>
      <id>report-aggregate</id>
      <phase>verify</phase>
      <goals>
        <goal>report-aggregate</goal>
      </goals>
    </execution>
  </executions>
  <configuration>
    <outputDirectory>${project.build.directory}/site/jacoco-aggregate</outputDirectory>
  </configuration>
</plugin>
```

### ▶️ Step 3: Build Command

```bash
mvn clean verify
```

This will:

* Generate coverage reports for each module in `target/site/jacoco/`
* (If aggregation is configured) Generate a merged report in `target/site/jacoco-aggregate/`

---

## 📝 Notes

* Ensure tests are meaningful and cover actual logic.
* You can integrate the generated `.xml` report with SonarQube for centralized quality monitoring.
* For GitHub Actions or Jenkins integration, refer to your CI configuration's test and coverage steps.

---

✅ **You're now ready to track and enforce code coverage across your Java project!**
